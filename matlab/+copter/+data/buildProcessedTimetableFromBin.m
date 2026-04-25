function [processedData, qualityReport] = buildProcessedTimetableFromBin(filePath, config, settings)
% Формирует обработанный timetable из бортового журнала DataFlash BIN.

if nargin < 2 || isempty(config)
    config = copter.config.defaultVehicleConfig();
end

if nargin < 3 || isempty(settings)
    settings = struct();
    settings.sample_rate_hz = config.normalization.sample_rate_hz;
end

if ~isfield(settings, 'sample_rate_hz')
    settings.sample_rate_hz = config.normalization.sample_rate_hz;
end

logData = copter.data.readBinLog(filePath, config);
[synchronizedData, syncReport] = copter.data.synchronizeLogMessages(logData.messages, settings.sample_rate_hz);
[flightTable, extractionReport] = copter.data.extractFlightSignals(synchronizedData, config);
[derivedTable, derivedReport] = copter.data.computeDerivedSignals(flightTable, settings);

if istimetable(derivedTable)
    processedData = derivedTable;
else
    processedData = table2timetable(derivedTable, 'RowTimes', seconds(derivedTable.t_s));
    processedData.Properties.DimensionNames{1} = 'Time';
end

qualityReport = struct();
qualityReport.file_path = string(filePath);
[~, fileName, fileExtension] = fileparts(filePath);
qualityReport.file_name = string(fileName) + string(fileExtension);
qualityReport.summary = logData.summary;
qualityReport.sync = syncReport;
qualityReport.extraction = extractionReport;
qualityReport.derived = derivedReport;
qualityReport.warnings = unique([logData.warnings; syncReport.warnings; extractionReport.warnings], 'stable');
qualityReport.row_count = height(processedData);
qualityReport.duration_s = processedData.t_s(end) - processedData.t_s(1);
qualityReport.note = "Обработанный набор данных сформирован по данным бортового журнала и не является независимым внешним измерением.";
end
