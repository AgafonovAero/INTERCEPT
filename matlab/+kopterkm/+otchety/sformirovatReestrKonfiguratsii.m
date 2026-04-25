function tekst = sformirovatReestrKonfiguratsii(konfiguratsiya, putKFailu)
% Формирует реестр конфигурации программного обеспечения компьютерного моделирования.

if nargin < 1 || isempty(konfiguratsiya)
    konfiguratsiya = kopterkm.konfiguratsiya.sozdatKonfiguratsiyuPoUmolchaniyu();
end
if nargin < 2
    putKFailu = "";
end

stroki = [
    "# Реестр конфигурации"
    ""
    "Идентификатор изделия: " + string(konfiguratsiya.identifikator_izdeliya)
    "Версия модели: " + string(konfiguratsiya.versiya_modeli)
    "Схема: " + string(konfiguratsiya.izdeliye.skhema)
    "Матрица преобразования CAD -> связанная система координат изделия:"
    "```"
    string(mat2str(konfiguratsiya.geometriya.preobrazovanie_cad_v_ssi, 6))
    "```"
    "Использовать произведения инерции: " + string(konfiguratsiya.inertsiya.use_products_of_inertia)
    "Предупреждения:"
    ];
for k = 1:numel(konfiguratsiya.preduprezhdeniya)
    stroki(end + 1) = "- " + string(konfiguratsiya.preduprezhdeniya(k));
end

tekst = strjoin(stroki, newline);
if strlength(string(putKFailu)) > 0
    fid = fopen(putKFailu, 'w', 'n', 'UTF-8');
    assert(fid > 0, 'Не удалось открыть реестр для записи.');
    ochistka = onCleanup(@() fclose(fid));
    fprintf(fid, '%s', tekst);
end
end
