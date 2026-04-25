function [createdFiles, warnings] = plotModel6DofReplayComparison(logData, simData, outputFolder, options)
% Строит overlay-графики сопоставления бортового журнала и расчета Model6DOF.

if nargin < 3 || isempty(outputFolder)
    outputFolder = pwd;
end

if nargin < 4 || isempty(options)
    options = struct();
end

if ~isfolder(outputFolder)
    mkdir(outputFolder);
end

options = normalizeOptions(options);
[createdFiles, warnings] = copter.visualization.plotModelVsLogComparison( ...
    logData, simData, outputFolder, options);

[residualFile, residualWarnings] = plotResiduals(logData, simData, outputFolder, options);
if strlength(residualFile) > 0
    createdFiles(end + 1, 1) = residualFile;
end
warnings = [warnings; residualWarnings];
end

function [filePath, warnings] = plotResiduals(logData, simData, outputFolder, options)
logTable = localTable(logData);
simTable = localTable(simData);
warnings = strings(0, 1);
filePath = "";

channels = [
    "ATT.Roll_rad", "roll_rad", "крен, рад"
    "ATT.Pitch_rad", "pitch_rad", "тангаж, рад"
    "ATT.Yaw_rad", "yaw_rad", "курс, рад"
    "RATE.R_rad_s", "p_rad_s", "p, рад/с"
    "RATE.P_rad_s", "q_rad_s", "q, рад/с"
    "RATE.Y_rad_s", "r_rad_s", "r, рад/с"
    "altitude_m", "altitude_m", "высота, м"
    "vertical_speed_mps", "vertical_speed_mps", "вертикальная скорость, м/с"
    ];

if isempty(logTable) || isempty(simTable)
    warnings(end + 1, 1) = "Невязки не построены: нет данных журнала или расчета.";
    return;
end

simTime = double(simTable.t_s(:));
figureHandle = figure('Visible', options.visible);
tiledlayout(figureHandle, 4, 2);
hasData = false;

for index = 1:size(channels, 1)
    nexttile;
    logName = channels(index, 1);
    simName = channels(index, 2);
    titleText = channels(index, 3);
    if hasVariable(logTable, logName) && hasVariable(simTable, simName)
        reference = interp1(double(logTable.t_s), double(logTable.(logName)), simTime, 'linear', 'extrap');
        residual = reference - double(simTable.(simName));
        plot(simTime, residual);
        grid on;
        hasData = true;
    end
    title("Невязка: " + titleText);
    xlabel('Время, с');
end

if hasData
    filePath = string(fullfile(outputFolder, 'model6dof_residuals.png'));
    exportgraphics(figureHandle, filePath, 'Resolution', options.resolution_dpi);
else
    warnings(end + 1, 1) = "Невязки не построены: общие каналы не найдены.";
end
close(figureHandle);
end

function options = normalizeOptions(options)
if ~isfield(options, 'visible')
    options.visible = 'off';
end

if ~isfield(options, 'resolution_dpi')
    options.resolution_dpi = 120;
end
end

function dataTable = localTable(dataSet)
if istimetable(dataSet)
    dataTable = timetable2table(dataSet, 'ConvertRowTimes', false);
else
    dataTable = dataSet;
end
end

function result = hasVariable(dataTable, variableName)
result = any(string(dataTable.Properties.VariableNames) == string(variableName));
end
