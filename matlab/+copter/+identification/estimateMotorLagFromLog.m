function [estimate, warnings] = estimateMotorLagFromLog(processedData, windows, vehicleConfig)
% Оценивает инерционность винтомоторной группы по журналу на первом приближении.

if nargin < 3 || isempty(vehicleConfig)
    vehicleConfig = copter.config.defaultVehicleConfig();
end

if nargin < 2
    windows = table();
end

dataTable = localTable(processedData);
warnings = strings(0, 1);
defaultTau = vehicleConfig.model6dof.tau_motor_s;

if isempty(windows) || ~hasVariable(dataTable, "vertical_speed_mps")
    warnings(end + 1, 1) = "Данных недостаточно для устойчивой оценки задержки ВМГ; использовано значение по умолчанию.";
    estimate.motor_tau_s = defaultTau;
    estimate.method = "default";
    return;
end

collective = readCollective(dataTable);
verticalAcceleration = gradient(double(dataTable.vertical_speed_mps), double(dataTable.t_s));
if std(collective, 'omitnan') < 1e-3 || std(verticalAcceleration, 'omitnan') < 1e-3
    warnings(end + 1, 1) = "Возбуждение по тяге мало; использовано значение задержки по умолчанию.";
    estimate.motor_tau_s = defaultTau;
    estimate.method = "default";
    return;
end

maxLag = min(20, floor(height(dataTable) / 10));
correlations = NaN(maxLag + 1, 1);
for lag = 0:maxLag
    input = collective(1:end - lag);
    response = verticalAcceleration(1 + lag:end);
    if numel(input) > 3
        matrix = corrcoef(input, response, 'Rows', 'complete');
        correlations(lag + 1) = matrix(1, 2);
    end
end

[~, bestIndex] = max(abs(correlations));
sampleTime = median(diff(double(dataTable.t_s)), 'omitnan');
estimate.motor_tau_s = max(0.02, min(0.5, (bestIndex - 1) * sampleTime));
if estimate.motor_tau_s == 0
    estimate.motor_tau_s = defaultTau;
end
estimate.method = "correlation";
end

function collective = readCollective(dataTable)
motors = NaN(height(dataTable), 4);
for index = 1:4
    name = "u_motor_" + string(index);
    if hasVariable(dataTable, name)
        motors(:, index) = double(dataTable.(name));
    end
end
collective = mean(motors, 2, 'omitnan');
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
