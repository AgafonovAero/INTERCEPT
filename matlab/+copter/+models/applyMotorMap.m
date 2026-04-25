function [mappedData, report] = applyMotorMap(inputData, motorMapCandidate, vehicleConfig)
% Применяет кандидатный мотор-маппинг к каналам RCOU или u_motor.

if nargin < 3 || isempty(vehicleConfig)
    vehicleConfig = copter.config.defaultVehicleConfig();
end

dataTable = localTable(inputData);
order = readMotorOrder(motorMapCandidate);
warnings = strings(0, 1);
[uRaw, rawWarnings] = readMotorInputs(dataTable, vehicleConfig);
warnings = [warnings; rawWarnings];

if numel(order) ~= 4 || any(order < 1) || any(order > 4)
    warnings(end + 1, 1) = "Кандидат мотор-маппинга некорректен; используется порядок 1, 2, 3, 4.";
    order = [1; 2; 3; 4];
end

uMapped = uRaw(:, order);
mappedData = dataTable;
for index = 1:4
    mappedData.("u_motor_" + string(index)) = uMapped(:, index);
end

report = struct();
report.motor_order = order(:);
report.source = readCandidateText(motorMapCandidate, "source", "unknown");
report.warnings = unique(warnings, 'stable');
end

function dataTable = localTable(inputData)
if istimetable(inputData)
    dataTable = timetable2table(inputData, 'ConvertRowTimes', false);
else
    dataTable = inputData;
end
end

function [uRaw, warnings] = readMotorInputs(dataTable, vehicleConfig)
warnings = strings(0, 1);
uRaw = NaN(height(dataTable), 4);
for index = 1:4
    uName = "u_motor_" + string(index);
    rcouName = "RCOU.C" + string(index);
    if hasVariable(dataTable, uName)
        uRaw(:, index) = double(dataTable.(uName));
    elseif hasVariable(dataTable, rcouName)
        pwm = double(dataTable.(rcouName));
        uRaw(:, index) = (pwm - vehicleConfig.normalization.pwm_min) ...
            ./ (vehicleConfig.normalization.pwm_max - vehicleConfig.normalization.pwm_min);
    else
        warnings(end + 1, 1) = "Отсутствует канал " + rcouName + " или " + uName + ".";
    end
end
uRaw = min(1, max(0, uRaw));
end

function result = hasVariable(dataTable, variableName)
result = any(string(dataTable.Properties.VariableNames) == string(variableName));
end

function order = readMotorOrder(candidate)
if istable(candidate)
    value = candidate.motor_order(1);
    if iscell(value)
        order = double(value{1}(:));
    else
        order = double(value(:));
    end
elseif isstruct(candidate) && isfield(candidate, 'motor_order')
    order = double(candidate.motor_order(:));
else
    order = transpose(1:4);
end
end

function text = readCandidateText(candidate, fieldName, defaultValue)
text = string(defaultValue);
if istable(candidate) && any(string(candidate.Properties.VariableNames) == string(fieldName))
    text = string(candidate.(fieldName)(1));
elseif isstruct(candidate) && isfield(candidate, fieldName)
    text = string(candidate.(fieldName));
end
end
