function zapisJson(putKFailu, dannye)
% Записывает структуру в JSON.

try
    tekst = jsonencode(dannye, 'PrettyPrint', true);
catch
    tekst = jsonencode(dannye);
end

fid = fopen(putKFailu, 'w', 'n', 'UTF-8');
assert(fid > 0, 'Не удалось открыть JSON для записи.');
ochistka = onCleanup(@() fclose(fid));
fprintf(fid, '%s', tekst);
end
