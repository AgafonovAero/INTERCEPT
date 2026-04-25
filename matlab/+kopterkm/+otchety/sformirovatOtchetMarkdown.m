function tekst = sformirovatOtchetMarkdown(putKFailu, dannyeOtcheta)
% Формирует отчет оценки адекватности компьютерной модели в текстовом формате .md.

if nargin < 1
    putKFailu = "";
end
if nargin < 2 || isempty(dannyeOtcheta)
    dannyeOtcheta = struct();
end

konfiguratsiya = poluchitPole(dannyeOtcheta, 'konfiguratsiya', kopterkm.konfiguratsiya.sozdatKonfiguratsiyuPoUmolchaniyu());
kachestvo = poluchitPole(dannyeOtcheta, 'kachestvo_dannykh', struct());
ident = poluchitPole(dannyeOtcheta, 'identifikatsiya', struct());
valid = poluchitPole(dannyeOtcheta, 'validatsiya', struct());
kheshIsh = poluchitPole(dannyeOtcheta, 'khesh_iskhodnykh_dannykh', "");
kheshObr = poluchitPole(dannyeOtcheta, 'khesh_obrabotannykh_dannykh', "");
kheshKonf = poluchitPole(dannyeOtcheta, 'khesh_konfiguratsii', "");

stroki = strings(0, 1);
stroki(end + 1) = "# Отчет оценки адекватности компьютерной модели";
stroki(end + 1) = "";
stroki(end + 1) = "**Данная проверка выполнена по данным бортового журнала и не является полной независимой валидацией реального изделия по внешним средствам измерений.**";
stroki(end + 1) = "";
stroki(end + 1) = "## Область применения";
stroki(end + 1) = "Текущий уровень: " + string(konfiguratsiya.tekushchiy_uroven) + ".";
stroki(end + 1) = "Объект моделирования: " + string(konfiguratsiya.naimenovanie_izdeliya) + ".";
stroki(end + 1) = "Идентификатор изделия: " + string(konfiguratsiya.identifikator_izdeliya) + ".";
stroki(end + 1) = "Версия модели: " + string(konfiguratsiya.versiya_modeli) + ".";
stroki(end + 1) = "";
stroki(end + 1) = "## Среда MATLAB";
stroki(end + 1) = "Версия MATLAB: " + string(version) + ".";
stroki(end + 1) = "";
stroki(end + 1) = "## Конфигурация изделия";
stroki(end + 1) = "- Схема: " + string(konfiguratsiya.izdeliye.skhema);
stroki(end + 1) = "- Прошивка: " + string(konfiguratsiya.izdeliye.proshivka);
stroki(end + 1) = "- Хэш прошивки: " + string(konfiguratsiya.izdeliye.khesh_proshivki);
stroki(end + 1) = "- Полетный контроллер: " + string(konfiguratsiya.izdeliye.poletnyy_kontroller);
stroki(end + 1) = "- Двигатели: " + string(konfiguratsiya.izdeliye.dvigiteli);
stroki(end + 1) = "- Винты по исходному описанию: " + string(konfiguratsiya.izdeliye.vinty_po_opisaniyu);
stroki(end + 1) = "- Винты по CAD: " + string(konfiguratsiya.izdeliye.vinty_po_cad);
stroki(end + 1) = "- Масса по CAD, кг: " + string(konfiguratsiya.izdeliye.massa_po_cad_kg);
stroki(end + 1) = "- Хэш конфигурации: " + string(kheshKonf);
stroki(end + 1) = "";
stroki(end + 1) = "## Данные";
stroki(end + 1) = "- Хэш исходного набора данных: " + string(kheshIsh);
stroki(end + 1) = "- Хэш обработанного набора данных: " + string(kheshObr);
stroki(end + 1) = spisokKanalov(kachestvo);
stroki(end + 1) = "";
stroki(end + 1) = "## Предупреждения качества данных";
stroki = stroki(:);
blok = spisokPreduprezhdeniy(kachestvo, konfiguratsiya);
stroki = [stroki; blok(:)];
stroki(end + 1) = "";
stroki(end + 1) = "## Параметры модели";
blok = opisanieParametrov(ident);
stroki = [stroki; blok(:)];
stroki(end + 1) = "";
stroki(end + 1) = "## Участки идентификации и проверки";
blok = opisanieUchastkov(dannyeOtcheta);
stroki = [stroki; blok(:)];
stroki(end + 1) = "";
stroki(end + 1) = "## Таблица показателей расхождения";
blok = tablitsaPokazateley(valid);
stroki = [stroki; blok(:)];
stroki(end + 1) = "";
stroki(end + 1) = "## Матрица валидации";
blok = tablitsaMatritsy(valid);
stroki = [stroki; blok(:)];
stroki(end + 1) = "";
stroki(end + 1) = "## Графики сопоставления";
blok = spisokGrafikov(poluchitPole(dannyeOtcheta, 'grafiki', strings(0, 1)));
stroki = [stroki; blok(:)];
stroki(end + 1) = "";
stroki(end + 1) = "## Границы применимости";
for k = 1:numel(konfiguratsiya.ogranicheniya)
    stroki(end + 1) = "- " + string(konfiguratsiya.ogranicheniya(k));
end
stroki(end + 1) = "- Критерии приемлемости являются предварительными и подлежат уточнению после накопления валидационного базиса.";
stroki(end + 1) = "";
stroki(end + 1) = "## Заключение";
stroki(end + 1) = "Выполнена оценка адекватности компьютерной модели по данным бортового журнала. Результаты применимы только в пределах указанных данных, допущений и границ применимости.";

