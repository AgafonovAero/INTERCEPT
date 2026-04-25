% Калибровка мотор-маппинга, знаков вращения и преобразования CAD -> body.

if exist('projectRootForScenario', 'var')
    projectRoot = projectRootForScenario;
else
    projectRoot = pwd;
    if ~isfolder(fullfile(projectRoot, 'matlab'))
        projectRoot = fileparts(projectRoot);
    end
end

run(fullfile(projectRoot, 'matlab', 'startup.m'));

vehicleConfig = copter.config.loadConfig(fullfile(projectRoot, 'config', 'vehicle_qc_ardupilot_v0.json'));
validationBasis = copter.utils.readJson(fullfile(projectRoot, 'config', 'validation_basis_v0.json'));
segmentSettings = copter.utils.readJson(fullfile(projectRoot, 'config', 'segment_detection_v0.json'));
replaySettings = copter.utils.readJson(fullfile(projectRoot, 'config', 'model6dof_replay_v0.json'));
motorSettings = copter.utils.readJson(fullfile(projectRoot, 'config', 'motor_map_calibration_v0.json'));
frameSettings = copter.utils.readJson(fullfile(projectRoot, 'config', 'coordinate_frame_calibration_v0.json'));

outputFolder = fullfile(projectRoot, 'result', 'motor_map_frame_calibration');
plotFolder = fullfile(outputFolder, 'plots');
reportFolder = fullfile(outputFolder, 'reports');
configFolder = fullfile(outputFolder, 'configs');
reviewFolder = fullfile(projectRoot, 'docs', 'review');
ensureFolders([string(outputFolder); string(plotFolder); string(reportFolder); string(configFolder); string(reviewFolder)]);

expectedLogs = [
    "data/raw/ardupilot/bin/VB-01.alt_50m.BIN"
    "data/raw/ardupilot/bin/full_fly_1.BIN"
    "data/raw/ardupilot/bin/full_fly_2.BIN"
    ];

summary = initializeSummary();
combinedData = table();
combinedWindows = table();

for logIndex = 1:numel(expectedLogs)
    relativePath = expectedLogs(logIndex);
    filePath = fullfile(projectRoot, relativePath);
    if ~isfile(filePath)
        summary.missing_logs(end + 1, 1) = relativePath;
        fprintf('Бортовой журнал отсутствует: %s\n', relativePath);
        continue;
    end

    fprintf('Калибровочный анализ журнала: %s\n', relativePath);
    summary.real_logs_available = true;
    [~, baseName, extension] = fileparts(filePath);
    logFileName = string(baseName) + string(extension);
    logData = copter.data.readBinLog(filePath, vehicleConfig);
    [params, paramReport] = copter.data.extractArduPilotParams(logData);
    [normalization, normalizationWarnings] = copter.data.buildPwmNormalizationFromParams(params, vehicleConfig);
    frameReport = copter.data.inspectArduPilotFrameParams(params, vehicleConfig);
    updatedConfig = vehicleConfig;
    updatedConfig.normalization.pwm_min = normalization.pwm_min;
    updatedConfig.normalization.pwm_max = normalization.pwm_max;

    [processedData, qualityReport] = copter.data.buildProcessedTimetableFromBin(filePath, updatedConfig, segmentSettings);
    segments = copter.validation.detectValidationSegments(processedData, validationBasis, segmentSettings, logFileName);
    registry = copter.validation.buildSegmentRegistry(processedData, segments, logFileName);
    replayWindows = copter.validation.selectModel6DofReplayWindows(registry, replaySettings);
    if isempty(replayWindows)
        replayWindows = fallbackWindow(processedData, logFileName, replaySettings);
    end

    dataTable = timetable2table(processedData, 'ConvertRowTimes', false);
    dataTable.log_file = repmat(logFileName, height(dataTable), 1);
    combinedData = [combinedData; dataTable];
    combinedWindows = [combinedWindows; replayWindows];

    logSummary = struct();
    logSummary.file_name = logFileName;
    logSummary.relative_path = relativePath;
    logSummary.duration_s = qualityReport.duration_s;
    logSummary.row_count = height(processedData);
    logSummary.window_count = height(replayWindows);
    logSummary.parameter_count = paramReport.parameter_count;
    logSummary.frame_report = frameReport;
    logSummary.normalization = normalization;
    logSummary.warnings = unique([qualityReport.warnings; paramReport.warnings; normalizationWarnings; frameReport.warnings], 'stable');
    summary.logs = [summary.logs; logSummary];
end

if isempty(combinedData)
    [combinedData, combinedWindows] = syntheticCalibrationData(vehicleConfig);
    summary.synthetic_mode = true;
    summary.warnings(end + 1, 1) = "Реальные журналы отсутствовали; выполнена синтетическая проверка калибровочного контура.";
