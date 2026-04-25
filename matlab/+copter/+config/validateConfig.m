function [isValid, warnings] = validateConfig(config)
% Проверяет полноту конфигурации объекта моделирования.

warnings = strings(0, 1);
isValid = true;

requiredFields = ["vehicle_id", "vehicle", "geometry", "inertia", "normalization"];
for index = 1:numel(requiredFields)
    fieldName = requiredFields(index);
    if ~isfield(config, fieldName)
        warnings(end + 1, 1) = "В конфигурации отсутствует поле: " + fieldName;
        isValid = false;
    end
end

if ~isfield(config, 'vehicle')
    return;
end

if isfield(config.vehicle, 'props_declared') && isfield(config.vehicle, 'props_from_cad')
    declared = string(config.vehicle.props_declared);
    fromCad = string(config.vehicle.props_from_cad);
    if declared ~= fromCad
        warnings(end + 1, 1) = "В исходном описании указаны винты Gemfan 8060, а в CAD-выгрузке присутствуют винты APC 7x11E.";
    end
end

if isfield(config, 'inertia')
    if isfield(config.inertia, 'use_products_of_inertia')
        if ~config.inertia.use_products_of_inertia
            warnings(end + 1, 1) = "Произведения инерции CAD сохраняются, но по умолчанию не применяются.";
        end
    end
end

if isfield(config, 'warnings')
    warnings = [warnings; string(config.warnings(:))];
end

warnings = unique(warnings, 'stable');
end
