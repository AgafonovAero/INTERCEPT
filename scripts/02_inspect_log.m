% Просмотр доступных столбцов и качества бортового журнала.

projectRoot = fileparts(fileparts(mfilename('fullpath')));
run(fullfile(projectRoot, 'matlab', 'startup.m'));
config = copter.config.loadConfig(fullfile(projectRoot, 'config', 'vehicle_qc_ardupilot_v0.json'));

files = [
    dir(fullfile(projectRoot, 'data', 'raw', '*.csv'))
    dir(fullfile(projectRoot, 'data', 'raw', '*.mat'))
    dir(fullfile(projectRoot, 'data', 'raw', 'ardupilot', 'bin', '*.BIN'))
    dir(fullfile(projectRoot, 'data', 'raw', 'ardupilot', 'bin', '*.bin'))
    ];

if isempty(files)
    fprintf('В data/raw нет CSV, MAT или BIN. Поместите набор данных в каталог data/raw.\n');
else
    filePath = fullfile(files(1).folder, files(1).name);
    fprintf('Просмотр набора данных: %s\n', filePath);
    copter.data.inspectLog(filePath, config);
end
