% Демонстрационный расчет модели движения с шестью степенями свободы.

kornevoyKatalog = fileparts(fileparts(mfilename('fullpath')));
run(fullfile(kornevoyKatalog, 'matlab', 'startup.m'));
konfiguratsiya = kopterkm.konfiguratsiya.zagruzitKonfiguratsiyu(fullfile(kornevoyKatalog, 'config', 'izdeliye_qc_ardupilot_v0.json'));
model = kopterkm.modeli.ModelDvizheniya6SS(konfiguratsiya);

x0 = zeros(16, 1);
tyagaNaDvigatel = model.massa_kg * model.g_m_s2 / 4;
x0(13:16) = tyagaNaDvigatel;
uVisenie = sqrt(tyagaNaDvigatel / model.kT) * ones(4, 1);

f = @(t, x) kopterkm.modeli.pravayaChast6SS(t, x, uVisenie, model);
[t, x] = ode45(f, [0 2], x0);

putRez = fullfile(kornevoyKatalog, 'results', 'raschet_modeli_6ss.mat');
save(putRez, 't', 'x', 'model');
fprintf('Расчет модели движения с шестью степенями свободы сохранен: %s\n', putRez);
