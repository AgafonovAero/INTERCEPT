% Анализ реальных бортовых журналов ArduPilot DataFlash BIN для PR №2.

projectRoot = fileparts(fileparts(mfilename('fullpath')));
run(fullfile(projectRoot, 'matlab', 'startup.m'));

config = copter.config.loadConfig(fullfile(projectRoot, 'config', 'vehicle_qc_ardupilot_v0.json'));
outputFolder = fullfile(projectRoot, 'result', 'bin_analysis');
if ~isfolder(outputFolder)
    mkdir(outputFolder);
end

expectedLogs = [
    "data/raw/ardupilot/bin/VB-01.alt_50m.BIN"
    "data/raw/ardupilot/bin/full_fly_1.BIN"
    "data/raw/ardupilot/bin/full_fly_2.BIN"
    ];

summaries = {};
missingLogs = strings(0, 1);

for index = 1:numel(expectedLogs)
    relativePath = expectedLogs(index);
    filePath = fullfile(projectRoot, relativePath);
    if ~isfile(filePath)
        missingLogs(end + 1, 1) = relativePath;
        fprintf('Бортовой журнал отсутствует: %s\n', relativePath);
        continue;
    end

    fprintf('Анализ бортового журнала: %s\n', relativePath);
    summary = copter.data.inspectBinLog(filePath);
    logData = copter.data.readBinLog(filePath, config, summary);
    summaries{end + 1} = summary;

    [~, baseName, ~] = fileparts(filePath);
    markdownPath = fullfile(outputFolder, baseName + "_summary.md");
    jsonPath = fullfile(outputFolder, baseName + "_summary.json");
    copter.reports.writeBinAnalysisSummary(markdownPath, jsonPath, summary, logData);
end

if ~isempty(missingLogs)
    missingReportPath = fullfile(outputFolder, 'missing_logs_report.md');
    copter.reports.writeMissingBinLogsReport(missingReportPath, missingLogs);
end

if ~isempty(summaries)
    inventory = copter.data.buildLogChannelInventory(summaries);
    inventoryPath = fullfile(outputFolder, 'log_channel_inventory.csv');
    writetable(inventory, inventoryPath);
    fprintf('Реестр состава каналов сформирован: %s\n', inventoryPath);
else
    fprintf('Реальные .BIN журналы отсутствовали. Разместите файлы в data/raw/ardupilot/bin/.\n');
end
