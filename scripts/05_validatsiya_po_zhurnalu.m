% Оценка адекватности компьютерной модели по данным бортового журнала.

kornevoyKatalog = fileparts(fileparts(mfilename('fullpath')));
run(fullfile(kornevoyKatalog, 'matlab', 'startup.m'));
konfiguratsiya = kopterkm.konfiguratsiya.zagruzitKonfiguratsiyu(fullfile(kornevoyKatalog, 'config', 'izdeliye_qc_ardupilot_v0.json'));
putObr = fullfile(kornevoyKatalog, 'data', 'processed', 'obrabotannye_dannye.mat');
putModeli = fullfile(kornevoyKatalog, 'results', 'model_uglovykh_skorostei.mat');

if ~isfile(putObr) || ~isfile(putModeli)
    fprintf('Не найдены обработанные данные или параметры модели. Выполните сценарии 03 и 04.\n');
else
    load(putObr, 'TT', 'kachestvo');
    load(putModeli, 'identifikatsiya', 'uchastki');
    validatsiya = kopterkm.validatsiya.otsenitAdekvantostPoZhurnalu(TT, identifikatsiya.model, uchastki.proverka, konfiguratsiya);
    grafiki = kopterkm.otchety.sformirovatGrafiki(TT, validatsiya.raschet, fullfile(kornevoyKatalog, 'results'));
    dannyeOtcheta = struct();
    dannyeOtcheta.konfiguratsiya = konfiguratsiya;
    dannyeOtcheta.kachestvo_dannykh = kachestvo;
    dannyeOtcheta.identifikatsiya = identifikatsiya;
    dannyeOtcheta.validatsiya = validatsiya;
    dannyeOtcheta.uchastki = uchastki;
    dannyeOtcheta.grafiki = grafiki;
    putOtcheta = fullfile(kornevoyKatalog, 'results', 'otchet_otsenki_adekvatnosti.md');
    kopterkm.otchety.sformirovatOtchetMarkdown(putOtcheta, dannyeOtcheta);
    fprintf('Отчет сформирован: %s\n', putOtcheta);
end
