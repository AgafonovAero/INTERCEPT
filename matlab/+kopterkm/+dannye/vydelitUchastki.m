function uchastki = vydelitUchastki(dannye, dlitelnostUchastkaS)
% Делит данные на разные участки идентификации и проверки.

if nargin < 2 || isempty(dlitelnostUchastkaS)
    dlitelnostUchastkaS = 2;
end

if istimetable(dannye)
    t = dannye.t_s;
else
    t = dannye.t_s;
end
t = double(t(:));
assert(numel(t) >= 2, 'Недостаточно данных для выделения участков.');

t0 = t(1);
tEnd = t(end);
dlitelnost = tEnd - t0;
dlitelnostUchastkaS = min(max(0.5, dlitelnostUchastkaS), max(0.5, dlitelnost / 2));

granitsa1 = t0 + dlitelnostUchastkaS;
granitsa2 = min(tEnd, granitsa1 + dlitelnostUchastkaS);
if granitsa2 <= granitsa1
    granitsa1 = t0 + dlitelnost / 2;
    granitsa2 = tEnd;
end

uchastki = struct();
uchastki.identifikatsiya = [t0, granitsa1];
uchastki.proverka = [granitsa1, granitsa2];
uchastki.primechanie = "Параметры на участке проверки не настраиваются.";
end
