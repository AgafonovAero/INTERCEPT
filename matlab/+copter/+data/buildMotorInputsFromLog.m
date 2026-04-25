function [motorInputs, inputReport] = buildMotorInputsFromLog(processedData, replayWindow, vehicleConfig)
% Формирует нормированные входы двигателей Model6DOF по каналам RCOU.

if nargin < 3 || isempty(vehicleConfig)
    vehicleConfig = copter.config.defaultVehicleConfig();
end

dataTable = localTable(processedData);
assert(hasVariable(dataTable, "t_s"), 'Для формирования входов двигателей требуется t_s.');

[tStartS, tEndS] = readWindowTime(replayWindow, dataTable);
mask = dataTable.t_s >= tStartS & dataTable.t_s <= tEndS;
windowTable = dataTable(mask, :);
warnings = strings(0, 1);

if isempty(windowTable)
    motorInputs = timetable();
    inputReport = makeReport([warnings; "В выбранном окне отсутствуют строки данных."], NaN);
    return;
end

timeSeconds = double(windowTable.t_s(:));
motorValues = NaN(height(windowTable), 4);

for index = 1:4
    normalizedName = "u_motor_" + string(index);
    rawName = "RCOU.C" + string(index);
    if hasVariable(windowTable, normalizedName)
        motorValues(:, index) = double(windowTable.(normalizedName));
    elseif hasVariable(windowTable, rawName)
        motorValues(:, index) = copter.utils.normalizePwm( ...
            double(windowTable.(rawName)), ...
            vehicleConfig.normalization.pwm_min, ...
            vehicleConfig.normalization.pwm_max);
    else
        warnings(end + 1, 1) = "Отсутствует канал " + rawName + ".";
    end
end

motorValues = fillmissing(motorValues, 'linear', 'EndValues', 'nearest');
motorValues = max(0, min(1, motorValues));
saturationFlag = any(motorValues <= 0 | motorValues >= 1, 2);
saturationPercent = 100 * mean(saturationFlag, 'omitnan');

inputTable = table();
inputTable.t_s = timeSeconds;
for index = 1:4
    inputTable.("u_motor_" + string(index)) = motorValues(:, index);
end
inputTable.motor_saturation_flag = saturationFlag;

motorInputs = table2timetable(inputTable, 'RowTimes', seconds(timeSeconds));
motorInputs.Properties.DimensionNames{1} = 'Time';
inputReport = makeReport(warnings, saturationPercent);
end

function [tStartS, tEndS] = readWindowTime(replayWindow, dataTable)
if istable(replayWindow)
    tStartS = double(replayWindow.t_start_s(1));
    tEndS = double(replayWindow.t_end_s(1));
elseif isstruct(replayWindow)
    tStartS = double(replayWindow.t_start_s);
    tEndS = double(replayWindow.t_end_s);
else
    tStartS = min(dataTable.t_s);
    tEndS = max(dataTable.t_s);
end
end

function inputReport = makeReport(warnings, saturationPercent)
inputReport = struct();
inputReport.warnings = string(warnings(:));
inputReport.saturation_percent = saturationPercent;
end

function dataTable = localTable(dataSet)
if istimetable(dataSet)
    dataTable = timetable2table(dataSet, 'ConvertRowTimes', false);
else
    dataTable = dataSet;
end
end

function result = hasVariable(dataTable, variableName)
result = any(string(dataTable.Properties.VariableNames) == string(variableName));
end
