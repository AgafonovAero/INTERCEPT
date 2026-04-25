% Создание папок и конфигурации изделия.

kornevoyKatalog = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(kornevoyKatalog, 'matlab'));

papki = ["matlab", "scripts", "config", "docs", "tests", "results", ...
    fullfile("data", "raw"), fullfile("data", "processed")];
for k = 1:numel(papki)
    put = fullfile(kornevoyKatalog, papki(k));
    if ~isfolder(put)
        mkdir(put);
    end
end

konfiguratsiya = kopterkm.konfiguratsiya.sozdatKonfiguratsiyuPoUmolchaniyu();
putKKonfiguratsii = fullfile(kornevoyKatalog, 'config', 'izdeliye_qc_ardupilot_v0.json');
kopterkm.konfiguratsiya.sokhranitKonfiguratsiyu(konfiguratsiya, putKKonfiguratsii);

fprintf('Проект компьютерного моделирования создан.\n');
fprintf('Конфигурация изделия: %s\n', putKKonfiguratsii);
