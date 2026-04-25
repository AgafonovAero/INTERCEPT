function [normalization, warnings] = buildPwmNormalizationFromParams(params, vehicleConfig)
% Формирует правила нормирования RCOU по параметрам ArduPilot.

if nargin < 2 || isempty(vehicleConfig)
    vehicleConfig = copter.config.defaultVehicleConfig();
end

warnings = strings(0, 1);
pwmMin = readParam(params, "MOT_PWM_MIN", NaN);
pwmMax = readParam(params, "MOT_PWM_MAX", NaN);

if ~isfinite(pwmMin) || pwmMin <= 0
    pwmMin = vehicleConfig.normalization.pwm_min;
    warnings(end + 1, 1) = "MOT_PWM_MIN отсутствует; используется значение из конфигурации изделия.";
end

if ~isfinite(pwmMax) || pwmMax <= pwmMin
    pwmMax = vehicleConfig.normalization.pwm_max;
    warnings(end + 1, 1) = "MOT_PWM_MAX отсутствует или некорректен; используется значение из конфигурации изделия.";
end

normalization = struct();
normalization.pwm_min = double(pwmMin);
normalization.pwm_max = double(pwmMax);
normalization.source = "ArduPilot PARM";
normalization.servo_min = NaN(16, 1);
normalization.servo_max = NaN(16, 1);
normalization.servo_trim = NaN(16, 1);

for index = 1:16
    normalization.servo_min(index) = readParam(params, "SERVO" + string(index) + "_MIN", NaN);
    normalization.servo_max(index) = readParam(params, "SERVO" + string(index) + "_MAX", NaN);
    normalization.servo_trim(index) = readParam(params, "SERVO" + string(index) + "_TRIM", NaN);
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
