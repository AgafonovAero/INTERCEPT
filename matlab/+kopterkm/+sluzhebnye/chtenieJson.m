function dannye = chtenieJson(putKFailu)
% Читает структуру из JSON.

assert(isfile(putKFailu), 'JSON не найден: %s', putKFailu);
tekst = fileread(putKFailu);
dannye = jsondecode(tekst);
end
