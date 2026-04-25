function [flightData, extractionReport] = extractFlightSignals(synchronizedData, config)
% Унифицирует сигналы бортового журнала для последующей идентификации.

if nargin < 2 || isempty(config)
    config = copter.config.defaultVehicleConfig();
end

if istimetable(synchronizedData)
    flightData = timetable2table(synchronizedData, 'ConvertRowTimes', false);
else
    flightData = synchronizedData;
end

extractionReport = struct();
extractionReport.warnings = strings(0, 1);

if ~hasVariable(flightData, "t_s")
    flightData.t_s = seconds(synchronizedData.Properties.RowTimes);
end

rateNames = ["R", "P", "Y"];
for index = 1:numel(rateNames)
    sourceName = "RATE." + rateNames(index);
    targetName = sourceName + "_rad_s";
    if hasVariable(flightData, sourceName) && ~hasVariable(flightData, targetName)
        flightData.(targetName) = deg2rad(double(flightData.(sourceName)));
    elseif ~hasVariable(flightData, sourceName)
        extractionReport.warnings(end + 1, 1) = "Отсутствует канал " + sourceName + ".";
    end
end

angleNames = ["Roll", "Pitch", "Yaw"];
for index = 1:numel(angleNames)
    sourceName = "ATT." + angleNames(index);
    targetName = sourceName + "_rad";
    if hasVariable(flightData, sourceName) && ~hasVariable(flightData, targetName)
        angleValue = double(flightData.(sourceName));
        if sourceName == "ATT.Yaw"
            angleValue = rad2deg(unwrap(deg2rad(angleValue)));
        end
        flightData.(targetName) = deg2rad(angleValue);
    elseif ~hasVariable(flightData, sourceName)
        extractionReport.warnings(end + 1, 1) = "Отсутствует канал " + sourceName + ".";
    end
end

[flightData, motorReport] = copter.data.normalizeMotorOutputsFromRCOU(flightData, config);
[flightData, altitudeWarnings] = addAltitude(flightData);
flightData = addHorizontalSpeed(flightData);
extractionReport.motor = motorReport;
extractionReport.warnings = [extractionReport.warnings; altitudeWarnings];
end

function [dataTable, warnings] = addAltitude(dataTable)
warnings = strings(0, 1);
altitudeSources = [
    "POS.RelHomeAlt"
    "POS.Alt"
    "BARO.Alt"
    "GPS.Alt"
    ];

for index = 1:numel(altitudeSources)
    sourceName = altitudeSources(index);
    if hasVariable(dataTable, sourceName)
        dataTable.altitude_m = double(dataTable.(sourceName));
        return;
    end
end

if hasVariable(dataTable, "XKF1.PD")
    dataTable.altitude_m = -double(dataTable.("XKF1.PD"));
else
    dataTable.altitude_m = NaN(height(dataTable), 1);
    warnings(end + 1, 1) = "Высота не найдена в GPS, POS, BARO или XKF1.";
end
end

function dataTable = addHorizontalSpeed(dataTable)
if hasVariable(dataTable, "GPS.Spd")
    dataTable.horizontal_speed_mps = double(dataTable.("GPS.Spd"));
elseif hasVariable(dataTable, "XKF1.VN") && hasVariable(dataTable, "XKF1.VE")
    northSpeed = double(dataTable.("XKF1.VN"));
    eastSpeed = double(dataTable.("XKF1.VE"));
    dataTable.horizontal_speed_mps = hypot(northSpeed, eastSpeed);
else
    dataTable.horizontal_speed_mps = NaN(height(dataTable), 1);
end
end

function result = hasVariable(dataTable, variableName)
result = any(string(dataTable.Properties.VariableNames) == string(variableName));
end