end

identificationWindows = combinedWindows(combinedWindows.split_role == "identification", :);
validationWindows = combinedWindows(combinedWindows.split_role == "validation", :);
if isempty(identificationWindows)
    identificationWindows = combinedWindows(1, :);
end
if isempty(validationWindows)
    validationWindows = combinedWindows(1, :);
end

calibrationResult = copter.identification.calibrateMotorMapAndFrame( ...
    combinedData, identificationWindows, validationWindows, vehicleConfig, motorSettings, frameSettings);
summary.calibration = calibrationResult;
summary.identification_window_count = height(identificationWindows);
summary.validation_window_count = height(validationWindows);
summary.motor_candidate_count = height(calibrationResult.motorCandidates);
summary.frame_candidate_count = height(calibrationResult.frameCandidates);
summary.selected_motor_candidate = string(calibrationResult.selectedMotorMap.candidate_id(1));
summary.selected_frame_candidate = string(calibrationResult.frameMetrics.candidate_id(1));
summary.warnings = unique([summary.warnings; calibrationResult.warnings], 'stable');

save(fullfile(configFolder, 'motor_map_frame_calibration_result.mat'), 'calibrationResult', 'summary');
writeArduPilotParamsReport(fullfile(reviewFolder, 'PR-007-ardupilot-params-report.md'), summary);
writeMotorMapReport(fullfile(reviewFolder, 'PR-007-motor-map-calibration-report.md'), summary);
writeCoordinateFrameReport(fullfile(reviewFolder, 'PR-007-coordinate-frame-report.md'), summary);
writeReplayImprovementReport(fullfile(reviewFolder, 'PR-007-model6dof-replay-improvement.md'), summary);
writeLocalReport(fullfile(reportFolder, 'motor_map_frame_calibration_report.md'), summary);

fprintf('Калибровочный анализ PR №7 сформирован.\n');

function summary = initializeSummary()
summary = struct();
summary.logs = struct([]);
summary.real_logs_available = false;
summary.synthetic_mode = false;
summary.missing_logs = strings(0, 1);
summary.warnings = strings(0, 1);
summary.identification_window_count = 0;
summary.validation_window_count = 0;
summary.motor_candidate_count = 0;
summary.frame_candidate_count = 0;
summary.selected_motor_candidate = "";
summary.selected_frame_candidate = "";
summary.calibration = struct();
end

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
    'VariableNames', {'window_id', 'log_file', 'candidate_validation_case_id', 'window_type', ...
    't_start_s', 't_end_s', 'duration_s', 'split_role'});
end

function [data, windows] = syntheticCalibrationData(vehicleConfig)
time = transpose(0:0.02:8);
u = [
    0.5 + 0.08 * sin(time), ...
    0.5 + 0.07 * cos(0.7 * time), ...
    0.5 + 0.06 * sin(1.3 * time), ...
    0.5 + 0.05 * cos(1.7 * time)
    ];
pwm = vehicleConfig.normalization.pwm_min ...
    + u .* (vehicleConfig.normalization.pwm_max - vehicleConfig.normalization.pwm_min);
data = table();
data.t_s = time;
data.log_file = repmat("synthetic", numel(time), 1);
for index = 1:4
    data.("RCOU.C" + string(index)) = pwm(:, index);
end
data.RATE_R_rad_s = 0.08 * sin(time);
data.RATE_P_rad_s = 0.07 * cos(0.7 * time);
data.RATE_Y_rad_s = 0.05 * sin(1.3 * time);
windows = table("synthetic_window", "synthetic", "В-10", "roll_response_candidate", 0, 8, 8, "identification", ...
    'VariableNames', {'window_id', 'log_file', 'candidate_validation_case_id', 'window_type', ...
    't_start_s', 't_end_s', 'duration_s', 'split_role'});
end

function ensureFolders(folders)
for index = 1:numel(folders)
    if ~isfolder(folders(index))
        mkdir(folders(index));
    end
end
end

function writeArduPilotParamsReport(filePath, summary)
lines = [
    "# Параметры ArduPilot по журналам PR №7"
    ""
    mandatoryPhrase()
    ""
    hypothesisPhrase()
    ""
    "## Обработанные журналы"
    logLines(summary)
    ""
    "## Извлеченные параметры"
    paramLines(summary)
    ""
    "## Предупреждения"
    warningLines(summary)
    ];
writelines(lines, filePath);
end

function writeMotorMapReport(filePath, summary)
topRows = topCandidateLines(summary.calibration.motorMetrics, "candidate_id", 10);
lines = [
    "# Калибровка мотор-маппинга PR №7"
    ""
    mandatoryPhrase()
    ""
    hypothesisPhrase()
    ""
    "## Кандидаты"
    "- Проверено motor map candidates: " + string(summary.motor_candidate_count) + "."
    "- Выбранный кандидат: `" + summary.selected_motor_candidate + "`."
    ""
    "## Top candidates"
    topRows
    ""
    "## Ограничения"
    "- Выбор выполнен только по identification-окнам."
    "- Validation-окна не использовались для выбора кандидатной конфигурации."
    "- Физическое подключение моторов и направления вращения требуют отдельной проверки."
    ];