tekst = strjoin(stroki, newline);

if strlength(string(putKFailu)) > 0
    papka = fileparts(char(putKFailu));
    if ~isempty(papka) && ~isfolder(papka)
        mkdir(papka);
    end
    fid = fopen(putKFailu, 'w', 'n', 'UTF-8');
    assert(fid > 0, 'Не удалось открыть отчет для записи.');
    ochistka = onCleanup(@() fclose(fid));
    fprintf(fid, '%s', tekst);
end
end

function zn = poluchitPole(s, imya, poUmolchaniyu)
if isstruct(s) && isfield(s, imya)
    zn = s.(imya);
else
    zn = poUmolchaniyu;
end
end

function s = spisokKanalov(kachestvo)
if isstruct(kachestvo) && isfield(kachestvo, 'ispolzovannye_kanaly')
    s = "Использованные каналы: " + strjoin(string(kachestvo.ispolzovannye_kanaly), ", ") + ".";
else
    s = "Использованные каналы: не заданы.";
end
end

function stroki = spisokPreduprezhdeniy(kachestvo, konfiguratsiya)
predupr = strings(0, 1);
if isstruct(kachestvo) && isfield(kachestvo, 'preduprezhdeniya')
    predupr = [predupr; string(kachestvo.preduprezhdeniya(:))];
end
if isfield(konfiguratsiya, 'preduprezhdeniya')
    predupr = [predupr; string(konfiguratsiya.preduprezhdeniya(:))];
end
predupr = unique(predupr, 'stable');
if isempty(predupr)
    stroki = "- Предупреждения не сформированы.";
else
    stroki = "- " + predupr;
end
end

function stroki = opisanieParametrov(ident)
if isstruct(ident) && isfield(ident, 'A')
    stroki = [
        "Матрица A:"
        "```"
        string(mat2str(ident.A, 6))
        "```"
        "Матрица B:"
        "```"
        string(mat2str(ident.B, 6))
        "```"
        "Смещение c:"
        "```"
        string(mat2str(ident.c, 6))
        "```"];
else
    stroki = "Параметры модели не заданы.";
end
end

function stroki = opisanieUchastkov(dannyeOtcheta)
stroki = strings(0, 1);
if isfield(dannyeOtcheta, 'uchastki')
    u = dannyeOtcheta.uchastki;
    if isfield(u, 'identifikatsiya')
        stroki(end + 1) = sprintf('- Участок идентификации: %.3f-%.3f с.', u.identifikatsiya(1), u.identifikatsiya(2));
    end
    if isfield(u, 'proverka')
        stroki(end + 1) = sprintf('- Участок проверки: %.3f-%.3f с.', u.proverka(1), u.proverka(2));
    end
end
if isempty(stroki)
    stroki = "- Участки не заданы.";
end
end

function stroki = tablitsaPokazateley(valid)
if ~isstruct(valid) || ~isfield(valid, 'pokazateli')
    stroki = "Показатели расхождения не заданы.";
    return;
end
p = valid.pokazateli;
stroki = [
    "| Параметр | Среднеквадратическое отклонение | Среднее абсолютное отклонение | Максимальное абсолютное отклонение | Нормированное среднеквадратическое отклонение | Показатель соответствия, % |"
    "|---|---:|---:|---:|---:|---:|"];
imena = ["p", "q", "r"];
for k = 1:3
    stroki(end + 1) = sprintf('| %s | %.6g | %.6g | %.6g | %.6g | %.3f |', ...
        imena(k), ...
        p.srednekvadraticheskoe_otklonenie(k), ...
        p.srednee_absolyutnoe_otklonenie(k), ...
        p.maksimalnoe_absolyutnoe_otklonenie(k), ...
        p.normirovannoe_srednekvadraticheskoe_otklonenie(k), ...
        p.pokazatel_sootvetstviya_proc(k));
end
end

function stroki = tablitsaMatritsy(valid)
if ~isstruct(valid) || ~isfield(valid, 'matritsa_validatsii')
    stroki = "Матрица валидации не задана.";
    return;
end
M = valid.matritsa_validatsii;
stroki = [
    "| Идентификатор проверки | Режим | Источник данных | Участок времени | Проверяемые параметры | Показатели расхождения | Критерий приемлемости | Результат | Вывод | Ограничения |"
    "|---|---|---|---|---|---|---|---|---|---|"];
for k = 1:height(M)
    stroki(end + 1) = "| " + string(M.identifikator_proverki(k)) + ...
        " | " + string(M.rezhim(k)) + ...
        " | " + string(M.istochnik_dannykh(k)) + ...
        " | " + string(M.uchastok_vremeni(k)) + ...
        " | " + string(M.proveryaemye_parametry(k)) + ...
        " | " + string(M.pokazateli_raskhozhdeniya(k)) + ...
        " | " + string(M.kriteriy_priemlemosti(k)) + ...
        " | " + string(M.rezultat(k)) + ...
        " | " + string(M.vyvod(k)) + ...
        " | " + string(M.ogranicheniya(k)) + " |";
end
end

function stroki = spisokGrafikov(grafiki)
grafiki = string(grafiki);
if isempty(grafiki)
    stroki = "- Графики не заданы.";
else
    stroki = "- " + grafiki(:);
end
end
