function [T, vremyaS, svedeniya] = privestiVremya(T)
% Приводит время бортового журнала к секундам, сортирует и удаляет дубли.

svedeniya = struct();
svedeniya.istochnik_vremeni = "";
svedeniya.chislo_dubley = 0;
svedeniya.dlitelnost_s = 0;

if istimetable(T)
    vremyaS = seconds(T.Properties.RowTimes - T.Properties.RowTimes(1));
    T = timetable2table(T, 'ConvertRowTimes', true);
    T.t_s = double(vremyaS);
    svedeniya.istochnik_vremeni = "RowTimes";
else
    imena = string(T.Properties.VariableNames);
    kandidaty = ["TimeUS", "TimeMS", "TimeS", "Time", "timestamp", "t", "time"];
    stolbets = "";
    for k = 1:numel(kandidaty)
        if any(imena == kandidaty(k))
            stolbets = kandidaty(k);
            break;
        end
    end
    assert(strlength(stolbets) > 0, 'Не найден столбец времени. Ожидается TimeUS, TimeMS, TimeS, Time, timestamp, t или time.');
    znachenie = T.(stolbets);
    if isduration(znachenie)
        vremyaS = seconds(znachenie - znachenie(1));
    elseif isdatetime(znachenie)
        vremyaS = seconds(znachenie - znachenie(1));
    else
        znachenie = double(znachenie);
        if stolbets == "TimeUS"
            vremyaS = znachenie ./ 1e6;
        elseif stolbets == "TimeMS"
            vremyaS = znachenie ./ 1e3;
        else
            vremyaS = znachenie;
        end
        vremyaS = vremyaS - vremyaS(1);
    end
    T.t_s = double(vremyaS(:));
    svedeniya.istochnik_vremeni = stolbets;
end

[vremyaS, poryadok] = sort(double(T.t_s(:)));
T = T(poryadok, :);

[vremyaUnikalnoe, indeksy] = unique(vremyaS, 'stable');
svedeniya.chislo_dubley = numel(vremyaS) - numel(vremyaUnikalnoe);
T = T(indeksy, :);
T.t_s = vremyaUnikalnoe(:);
vremyaS = vremyaUnikalnoe(:);

if numel(vremyaS) > 1
    svedeniya.dlitelnost_s = vremyaS(end) - vremyaS(1);
end
end
