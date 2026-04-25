function report = inspectArduPilotFrameParams(params, vehicleConfig)
% Сопоставляет параметры рамы ArduPilot с конфигурацией объекта моделирования.

if nargin < 2 || isempty(vehicleConfig)
    vehicleConfig = copter.config.defaultVehicleConfig();
end

frameClass = readParam(params, "FRAME_CLASS", NaN);
frameType = readParam(params, "FRAME_TYPE", NaN);
warnings = strings(0, 1);

isQuad = isfinite(frameClass) && frameClass == 1;
isX = isfinite(frameType) && frameType == 1;
matchesConfig = isQuad && isX && string(vehicleConfig.vehicle.frame) == "QUAD/X";

if ~isfinite(frameClass)
    warnings(end + 1, 1) = "FRAME_CLASS отсутствует в PARM; схема рамы подтверждается только конфигурацией изделия.";
end

if ~isfinite(frameType)
    warnings(end + 1, 1) = "FRAME_TYPE отсутствует в PARM; тип рамы подтверждается только конфигурацией изделия.";
end

if isfinite(frameClass) && ~isQuad
    warnings(end + 1, 1) = "FRAME_CLASS не соответствует ожидаемому QUAD.";
end

if isfinite(frameType) && ~isX
    warnings(end + 1, 1) = "FRAME_TYPE не соответствует ожидаемому X.";
end

report = struct();
report.frame_class = frameClass;
report.frame_type = frameType;
report.expected_frame = string(vehicleConfig.vehicle.frame);
report.interpreted_frame = interpretFrame(frameClass, frameType);
report.matches_vehicle_config = matchesConfig;
report.warnings = unique(warnings, 'stable');
end

function text = interpretFrame(frameClass, frameType)
if frameClass == 1 && frameType == 1
    text = "QUAD/X";
elseif ~isfinite(frameClass) || ~isfinite(frameType)
    text = "не определено";
else
    text = "иная схема";
end
end

function value = readParam(params, name, defaultValue)
fieldName = matlab.lang.makeValidName(char(name));
if isstruct(params) && isfield(params, fieldName)
    value = double(params.(fieldName));
else
    value = defaultValue;
end
end
