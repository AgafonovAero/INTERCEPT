function [processedData, derivedReport] = computeDerivedSignals(inputData, settings)
% Рассчитывает производные признаки для выделения участков ВБ.

if nargin < 2 || isempty(settings)
    settings = defaultSettings();
end

if istimetable(inputData)
    dataTable = timetable2table(inputData, 'ConvertRowTimes', false);
else
    dataTable = inputData;
end

if ~hasVariable(dataTable, "t_s")
    error('Для расчета производных признаков требуется t_s.');
end

timeSeconds = double(dataTable.t_s(:));
dataTable.vertical_speed_mps = computeVerticalSpeed(dataTable, timeSeconds);
dataTable.horizontal_speed_mps = ensureHorizontalSpeed(dataTable);
dataTable.roll_abs_deg = abs(readColumn(dataTable, "ATT.Roll"));
dataTable.pitch_abs_deg = abs(readColumn(dataTable, "ATT.Pitch"));
dataTable.yaw_rate_abs_deg_s = abs(readColumn(dataTable, "RATE.Y"));

[rollInput, pitchInput, yawInput, thrustInput] = computeControlAmplitudes(dataTable);
dataTable.control_roll_amplitude = abs(rollInput);
dataTable.control_pitch_amplitude = abs(pitchInput);
dataTable.control_yaw_amplitude = abs(yawInput);
dataTable.control_thrust_amplitude = abs(thrustInput - movmedian(thrustInput, max(3, round(settings.sample_rate_hz))));

dataTable.motor_saturation_flag = computeMotorSaturation(dataTable);
dataTable.is_hover = dataTable.horizontal_speed_mps <= settings.hover_max_horizontal_speed_mps ...
    & abs(dataTable.vertical_speed_mps) <= settings.hover_max_vertical_speed_mps ...
    & dataTable.roll_abs_deg <= settings.hover_max_roll_pitch_deg ...
    & dataTable.pitch_abs_deg <= settings.hover_max_roll_pitch_deg;
dataTable.is_climb = dataTable.vertical_speed_mps >= settings.climb_vertical_speed_threshold_mps;
dataTable.is_descent = dataTable.vertical_speed_mps <= -abs(settings.descent_vertical_speed_threshold_mps);

if istimetable(inputData)
    processedData = table2timetable(dataTable, 'RowTimes', inputData.Properties.RowTimes);
    processedData.Properties.DimensionNames{1} = 'Time';
else
    processedData = dataTable;
end

derivedReport = struct();
derivedReport.nan_percent = 100 * mean(any(ismissing(dataTable), 2), 'omitnan');
derivedReport.motor_saturation_percent = 100 * mean(dataTable.motor_saturation_flag, 'omitnan');
derivedReport.row_count = height(dataTable);
end

function settings = defaultSettings()
settings = struct();
settings.sample_rate_hz = 100;
settings.hover_max_horizontal_speed_mps = 1.5;
settings.hover_max_vertical_speed_mps = 0.5;
settings.hover_max_roll_pitch_deg = 7;
settings.climb_vertical_speed_threshold_mps = 1.0;
settings.descent_vertical_speed_threshold_mps = 1.0;
end

function verticalSpeed = computeVerticalSpeed(dataTable, timeSeconds)
if hasVariable(dataTable, "GPS.VZ")
    verticalSpeed = -double(dataTable.("GPS.VZ"));
elseif hasVariable(dataTable, "XKF1.VD")
    verticalSpeed = -double(dataTable.("XKF1.VD"));
elseif hasVariable(dataTable, "altitude_m")
    altitude = fillmissing(double(dataTable.altitude_m(:)), 'linear', 'EndValues', 'nearest');
    verticalSpeed = gradient(altitude, timeSeconds);
else
    verticalSpeed = NaN(height(dataTable), 1);
end
end

function horizontalSpeed = ensureHorizontalSpeed(dataTable)
if hasVariable(dataTable, "horizontal_speed_mps")
    horizontalSpeed = double(dataTable.horizontal_speed_mps);
elseif hasVariable(dataTable, "GPS.Spd")
    horizontalSpeed = double(dataTable.("GPS.Spd"));
elseif hasVariable(dataTable, "XKF1.VN") && hasVariable(dataTable, "XKF1.VE")
    horizontalSpeed = hypot(double(dataTable.("XKF1.VN")), double(dataTable.("XKF1.VE")));
else
    horizontalSpeed = NaN(height(dataTable), 1);
end
end

function [rollInput, pitchInput, yawInput, thrustInput] = computeControlAmplitudes(dataTable)
if hasVariable(dataTable, "RATE.ROut")
    rollInput = double(dataTable.("RATE.ROut"));
else
    rollInput = reconstructedAxis(dataTable, 1);
end

if hasVariable(dataTable, "RATE.POut")
    pitchInput = double(dataTable.("RATE.POut"));
else
    pitchInput = reconstructedAxis(dataTable, 2);
end

if hasVariable(dataTable, "RATE.YOut")
    yawInput = double(dataTable.("RATE.YOut"));
else
    yawInput = reconstructedAxis(dataTable, 3);
end

motors = readMotors(dataTable);
thrustInput = mean(motors, 2, 'omitnan');
end

function axisValue = reconstructedAxis(dataTable, axisIndex)
motors = readMotors(dataTable);
c1 = motors(:, 1);
c2 = motors(:, 2);
c3 = motors(:, 3);
c4 = motors(:, 4);

if axisIndex == 1
    axisValue = 0.5 * (c2 + c3 - c1 - c4);
elseif axisIndex == 2
    axisValue = 0.5 * (c3 + c4 - c1 - c2);
else
    axisValue = 0.5 * (c1 + c3 - c2 - c4);
end
end

function motors = readMotors(dataTable)
motors = NaN(height(dataTable), 4);
for index = 1:4
    name = "u_motor_" + string(index);
    if hasVariable(dataTable, name)
        motors(:, index) = double(dataTable.(name));
    end
end
end

function saturationFlag = computeMotorSaturation(dataTable)
motors = readMotors(dataTable);
saturationFlag = any(motors <= 0 | motors >= 1, 2);
end

function value = readColumn(dataTable, variableName)
if hasVariable(dataTable, variableName)
    value = double(dataTable.(variableName));
else
    value = NaN(height(dataTable), 1);
end
end

function result = hasVariable(dataTable, variableName)
result = any(string(dataTable.Properties.VariableNames) == string(variableName));
end
