function [params, report] = extractArduPilotParams(logData)
% Извлекает параметры ArduPilot из сообщений PARM бортового журнала.

targetNames = buildTargetNames();
params = struct();
params.values = struct();
params.available_names = strings(0, 1);
warnings = strings(0, 1);

if ~isfield(logData, 'messages') || ~isfield(logData.messages, 'PARM')
    warnings(end + 1, 1) = "Сообщения PARM отсутствуют в прочитанном журнале.";
    params = fillMissingTargets(params, targetNames);
    report = makeReport(0, warnings);
    return;
end

parmTable = logData.messages.PARM;
if isempty(parmTable)
    warnings(end + 1, 1) = "Таблица PARM пуста.";
    params = fillMissingTargets(params, targetNames);
    report = makeReport(0, warnings);
    return;
end

[nameColumn, valueColumn, columnWarnings] = findParmColumns(parmTable);
warnings = [warnings; columnWarnings];
if strlength(nameColumn) == 0 || strlength(valueColumn) == 0
    params = fillMissingTargets(params, targetNames);
    report = makeReport(height(parmTable), warnings);
    return;
end

names = string(parmTable.(nameColumn));
values = double(parmTable.(valueColumn));
validMask = strlength(names) > 0 & isfinite(values);
names = names(validMask);
values = values(validMask);
params.available_names = names;

for index = 1:numel(names)
    fieldName = matlab.lang.makeValidName(char(names(index)));
    params.values.(fieldName) = values(index);
    params.(fieldName) = values(index);
end

params = fillMissingTargets(params, targetNames);
report = makeReport(numel(names), warnings);
end

function targetNames = buildTargetNames()
baseNames = [
    "FRAME_CLASS"
    "FRAME_TYPE"
    "MOT_PWM_MIN"
    "MOT_PWM_MAX"
    "MOT_SPIN_MIN"
    "MOT_SPIN_MAX"
    "MOT_THST_EXPO"
    "MOT_SAFE_DISARM"
    ];

servoNames = strings(0, 1);
for index = 1:16
    prefix = "SERVO" + string(index);
    servoNames = [
        servoNames
        prefix + "_FUNCTION"
        prefix + "_MIN"
        prefix + "_MAX"
        prefix + "_TRIM"
        ];
end

targetNames = [baseNames; servoNames; "BATT_MONITOR"; "BATT_CAPACITY"; "BATT_LOW_VOLT"];
end

function params = fillMissingTargets(params, targetNames)
for index = 1:numel(targetNames)
    fieldName = matlab.lang.makeValidName(char(targetNames(index)));
    if ~isfield(params, fieldName)
        params.(fieldName) = NaN;
    end
end
end

function [nameColumn, valueColumn, warnings] = findParmColumns(parmTable)
variableNames = string(parmTable.Properties.VariableNames);
warnings = strings(0, 1);
nameCandidates = ["Name", "ParamName", "ParmName", "PName", "N"];
valueCandidates = ["Value", "Val", "V"];
nameColumn = firstExisting(variableNames, nameCandidates);
valueColumn = firstExisting(variableNames, valueCandidates);

if strlength(nameColumn) == 0
    textMask = false(size(variableNames));
    for index = 1:numel(variableNames)
        value = parmTable.(variableNames(index));
        textMask(index) = iscellstr(value) || isstring(value) || ischar(value);
    end
    textIndex = find(textMask, 1, 'first');
    if ~isempty(textIndex)
        nameColumn = variableNames(textIndex);
    else
        warnings(end + 1, 1) = "Не найден текстовый столбец имени параметра PARM.";
    end
end

if strlength(valueColumn) == 0
    numericMask = false(size(variableNames));
    for index = 1:numel(variableNames)
        value = parmTable.(variableNames(index));
        numericMask(index) = isnumeric(value) || islogical(value);
    end
    numericIndex = find(numericMask, 1, 'last');
    if ~isempty(numericIndex)
        valueColumn = variableNames(numericIndex);
    else
        warnings(end + 1, 1) = "Не найден числовой столбец значения параметра PARM.";
    end
end
end

function existingName = firstExisting(variableNames, candidateNames)
existingName = "";
for index = 1:numel(candidateNames)
    mask = strcmpi(variableNames, candidateNames(index));
    if any(mask)
        existingName = variableNames(find(mask, 1, 'first'));
        return;
    end
end
end

function report = makeReport(count, warnings)
report = struct();
report.parameter_count = count;
report.warnings = unique(string(warnings(:)), 'stable');
report.note = "Параметры ArduPilot извлечены из бортового журнала и используются как исходные данные препроцессора.";
end
