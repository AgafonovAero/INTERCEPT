% Сопоставление Model6DOF с реальными бортовыми журналами и первичная настройка параметров.

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
replaySettings = copter.utils.readJson(fullfile(projectRoot, 'config', 'model6dof_replay_v0.json'));
fitSettings = copter.utils.readJson(fullfile(projectRoot, 'config', 'model6dof_parameter_fit_v0.json'));

outputFolder = fullfile(projectRoot, 'result', 'model6dof_log_replay');
plotFolder = fullfile(outputFolder, 'plots');
reportFolder = fullfile(outputFolder, 'reports');
parameterFolder = fullfile(outputFolder, 'parameters');
reviewFolder = fullfile(projectRoot, 'docs', 'review');
ensureFolders([
    string(outputFolder)
    string(plotFolder)
    string(reportFolder)
    string(parameterFolder)
    string(reviewFolder)
    ]);

expectedLogs = [
    "data/raw/ardupilot/bin/VB-01.alt_50m.BIN"
    "data/raw/ardupilot/bin/full_fly_1.BIN"
    "data/raw/ardupilot/bin/full_fly_2.BIN"
    ];

runSummary = struct();
runSummary.logs = struct([]);
runSummary.total_windows = 0;
runSummary.identification_windows = 0;
runSummary.validation_windows = 0;
runSummary.real_logs_available = false;
runSummary.missing_logs = strings(0, 1);
runSummary.metrics = table();
runSummary.channel_summary = table();
runSummary.fitted_params = struct();
runSummary.warnings = strings(0, 1);

for logIndex = 1:numel(expectedLogs)
    relativePath = expectedLogs(logIndex);
    filePath = fullfile(projectRoot, relativePath);
    if ~isfile(filePath)
        runSummary.missing_logs(end + 1, 1) = relativePath;
        fprintf('Бортовой журнал отсутствует: %s\n', relativePath);
        continue;
    end

    fprintf('Replay Model6DOF по журналу: %s\n', relativePath);
    runSummary.real_logs_available = true;
    [processedData, qualityReport] = copter.data.buildProcessedTimetableFromBin(filePath, config, segmentSettings);
    [~, baseName, extension] = fileparts(filePath);
    logFileName = string(baseName) + string(extension);
    segments = copter.validation.detectValidationSegments(processedData, validationBasis, segmentSettings, logFileName);
    registry = copter.validation.buildSegmentRegistry(processedData, segments, logFileName);
    replayWindows = copter.validation.selectModel6DofReplayWindows(registry, replaySettings);
    if isempty(replayWindows)
        replayWindows = fallbackWindow(processedData, logFileName, replaySettings);
    end

    identificationWindows = replayWindows(replayWindows.split_role == "identification", :);
    validationWindows = replayWindows(replayWindows.split_role == "validation", :);
    if isempty(validationWindows)
        validationWindows = replayWindows(1, :);
    end

    [fittedParams, fitDiagnostics, fitWarnings] = copter.identification.fitModel6DofParametersFromWindows( ...
        processedData, identificationWindows, config, fitSettings);
    validationReport = copter.validation.validateModel6DofOnLogWindows( ...
        fittedParams, processedData, validationWindows, config);

    logPlotFolder = fullfile(plotFolder, erase(logFileName, ".BIN"));
    ensureFolders(string(logPlotFolder));
    createdPlots = strings(0, 1);
    for windowIndex = 1:min(2, height(validationWindows))
        [simData, simReport] = copter.validation.simulateModel6DofOnLogWindow( ...
            processedData, validationWindows(windowIndex, :), fittedParams, config);
        windowFolder = fullfile(logPlotFolder, string(validationWindows.window_id(windowIndex)));
        ensureFolders(string(windowFolder));
        [plots, plotWarnings] = copter.visualization.plotModel6DofReplayComparison( ...
            processedData, simData, windowFolder);
        createdPlots = [createdPlots; plots];
        runSummary.warnings = [runSummary.warnings; simReport.warnings; plotWarnings];
    end
    copter.visualization.plotModel6DofParameterFitSummary(fittedParams, validationReport, logPlotFolder);

    runSummary.total_windows = runSummary.total_windows + height(replayWindows);
    runSummary.identification_windows = runSummary.identification_windows + height(identificationWindows);
    runSummary.validation_windows = runSummary.validation_windows + height(validationWindows);
    runSummary.metrics = [runSummary.metrics; addLogName(validationReport.metricsByWindow, logFileName)];
    runSummary.channel_summary = [runSummary.channel_summary; addLogName(validationReport.channelSummary, logFileName)];
    runSummary.fitted_params = fittedParams;
    runSummary.warnings = [runSummary.warnings; fitWarnings; validationReport.warnings];

    reportIndex = numel(runSummary.logs) + 1;
    runSummary.logs(reportIndex).file_name = logFileName;
    runSummary.logs(reportIndex).duration_s = qualityReport.duration_s;
    runSummary.logs(reportIndex).row_count = height(processedData);
    runSummary.logs(reportIndex).window_count = height(replayWindows);
    runSummary.logs(reportIndex).identification_count = height(identificationWindows);
    runSummary.logs(reportIndex).validation_count = height(validationWindows);
    runSummary.logs(reportIndex).created_plots = createdPlots;
    runSummary.logs(reportIndex).fit_diagnostics = fitDiagnostics;

    save(fullfile(parameterFolder, string(baseName) + "_model6dof_fit.mat"), ...
        'fittedParams', 'fitDiagnostics', 'validationReport', 'replayWindows');
