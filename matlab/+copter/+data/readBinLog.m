function logData = readBinLog(filePath, config, summary)
% Читает ключевые сообщения DataFlash BIN в структуры таблиц MATLAB.

if nargin < 2 || isempty(config)
    config = copter.config.defaultVehicleConfig();
end

if nargin < 1 || strlength(string(filePath)) == 0
    error('Укажите путь к бортовому журналу ArduPilot DataFlash BIN.');
end

assert(isfile(filePath), 'Файл DataFlash BIN не найден: %s', filePath);

if nargin < 3 || isempty(summary)
    summary = copter.data.inspectBinLog(filePath);
end

bytes = readBinaryFile(filePath);
desiredFormats = selectDesiredFormats(summary.formats);
[messages, readWarnings] = decodeDesiredMessages(bytes, summary.formats, desiredFormats);
missingWarnings = buildMissingMessageWarnings(messages);

logData = struct();
logData.summary = summary;
logData.messages = messages;
logData.warnings = unique([summary.warnings; readWarnings; missingWarnings], 'stable');
logData.vehicle_id = string(config.vehicle_id);
end

function bytes = readBinaryFile(filePath)
fileId = fopen(filePath, 'r');
assert(fileId > 0, 'Не удалось открыть файл DataFlash BIN: %s', filePath);
cleanup = onCleanup(@() fclose(fileId));
bytes = transpose(fread(fileId, Inf, '*uint8'));
end

function desiredFormats = selectDesiredFormats(formats)
desiredFormats = formats([]);
for index = 1:numel(formats)
    messageName = upper(string(formats(index).name));
    if isDesiredMessage(messageName)
        desiredFormats(end + 1) = formats(index);
    end
end
end

function isDesired = isDesiredMessage(messageName)
baseMessages = [
    "ATT"
    "RATE"
    "RCOU"
    "BAT"
    "GPS"
    "POS"
    "MODE"
    ];
isDesired = any(messageName == baseMessages) || startsWith(messageName, "ESC") || startsWith(messageName, "XKF");
end

function [messages, warnings] = decodeDesiredMessages(bytes, allFormats, desiredFormats)
sync1 = uint8(hex2dec('A3'));
sync2 = uint8(hex2dec('95'));
messages = struct();
warnings = strings(0, 1);
records = struct();
allFormatLookup = buildFormatLookup(allFormats);
desiredFormatLookup = buildFormatLookup(desiredFormats);
dataFormatMap = copter.data.dataFlashFormatMap();
decodeWarningIssued = containers.Map('KeyType', 'char', 'ValueType', 'logical');
unsupportedTypes = containers.Map('KeyType', 'char', 'ValueType', 'logical');

for index = 1:numel(desiredFormats)
    safeName = matlab.lang.makeValidName(char(desiredFormats(index).name));
    records.(safeName) = {};
end

index = 1;
while index <= numel(bytes) - 2
    if bytes(index) ~= sync1 || bytes(index + 1) ~= sync2
        index = index + 1;
        continue;
    end

    typeId = double(bytes(index + 2));
    typeName = typeKey(typeId);
    if ~isKey(allFormatLookup, typeName)
        index = index + 1;
        continue;
    end

    formatDescription = allFormatLookup(typeName);
    shouldDecode = isKey(desiredFormatLookup, typeName);
    if ~shouldDecode
        index = index + max(1, formatDescription.length);
        continue;
    end

    packetLength = formatDescription.length;
    if packetLength <= 3 || index + packetLength - 1 > numel(bytes)
        warnings(end + 1, 1) = "Не удалось прочитать сообщение " + string(formatDescription.name) + " из-за некорректной длины.";
        index = index + 1;
        continue;
    end

    payload = bytes(index + 3:index + packetLength - 1);
    if isKey(unsupportedTypes, typeName)
        index = index + packetLength;
        continue;
    end

    [record, recognized, decodeWarnings] = copter.data.decodeDataFlashMessage(payload, formatDescription, dataFormatMap);
    safeName = matlab.lang.makeValidName(char(formatDescription.name));
    if recognized
        records.(safeName){end + 1} = record;
    elseif ~isKey(decodeWarningIssued, safeName)
        warnings = [warnings; decodeWarnings];
        decodeWarningIssued(safeName) = true;
        unsupportedTypes(typeName) = true;
    end

    index = index + packetLength;
end

messageNames = fieldnames(records);
for index = 1:numel(messageNames)
    safeName = messageNames{index};
    recordCells = records.(safeName);
    if isempty(recordCells)
        continue;
    end

    recordArray = [recordCells{:}];
    messages.(safeName) = struct2table(recordArray);
end

warnings = unique(warnings, 'stable');
end

function warnings = buildMissingMessageWarnings(messages)
minimumMessages = ["ATT"; "RATE"; "RCOU"; "BAT"; "GPS"; "POS"; "XKF"];
available = upper(string(fieldnames(messages)));
warnings = strings(0, 1);

for index = 1:numel(minimumMessages)
    messageName = minimumMessages(index);
    if messageName == "XKF"
        isPresent = any(available == "XKF" | startsWith(available, "XKF"));
    else
        isPresent = any(available == messageName);
    end

    if ~isPresent
        warnings(end + 1, 1) = "Сообщение " + messageName + " отсутствует и не создано в logData.messages.";
    end
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
