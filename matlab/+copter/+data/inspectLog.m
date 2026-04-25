function info = inspectLog(source, config)
% Формирует краткие сведения о бортовом журнале.

if nargin < 2 || isempty(config)
    config = copter.config.defaultVehicleConfig();
end

filePath = string(source);
if strlength(filePath) > 0 && isfile(filePath)
    [~, ~, extension] = fileparts(filePath);
    if strcmpi(extension, '.bin')
        info = copter.data.readBinPlaceholder(filePath);
        fprintf('%s\n', info.message);
        return;
    end
end

dataTable = copter.data.readTableLog(source);
[dataTable, ~, timeInfo] = copter.data.normalizeTime(dataTable);
quality = copter.data.assessDataQuality(dataTable, config);

info = struct();
info.columns = transpose(string(dataTable.Properties.VariableNames));
info.time = timeInfo;
info.quality = quality;

fprintf('Столбцов: %d\n', numel(info.columns));
fprintf('Строк: %d\n', quality.row_count);
fprintf('Длительность, с: %.3f\n', quality.duration_s);

if ~isempty(quality.warnings)
    fprintf('Предупреждения качества данных:\n');
    for index = 1:numel(quality.warnings)
        fprintf('  - %s\n', quality.warnings(index));
    end
end
end