end

if ~isempty(runSummary.missing_logs)
    copter.reports.writeMissingBinLogsReport( ...
        fullfile(reportFolder, 'missing_logs_report.md'), runSummary.missing_logs);
end

writeReplayReport(fullfile(reviewFolder, 'PR-006-model6dof-log-replay-report.md'), runSummary);
writeIdentificationReport(fullfile(reviewFolder, 'PR-006-parameter-identification-report.md'), runSummary);
writeValidationSummary(fullfile(reviewFolder, 'PR-006-model6dof-validation-summary.md'), runSummary);
writeLocalReport(fullfile(reportFolder, 'model6dof_log_replay_report.md'), runSummary);

fprintf('Сопоставление Model6DOF с журналами сформировано.\n');

function replayWindow = fallbackWindow(processedData, logFileName, replaySettings)
dataTable = timetable2table(processedData, 'ConvertRowTimes', false);
startTime = min(dataTable.t_s);
endTime = min(max(dataTable.t_s), startTime + replaySettings.max_window_duration_s);
replayWindow = table( ...
    "fallback_" + logFileName, ...
    logFileName, ...
    "В-01", ...
    "hover_candidate", ...
    startTime, ...
    endTime, ...
    endTime - startTime, ...
    "validation", ...
    'VariableNames', { ...
    'window_id', ...
    'log_file', ...
    'candidate_validation_case_id', ...
    'window_type', ...
    't_start_s', ...
    't_end_s', ...
    'duration_s', ...
    'split_role'});
end

function tableOut = addLogName(tableIn, logFileName)
tableOut = tableIn;
if ~isempty(tableOut)
    tableOut.log_file = repmat(string(logFileName), height(tableOut), 1);
end
end

function ensureFolders(folders)
folders = string(folders);
for index = 1:numel(folders)
    if ~isfolder(folders(index))
        mkdir(folders(index));
    end
end
end

function writeReplayReport(filePath, summary)
lines = [
    "# Replay Model6DOF по бортовым журналам PR №6"
    ""
    mandatoryPhrase()
    ""
    "## Обработанные журналы"
    logLines(summary)
    ""
    "## Окна replay"
    "- Всего окон: " + string(summary.total_windows) + "."
    "- Окон identification: " + string(summary.identification_windows) + "."
    "- Окон validation: " + string(summary.validation_windows) + "."
    ""
    "## Сравниваемые сигналы"
    "- ATT.Roll, ATT.Pitch, ATT.Yaw."
    "- RATE.R, RATE.P, RATE.Y."
    "- altitude_m, vertical_speed_mps, horizontal_speed_mps при наличии."
    ""
    "## Локальные графики"
    "- Overlay-графики сохранены в `result/model6dof_log_replay/plots/`."
    "- Расчетные параметры сохранены в `result/model6dof_log_replay/parameters/`."
    ""
    "## Основные выводы"
    conclusionLines(summary)
    ];
writelines(lines, filePath);
end

function writeIdentificationReport(filePath, summary)
params = summary.fitted_params;
lines = [
    "# Первичная идентификация параметров Model6DOF PR №6"
    ""
    mandatoryPhrase()
    ""
    "## Оцененные параметры"
    "- thrust_scale: " + valueText(params, "thrust_scale") + "."
    "- motor_tau_s: " + valueText(params, "motor_tau_s") + " с."
    "- kQ_over_kT: " + valueText(params, "kQ_over_kT") + "."
    "- linear_drag_x: " + valueText(params, "linear_drag_x") + "."
    "- linear_drag_y: " + valueText(params, "linear_drag_y") + "."
    "- linear_drag_z: " + valueText(params, "linear_drag_z") + "."
    ""
    "## Предупреждения"
    warningLines(summary.warnings)
    ""
    "## Ограничения применимости"
    "- Параметры подобраны только по коротким окнам бортового журнала."
    "- Validation-окна не использовались для подбора параметров."
    "- Подбор является первичной настройкой, а не полной валидацией объекта моделирования."
    ];
