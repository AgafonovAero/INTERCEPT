function saveConfig(config, filePath)
% Сохраняет конфигурацию изделия в JSON.

if nargin < 2 || strlength(string(filePath)) == 0
    projectRoot = fileparts(fileparts(fileparts(fileparts(mfilename('fullpath')))));
    filePath = fullfile(projectRoot, 'config', 'vehicle_qc_ardupilot_v0.json');
end

copter.utils.writeJson(filePath, config);
end
