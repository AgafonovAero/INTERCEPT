function [TT, otchetKachestva] = podgotovitDannye(istochnik, konfiguratsiya, chastotaGts)
% Подготавливает данные для расчета компьютерной модели.

if nargin < 2 || isempty(konfiguratsiya)
    konfiguratsiya = kopterkm.konfiguratsiya.sozdatKonfiguratsiyuPoUmolchaniyu();
end
if nargin < 3 || isempty(chastotaGts)
    chastotaGts = konfiguratsiya.normalizatsiya.chastota_setki_gts;
end

T = kopterkm.dannye.chitatTablichnyiZhurnal(istochnik);
[T, vremyaS, svedeniyaVremeni] = kopterkm.dannye.privestiVremya(T);
T = kopterkm.dannye.privestiEdinitsyIzmereniya(T, konfiguratsiya);

otchetKachestva = kopterkm.dannye.otsenitKachestvoDannykh(T, konfiguratsiya);
otchetKachestva.vremya = svedeniyaVremeni;
otchetKachestva.chastota_setki_gts = chastotaGts;

if numel(vremyaS) < 2
    TT = table2timetable(T, 'RowTimes', seconds(T.t_s));
    return;
end

shag = 1 / chastotaGts;
vremyaRavnomernoe = (vremyaS(1):shag:vremyaS(end)).';
Treg = table();
Treg.t_s = vremyaRavnomernoe;

imena = string(T.Properties.VariableNames);
for k = 1:numel(imena)
    imya = imena(k);
    if imya == "t_s"
        continue;
    end
    znachenie = T.(imya);
    if isnumeric(znachenie) || islogical(znachenie)
        znachenie = double(znachenie);
        if isvector(znachenie)
            Treg.(imya) = interp1(vremyaS, znachenie(:), vremyaRavnomernoe, 'linear', 'extrap');
        end
    end
end

TT = table2timetable(Treg, 'RowTimes', seconds(Treg.t_s));
TT.Properties.DimensionNames{1} = 'Vremya';
end
