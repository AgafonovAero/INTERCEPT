function [formats, warnings] = parseDataFlashFmt(source)
% Извлекает описания сообщений DataFlash из записей FMT.

bytes = readBinarySource(source);
formats = emptyFormat();
warnings = strings(0, 1);

sync1 = uint8(hex2dec('A3'));
sync2 = uint8(hex2dec('95'));
fmtTypeId = 128;
fmtPacketLength = 89;
index = 1;

while index <= numel(bytes) - 2
    if bytes(index) ~= sync1 || bytes(index + 1) ~= sync2
        index = index + 1;
        continue;
    end

    typeId = double(bytes(index + 2));
    if typeId == fmtTypeId
        if index + fmtPacketLength - 1 > numel(bytes)
            warnings(end + 1, 1) = "Обнаружено неполное сообщение FMT в конце файла.";
            break;
        end

        payload = bytes(index + 3:index + fmtPacketLength - 1);
        formatDescription = decodeFmtPayload(payload);
        formats = upsertFormat(formats, formatDescription);
        index = index + fmtPacketLength;
        continue;
    end

    knownFormat = findFormatByType(formats, typeId);
    if ~isempty(knownFormat) && knownFormat.length > 0
        index = index + knownFormat.length;
    else
        index = index + 1;
    end
end

if isempty(formats)
    warnings(end + 1, 1) = "В журнале не найдены сообщения FMT.";
end
end

function bytes = readBinarySource(source)
if isnumeric(source) || islogical(source)
    bytes = transpose(uint8(source(:)));
    return;
end

filePath = string(source);
assert(isfile(filePath), 'Файл DataFlash BIN не найден: %s', filePath);
fileId = fopen(filePath, 'r');
assert(fileId > 0, 'Не удалось открыть файл DataFlash BIN: %s', filePath);
cleanup = onCleanup(@() fclose(fileId));
bytes = transpose(fread(fileId, Inf, '*uint8'));
end

function formatDescription = decodeFmtPayload(payload)
payload = transpose(uint8(payload(:)));
formatDescription = struct();
formatDescription.type_id = double(payload(1));
formatDescription.length = double(payload(2));
formatDescription.name = cleanCharBytes(payload(3:6));
formatDescription.format = cleanCharBytes(payload(7:22));
columnsText = cleanCharBytes(payload(23:86));
fields = strtrim(split(columnsText, ","));
fields(fields == "") = [];
formatDescription.fields = reshape(fields, 1, []);
formatDescription.payload_length = max(0, formatDescription.length - 3);
end

function formats = upsertFormat(formats, formatDescription)
if isempty(formats)
    formats = formatDescription;
    return;
end

typeIds = [formats.type_id];
matchIndex = find(typeIds == formatDescription.type_id, 1, 'first');
if isempty(matchIndex)
    formats(end + 1) = formatDescription;
else
    formats(matchIndex) = formatDescription;
end
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

function text = cleanCharBytes(bytes)
bytes = transpose(uint8(bytes(:)));
zeroIndex = find(bytes == 0, 1, 'first');
if ~isempty(zeroIndex)
    bytes = bytes(1:zeroIndex - 1);
end

text = string(strtrim(char(bytes)));
end

function formatDescription = emptyFormat()
formatDescription = struct( ...
    'type_id', {}, ...
    'length', {}, ...
    'name', {}, ...
    'format', {}, ...
    'fields', {}, ...
    'payload_length', {});
end
