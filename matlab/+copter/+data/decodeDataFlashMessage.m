function [record, recognized, warnings] = decodeDataFlashMessage(payload, description, formatMap)
% Декодирует одно сообщение DataFlash по описанию FMT.

if nargin < 3 || isempty(formatMap)
    formatMap = copter.data.dataFlashFormatMap();
end

payload = transpose(uint8(payload(:)));
formatText = char(string(description.format));
fieldNames = makeRecordFieldNames(description, numel(formatText));

record = struct();
recognized = true;
warnings = strings(0, 1);
offset = 1;

for index = 1:numel(formatText)
    symbol = formatText(index);
    if ~isKey(formatMap, symbol)
        warnings(end + 1, 1) = "Неизвестный символ формата DataFlash: " + string(symbol) + ". Сообщение " + string(description.name) + " пропущено.";
        recognized = false;
        return;
    end

    entry = formatMap(symbol);
    lastByte = offset + entry.size_bytes - 1;
    if lastByte > numel(payload)
        warnings(end + 1, 1) = "Недостаточная длина полезной нагрузки сообщения " + string(description.name) + ".";
        recognized = false;
        return;
    end

    fieldPayload = payload(offset:lastByte);
    record.(fieldNames{index}) = decodeFieldValue(fieldPayload, entry);
    offset = lastByte + 1;
end
end

function fieldNames = makeRecordFieldNames(description, fieldCount)
if isfield(description, 'fields')
    rawFields = string(description.fields);
else
    rawFields = strings(0, 1);
end

if numel(rawFields) < fieldCount
    for index = numel(rawFields) + 1:fieldCount
        rawFields(index) = "field_" + string(index);
    end
end

rawFields = rawFields(1:fieldCount);
fieldNames = matlab.lang.makeValidName(cellstr(rawFields));
fieldNames = matlab.lang.makeUniqueStrings(fieldNames);
end

function value = decodeFieldValue(fieldPayload, entry)
if entry.is_text
    value = cleanCharBytes(fieldPayload);
    return;
end

rawValue = typecast(uint8(fieldPayload), char(entry.matlab_type));
value = double(rawValue) .* entry.scale;
end

function text = cleanCharBytes(fieldPayload)
bytes = transpose(uint8(fieldPayload(:)));
zeroIndex = find(bytes == 0, 1, 'first');
if ~isempty(zeroIndex)
    bytes = bytes(1:zeroIndex - 1);
end

text = string(strtrim(char(bytes)));
end
