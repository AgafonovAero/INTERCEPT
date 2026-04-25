function [x0, warnings] = buildInitialStateFromLog(processedData, tStartS, vehicleConfig)
% Формирует начальное состояние Model6DOF по обработанному бортовому журналу.

if nargin < 3 || isempty(vehicleConfig)
    vehicleConfig = copter.config.defaultVehicleConfig();
end

dataTable = localTable(processedData);
assert(~isempty(dataTable), 'Обработанный набор данных пуст.');
assert(hasVariable(dataTable, "t_s"), 'Для построения начального состояния требуется t_s.');

timeSeconds = double(dataTable.t_s(:));
[~, rowIndex] = min(abs(timeSeconds - double(tStartS)));
row = dataTable(rowIndex, :);
model = copter.models.Model6DOF(vehicleConfig);
warnings = strings(0, 1);

position = [
    readValue(row, ["XKF1.PN", "POS.PN", "GPS.N"], 0)
    readValue(row, ["XKF1.PE", "POS.PE", "GPS.E"], 0)
    readValue(row, ["altitude_m", "POS.RelHomeAlt", "POS.Alt", "BARO.Alt"], 0)
    ];

velocity = [
    readValue(row, ["XKF1.VN", "POS.VN", "GPS.VN"], 0)
    readValue(row, ["XKF1.VE", "POS.VE", "GPS.VE"], 0)
    readVerticalVelocity(row)
    ];

angles = [
    readAngleRad(row, "ATT.Roll", "ATT.Roll_rad")
    readAngleRad(row, "ATT.Pitch", "ATT.Pitch_rad")
    readAngleRad(row, "ATT.Yaw", "ATT.Yaw_rad")
    ];

omega = [
    readRateRadS(row, "RATE.R", "RATE.R_rad_s")
    readRateRadS(row, "RATE.P", "RATE.P_rad_s")
    readRateRadS(row, "RATE.Y", "RATE.Y_rad_s")
    ];

motorInput = readMotorInput(row, vehicleConfig);
if any(~isfinite(motorInput))
    warnings(end + 1, 1) = "Команды двигателей в начальной точке не найдены; тяга задана из условия висения.";
    initialThrust = ones(4, 1) .* model.mass_kg .* model.g_m_s2 ./ 4;
else
    initialThrust = model.kT .* (motorInput(:) .^ 2);
end

if any(~isfinite(position))
    warnings(end + 1, 1) = "Часть координат положения отсутствует; использованы безопасные значения по умолчанию.";
    position(~isfinite(position)) = 0;
end

if any(~isfinite(velocity))
    warnings(end + 1, 1) = "Часть компонент скорости отсутствует; использованы безопасные значения по умолчанию.";
    velocity(~isfinite(velocity)) = 0;
end

if any(~isfinite(angles))
    warnings(end + 1, 1) = "Часть углов ориентации отсутствует; использованы нулевые начальные углы.";
    angles(~isfinite(angles)) = 0;
end

if any(~isfinite(omega))
    warnings(end + 1, 1) = "Часть угловых скоростей отсутствует; использованы нулевые начальные угловые скорости.";
    omega(~isfinite(omega)) = 0;
end

x0 = zeros(16, 1);
x0(1:3) = position;
x0(4:6) = velocity;
x0(7:9) = angles;
x0(10:12) = omega;
x0(13:16) = initialThrust;
end

function value = readVerticalVelocity(row)
if hasVariable(row, "vertical_speed_mps")
    value = double(row.vertical_speed_mps);
elseif hasVariable(row, "XKF1.VD")
    value = -double(row.("XKF1.VD"));
elseif hasVariable(row, "GPS.VZ")
    value = -double(row.("GPS.VZ"));
else
    value = 0;
end
end

function value = readAngleRad(row, degreeName, radName)
if hasVariable(row, radName)
    value = double(row.(radName));
elseif hasVariable(row, degreeName)
    value = deg2rad(double(row.(degreeName)));
else
    value = NaN;
end
end

function value = readRateRadS(row, degreeName, radName)
if hasVariable(row, radName)
    value = double(row.(radName));
elseif hasVariable(row, degreeName)
    value = deg2rad(double(row.(degreeName)));
else
    value = NaN;
end
end

function motorInput = readMotorInput(row, vehicleConfig)
motorInput = NaN(4, 1);
for index = 1:4
    normalizedName = "u_motor_" + string(index);
    rawName = "RCOU.C" + string(index);
    if hasVariable(row, normalizedName)
        motorInput(index) = double(row.(normalizedName));
    elseif hasVariable(row, rawName)
        motorInput(index) = copter.utils.normalizePwm( ...
            double(row.(rawName)), ...
            vehicleConfig.normalization.pwm_min, ...
            vehicleConfig.normalization.pwm_max);
    end
end
motorInput = max(0, min(1, motorInput));
end

function value = readValue(row, candidateNames, defaultValue)
value = defaultValue;
for index = 1:numel(candidateNames)
    name = candidateNames(index);
    if hasVariable(row, name)
        candidateValue = double(row.(name));
        if isfinite(candidateValue)
            value = candidateValue;
            return;
        end
    end
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
