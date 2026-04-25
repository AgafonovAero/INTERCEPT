function matritsa = sformirovatMatritsuValidatsii(pokazateli, uchastok, konfiguratsiya)
% Формирует минимальную матрицу проверки адекватности по журналу.

if nargin < 2 || isempty(uchastok)
    uchastok = [NaN, NaN];
end
if nargin < 3 || isempty(konfiguratsiya)
    konfiguratsiya = kopterkm.konfiguratsiya.sozdatKonfiguratsiyuPoUmolchaniyu();
end

sootv = pokazateli.pokazatel_sootvetstviya_proc;
rezRoll = sootv(1) >= konfiguratsiya.kriterii.sootvetstvie_roll_pitch_min_proc;
rezPitch = sootv(2) >= konfiguratsiya.kriterii.sootvetstvie_roll_pitch_min_proc;
rezYaw = sootv(3) >= konfiguratsiya.kriterii.sootvetstvie_yaw_min_proc;

matritsa = table();
matritsa.identifikator_proverki = ["RATE_R"; "RATE_P"; "RATE_Y"];
matritsa.rezhim = repmat("Проверка по отложенному участку бортового журнала", 3, 1);
matritsa.istochnik_dannykh = repmat("Бортовой журнал ArduPilot", 3, 1);
matritsa.uchastok_vremeni = repmat(string(sprintf('%.3f-%.3f с', uchastok(1), uchastok(2))), 3, 1);
matritsa.proveryaemye_parametry = ["угловая скорость крена"; "угловая скорость тангажа"; "угловая скорость рыскания"];
matritsa.pokazateli_raskhozhdeniya = [
    string(sprintf('показатель соответствия %.2f%%', sootv(1)))
    string(sprintf('показатель соответствия %.2f%%', sootv(2)))
    string(sprintf('показатель соответствия %.2f%%', sootv(3)))];
matritsa.kriteriy_priemlemosti = [
    string(sprintf('не менее %.1f%%', konfiguratsiya.kriterii.sootvetstvie_roll_pitch_min_proc))
    string(sprintf('не менее %.1f%%', konfiguratsiya.kriterii.sootvetstvie_roll_pitch_min_proc))
    string(sprintf('не менее %.1f%%', konfiguratsiya.kriterii.sootvetstvie_yaw_min_proc))];
matritsa.rezultat = [slovoRezultata(rezRoll); slovoRezultata(rezPitch); slovoRezultata(rezYaw)];
matritsa.vyvod = [
    "Предварительная оценка по данным журнала"
    "Предварительная оценка по данным журнала"
    "Предварительная оценка по данным журнала"];
matritsa.ogranicheniya = repmat("Не является полной независимой валидацией реального изделия", 3, 1);
end

function s = slovoRezultata(tf)
if tf
    s = "соответствует";
else
    s = "не соответствует";
end
end
