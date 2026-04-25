% Визуальный демонстратор журналов и демонстрационного полета Model6DOF.

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
demoConfig = makeDemoConfig(config);
outputRoot = fullfile(projectRoot, 'result', 'visual_demo');
overviewFolder = fullfile(outputRoot, 'log_overview');
replayFolder = fullfile(outputRoot, 'log_replay');
demoFolder = fullfile(outputRoot, 'model6dof_demo');
assetFolder = fullfile(projectRoot, 'docs', 'review', 'assets', 'pr5');
ensureFolders({outputRoot, overviewFolder, replayFolder, demoFolder, assetFolder});

expectedLogs = [
    "data/raw/ardupilot/bin/VB-01.alt_50m.BIN"
    "data/raw/ardupilot/bin/full_fly_1.BIN"
    "data/raw/ardupilot/bin/full_fly_2.BIN"
    ];

logReports = struct([]);
missingLogs = strings(0, 1);
settings = copter.utils.readJson(fullfile(projectRoot, 'config', 'segment_detection_v0.json'));
settings.sample_rate_hz = 50;

for logIndex = 1:numel(expectedLogs)
    relativePath = expectedLogs(logIndex);
    filePath = fullfile(projectRoot, relativePath);
    if ~isfile(filePath)
        missingLogs(end + 1, 1) = relativePath;
        fprintf('Бортовой журнал отсутствует: %s\n', relativePath);
        continue;
    end

    fprintf('Формирование графиков журнала: %s\n', relativePath);
    [processedData, qualityReport] = copter.data.buildProcessedTimetableFromBin(filePath, config, settings);
    [~, baseName, extension] = fileparts(filePath);
    logName = string(baseName) + string(extension);
    logOutputFolder = fullfile(overviewFolder, char(baseName));
    [overviewFiles, overviewWarnings] = copter.visualization.plotLogOverview(processedData, logOutputFolder);
    pathFile = fullfile(replayFolder, char(baseName + "_path_3d.png"));
    [pathFigure, pathReport] = copter.visualization.plotFlightPath3D(processedData, pathFile);
    close(pathFigure);

    replayGif = "";
    if hasReplayAttitude(processedData)
        replayGif = fullfile(replayFolder, char(baseName + "_replay.gif"));
        replayData = thinReplayData(processedData, 120);
        [time, position, attitude] = replayArrays(replayData);
        [replayFigure, ~] = copter.visualization.animateCopterFlight(time, position, attitude, config, ...
            struct('gif_file', replayGif, 'max_frames', 60, 'visible', 'off'));
        close(replayFigure);
    end

    reportIndex = numel(logReports) + 1;
    logReports(reportIndex).file_name = logName;
    logReports(reportIndex).row_count = height(processedData);
    logReports(reportIndex).duration_s = qualityReport.duration_s;
    logReports(reportIndex).overview_files = overviewFiles;
    logReports(reportIndex).overview_warnings = overviewWarnings;
    logReports(reportIndex).path_file = string(pathFile);
    logReports(reportIndex).path_warnings = pathReport.warnings;
    logReports(reportIndex).replay_gif = string(replayGif);
end

if ~isempty(missingLogs)
    copter.reports.writeMissingBinLogsReport(fullfile(outputRoot, 'missing_logs_report.md'), missingLogs);
end

fprintf('Расчет демонстрационного полета Model6DOF.\n');
hoverTrajectory = makeHoverTrajectory(5, 5, 0.05);
climbTrajectory = makeClimbTrajectory(8, 8, 0.05);
boxTrajectory = copter.control.generateBoxTrajectory(struct('dt_s', 0.05));
hoverSimulation = copter.control.simulatePrimitiveClosedLoop(hoverTrajectory, demoConfig);
climbSimulation = copter.control.simulatePrimitiveClosedLoop(climbTrajectory, demoConfig);
boxSimulation = copter.control.simulatePrimitiveClosedLoop(boxTrajectory, demoConfig);

writeSimulationOutputs(hoverSimulation, boxSimulation, demoFolder, assetFolder, demoConfig);
writeVisualDemoReport(fullfile(outputRoot, 'visual_demo_report.md'), logReports, missingLogs, demoFolder);
writeReviewReports(projectRoot, logReports, missingLogs, hoverSimulation, climbSimulation, boxSimulation);

fprintf('Визуальный демонстратор PR №5 сформирован.\n');

