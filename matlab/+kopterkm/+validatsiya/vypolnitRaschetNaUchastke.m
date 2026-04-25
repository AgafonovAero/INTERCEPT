function rezultat = vypolnitRaschetNaUchastke(dannye, model, uchastok)
% Выполняет расчет модели угловых скоростей на отложенном участке.

T = lokalnayaTablitsa(dannye);
if nargin >= 3 && ~isempty(uchastok)
    maska = T.t_s >= uchastok(1) & T.t_s <= uchastok(2);
    T = T(maska, :);
end
assert(height(T) >= 2, 'Недостаточно строк для расчета компьютерной модели.');

t = double(T.t_s(:));
Y0 = izmerennyeSkorosti(T(1, :)).';
U = upravlyayushchieVozdeystviya(T);
omega = zeros(numel(t), 3);
omega(1, :) = Y0(:).';

for k = 1:(numel(t) - 1)
    h = t(k + 1) - t(k);
    u1 = U(k, :).';
    u2 = U(k + 1, :).';
    us = 0.5 * (u1 + u2);
    x = omega(k, :).';
    k1 = kopterkm.modeli.pravayaChastUglovykhSkorostei(t(k), x, u1, model);
    k2 = kopterkm.modeli.pravayaChastUglovykhSkorostei(t(k) + h / 2, x + h * k1 / 2, us, model);
    k3 = kopterkm.modeli.pravayaChastUglovykhSkorostei(t(k) + h / 2, x + h * k2 / 2, us, model);
    k4 = kopterkm.modeli.pravayaChastUglovykhSkorostei(t(k + 1), x + h * k3, u2, model);
    omega(k + 1, :) = (x + h * (k1 + 2 * k2 + 2 * k3 + k4) / 6).';
end

rezultat = table();
rezultat.t_s = t;
rezultat.RATE_R_calc_rad_s = omega(:, 1);
rezultat.RATE_P_calc_rad_s = omega(:, 2);
rezultat.RATE_Y_calc_rad_s = omega(:, 3);
rezultat.RATE_R_calc_deg_s = rad2deg(omega(:, 1));
rezultat.RATE_P_calc_deg_s = rad2deg(omega(:, 2));
rezultat.RATE_Y_calc_deg_s = rad2deg(omega(:, 3));
end

function T = lokalnayaTablitsa(dannye)
if istimetable(dannye)
    T = timetable2table(dannye, 'ConvertRowTimes', false);
else
    T = dannye;
end
end

function Y = izmerennyeSkorosti(T)
imena = ["RATE.R_rad_s", "RATE.P_rad_s", "RATE.Y_rad_s"];
zapask = ["RATE.R", "RATE.P", "RATE.Y"];
Y = zeros(height(T), 3);
for k = 1:3
    if est(T, imena(k))
        Y(:, k) = double(T.(imena(k)));
    elseif est(T, zapask(k))
        Y(:, k) = deg2rad(double(T.(zapask(k))));
    else
        error('Не найден канал измеренной угловой скорости: %s', zapask(k));
    end
end
end

function U = upravlyayushchieVozdeystviya(T)
imena = ["RATE.ROut", "RATE.POut", "RATE.YOut"];
U = zeros(height(T), 3);
if all(estNabor(T, imena))
    for k = 1:3
        U(:, k) = double(T.(imena(k)));
    end
    return;
end

rcou = ["RCOU.C1_norm", "RCOU.C2_norm", "RCOU.C3_norm", "RCOU.C4_norm"];
if all(estNabor(T, rcou))
    c1 = double(T.(rcou(1)));
    c2 = double(T.(rcou(2)));
    c3 = double(T.(rcou(3)));
    c4 = double(T.(rcou(4)));
else
    error('Для расчета требуется RATE.*Out или нормированные RCOU.C1-C4.');
end

U(:, 1) = 0.5 * (c2 + c3 - c1 - c4);
U(:, 2) = 0.5 * (c3 + c4 - c1 - c2);
U(:, 3) = 0.5 * (c1 + c3 - c2 - c4);
end

function tf = est(T, imya)
tf = any(string(T.Properties.VariableNames) == string(imya));
end

function tf = estNabor(T, imena)
tf = false(size(imena));
for i = 1:numel(imena)
    tf(i) = est(T, imena(i));
end
end
