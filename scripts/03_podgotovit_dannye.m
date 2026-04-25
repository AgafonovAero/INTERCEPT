% Подготовка табличного бортового журнала для расчета.

kornevoyKatalog = fileparts(fileparts(mfilename('fullpath')));
run(fullfile(kornevoyKatalog, 'matlab', 'startup.m'));
konfiguratsiya = kopterkm.konfiguratsiya.zagruzitKonfiguratsiyu(fullfile(kornevoyKatalog, 'config', 'izdeliye_qc_ardupilot_v0.json'));

faily = [dir(fullfile(kornevoyKatalog, 'data', 'raw', '*.csv')); dir(fullfile(kornevoyKatalog, 'data', 'raw', '*.mat'))];
if isempty(faily)
    fprintf('В data/raw нет CSV или MAT. Подготовка данных не выполнена.\n');
else
    put = fullfile(faily(1).folder, faily(1).name);
    [TT, kachestvo] = kopterkm.dannye.podgotovitDannye(put, konfiguratsiya);
    putObr = fullfile(kornevoyKatalog, 'data', 'processed', 'obrabotannye_dannye.mat');
    save(putObr, 'TT', 'kachestvo');
    fprintf('Обработанный набор данных сохранен: %s\n', putObr);
end