function config = makeDemoConfig(config)
config.geometry.cad_cg_mm = [0; 0; 0];
armMm = 260;
config.geometry.motor_1_raw_cad_mm = [-armMm; -armMm; 0];
config.geometry.motor_2_raw_cad_mm = [armMm; -armMm; 0];
config.geometry.motor_3_raw_cad_mm = [armMm; armMm; 0];
config.geometry.motor_4_raw_cad_mm = [-armMm; armMm; 0];
config.geometry.spin_sign = [1; -1; 1; -1];
config.model6dof.kT = 40;
config.model6dof.tau_motor_s = 0.08;
config.model6dof.linear_drag = [0.18; 0.18; 0.25];
end

function ensureFolders(folders)
for index = 1:numel(folders)
    folder = string(folders{index});
    if ~isfolder(folder)
        mkdir(folder);
    end
end
end

function result = hasReplayAttitude(dataSet)
dataTable = timetable2table(dataSet, 'ConvertRowTimes', false);
result = all(hasVariables(dataTable, ["ATT.Roll_rad", "ATT.Pitch_rad", "ATT.Yaw_rad"]));
end

function replayData = thinReplayData(dataSet, maxSamples)
dataTable = timetable2table(dataSet, 'ConvertRowTimes', false);
indices = unique(round(linspace(1, height(dataTable), min(maxSamples, height(dataTable)))));
replayData = dataTable(indices, :);
end

function [time, position, attitude] = replayArrays(dataTable)
time = double(dataTable.t_s(:));
altitude = readOptional(dataTable, "altitude_m", zeros(height(dataTable), 1));
horizontalSpeed = readOptional(dataTable, "horizontal_speed_mps", zeros(height(dataTable), 1));
position = [cumtrapz(time, horizontalSpeed), zeros(height(dataTable), 1), altitude];
attitude = [
    readOptional(dataTable, "ATT.Roll_rad", zeros(height(dataTable), 1)), ...
    readOptional(dataTable, "ATT.Pitch_rad", zeros(height(dataTable), 1)), ...
    readOptional(dataTable, "ATT.Yaw_rad", zeros(height(dataTable), 1))
    ];
end

function values = readOptional(dataTable, variableName, defaultValue)
if hasVariable(dataTable, variableName)
    values = double(dataTable.(variableName));
else
    values = defaultValue;
end
end

function trajectory = makeHoverTrajectory(heightM, durationS, dtS)
time = transpose(0:dtS:durationS);
dataTable = table();
dataTable.t_s = time;
dataTable.x_m = zeros(numel(time), 1);
dataTable.y_m = zeros(numel(time), 1);
dataTable.z_m = heightM * ones(numel(time), 1);
dataTable.vx_mps = zeros(numel(time), 1);
dataTable.vy_mps = zeros(numel(time), 1);
dataTable.vz_mps = zeros(numel(time), 1);
dataTable.yaw_rad = zeros(numel(time), 1);
dataTable.phase = repmat("висение", numel(time), 1);
trajectory = table2timetable(dataTable, 'RowTimes', seconds(time));
end

function trajectory = makeClimbTrajectory(heightM, durationS, dtS)
time = transpose(0:dtS:durationS);
dataTable = table();
dataTable.t_s = time;
dataTable.x_m = zeros(numel(time), 1);
dataTable.y_m = zeros(numel(time), 1);
dataTable.z_m = heightM * time ./ max(time(end), eps);
dataTable.vx_mps = zeros(numel(time), 1);
dataTable.vy_mps = zeros(numel(time), 1);
dataTable.vz_mps = gradient(dataTable.z_m, time);
dataTable.yaw_rad = zeros(numel(time), 1);
dataTable.phase = repmat("набор", numel(time), 1);
trajectory = table2timetable(dataTable, 'RowTimes', seconds(time));
end

function writeSimulationOutputs(hoverSimulation, boxSimulation, demoFolder, assetFolder, config)
plotHoverTimeseries(hoverSimulation, fullfile(assetFolder, 'synthetic_hover_timeseries.png'));
plotBoxTrajectory(boxSimulation, fullfile(assetFolder, 'synthetic_box_trajectory_3d.png'));
plotBoxAttitude(boxSimulation, fullfile(assetFolder, 'synthetic_box_attitude.png'));
plotMotorCommands(boxSimulation, fullfile(assetFolder, 'synthetic_motor_commands.png'));
plotHoverTimeseries(hoverSimulation, fullfile(demoFolder, 'hover_timeseries.png'));
plotBoxTrajectory(boxSimulation, fullfile(demoFolder, 'box_trajectory_3d.png'));
plotBoxAttitude(boxSimulation, fullfile(demoFolder, 'box_attitude.png'));
plotMotorCommands(boxSimulation, fullfile(demoFolder, 'motor_commands.png'));
[time, position, attitude] = simulationArrays(boxSimulation);
[figureHandle, ~] = copter.visualization.animateCopterFlight(time, position, attitude, config, ...
    struct('gif_file', fullfile(assetFolder, 'synthetic_box_flight.gif'), 'max_frames', 10, 'visible', 'off'));
