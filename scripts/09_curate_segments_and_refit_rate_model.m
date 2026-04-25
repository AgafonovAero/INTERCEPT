% Инженерная фильтрация участков и повторная идентификация ModelRate.

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
curationSettings = copter.utils.readJson(fullfile(projectRoot, 'config', 'segment_curation_v0.json'));

outputFolder = fullfile(projectRoot, 'result', 'rate_identification_curated');
reviewFolder = fullfile(projectRoot, 'docs', 'review');
if ~isfolder(outputFolder)
    mkdir(outputFolder);
end

if ~isfolder(reviewFolder)
    mkdir(reviewFolder);
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

    fprintf('Инженерная подготовка участков: %s\n', relativePath);
    [processedData, qualityReport] = copter.data.buildProcessedTimetableFromBin(filePath, config, segmentSettings);
    unitDiagnostics = copter.data.diagnoseSignalUnits(processedData);
    timeDiagnostics = copter.data.diagnoseTimebase(processedData, segmentSettings.sample_rate_hz);
    [~, baseName, extension] = fileparts(filePath);
    logFileName = string(baseName) + string(extension);

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
    logReports(reportIndex).quality_warnings = qualityReport.warnings;
    logReports(reportIndex).unit_diagnostics = unitDiagnostics;
    logReports(reportIndex).time_diagnostics = timeDiagnostics;

    save(fullfile(outputFolder, baseName + "_processed.mat"), ...
        'processedData', 'qualityReport', 'unitDiagnostics', 'timeDiagnostics');
    timeOffset = max(processedTable.t_s) + 10;
end

if ~isempty(missingLogs)
    copter.reports.writeMissingBinLogsReport(fullfile(outputFolder, 'missing_logs_report.md'), missingLogs);
end

if isempty(combinedTable) || isempty(allRegistry)
    combinedData = timetable();
    curatedSegments = table();
    excludedSegments = table();
    overlapExcludedSegments = table();
    splitSegments = table();
    comparison = table();
    continuousModel = copter.models.ModelRate();
    discreteModel = copter.models.ModelRateDiscrete();
    fitDiagnostics = struct();
    fitWarnings = "Реальные журналы отсутствуют; переидентификация не выполнена.";
else
    combinedData = table2timetable(combinedTable, 'RowTimes', seconds(combinedTable.t_s));
    combinedData.Properties.DimensionNames{1} = 'Time';
    [curatedSegments, excludedSegments, diagnosticTable] = copter.validation.curateValidationSegments( ...
        allRegistry, combinedData, curationSettings);
    [curatedSegments, overlapExcludedSegments] = copter.validation.removeOverlappingSegments( ...
        curatedSegments, curationSettings);
    [splitSegments, splitReport] = copter.validation.splitCuratedSegments(curatedSegments, curationSettings);
    identificationSegments = splitSegments(splitSegments.split_role == "identification", :);
    validationSegments = splitSegments(splitSegments.split_role == "validation", :);

    [continuousModel, discreteModel, fitDiagnostics, selectedDelay, fitWarnings] = ...
        copter.identification.fitCuratedRateModels(combinedData, identificationSegments, config, curationSettings);
    comparison = copter.validation.compareRateModelVariants( ...
        continuousModel, discreteModel, combinedData, validationSegments, config);

    fitDiagnostics.selected_delay_samples = selectedDelay;
    fitDiagnostics.split_report = splitReport;
    writetable(diagnosticTable, fullfile(outputFolder, 'segment_curation_diagnostics.csv'));
    writetable(splitSegments, fullfile(outputFolder, 'curated_segment_registry.csv'));
    writetable(comparison, fullfile(outputFolder, 'rate_model_variant_comparison.csv'));
    save(fullfile(outputFolder, 'curated_rate_identification_result.mat'), ...
        'continuousModel', 'discreteModel', 'fitDiagnostics', 'fitWarnings', 'comparison', 'splitSegments');
end

writeCuratedSegmentReview(fullfile(reviewFolder, 'PR-004-curated-segment-review.md'), ...
    allRegistry, curatedSegments, excludedSegments, overlapExcludedSegments, splitSegments, logReports);
writeDiagnosticsReport(fullfile(reviewFolder, 'PR-004-rate-model-diagnostics.md'), ...
    logReports, allRegistry, curatedSegments, excludedSegments, overlapExcludedSegments, fitWarnings);
