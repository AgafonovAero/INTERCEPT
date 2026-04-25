function konfiguratsiya = zagruzitKonfiguratsiyu(putKFailu)
% Загружает конфигурацию изделия из JSON.

if nargin < 1 || strlength(string(putKFailu)) == 0
    kornevoyKatalog = fileparts(fileparts(fileparts(fileparts(mfilename('fullpath')))));
    putKFailu = fullfile(kornevoyKatalog, 'config', 'izdeliye_qc_ardupilot_v0.json');
end

konfiguratsiya = kopterkm.sluzhebnye.chtenieJson(putKFailu);
end
