% Выделение участков ВБ и первая идентификация ModelRate по журналам BIN.

if exist('projectRootForScenario', 'var')
    projectRoot = projectRootForScenario;
else
    projectRoot = pwd;
    if ~isfolder(fullfile(projectRoot, 'matlab'))
        projectRoot = fileparts(projectRoot);
    end
end

run(fullfile(projectRoot, 'matlab', 'startup.m'));

config = copter.config.loadConfig(fullfile(projectRoot, 'config', 'vehicle_qc_ardupilot_v0.json'));
validationBasis = copter.utils.readJson(fullfile(projectRoot, 'config', 'validation_basis_v0.json'));
segmentSettings = copter.utils.readJson(fullfile(projectRoot, 'config', 'segment_detection_v0.json'));
identificationSettings = copter.utils.readJson(fullfile(projectRoot, 'config', 'model_rate_identification_v0.json'));

outputFolder = fullfile(projectRoot, 'result', 'rate_identification');
if ~isfolder(outputFolder)
    mkdir(outputFolder);
end

expectedLogs = [
    "data/raw/ardupilot/bin/VB-01.alt_50m.BIN"
    "data/raw/ardupilot/bin/full_fly_1.BIN"
    "data/raw/ardupilot/bin/full_fly_2.BIN"
    ];

combinedTable = table();
allRegistry = table();
logReports = struct([]);
missingLogs = strings(0, 1);
timeOffset = 0;

for logIndex = 1:numel(expectedLogs)
    relativePath = expectedLogs(logIndex);
    filePath = fullfile(projectRoot, relativePath);
    if ~isfile(filePath)
        missingLogs(end + 1, 1) = relativePath;
        fprintf('Бортовой журнал отсутствует: %s\n', relativePath);
        continue;
    end

    fprintf('Подготовка данных и выделение участков: %s\n', relativePath);
    [processedData, qualityReport] = copter.data.buildProcessedTimetableFromBin(filePath, config, segmentSettings);
    [~, baseName, extension] = fileparts(filePath);
    logFileName = string(baseName + extension);
    segments = copter.validation.detectValidationSegments(processedData, validationBasis, segmentSettings, logFileName);
    registry = copter.validation.buildSegmentRegistry(processedData, segments, logFileName);
    if ~isempty(registry)
        registry.segment_id = matlab.lang.makeUniqueStrings(cellstr(logFileName + "_" + registry.segment_id));
        registry.segment_id = string(registry.segment_id);
        registry.t_start_s = registry.t_start_s + timeOffset;
        registry.t_end_s = registry.t_end_s + timeOffset;
    end

    processedTable = timetable2table(processedData, 'ConvertRowTimes', false);
    processedTable.t_s = processedTable.t_s + timeOffset;
    processedTable.log_file = repmat(logFileName, height(processedTable), 1);
    combinedTable = [combinedTable; processedTable];
    allRegistry = [allRegistry; registry];

    reportIndex = numel(logReports) + 1;
    logReports(reportIndex).file_name = logFileName;
    logReports(reportIndex).row_count = height(processedData);
    logReports(reportIndex).duration_s = qualityReport.duration_s;
    logReports(reportIndex).warnings = qualityReport.warnings;

    save(fullfile(outputFolder, baseName + "_processed.mat"), 'processedData', 'qualityReport');
    timeOffset = max(processedTable.t_s) + 10;
end

if ~isempty(missingLogs)
    copter.reports.writeMissingBinLogsReport(fullfile(outputFolder, 'missing_logs_report.md'), missingLogs);
end

if isempty(combinedTable) || isempty(allRegistry)
    fprintf('Реальные участки не выделены. Отчеты будут сформированы с указанием ограничения.\n');
    splitRegistry = allRegistry;
    model = copter.models.ModelRate();
    fitReport = table();
    validationReport = struct();
    validationReport.metricsBySegment = table();
    validationReport.channelConclusion = table();
    validationReport.warnings = "Реальные участки отсутствуют.";
else
    combinedData = table2timetable(combinedTable, 'RowTimes', seconds(combinedTable.t_s));
    combinedData.Properties.DimensionNames{1} = 'Time';
    splitRegistry = copter.validation.splitSegmentsForIdentification(allRegistry, identificationSettings);
    identificationSegments = splitRegistry(splitRegistry.split_role == "identification", :);
    validationSegments = splitRegistry(splitRegistry.split_role == "validation", :);
    [model, fitReport, fitWarnings] = copter.identification.fitRateModelFromSegments(combinedData, identificationSegments, config);
    validationReport = copter.validation.validateRateModelOnSegments(model, combinedData, validationSegments, config);
    validationReport.warnings = unique([validationReport.warnings; fitWarnings], 'stable');
    writetable(splitRegistry, fullfile(outputFolder, 'segment_registry.csv'));
    if ~isempty(validationReport.metricsBySegment)
        writetable(validationReport.metricsBySegment, fullfile(outputFolder, 'rate_validation_metrics.csv'));
    end
    save(fullfile(outputFolder, 'rate_identification_result.mat'), 'model', 'fitReport', 'validationReport', 'splitRegistry');
end

copter.reports.writeSegmentInventoryReport(fullfile(projectRoot, 'docs', 'review', 'PR-003-segment-inventory.md'), splitRegistry, logReports);
copter.reports.writeRateIdentificationReport(fullfile(projectRoot, 'docs', 'review', 'PR-003-rate-model-validation-summary.md'), model, fitReport, validationReport, splitRegistry);

fprintf('Реестр участков и отчет идентификации ModelRate сформированы.\n');
