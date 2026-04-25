function result = fitModel6DOF(~, config)
% Создает заготовку параметров модели движения с шестью степенями свободы.

if nargin < 2 || isempty(config)
    config = copter.config.defaultVehicleConfig();
end

result = struct();
result.model = copter.models.Model6DOF(config);
result.note = "На первом этапе параметры модели движения с шестью степенями свободы берутся из конфигурации изделия.";
end