writeValidationSummary(fullfile(reviewFolder, 'PR-004-rate-model-validation-summary.md'), ...
    continuousModel, discreteModel, fitDiagnostics, comparison, splitSegments);

fprintf('Инженерная фильтрация и отчеты PR №4 сформированы.\n');

function writeCuratedSegmentReview(filePath, allRegistry, curatedSegments, excludedSegments, overlapExcluded, splitSegments, logReports)
lines = [
    "# Обзор инженерной фильтрации участков PR №4"
    ""
    mandatoryPhrase()
    ""
    "## Сводка"
    "- Участков в PR №3: " + string(height(allRegistry)) + "."
    "- Исключено по правилам качества: " + string(height(excludedSegments)) + "."
    "- Исключено из-за перекрытий: " + string(height(overlapExcluded)) + "."
    "- Осталось curated-участков: " + string(height(curatedSegments)) + "."
    "- Участков identification: " + string(countRole(splitSegments, "identification")) + "."
    "- Участков validation: " + string(countRole(splitSegments, "validation")) + "."
    ""
    "## Журналы"
    logLines(logReports)
    ""
    "## Причины исключения"
    reasonLines(excludedSegments, overlapExcluded)
    ""
    "## Покрытие ВБ"
    caseLines(splitSegments)
    ""
    "## Предупреждение по VB-01.alt_50m.BIN"
    "Имя файла указывает alt_50m, а случай В-01 в ВБ задан как висение на высоте 30 м."
    "До подтверждения фактической высоты по журналу это считается ограничением исходных данных."
    ""
    "## Вывод"
    "Автоматическая разметка PR №3 не является окончательным валидационным базисом."
    "Инженерная фильтрация снижает риск утечки данных и ложных response-участков."
    ];
writelines(lines, filePath);
end

function writeDiagnosticsReport(filePath, logReports, allRegistry, curatedSegments, excludedSegments, overlapExcluded, fitWarnings)
lines = [
    "# Диагностика причин провала ModelRate PR №3"
    ""
    mandatoryPhrase()
    ""
    "## Диагностика единиц и времени"
    diagnosticLines(logReports)
    ""
    "## Анализ участков"
    "- Исходных участков: " + string(height(allRegistry)) + "."
    "- Curated-участков: " + string(height(curatedSegments)) + "."
    "- Исключено по качеству: " + string(height(excludedSegments)) + "."
    "- Исключено по перекрытиям: " + string(height(overlapExcluded)) + "."
    ""
    "## Причины провала PR №3"
    "- В автоматической разметке присутствовали перекрывающиеся и слабо информативные окна."
    "- Часть участков имела малую изменчивость эталонного сигнала, поэтому FIT был неустойчив."
    "- Случайное деление перекрывающихся окон повышало риск утечки данных между наборами."
    "- Непрерывная модель первого уровня не описывает все режимы движения изделия."
    ""
    "## Предупреждения идентификации"
    warningLines(fitWarnings)
    ""
    "## Выводы по каналам"
    "- RATE.R: требуется ручная проверка участков крена и задержки входа."
    "- RATE.P: требуется отделять тангажные response-участки от участков движения по высоте."
    "- RATE.Y: требуется больше независимых воздействий по рысканию и проверка моторных команд."
    ];
writelines(lines, filePath);
end

function writeValidationSummary(filePath, continuousModel, discreteModel, fitDiagnostics, comparison, splitSegments)
lines = [
    "# Сводка проверки ModelRate PR №4"
    ""
    mandatoryPhrase()
    ""
    "## Модели"
    "- Continuous ModelRate: `domega/dt = A * omega + B * u + c`."
    "- Discrete ModelRateDiscrete: `omega[k+1] = Ad * omega[k] + Bd * u[k-delay] + cd`."
    "- Дискретная модель используется как диагностический вариант, а не замена полной модели."
    ""
    "## Параметры continuous ModelRate"
    matrixLines("A", continuousModel.A)
    matrixLines("B", continuousModel.B)
    "- c: " + mat2str(continuousModel.c, 5)
    ""
    "## Параметры discrete ModelRateDiscrete"
    matrixLines("Ad", discreteModel.Ad)
    matrixLines("Bd", discreteModel.Bd)
    "- cd: " + mat2str(discreteModel.cd, 5)
    "- Задержка входа, отсчеты: " + string(discreteModel.delay_samples) + "."
    ""
    "## Участки"
    "- identification: " + string(countRole(splitSegments, "identification")) + "."
    "- validation: " + string(countRole(splitSegments, "validation")) + "."
    ""
    "## Сравнение вариантов"
    comparisonLines(comparison)
    ""
    "## Ограничения применимости"
    "- ModelRate является компьютерной моделью первого уровня для угловых скоростей."
    "- Модель не является полной моделью движения изделия."
    "- Validation-участки не использовались для подбора параметров."
    ];

