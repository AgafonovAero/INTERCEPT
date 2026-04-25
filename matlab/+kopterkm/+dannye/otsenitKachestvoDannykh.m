function otchet = otsenitKachestvoDannykh(T, konfiguratsiya)
% Оценивает качество исходных данных и наличие каналов.

if nargin < 2 || isempty(konfiguratsiya)
    konfiguratsiya = kopterkm.konfiguratsiya.sozdatKonfiguratsiyuPoUmolchaniyu();
end

kanaly = ["TimeUS", "ATT.Roll", "ATT.Pitch", "ATT.Yaw", ...
    "ATT.DesRoll", "ATT.DesPitch", "ATT.DesYaw", ...
    "RATE.R", "RATE.P", "RATE.Y", ...
    "RATE.RDes", "RATE.PDes", "RATE.YDes", ...
    "RATE.ROut", "RATE.POut", "RATE.YOut", "RATE.AOut", ...
    "RCOU.C1", "RCOU.C2", "RCOU.C3", "RCOU.C4", ...
    "BAT.Volt", "BAT.Curr", "BAT.CurrTot", "BAT.EnrgTot", ...
    "ESC.RPM", "ESC.Curr", "ESC.Volt"];

[ispolzovannye, otsutstvuyushchie] = kopterkm.sluzhebnye.proverkaPoleiTablitsy(T, kanaly);

preduprezhdeniya = strings(0, 1);
if ~isempty(otsutstvuyushchie)
    preduprezhdeniya(end + 1, 1) = "Отсутствующие необязательные каналы: " + strjoin(otsutstvuyushchie, ", ");
end

if any(string(T.Properties.VariableNames) == "t_s")
    t = double(T.t_s(:));
    dt = diff(t);
    if ~isempty(dt)
        medianaDt = median(dt);
        propuski = find(dt > 1.5 * medianaDt);
        if ~isempty(propuski)
            preduprezhdeniya(end + 1, 1) = "Выявлены пропуски времени: " + num2str(numel(propuski));
        end
        if any(dt <= 0)
            preduprezhdeniya(end + 1, 1) = "Выявлены нестрого возрастающие отметки времени.";
        end
    end
end

[~, preduprKonf] = kopterkm.konfiguratsiya.proveritKonfiguratsiyu(konfiguratsiya);
preduprezhdeniya = [preduprezhdeniya; preduprKonf(:)];

otchet = struct();
otchet.ispolzovannye_kanaly = ispolzovannye(:);
otchet.otsutstvuyushchie_kanaly = otsutstvuyushchie(:);
otchet.preduprezhdeniya = unique(preduprezhdeniya, 'stable');
otchet.chislo_strok = height(T);
if any(string(T.Properties.VariableNames) == "t_s") && height(T) > 1
    otchet.dlitelnost_s = max(T.t_s) - min(T.t_s);
else
    otchet.dlitelnost_s = 0;
end
end
