function [estimate, warnings] = estimateHoverThrustScale(processedData, hoverWindows, vehicleConfig)
% Оценивает масштаб тяги по участкам, близким к висению.

if nargin < 3 || isempty(vehicleConfig)
    vehicleConfig = copter.config.defaultVehicleConfig();
end

dataTable = localTable(processedData);
model = copter.models.Model6DOF(vehicleConfig);
warnings = strings(0, 1);

if nargin < 2 || isempty(hoverWindows)
    hoverWindows = table(min(dataTable.t_s), max(dataTable.t_s), "all_data", ...
        'VariableNames', {'t_start_s', 't_end_s', 'window_type'});
end

scaleValues = NaN(height(hoverWindows), 1);
collectiveValues = NaN(height(hoverWindows), 1);
for index = 1:height(hoverWindows)
    if any(string(hoverWindows.Properties.VariableNames) == "window_type")
        isHover = contains(string(hoverWindows.window_type(index)), "hover");
        if ~isHover
            continue;
        end
    end

    mask = dataTable.t_s >= hoverWindows.t_start_s(index) & dataTable.t_s <= hoverWindows.t_end_s(index);
    motorValues = readMotors(dataTable(mask, :), vehicleConfig);
    meanSquaredInput = mean(motorValues(:) .^ 2, 'omitnan');
    meanCollective = mean(motorValues(:), 'omitnan');
    if isfinite(meanSquaredInput) && meanSquaredInput > 1e-6
        scaleValues(index) = model.mass_kg * model.g_m_s2 / (4 * model.kT * meanSquaredInput);
        collectiveValues(index) = meanCollective;
    end
end

validValues = scaleValues(isfinite(scaleValues));
if isempty(validValues)
    warnings(end + 1, 1) = "Участки висения для оценки масштаба тяги не найдены; использовано значение 1.";
    estimate.thrust_scale = 1;
else
    estimate.thrust_scale = median(validValues, 'omitnan');
end

estimate.mean_collective = mean(collectiveValues, 'omitnan');
estimate.std_thrust_scale = std(validValues, 0, 'omitnan');
estimate.sample_count = nnz(isfinite(scaleValues));
end

function motors = readMotors(dataTable, vehicleConfig)
motors = NaN(height(dataTable), 4);
for index = 1:4
    normalizedName = "u_motor_" + string(index);
    rawName = "RCOU.C" + string(index);
    if hasVariable(dataTable, normalizedName)
        motors(:, index) = double(dataTable.(normalizedName));
    elseif hasVariable(dataTable, rawName)
        motors(:, index) = copter.utils.normalizePwm( ...
            double(dataTable.(rawName)), ...
            vehicleConfig.normalization.pwm_min, ...
            vehicleConfig.normalization.pwm_max);
    end
end
motors = max(0, min(1, motors));
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
