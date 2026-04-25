function dashboardReport = makeDemoDashboard(logData, modelData, outputFolder, config)
% Формирует основной набор графиков визуального демонстратора.

if nargin < 4 || isempty(config)
    config = copter.config.defaultVehicleConfig();
end

if ~isfolder(outputFolder)
    mkdir(outputFolder);
end

overviewFolder = fullfile(outputFolder, 'overview');
comparisonFolder = fullfile(outputFolder, 'comparison');
[overviewFiles, overviewWarnings] = copter.visualization.plotLogOverview(logData, overviewFolder);
pathFile = fullfile(outputFolder, 'flight_path_3d.png');
[pathFigure, pathReport] = copter.visualization.plotFlightPath3D(logData, pathFile);
close(pathFigure);
[comparisonFiles, comparisonWarnings] = copter.visualization.plotModelVsLogComparison( ...
    logData, modelData, comparisonFolder);

dashboardReport = struct();
dashboardReport.overview_files = overviewFiles;
dashboardReport.overview_warnings = overviewWarnings;
dashboardReport.path_report = pathReport;
dashboardReport.comparison_files = comparisonFiles;
dashboardReport.comparison_warnings = comparisonWarnings;
dashboardReport.vehicle_id = string(config.vehicle_id);
dashboardReport.note = "Демонстрационная панель является постпроцессором результатов расчета.";
end
