function dataTable = convertUnits(dataTable, config)
% Приводит единицы измерения к внутренним единицам расчета.

if nargin < 2 || isempty(config)
    config = copter.config.defaultVehicleConfig();
end

angleFields = [
    "ATT.Roll"
    "ATT.Pitch"
    "ATT.Yaw"
    "ATT.DesRoll"
    "ATT.DesPitch"
    "ATT.DesYaw"
    ];

for index = 1:numel(angleFields)
    fieldName = angleFields(index);
    if hasColumn(dataTable, fieldName)
        outputName = fieldName + "_rad";
        dataTable.(outputName) = deg2rad(double(dataTable.(fieldName)));
        if fieldName == "ATT.Yaw" || fieldName == "ATT.DesYaw"
            dataTable.(outputName) = unwrap(dataTable.(outputName));
        end
    end
end

rateFields = [
    "RATE.R"
    "RATE.P"
    "RATE.Y"
    "RATE.RDes"
    "RATE.PDes"
    "RATE.YDes"
    ];

for index = 1:numel(rateFields)
    fieldName = rateFields(index);
    if hasColumn(dataTable, fieldName)
        dataTable.(fieldName + "_rad_s") = deg2rad(double(dataTable.(fieldName)));
    end
end

for motorIndex = 1:4
    fieldName = "RCOU.C" + motorIndex;
    if hasColumn(dataTable, fieldName)
        dataTable.(fieldName + "_norm") = copter.utils.normalizePwm( ...
            dataTable.(fieldName), ...
            config.normalization.pwm_min, ...
            config.normalization.pwm_max);
    end
end
end

function result = hasColumn(dataTable, fieldName)
result = any(string(dataTable.Properties.VariableNames) == string(fieldName));
end
