function sokhranitKonfiguratsiyu(konfiguratsiya, putKFailu)
% Сохраняет конфигурацию изделия в JSON.

if nargin < 2 || strlength(string(putKFailu)) == 0
    kornevoyKatalog = fileparts(fileparts(fileparts(fileparts(mfilename('fullpath')))));
    putKFailu = fullfile(kornevoyKatalog, 'config', 'izdeliye_qc_ardupilot_v0.json');
end

papka = fileparts(putKFailu);
if ~isfolder(papka)
    mkdir(papka);
end

kopterkm.sluzhebnye.zapisJson(putKFailu, konfiguratsiya);
end
