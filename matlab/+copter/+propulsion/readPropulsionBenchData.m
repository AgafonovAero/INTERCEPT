function [benchData, report] = readPropulsionBenchData(filePath)
% Читает CSV или MAT со стендовыми данными винтомоторной группы.

warnings = strings(0, 1);
benchData = table();
if nargin < 1 || isempty(filePath)
    filePath = fullfile("data", "raw", "bench", "propulsion", "propulsion_static_test.csv");
end

if ~isfile(filePath)
    warnings(end + 1, 1) = "Стендовые данные ВМГ отсутствуют: " + string(filePath) + ".";
    report = makeReport("not_available", filePath, warnings, benchData);
    return;
end

[~, ~, extension] = fileparts(filePath);
try
    switch lower(string(extension))
        case ".csv"
            benchData = readtable(filePath, 'VariableNamingRule', 'preserve');
        case ".mat"
            loaded = load(filePath);
            benchData = firstTable(loaded);
        otherwise
            warnings(end + 1, 1) = "Неподдерживаемый формат стендовых данных: " + string(extension) + ".";
    end
catch exception
    warnings(end + 1, 1) = "Не удалось прочитать стендовые данные: " + string(exception.message);
end

benchData = normalizeVariableNames(benchData);
missing = missingExpectedFields(benchData);
if ~isempty(missing)
    warnings(end + 1, 1) = "Отсутствуют необязательные или обязательные поля: " + join(missing, ", ") + ".";
end

status = "loaded";
if isempty(benchData)
    status = "not_available";
end
report = makeReport(status, filePath, warnings, benchData);
end

function tableOut = firstTable(loaded)
tableOut = table();
names = string(fieldnames(loaded));
for index = 1:numel(names)
    value = loaded.(names(index));
    if istable(value)
        tableOut = value;
        return;
    end
end
end

function tableOut = normalizeVariableNames(tableIn)
tableOut = tableIn;
if isempty(tableOut)
    return;
end
names = string(tableOut.Properties.VariableNames);
for index = 1:numel(names)
    names(index) = matlab.lang.makeValidName(lower(strrep(names(index), ".", "_")));
end
tableOut.Properties.VariableNames = cellstr(names);
end

function missing = missingExpectedFields(benchData)
expected = [
    "input_command"
    "pwm_us"
    "normalized_input"
    "voltage_v"
    "current_a"
    "thrust_n"
    "rpm"
    "temperature_c"
    "motor_type"
    "propeller_type"
    "esc_type"
    "battery_or_power_source"
    ];
if isempty(benchData)
    missing = expected;
    return;
end
missing = setdiff(expected, string(benchData.Properties.VariableNames), 'stable');
end

function report = makeReport(status, filePath, warnings, benchData)
report = struct();
report.status = string(status);
report.file_path = string(filePath);
report.row_count = height(benchData);
report.warnings = unique(warnings, 'stable');
end
