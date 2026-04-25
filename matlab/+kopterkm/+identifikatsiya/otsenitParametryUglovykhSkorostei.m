function rezultat = otsenitParametryUglovykhSkorostei(dannye, konfiguratsiya, uchastok)
% Идентифицирует модель угловых скоростей по данным бортового журнала.

if nargin < 2 || isempty(konfiguratsiya)
    konfiguratsiya = kopterkm.konfiguratsiya.sozdatKonfiguratsiyuPoUmolchaniyu();
end
if nargin < 3
    uchastok = [];
end

T = lokalnayaTablitsa(dannye);
if ~isempty(uchastok)
    maska = T.t_s >= uchastok(1) & T.t_s <= uchastok(2);
    T = T(maska, :);
end
assert(height(T) >= 6, 'Недостаточно строк для идентификации модели угловых скоростей.');

[Y, imenaY] = izmerennyeSkorosti(T);
[U, imenaU, istochnikU] = upravlyayushchieVozdeystviya(T);
t = double(T.t_s(:));

A = zeros(3);
B = zeros(3);
c = zeros(3, 1);
zaderzhki = zeros(3, 1);
oshibki = zeros(3, 1);

maksZaderzhka = konfiguratsiya.model_uglovykh_skorostei.maksimalnaya_zaderzhka_shagov;
for os = 1:3
    y = Y(:, os);
    u = U(:, os);
    dy = kopterkm.identifikatsiya.raschetProizvodnykh(t, y);
    [zaderzhka, ~] = kopterkm.identifikatsiya.otsenitZaderzhkuVkhoda(y, dy, u, maksZaderzhka);
    indeks = (1 + zaderzhka):numel(t);
    X = [y(indeks), u(indeks - zaderzhka), ones(numel(indeks), 1)];
    theta = X \ dy(indeks);
    A(os, os) = theta(1);
    B(os, os) = theta(2);
    c(os) = theta(3);
    ostatok = dy(indeks) - X * theta;
    oshibki(os) = sqrt(mean(ostatok .^ 2, 'omitnan'));
    zaderzhki(os) = zaderzhka;
end

rezultat = struct();
rezultat.model = kopterkm.modeli.ModelUglovykhSkorostei(A, B, c);
rezultat.A = A;
rezultat.B = B;
rezultat.c = c;
rezultat.zaderzhki_shagov = zaderzhki;
rezultat.oshibka_sko_proizvodnykh = oshibki;
rezultat.imena_izmerennykh_kanalov = imenaY;
rezultat.imena_vkhodnykh_kanalov = imenaU;
rezultat.istochnik_vkhoda = istochnikU;
rezultat.uchastok_identifikatsii_s = uchastok;
end

function T = lokalnayaTablitsa(dannye)
if istimetable(dannye)
    T = timetable2table(dannye, 'ConvertRowTimes', false);
else
    T = dannye;
end
end

function [Y, imena] = izmerennyeSkorosti(T)
imena = ["RATE.R_rad_s", "RATE.P_rad_s", "RATE.Y_rad_s"];
zapask = ["RATE.R", "RATE.P", "RATE.Y"];
Y = zeros(height(T), 3);
for k = 1:3
    if est(T, imena(k))
        Y(:, k) = double(T.(imena(k)));
    elseif est(T, zapask(k))
        Y(:, k) = deg2rad(double(T.(zapask(k))));
        imena(k) = zapask(k);
    else
        error('Не найден канал измеренной угловой скорости: %s', zapask(k));
    end
end
end

function [U, imena, istochnik] = upravlyayushchieVozdeystviya(T)
imena = ["RATE.ROut", "RATE.POut", "RATE.YOut"];
U = zeros(height(T), 3);
if all(estNabor(T, imena))
    for k = 1:3
        U(:, k) = double(T.(imena(k)));
    end
    istochnik = "RATE.ROut, RATE.POut, RATE.YOut";
    return;
end

rcou = ["RCOU.C1_norm", "RCOU.C2_norm", "RCOU.C3_norm", "RCOU.C4_norm"];
if all(estNabor(T, rcou))
    c1 = double(T.(rcou(1)));
    c2 = double(T.(rcou(2)));
    c3 = double(T.(rcou(3)));
    c4 = double(T.(rcou(4)));
else
    rcouRaw = ["RCOU.C1", "RCOU.C2", "RCOU.C3", "RCOU.C4"];
    if ~all(estNabor(T, rcouRaw))
        error('Не найдены RATE.*Out и RCOU.C1-C4 для восстановления входных воздействий.');
    end
    c1 = kopterkm.sluzhebnye.normalizatsiyaShIM(T.(rcouRaw(1)), 1000, 2000);
    c2 = kopterkm.sluzhebnye.normalizatsiyaShIM(T.(rcouRaw(2)), 1000, 2000);
    c3 = kopterkm.sluzhebnye.normalizatsiyaShIM(T.(rcouRaw(3)), 1000, 2000);
    c4 = kopterkm.sluzhebnye.normalizatsiyaShIM(T.(rcouRaw(4)), 1000, 2000);
end

U(:, 1) = 0.5 * (c2 + c3 - c1 - c4);
U(:, 2) = 0.5 * (c3 + c4 - c1 - c2);
U(:, 3) = 0.5 * (c1 + c3 - c2 - c4);
imena = ["RCOU крен", "RCOU тангаж", "RCOU рыскание"];
istochnik = "Приближенное восстановление по RCOU.C1-C4";
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
