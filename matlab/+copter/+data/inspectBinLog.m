function summary = inspectBinLog(filePath)
% Анализирует состав сообщений бортового журнала ArduPilot DataFlash BIN.

if nargin < 1 || strlength(string(filePath)) == 0
    error('Укажите путь к бортовому журналу ArduPilot DataFlash BIN.');
end

assert(isfile(filePath), 'Файл DataFlash BIN не найден: %s', filePath);

fileInfo = dir(filePath);
bytes = readBinaryFile(filePath);
[formats, fmtWarnings] = copter.data.parseDataFlashFmt(bytes);
[counts, timeStats, packetWarnings, totalPackets] = scanPackets(bytes, formats);
messageTable = buildMessageTable(formats, counts, timeStats);
keyStatus = buildKeyMessageStatus(messageTable);
warnings = [
    fmtWarnings
    packetWarnings
    buildMissingKeyWarnings(keyStatus)
    ];

summary = struct();
summary.file_path = string(filePath);
summary.file_name = string(fileInfo.name);
summary.file_size_bytes = fileInfo.bytes;
summary.modified_datetime = string(fileInfo.date);
summary.total_packets = totalPackets;
summary.formats = formats;
summary.messages = messageTable;
summary.key_messages = keyStatus;
summary.duration_s = estimateLogDuration(messageTable);
summary.warnings = warnings;
end

function bytes = readBinaryFile(filePath)
fileId = fopen(filePath, 'r');
assert(fileId > 0, 'Не удалось открыть файл DataFlash BIN: %s', filePath);
cleanup = onCleanup(@() fclose(fileId));
bytes = transpose(fread(fileId, Inf, '*uint8'));
end

function [counts, timeStats, warnings, totalPackets] = scanPackets(bytes, formats)
sync1 = uint8(hex2dec('A3'));
sync2 = uint8(hex2dec('95'));
counts = containers.Map('KeyType', 'char', 'ValueType', 'double');
timeStats = containers.Map('KeyType', 'char', 'ValueType', 'any');
formatLookup = buildFormatLookup(formats);
dataFormatMap = copter.data.dataFlashFormatMap();
warnings = strings(0, 1);
totalPackets = 0;
index = 1;

while index <= numel(bytes) - 2
    if bytes(index) ~= sync1 || bytes(index + 1) ~= sync2
        index = index + 1;
        continue;
    end

    typeId = double(bytes(index + 2));
    key = typeKey(typeId);
    if ~isKey(formatLookup, key)
        warnings(end + 1, 1) = "Обнаружен тип сообщения DataFlash без описания FMT: " + string(typeId) + ".";
        index = index + 1;
        continue;
    end

    formatDescription = formatLookup(key);
    packetLength = formatDescription.length;
    if packetLength <= 3
        warnings(end + 1, 1) = "Некорректная длина сообщения DataFlash для типа " + string(typeId) + ".";
        index = index + 1;
        continue;
    end

    if index + packetLength - 1 > numel(bytes)
        warnings(end + 1, 1) = "Обнаружено неполное сообщение DataFlash в конце файла.";
        break;
    end

    if isKey(counts, key)
        counts(key) = counts(key) + 1;
    else
        counts(key) = 1;
    end

    totalPackets = totalPackets + 1;
    payload = bytes(index + 3:index + packetLength - 1);
    [timeUs, hasTime] = decodeTimeUS(payload, formatDescription, dataFormatMap);
    if hasTime
        timeStats = updateTimeStats(timeStats, key, timeUs);
    end

    index = index + packetLength;
end

warnings = unique(warnings, 'stable');
end

function timeStats = updateTimeStats(timeStats, key, timeUs)
if isKey(timeStats, key)
    stats = timeStats(key);
    stats.first_TimeUS = min(stats.first_TimeUS, timeUs);
    stats.last_TimeUS = max(stats.last_TimeUS, timeUs);
else
    stats = struct();
    stats.first_TimeUS = timeUs;
    stats.last_TimeUS = timeUs;
end

timeStats(key) = stats;
end

function [timeUs, hasTime] = decodeTimeUS(payload, formatDescription, formatMap)
timeUs = NaN;
hasTime = false;
fields = string(formatDescription.fields);
timeIndex = find(fields == "TimeUS", 1, 'first');
if isempty(timeIndex)
    return;
end

formatText = char(string(formatDescription.format));
if timeIndex > numel(formatText)
    return;
end

offset = 1;
for index = 1:timeIndex
    symbol = formatText(index);
    if ~isKey(formatMap, symbol)
        return;
    end

    entry = formatMap(symbol);
    lastByte = offset + entry.size_bytes - 1;
    if lastByte > numel(payload)
        return;
    end

    if index == timeIndex
        value = typecast(uint8(payload(offset:lastByte)), char(entry.matlab_type));
        timeUs = double(value) .* entry.scale;
        hasTime = true;
        return;
    end

    offset = lastByte + 1;
end
end

function messageTable = buildMessageTable(formats, counts, timeStats)
if isempty(formats)
    messageTable = emptyMessageTable();
    return;
