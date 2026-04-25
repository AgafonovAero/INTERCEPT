function data = readJson(filePath)
% Читает структуру данных из JSON.

assert(isfile(filePath), 'JSON не найден: %s', filePath);
text = fileread(filePath);
data = jsondecode(text);
end
