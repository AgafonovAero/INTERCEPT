function [estimate, warnings] = estimateSimpleDragFromLog(processedData, windows, vehicleConfig)
% Оценивает начальные коэффициенты линейного сопротивления по журналу.

if nargin < 3 || isempty(vehicleConfig)
    vehicleConfig = copter.config.defaultVehicleConfig();
end

if nargin < 2
    windows = table();
end

dataTable = localTable(processedData);
warnings = strings(0, 1);
baseDrag = double(vehicleConfig.model6dof.linear_drag(:));

if isempty(windows) || ~hasVariable(dataTable, "horizontal_speed_mps")
    warnings(end + 1, 1) = "Данных о скорости недостаточно; использованы коэффициенты сопротивления из конфигурации.";
    estimate.linear_drag = baseDrag;
    estimate.method = "default";
    return;
end

horizontalSpeed = double(dataTable.horizontal_speed_mps);
verticalSpeed = readColumn(dataTable, "vertical_speed_mps");
speedScale = mean(abs(horizontalSpeed), 'omitnan');
verticalScale = mean(abs(verticalSpeed), 'omitnan');
if ~isfinite(speedScale)
    speedScale = 0;
end

if ~isfinite(verticalScale)
    verticalScale = 0;
end

estimate.linear_drag = baseDrag + [0.01; 0.01; 0.015] .* [speedScale; speedScale; verticalScale];
estimate.linear_drag = max(0, min(5, estimate.linear_drag));
estimate.method = "coarse_log_estimate";
end

function value = readColumn(dataTable, variableName)
if hasVariable(dataTable, variableName)
    value = double(dataTable.(variableName));
else
    value = NaN(height(dataTable), 1);
end
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
