function writeJson(filePath, data)
% Записывает структуру данных в JSON.

try
    text = jsonencode(data, 'PrettyPrint', true);
catch
    text = jsonencode(data);
end

folderPath = fileparts(char(filePath));
if ~isempty(folderPath) && ~isfolder(folderPath)
    mkdir(folderPath);
end

fileId = fopen(filePath, 'w', 'n', 'UTF-8');
assert(fileId > 0, 'Не удалось открыть JSON для записи.');
cleanup = onCleanup(@() fclose(fileId));
fprintf(fileId, '%s', text);
end
