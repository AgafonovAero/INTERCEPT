function [dataTable, saturationReport] = normalizeMotorOutputsFromRCOU(dataTable, config)
% Нормирует выходы RCOU без изменения принятого мотор-маппинга.

if nargin < 2 || isempty(config)
    config = copter.config.defaultVehicleConfig();
end

pwmMin = config.normalization.pwm_min;
pwmMax = config.normalization.pwm_max;
saturationMask = false(height(dataTable), 4);

for index = 1:4
    sourceName = "RCOU.C" + string(index);
    normName = "RCOU.C" + string(index) + "_norm";
    motorName = "u_motor_" + string(index);
    if hasVariable(dataTable, sourceName)
        pwmValue = double(dataTable.(sourceName));
        normalizedValue = copter.utils.normalizePwm(pwmValue, pwmMin, pwmMax);
        dataTable.(normName) = normalizedValue;
        dataTable.(motorName) = normalizedValue;
        saturationMask(:, index) = normalizedValue <= 0 | normalizedValue >= 1;
    elseif ~hasVariable(dataTable, motorName)
        dataTable.(normName) = NaN(height(dataTable), 1);
        dataTable.(motorName) = NaN(height(dataTable), 1);
    end
end

saturationReport = struct();
saturationReport.pwm_min = pwmMin;
saturationReport.pwm_max = pwmMax;
saturationReport.motor_saturation_percent = 100 * mean(any(saturationMask, 2), 'omitnan');
saturationReport.note = "Нормирование выполнено по конфигурации изделия; жесткие предположения о мотор-маппинге не вводились.";
end

function result = hasVariable(dataTable, variableName)
result = any(string(dataTable.Properties.VariableNames) == string(variableName));
end
