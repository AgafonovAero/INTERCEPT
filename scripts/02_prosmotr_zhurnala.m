% Просмотр доступных столбцов и качества бортового журнала.

kornevoyKatalog = fileparts(fileparts(mfilename('fullpath')));
run(fullfile(kornevoyKatalog, 'matlab', 'startup.m'));
konfiguratsiya = kopterkm.konfiguratsiya.zagruzitKonfiguratsiyu(fullfile(kornevoyKatalog, 'config', 'izdeliye_qc_ardupilot_v0.json'));

faily = [dir(fullfile(kornevoyKatalog, 'data', 'raw', '*.csv')); dir(fullfile(kornevoyKatalog, 'data', 'raw', '*.mat'))];
if isempty(faily)
    fprintf('В data/raw нет CSV или MAT. Поместите табличный бортовой журнал в эту папку.\n');
else
    put = fullfile(faily(1).folder, faily(1).name);
    fprintf('Просмотр набора данных: %s\n', put);
    kopterkm.dannye.prosmotrZhurnala(put, konfiguratsiya);
end