close(figureHandle);
end

function plotHoverTimeseries(simulation, filePath)
dataTable = timetable2table(simulation, 'ConvertRowTimes', false);
figureHandle = figure('Visible', 'off');
tiledlayout(figureHandle, 2, 1);
nexttile;
plot(dataTable.t_s, dataTable.z_m, dataTable.t_s, dataTable.desired_z_m, '--');
grid on;
xlabel('Время, с');
ylabel('Высота, м');
title('Демонстрационное висение Model6DOF');
legend('расчет', 'задание', 'Location', 'best');
nexttile;
plot(dataTable.t_s, dataTable.vz_mps);
grid on;
xlabel('Время, с');
ylabel('Вертикальная скорость, м/с');
exportgraphics(figureHandle, filePath, 'Resolution', 120);
close(figureHandle);
end

function plotBoxTrajectory(simulation, filePath)
[time, position, attitude] = simulationArrays(simulation);
[figureHandle, ~] = copter.visualization.plotFlightPath3D( ...
    tableForPath(time, position, attitude), filePath, table(), struct('visible', 'off'));
close(figureHandle);
end

function plotBoxAttitude(simulation, filePath)
dataTable = timetable2table(simulation, 'ConvertRowTimes', false);
figureHandle = figure('Visible', 'off');
plot(dataTable.t_s, rad2deg(dataTable.roll_rad), dataTable.t_s, rad2deg(dataTable.pitch_rad), ...
    dataTable.t_s, rad2deg(dataTable.yaw_rad));
grid on;
xlabel('Время, с');
ylabel('Угол, град');
title('Углы демонстрационного полета по прямоугольнику');
legend('крен', 'тангаж', 'курс', 'Location', 'best');
exportgraphics(figureHandle, filePath, 'Resolution', 120);
close(figureHandle);
end

function plotMotorCommands(simulation, filePath)
dataTable = timetable2table(simulation, 'ConvertRowTimes', false);
figureHandle = figure('Visible', 'off');
plot(dataTable.t_s, dataTable.u_motor_1, dataTable.t_s, dataTable.u_motor_2, ...
    dataTable.t_s, dataTable.u_motor_3, dataTable.t_s, dataTable.u_motor_4);
grid on;
xlabel('Время, с');
ylabel('Команда, 0...1');
title('Команды двигателей демонстрационного полета');
legend('M1', 'M2', 'M3', 'M4', 'Location', 'best');
exportgraphics(figureHandle, filePath, 'Resolution', 120);
close(figureHandle);
end

function dataTable = tableForPath(time, position, attitude)
dataTable = table();
dataTable.t_s = time;
dataTable.x_m = position(:, 1);
dataTable.y_m = position(:, 2);
dataTable.z_m = position(:, 3);
dataTable.roll_rad = attitude(:, 1);
dataTable.pitch_rad = attitude(:, 2);
dataTable.yaw_rad = attitude(:, 3);
dataTable = table2timetable(dataTable, 'RowTimes', seconds(time));
end

function [time, position, attitude] = simulationArrays(simulation)
dataTable = timetable2table(simulation, 'ConvertRowTimes', false);
time = dataTable.t_s;
position = [dataTable.x_m, dataTable.y_m, dataTable.z_m];
attitude = [dataTable.roll_rad, dataTable.pitch_rad, dataTable.yaw_rad];
end

function writeVisualDemoReport(filePath, logReports, missingLogs, demoFolder)
lines = [
    "# Отчет визуального демонстратора"
    ""
    mandatoryPhrase()
    ""
    "## Журналы"
    logReportLines(logReports, missingLogs)
    ""
    "## Демонстрационный расчет"
    "- Локальные результаты Model6DOF сохранены в `" + string(demoFolder) + "`."
    "- Демонстрационный полет не подтверждает адекватность модели реальному изделию."
    ];
writelines(lines, filePath);
end