writelines(lines, filePath);
end

function writeValidationSummary(filePath, summary)
lines = [
    "# Сводка сопоставления Model6DOF с журналом PR №6"
    ""
    mandatoryPhrase()
    ""
    "## Метрики по каналам"
    metricLines(summary.channel_summary)
    ""
    "## Где модель согласуется с журналом"
    passLines(summary.channel_summary, true)
    ""
    "## Где модель не согласуется с журналом"
    passLines(summary.channel_summary, false)
    ""
    "## Рекомендации для PR №7"
    "- Уточнить мотор-маппинг и знаки вращения после подтверждения системы координат."
    "- Расширить подбор параметров по независимым участкам ВБ."
    "- Добавить сопоставление Model6DOF и ModelRate на одинаковых окнах."
    "- Подготовить перенос устойчивого replay-контура в Simulink."
    ];
writelines(lines, filePath);
end

function writeLocalReport(filePath, summary)
lines = [
    "# Локальный отчет replay Model6DOF"
    ""
    mandatoryPhrase()
    ""
    "Отчет содержит сводку локального запуска сценария `scripts/11_model6dof_log_replay_and_fit.m`."
    ""
    "Локальные графики и расчетные таблицы не добавляются в Git."
    ""
    "Всего окон replay: " + string(summary.total_windows) + "."
    ];
writelines(lines, filePath);
end

function lines = logLines(summary)
if isempty(summary.logs)
    lines = [
        "Реальные .BIN журналы отсутствовали в рабочей среде MATLAB."
        "Реальное сопоставление Model6DOF с журналами не выполнено."
        ];
    return;
end

lines = strings(numel(summary.logs), 1);
for index = 1:numel(summary.logs)
    item = summary.logs(index);
    lines(index) = "- " + string(item.file_name) + ": " + string(item.row_count) ...
        + " строк, " + string(round(item.duration_s, 2)) + " с, окон " ...
        + string(item.window_count) + ".";
end
end

function lines = conclusionLines(summary)
if isempty(summary.channel_summary)
    lines = "Метрики не сформированы; требуется наличие replay-окон и общих каналов.";
    return;
end

passed = nnz(summary.channel_summary.pass_preliminary_criterion);
total = height(summary.channel_summary);
lines = [
    "- Предварительные критерии выполнены для " + string(passed) + " из " + string(total) + " строк сводки."
    "- Несогласования не являются блокером PR №6 и фиксируются как входные данные для следующего этапа."
    ];
end

function lines = metricLines(channelSummary)
if isempty(channelSummary)
    lines = "Метрики по каналам отсутствуют.";
    return;
end

lines = strings(height(channelSummary), 1);
for index = 1:height(channelSummary)
    lines(index) = "- " + string(channelSummary.log_file(index)) + ", " ...
        + string(channelSummary.signal(index)) + ": RMSE " ...
        + string(round(channelSummary.mean_rmse(index), 5)) + ", FIT " ...
        + string(round(channelSummary.mean_fit_percent(index), 3)) + " %, " ...
        + string(channelSummary.conclusion(index)) + ".";
end
end

function lines = passLines(channelSummary, passFlag)
if isempty(channelSummary)
    lines = "Нет данных.";
    return;
end

mask = channelSummary.pass_preliminary_criterion == passFlag;
if ~any(mask)
    lines = "Нет каналов в данной группе.";
    return;
end

subset = channelSummary(mask, :);
lines = strings(height(subset), 1);
for index = 1:height(subset)
    lines(index) = "- " + string(subset.log_file(index)) + ", " + string(subset.signal(index)) + ".";
end
end

function lines = warningLines(warnings)
warnings = unique(string(warnings(:)), 'stable');
warnings(strlength(warnings) == 0) = [];
if isempty(warnings)
    lines = "Предупреждения отсутствуют.";
else
    lines = "- " + warnings;
end
end

function text = valueText(params, fieldName)
if isstruct(params) && isfield(params, fieldName)
    text = string(round(double(params.(fieldName)), 6));
else
    text = "не определено";
end
end

function text = mandatoryPhrase()
text = "Данная проверка выполнена по данным бортового журнала и не является полной независимой валидацией реального изделия по внешним средствам измерений.";
end
