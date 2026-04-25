function config = loadConfig(filePath)
% Загружает конфигурацию изделия из JSON.

if nargin < 1 || strlength(string(filePath)) == 0
    projectRoot = fileparts(fileparts(fileparts(fileparts(mfilename('fullpath')))));
    filePath = fullfile(projectRoot, 'config', 'vehicle_qc_ardupilot_v0.json');
end

config = copter.utils.readJson(filePath);
end
