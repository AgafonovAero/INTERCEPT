function [processedData, syncReport] = synchronizeLogMessages(messages, sampleRateHz)
% Синхронизирует сообщения бортового журнала на равномерной сетке времени.

if nargin < 2 || isempty(sampleRateHz)
    sampleRateHz = 100;
end

messageNames = string(fieldnames(messages));
[timeStart, timeEnd, warnings] = findTimeRange(messages, messageNames);

syncReport = struct();
syncReport.sample_rate_hz = sampleRateHz;
syncReport.warnings = warnings;

if isnan(timeStart) || isnan(timeEnd) || timeEnd <= timeStart
    processedData = timetable();
    syncReport.warnings(end + 1, 1) = "Не удалось выбрать опорную временную сетку по TimeUS.";
    return;
end

step = 1 / sampleRateHz;
durationSeconds = (timeEnd - timeStart) * 1e-6;
timeSeconds = transpose(0:step:durationSeconds);
regularTable = table();
regularTable.t_s = timeSeconds;

for messageIndex = 1:numel(messageNames)
    messageName = messageNames(messageIndex);
    messageTable = messages.(messageName);
    if ~istable(messageTable) || ~hasVariable(messageTable, "TimeUS")
        syncReport.warnings(end + 1, 1) = "Сообщение " + messageName + " не содержит TimeUS и не синхронизировано.";
        continue;
    end

    localTime = (double(messageTable.TimeUS(:)) - timeStart) * 1e-6;
    [localTime, uniqueIndex] = unique(localTime, 'stable');
    if numel(localTime) < 1
        continue;
    end

    variableNames = string(messageTable.Properties.VariableNames);
    for variableIndex = 1:numel(variableNames)
        variableName = variableNames(variableIndex);
        if variableName == "TimeUS"
            continue;
        end

        values = messageTable.(variableName);
        if ~(isnumeric(values) || islogical(values)) || ~isvector(values)
            continue;
        end

        values = double(values(uniqueIndex));
        outputName = matlab.lang.makeUniqueStrings(char(messageName + "." + variableName), regularTable.Properties.VariableNames);
        regularTable.(outputName) = interpolateSignal(localTime, values, timeSeconds);
    end
end

processedData = table2timetable(regularTable, 'RowTimes', seconds(regularTable.t_s));
processedData.Properties.DimensionNames{1} = 'Time';
syncReport.duration_s = timeSeconds(end);
syncReport.row_count = height(processedData);
end

function [timeStart, timeEnd, warnings] = findTimeRange(messages, messageNames)
timeStart = NaN;
timeEnd = NaN;
warnings = strings(0, 1);
preferredMessages = ["RATE", "ATT", "RCOU", "BAT", "GPS", "POS", "XKF1"];

for preferredIndex = 1:numel(preferredMessages)
    preferredName = preferredMessages(preferredIndex);
    safeName = char(preferredName);
    if isfield(messages, safeName)
        [timeStart, timeEnd] = timeRangeFromTable(messages.(safeName));
        if ~isnan(timeStart) && timeEnd > timeStart
            return;
        end
    end
end

for index = 1:numel(messageNames)
    messageName = messageNames(index);
    messageTable = messages.(messageName);
    [candidateStart, candidateEnd] = timeRangeFromTable(messageTable);
    if isnan(candidateStart) || candidateEnd <= candidateStart
        continue;
    end

    candidateDuration = (candidateEnd - candidateStart) * 1e-6;
    if candidateDuration > 24 * 3600
        warnings(end + 1, 1) = "Сообщение " + messageName + " имеет подозрительный диапазон TimeUS и не использовано для выбора сетки.";
        continue;
    end

    timeStart = minValue(timeStart, candidateStart);
    timeEnd = maxValue(timeEnd, candidateEnd);
end
end

function [timeStart, timeEnd] = timeRangeFromTable(messageTable)
timeStart = NaN;
timeEnd = NaN;

if ~istable(messageTable) || ~hasVariable(messageTable, "TimeUS") || isempty(messageTable.TimeUS)
    return;
end

timeValues = double(messageTable.TimeUS(:));
timeValues = timeValues(isfinite(timeValues));
if isempty(timeValues)
    return;
end

timeStart = min(timeValues);
timeEnd = max(timeValues);
end

function valuesOut = interpolateSignal(timeIn, valuesIn, timeOut)
finiteMask = isfinite(timeIn) & isfinite(valuesIn);
timeIn = timeIn(finiteMask);
valuesIn = valuesIn(finiteMask);

if isempty(timeIn)
    valuesOut = NaN(size(timeOut));
elseif numel(timeIn) == 1
    valuesOut = repmat(valuesIn(1), size(timeOut));
else
    valuesOut = interp1(timeIn, valuesIn, timeOut, 'linear', NaN);
end
end

function result = minValue(currentValue, candidateValue)
if isnan(currentValue)
    result = candidateValue;
else
    result = min(currentValue, candidateValue);
end
end

function result = maxValue(currentValue, candidateValue)
if isnan(currentValue)
    result = candidateValue;
else
    result = max(currentValue, candidateValue);
end
end

function result = hasVariable(dataTable, variableName)
result = any(string(dataTable.Properties.VariableNames) == string(variableName));
end