end

rowCount = numel(formats);
messageName = strings(rowCount, 1);
messageTypeId = zeros(rowCount, 1);
messageLength = zeros(rowCount, 1);
count = zeros(rowCount, 1);
hasTimeUS = false(rowCount, 1);
firstTimeUS = NaN(rowCount, 1);
lastTimeUS = NaN(rowCount, 1);
durationS = NaN(rowCount, 1);
estimatedRateHz = NaN(rowCount, 1);
fields = strings(rowCount, 1);

for index = 1:rowCount
    formatDescription = formats(index);
    key = typeKey(formatDescription.type_id);
    messageName(index) = string(formatDescription.name);
    messageTypeId(index) = formatDescription.type_id;
    messageLength(index) = formatDescription.length;
    fields(index) = strjoin(string(formatDescription.fields), ",");

    if isKey(counts, key)
        count(index) = counts(key);
    end

    if isKey(timeStats, key)
        stats = timeStats(key);
        hasTimeUS(index) = true;
        firstTimeUS(index) = stats.first_TimeUS;
        lastTimeUS(index) = stats.last_TimeUS;
        durationS(index) = max(0, (stats.last_TimeUS - stats.first_TimeUS) * 1e-6);
        if durationS(index) > 0 && count(index) > 1
            estimatedRateHz(index) = (count(index) - 1) / durationS(index);
        end
    end
end

messageTable = table( ...
    messageName, ...
    messageTypeId, ...
    messageLength, ...
    count, ...
    hasTimeUS, ...
    firstTimeUS, ...
    lastTimeUS, ...
    durationS, ...
    estimatedRateHz, ...
    fields, ...
    'VariableNames', { ...
    'message_name', ...
    'message_type_id', ...
    'message_length', ...
    'count', ...
    'has_TimeUS', ...
    'first_TimeUS', ...
    'last_TimeUS', ...
    'duration_s', ...
    'estimated_rate_hz', ...
    'fields'});
end

function keyStatus = buildKeyMessageStatus(messageTable)
keyMessages = [
    "FMT"
    "PARM"
    "MSG"
    "MODE"
    "ATT"
    "RATE"
    "RCOU"
    "BAT"
    "ESC"
    "GPS"
    "POS"
    "XKF"
    "XKF1"
    "XKF2"
    "XKF3"
    "XKF4"
    "IMU"
    "ACC"
    "GYR"
    "BARO"
    ];
available = upper(string(messageTable.message_name));
present = false(numel(keyMessages), 1);

for index = 1:numel(keyMessages)
    keyMessage = keyMessages(index);
    if keyMessage == "ESC"
        present(index) = any(available == "ESC" | startsWith(available, "ESC"));
    elseif keyMessage == "XKF"
        present(index) = any(available == "XKF" | startsWith(available, "XKF"));
    else
        present(index) = any(available == keyMessage);
    end
end

keyStatus = table(keyMessages, present, 'VariableNames', {'message_name', 'present'});
end

function warnings = buildMissingKeyWarnings(keyStatus)
warnings = strings(0, 1);
for index = 1:height(keyStatus)
    if ~keyStatus.present(index)
        warnings(end + 1, 1) = "В журнале отсутствует ключевое сообщение " + keyStatus.message_name(index) + ".";
    end
end
end

function durationS = estimateLogDuration(messageTable)
if isempty(messageTable) || ~any(messageTable.has_TimeUS)
    durationS = NaN;
    return;
end

firstValues = messageTable.first_TimeUS(messageTable.has_TimeUS);
lastValues = messageTable.last_TimeUS(messageTable.has_TimeUS);
durationS = (max(lastValues) - min(firstValues)) * 1e-6;
end

function formatDescription = findFormatByType(formats, typeId)
formatDescription = [];
if isempty(formats)
    return;
end

matchIndex = find([formats.type_id] == typeId, 1, 'first');
if ~isempty(matchIndex)
    formatDescription = formats(matchIndex);
end
end

function formatLookup = buildFormatLookup(formats)
formatLookup = containers.Map('KeyType', 'char', 'ValueType', 'any');
for index = 1:numel(formats)
    formatLookup(typeKey(formats(index).type_id)) = formats(index);
end
end

function key = typeKey(typeId)
key = sprintf('type_%d', typeId);
end

function messageTable = emptyMessageTable()
messageTable = table( ...
    strings(0, 1), ...
    zeros(0, 1), ...
    zeros(0, 1), ...
    zeros(0, 1), ...
    false(0, 1), ...
    NaN(0, 1), ...
    NaN(0, 1), ...
    NaN(0, 1), ...
    NaN(0, 1), ...
    strings(0, 1), ...
    'VariableNames', { ...
    'message_name', ...
    'message_type_id', ...
    'message_length', ...
    'count', ...
    'has_TimeUS', ...
    'first_TimeUS', ...
    'last_TimeUS', ...
    'duration_s', ...
    'estimated_rate_hz', ...
    'fields'});
end
