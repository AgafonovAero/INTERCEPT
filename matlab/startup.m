% Настройка путей проекта программного обеспечения компьютерного моделирования.

kornevoyKatalog = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(kornevoyKatalog, 'matlab'));
addpath(fullfile(kornevoyKatalog, 'scripts'));
addpath(fullfile(kornevoyKatalog, 'tests'));

putKKonfiguratsii = fullfile(kornevoyKatalog, 'config', 'izdeliye_qc_ardupilot_v0.json');
if ~isfile(putKKonfiguratsii)
    konfiguratsiya = kopterkm.konfiguratsiya.sozdatKonfiguratsiyuPoUmolchaniyu();
    kopterkm.konfiguratsiya.sokhranitKonfiguratsiyu(konfiguratsiya, putKKonfiguratsii);
    fprintf('Создана конфигурация изделия: %s\n', putKKonfiguratsii);
end

fprintf('Пути проекта компьютерного моделирования настроены.\n');