if isfield(fitDiagnostics, 'selected_delay_samples')
    lines(end + 1, 1) = "- Выбранная задержка входа: " + string(fitDiagnostics.selected_delay_samples) + " отсчетов.";
end

writelines(lines, filePath);
end

function lines = logLines(logReports)
if isempty(logReports)
    lines = "Реальные журналы отсутствовали в рабочей среде.";
    return;
end

lines = strings(numel(logReports), 1);
for index = 1:numel(logReports)
    lines(index) = "- " + string(logReports(index).file_name) + ": " ...
        + string(logReports(index).row_count) + " строк, длительность " ...
        + string(round(logReports(index).duration_s, 2)) + " с.";
end
end

function lines = diagnosticLines(logReports)
if isempty(logReports)
    lines = "Диагностика не выполнена, реальные журналы отсутствовали.";
    return;
end

lines = strings(0, 1);
for index = 1:numel(logReports)
    timeDiagnostics = logReports(index).time_diagnostics;
    lines(end + 1, 1) = "- " + string(logReports(index).file_name) ...
        + ": средний dt " + string(round(timeDiagnostics.mean_dt_s, 5)) ...
        + " с, частота " + string(round(timeDiagnostics.estimated_sample_rate_hz, 2)) + " Гц.";
    unitWarnings = logReports(index).unit_diagnostics.warnings;
    if ~isempty(unitWarnings)
        lines = [lines; "  Предупреждения единиц: " + join(unitWarnings, "; ")];
    end
end
end

function lines = reasonLines(excludedSegments, overlapExcluded)
allExcluded = [excludedSegments; overlapExcluded];
if isempty(allExcluded)
    lines = "Исключенные участки отсутствуют.";
    return;
end

reasons = unique(string(allExcluded.exclusion_reason), 'stable');
lines = strings(numel(reasons), 1);
for index = 1:numel(reasons)
    count = nnz(string(allExcluded.exclusion_reason) == reasons(index));
    lines(index) = "- " + reasons(index) + ": " + string(count) + ".";
end
end

function lines = caseLines(splitSegments)
if isempty(splitSegments)
    lines = "Покрытие случаев ВБ не сформировано.";
    return;
end

caseIds = unique(string(splitSegments.candidate_validation_case_id), 'stable');
lines = strings(numel(caseIds), 1);
for index = 1:numel(caseIds)
    count = nnz(string(splitSegments.candidate_validation_case_id) == caseIds(index));
    lines(index) = "- " + caseIds(index) + ": " + string(count) + " curated-участков.";
end
end

function lines = warningLines(warnings)
if isempty(warnings)
    lines = "Предупреждения идентификации отсутствуют.";
    return;
end

warnings = string(warnings(:));
lines = "- " + warnings;
end

function lines = matrixLines(name, matrix)
lines = strings(size(matrix, 1), 1);
for index = 1:size(matrix, 1)
    lines(index) = "- " + name + "(" + string(index) + ",:): " + mat2str(matrix(index, :), 5);
end
end

function lines = comparisonLines(comparison)
if isempty(comparison)
    lines = "Сравнение не выполнено, validation-участки отсутствуют.";
    return;
end

lines = strings(height(comparison), 1);
for index = 1:height(comparison)
    lines(index) = "- " + string(comparison.model_variant(index)) + ", " ...
        + string(comparison.axis(index)) + ": FIT " + string(round(comparison.FIT(index), 3)) ...
        + " %, RMSE " + string(round(comparison.RMSE(index), 5)) ...
        + ", вывод: " + string(comparison.conclusion(index)) + ".";
end
end

function count = countRole(splitSegments, roleName)
if isempty(splitSegments) || ~any(string(splitSegments.Properties.VariableNames) == "split_role")
    count = 0;
else
    count = nnz(splitSegments.split_role == roleName);
end
end

function text = mandatoryPhrase()
text = "Данная проверка выполнена по данным бортового журнала и не является полной независимой валидацией реального изделия по внешним средствам измерений.";
end
