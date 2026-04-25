function dataTable = readTableLog(source)
% Читает табличный бортовой журнал ArduPilot из CSV, MAT, table или timetable.

if istimetable(source) || istable(source)
    dataTable = source;
    return;
end

filePath = char(string(source));
assert(isfile(filePath), 'Набор данных не найден: %s', filePath);
[~, ~, extension] = fileparts(filePath);
extension = lower(extension);

switch extension
    case '.csv'
        options = detectImportOptions(filePath, 'VariableNamingRule', 'preserve');
        dataTable = readtable(filePath, options);
    case '.mat'
        dataTable = copter.data.readMatData(filePath);
    case '.bin'
        error('Файл BIN на первом этапе не разбирается полноценно. Используйте readBinPlaceholder или предварительное приведение к CSV/MAT.');
    otherwise
        error('Поддерживаются CSV, MAT, table и timetable MATLAB.');
end
end
