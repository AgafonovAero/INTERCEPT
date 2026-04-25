% Пример идентификации ModelRate по подготовленному набору данных.

projectRoot = fileparts(fileparts(mfilename('fullpath')));
run(fullfile(projectRoot, 'matlab', 'startup.m'));
config = copter.config.loadConfig(fullfile(projectRoot, 'config', 'vehicle_qc_ardupilot_v0.json'));
processedPath = fullfile(projectRoot, 'data', 'processed', 'processed_log_data.mat');

if ~isfile(processedPath)
    fprintf('Обработанный набор данных не найден. Сначала выполните scripts/03_preprocess_log_data.m.\n');
else
    load(processedPath, 'processedData');
    segments = copter.data.selectSegments(processedData);
    identification = copter.identification.fitRateModel(processedData, config, segments.identification);
    modelPath = fullfile(projectRoot, 'result', 'rate_model.mat');
    save(modelPath, 'identification', 'segments');
    fprintf('Параметры ModelRate сохранены: %s\n', modelPath);
end
