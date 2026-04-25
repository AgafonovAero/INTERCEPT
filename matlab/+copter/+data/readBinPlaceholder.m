function info = readBinPlaceholder(filePath)
% Возвращает сведения о BIN без полноценного чтения DataFlash.

if nargin < 1 || strlength(string(filePath)) == 0
    error('Укажите путь к бортовому журналу ArduPilot DataFlash BIN.');
end

if ~isfile(filePath)
    error('Файл BIN не найден: %s. На первом этапе полноценное чтение DataFlash не реализовано.', filePath);
end

fileInfo = dir(filePath);
info = struct();
info.file_path = string(filePath);
info.file_name = string(fileInfo.name);
info.file_size_bytes = fileInfo.bytes;
info.modified_datetime = string(fileInfo.date);
info.message = "Полноценное чтение DataFlash будет реализовано следующим этапом. В текущем PR файл BIN используется только как исходный материал для анализа структуры бортового журнала.";
end