function writeReviewReports(projectRoot, logReports, missingLogs, hoverSimulation, climbSimulation, boxSimulation)
reviewFolder = fullfile(projectRoot, 'docs', 'review');
assetFolder = fullfile(reviewFolder, 'assets', 'pr5');
writePrVisualReport(fullfile(reviewFolder, 'PR-005-visual-demo-report.md'), logReports, missingLogs, assetFolder);
writePrModelReport(fullfile(reviewFolder, 'PR-005-model6dof-demo-report.md'), ...
    hoverSimulation, climbSimulation, boxSimulation, assetFolder);
end

function writePrVisualReport(filePath, logReports, missingLogs, assetFolder)
lines = [
    "# Визуальный демонстратор PR №5"
    ""
    mandatoryPhrase()
    ""
    "## Доступность журналов"
    logReportLines(logReports, missingLogs)
    ""
    "## Сформированные графики"
    "- Обзорные графики реальных журналов сохранены локально в `result/visual_demo/log_overview/`."
    "- 3D-траектории и replay сохранены локально в `result/visual_demo/log_replay/`."
    ""
    "## Синтетические изображения в Git"
    "- `docs/review/assets/pr5/synthetic_hover_timeseries.png`."
    "- `docs/review/assets/pr5/synthetic_box_trajectory_3d.png`."
    "- `docs/review/assets/pr5/synthetic_box_attitude.png`."
    "- `docs/review/assets/pr5/synthetic_motor_commands.png`."
    "- `docs/review/assets/pr5/synthetic_box_flight.gif`."
    ""
    "## Ограничения"
    "- Изображения по реальным журналам не добавлены в Git из-за чувствительности данных."
    "- Replay показывает зарегистрированные или оцененные бортовой системой состояния."
    "- Каталог синтетических материалов: `" + string(assetFolder) + "`."
    ];
writelines(lines, filePath);
end

function writePrModelReport(filePath, hoverSimulation, climbSimulation, boxSimulation, assetFolder)
hoverTable = timetable2table(hoverSimulation, 'ConvertRowTimes', false);
climbTable = timetable2table(climbSimulation, 'ConvertRowTimes', false);
boxTable = timetable2table(boxSimulation, 'ConvertRowTimes', false);
lines = [
    "# Демонстрационный полет Model6DOF PR №5"
    ""
    mandatoryPhrase()
    ""
    "Демонстрационный полет Model6DOF в PR №5 предназначен для проверки работоспособности решателя, регулятора и постпроцессора. Он не подтверждает адекватность модели реальному изделию."
    ""
    "## Сценарии"
    "- Висение: конечная высота " + string(round(hoverTable.z_m(end), 3)) + " м."
    "- Набор: конечная высота " + string(round(climbTable.z_m(end), 3)) + " м."
    "- Прямоугольник: конечная высота " + string(round(boxTable.z_m(end), 3)) + " м."
    ""
    "## Примитивный регулятор"
    "- Внешний контур положения задает крен, тангаж, курс и высоту."
    "- Контур высоты задает коллективную тягу."
    "- Контур углов задает команды крена, тангажа и рыскания."
    "- Смеситель `quadXMixer` формирует команды двигателей 0...1."
    ""
    "## Графики"
    "- Синтетические графики сохранены в `" + string(assetFolder) + "`."
    ""
    "## Ограничения"
    "- Параметры тяги заданы демонстрационно."
    "- Модель не содержит полноценной аэродинамики и не использует ESC telemetry."
    "- Это демонстрация решателя и постпроцессора, а не валидация реального изделия."
    ];
writelines(lines, filePath);
end

function lines = logReportLines(logReports, missingLogs)
lines = strings(0, 1);
if isempty(logReports)
    lines(end + 1, 1) = "Реальные журналы не были доступны.";
else
    for index = 1:numel(logReports)
        line = "- " + string(logReports(index).file_name) + ": " ...
            + string(logReports(index).row_count) + " строк, " ...
            + string(round(logReports(index).duration_s, 2)) + " с.";
        lines(end + 1, 1) = line;
    end
end

for index = 1:numel(missingLogs)
    lines(end + 1, 1) = "- отсутствует: `" + missingLogs(index) + "`.";
end
end

function result = hasVariables(dataTable, names)
result = false(size(names));
for index = 1:numel(names)
    result(index) = hasVariable(dataTable, names(index));
end
end

function result = hasVariable(dataTable, variableName)
result = any(string(dataTable.Properties.VariableNames) == string(variableName));
end

function text = mandatoryPhrase()
text = "Данная проверка выполнена по данным бортового журнала и не является полной независимой валидацией реального изделия по внешним средствам измерений.";
end
