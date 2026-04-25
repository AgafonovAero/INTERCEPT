% Пример оценки адекватности компьютерной модели по бортовому журналу.

projectRoot = fileparts(fileparts(mfilename('fullpath')));
run(fullfile(projectRoot, 'matlab', 'startup.m'));
config = copter.config.loadConfig(fullfile(projectRoot, 'config', 'vehicle_qc_ardupilot_v0.json'));
processedPath = fullfile(projectRoot, 'data', 'processed', 'processed_log_data.mat');
modelPath = fullfile(projectRoot, 'result', 'rate_model.mat');

if ~isfile(processedPath) || ~isfile(modelPath)
    fprintf('Не найдены обработанные данные или параметры модели. Выполните сценарии 03 и 04.\n');
else
    load(processedPath, 'processedData', 'dataQuality');
    load(modelPath, 'identification', 'segments');
    validation = copter.validation.validateByLog(processedData, identification.model, segments.validation, config);
    reportData = struct();
    reportData.config = config;
    reportData.data_quality = dataQuality;
    reportData.identification = identification;
    reportData.validation = validation;
    reportData.segments = segments;
    reportPath = fullfile(projectRoot, 'result', 'validation_by_log_report.md');
    copter.reports.writeMarkdownReport(reportPath, reportData);
    fprintf('Отчет оценки адекватности сформирован: %s\n', reportPath);
end
