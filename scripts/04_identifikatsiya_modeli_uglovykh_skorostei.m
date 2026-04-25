% Идентификация модели угловых скоростей.

kornevoyKatalog = fileparts(fileparts(mfilename('fullpath')));
run(fullfile(kornevoyKatalog, 'matlab', 'startup.m'));
konfiguratsiya = kopterkm.konfiguratsiya.zagruzitKonfiguratsiyu(fullfile(kornevoyKatalog, 'config', 'izdeliye_qc_ardupilot_v0.json'));
putObr = fullfile(kornevoyKatalog, 'data', 'processed', 'obrabotannye_dannye.mat');

if ~isfile(putObr)
    fprintf('Обработанный набор данных не найден. Сначала выполните scripts/03_podgotovit_dannye.m.\n');
else
    load(putObr, 'TT');
    uchastki = kopterkm.dannye.vydelitUchastki(TT);
    identifikatsiya = kopterkm.identifikatsiya.otsenitParametryUglovykhSkorostei(TT, konfiguratsiya, uchastki.identifikatsiya);
    putModeli = fullfile(kornevoyKatalog, 'results', 'model_uglovykh_skorostei.mat');
    save(putModeli, 'identifikatsiya', 'uchastki');
    fprintf('Параметры модели сохранены: %s\n', putModeli);
end