writelines(lines, filePath);
end

function writeCoordinateFrameReport(filePath, summary)
topRows = topCandidateLines(summary.calibration.frameMetrics, "candidate_id", 10);
lines = [
    "# Система координат и CAD -> body PR №7"
    ""
    mandatoryPhrase()
    ""
    hypothesisPhrase()
    ""
    "## Кандидаты преобразования"
    "- Проверено frame candidates: " + string(summary.frame_candidate_count) + "."
    "- Выбранный кандидат: `" + summary.selected_frame_candidate + "`."
    ""
    "## Ранжирование"
    topRows
    ""
    "## Ограничения"
    "- Оси CAD не считаются автоматически совпадающими со связанной системой координат изделия."
    "- Произведения инерции не применяются до подтверждения систем координат."
    ];
writelines(lines, filePath);
end

function writeReplayImprovementReport(filePath, summary)
lines = [
    "# Сравнение replay Model6DOF до и после PR №7"
    ""
    mandatoryPhrase()
    ""
    hypothesisPhrase()
    ""
    "## Результат"
    "- PR №7 проверяет физические причины расхождений PR №6: мотор-маппинг, знаки вращения и CAD -> body."
    "- Улучшение метрик не считается обязательным условием прохождения тестов."
    "- Для выбранной гипотезы validation score: " + validationScoreLine(summary) + "."
    ""
    "## Вывод"
    "- Конфигурация принята как расчетная гипотеза для последующей инженерной проверки."
    "- Если улучшение replay недостаточно, следующий этап должен уточнить аэродинамику и параметры ВМГ."
    ];
writelines(lines, filePath);
end

function writeLocalReport(filePath, summary)
lines = [
    "# Локальный отчет калибровки PR №7"
    ""
    "Отчет содержит расчетные сведения, сформированные локально в `result/motor_map_frame_calibration/`."
    ""
    "Выбранный motor map candidate: `" + summary.selected_motor_candidate + "`."
    "Выбранный frame candidate: `" + summary.selected_frame_candidate + "`."
    ];
writelines(lines, filePath);
end

function lines = logLines(summary)
if isempty(summary.logs)
    lines = "- Реальные .BIN журналы отсутствовали; использована синтетическая проверка.";
    return;
end

lines = strings(numel(summary.logs), 1);
for index = 1:numel(summary.logs)
    item = summary.logs(index);
    lines(index) = "- `" + item.relative_path + "`: строк " + string(item.row_count) ...
        + ", длительность " + string(round(item.duration_s, 2)) + " с.";
end
end

function lines = paramLines(summary)
if isempty(summary.logs)
    lines = "- PARM не извлекались из реальных журналов.";
    return;
end

lines = strings(numel(summary.logs), 1);
for index = 1:numel(summary.logs)
    item = summary.logs(index);
    lines(index) = "- `" + item.file_name + "`: PARM записей " + string(item.parameter_count) ...
        + ", FRAME `" + string(item.frame_report.interpreted_frame) + "`.";
end
end

function lines = warningLines(summary)
warnings = unique(string(summary.warnings(:)), 'stable');
warnings = warnings(strlength(warnings) > 0);
if isempty(warnings)
    lines = "- Предупреждений нет.";
else
    lines = "- " + warnings;
end
end

function lines = topCandidateLines(tableIn, idColumn, limit)
if isempty(tableIn)
    lines = "- Нет данных для ранжирования.";
    return;
end

count = min(limit, height(tableIn));
lines = strings(count, 1);
for index = 1:count
    lines(index) = "- `" + string(tableIn.(idColumn)(index)) + "`: score " ...
        + string(round(tableIn.score(index), 4)) + ".";
end
end

function text = validationScoreLine(summary)
if isfield(summary.calibration, 'calibrationMetrics')
    value = summary.calibration.calibrationMetrics.validation_score;
    text = string(round(value, 4));
else
    text = "нет данных";
end
end

function text = mandatoryPhrase()
text = "Данная проверка выполнена по данным бортового журнала и не является полной независимой валидацией реального изделия по внешним средствам измерений.";
end

function text = hypothesisPhrase()
parts = [
    "Выбранный мотор-маппинг и преобразование CAD -> body являются расчетной гипотезой, сформированной по бортовым журналам."
    "Для окончательного подтверждения требуется физическая проверка подключения моторов, направления вращения и системы координат изделия."
    ];
text = join(parts, " ");
end
