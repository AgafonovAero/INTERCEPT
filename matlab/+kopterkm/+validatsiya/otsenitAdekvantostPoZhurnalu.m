function rezultat = otsenitAdekvantostPoZhurnalu(dannye, parametryModeli, uchastok, konfiguratsiya)
% Оценивает адекватность компьютерной модели по отложенному участку журнала.

if nargin < 4 || isempty(konfiguratsiya)
    konfiguratsiya = kopterkm.konfiguratsiya.sozdatKonfiguratsiyuPoUmolchaniyu();
end

raschet = kopterkm.validatsiya.vypolnitRaschetNaUchastke(dannye, parametryModeli, uchastok);
T = lokalnayaTablitsa(dannye);
maska = T.t_s >= uchastok(1) & T.t_s <= uchastok(2);
T = T(maska, :);

yRef = [poluchitSkorost(T, "RATE.R"), poluchitSkorost(T, "RATE.P"), poluchitSkorost(T, "RATE.Y")];
yCalc = [raschet.RATE_R_calc_rad_s, raschet.RATE_P_calc_rad_s, raschet.RATE_Y_calc_rad_s];
pokazateli = kopterkm.validatsiya.raschitatPokazateliRaskhozhdeniya(yRef, yCalc);
matritsa = kopterkm.validatsiya.sformirovatMatritsuValidatsii(pokazateli, uchastok, konfiguratsiya);

rezultat = struct();
rezultat.raschet = raschet;
rezultat.pokazateli = pokazateli;
rezultat.matritsa_validatsii = matritsa;
rezultat.uchastok_proverki_s = uchastok;
rezultat.preduprezhdenie = "Данная проверка выполнена по данным бортового журнала и не является полной независимой валидацией реального изделия по внешним средствам измерений.";
end

function T = lokalnayaTablitsa(dannye)
if istimetable(dannye)
    T = timetable2table(dannye, 'ConvertRowTimes', false);
else
    T = dannye;
end
end

function y = poluchitSkorost(T, imya)
imyaRad = imya + "_rad_s";
if any(string(T.Properties.VariableNames) == imyaRad)
    y = double(T.(imyaRad));
else
    y = deg2rad(double(T.(imya)));
end
end
