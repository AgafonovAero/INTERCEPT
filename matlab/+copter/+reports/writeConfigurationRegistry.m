function text = writeConfigurationRegistry(config, filePath)
% Формирует реестр конфигурации проекта.

if nargin < 1 || isempty(config)
    config = copter.config.defaultVehicleConfig();
end

if nargin < 2
    filePath = "";
end

lines = [
    "# Реестр конфигурации"
    ""
    "Идентификатор изделия: " + string(config.vehicle_id)
    "Версия модели: " + string(config.model_version)
    "Схема: " + string(config.vehicle.frame)
    "Матрица преобразования CAD -> связанная система координат изделия:"
    "```"
    string(mat2str(config.geometry.cad_to_body_matrix, 6))
    "```"
    "Использовать произведения инерции: " + string(config.inertia.use_products_of_inertia)
    "Предупреждения:"
    ];

for index = 1:numel(config.warnings)
    lines(end + 1, 1) = "- " + string(config.warnings(index));
end

text = strjoin(lines, newline);

if strlength(string(filePath)) > 0
    fileId = fopen(filePath, 'w', 'n', 'UTF-8');
    assert(fileId > 0, 'Не удалось открыть реестр конфигурации для записи.');
    cleanup = onCleanup(@() fclose(fileId));
    fprintf(fileId, '%s', text);
end
end
