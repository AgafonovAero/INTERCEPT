% Пример подготовки CSV или MAT к расчету компьютерной модели.

projectRoot = fileparts(fileparts(mfilename('fullpath')));
run(fullfile(projectRoot, 'matlab', 'startup.m'));
config = copter.config.loadConfig(fullfile(projectRoot, 'config', 'vehicle_qc_ardupilot_v0.json'));

files = [
    dir(fullfile(projectRoot, 'data', 'raw', '*.csv'))
    dir(fullfile(projectRoot, 'data', 'raw', '*.mat'))
    ];

if isempty(files)
    fprintf('В data/raw нет CSV или MAT. Подготовка данных не выполнена.\n');
else
    filePath = fullfile(files(1).folder, files(1).name);
    [processedData, dataQuality] = copter.data.preprocessLogData(filePath, config);
    outputPath = fullfile(projectRoot, 'data', 'processed', 'processed_log_data.mat');
    save(outputPath, 'processedData', 'dataQuality');
    fprintf('Обработанный набор данных сохранен: %s\n', outputPath);
end
