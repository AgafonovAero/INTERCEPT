function [figureHandle, plotReport] = plotFlightPath3D(dataSet, outputFile, segments, options)
% Строит 3D-траекторию полета по журналу или расчету.

if nargin < 2
    outputFile = "";
end

if nargin < 3
    segments = table();
end

if nargin < 4 || isempty(options)
    options = struct();
end

options = normalizeOptions(options);
dataTable = localTable(dataSet);
[position, sourceName, warnings] = extractPosition(dataTable);

figureHandle = figure('Visible', options.visible);
axesHandle = axes(figureHandle);
plot3(axesHandle, position(:, 1), position(:, 2), position(:, 3), 'LineWidth', 1.5);
hold(axesHandle, 'on');
scatter3(axesHandle, position(1, 1), position(1, 2), position(1, 3), 50, 'g', 'filled');
scatter3(axesHandle, position(end, 1), position(end, 2), position(end, 3), 50, 'r', 'filled');
plotSegments(axesHandle, dataTable, position, segments);
grid(axesHandle, 'on');
axis(axesHandle, 'equal');
xlabel(axesHandle, 'Восток или X, м');
ylabel(axesHandle, 'Север или Y, м');
zlabel(axesHandle, 'Высота или Z, м');
title(axesHandle, "3D-траектория, система ENU: " + sourceName);
view(axesHandle, 3);

if strlength(string(outputFile)) > 0
    outputFolder = fileparts(outputFile);
    if strlength(string(outputFolder)) > 0 && ~isfolder(outputFolder)
        mkdir(outputFolder);
    end
    exportgraphics(figureHandle, outputFile, 'Resolution', options.resolution_dpi);
end

plotReport = struct();
plotReport.position_source = sourceName;
plotReport.warnings = warnings;
plotReport.output_file = string(outputFile);
end

function [position, sourceName, warnings] = extractPosition(dataTable)
warnings = strings(0, 1);
if all(hasVariables(dataTable, ["x_m", "y_m", "z_m"]))
    position = [dataTable.x_m, dataTable.y_m, dataTable.z_m];
    sourceName = "расчетные координаты";
    return;
end

if all(hasVariables(dataTable, ["POS.X", "POS.Y", "POS.RelHomeAlt"]))
    position = [dataTable.("POS.X"), dataTable.("POS.Y"), dataTable.("POS.RelHomeAlt")];
    sourceName = "POS";
    return;
end

if all(hasVariables(dataTable, ["XKF1.PN", "XKF1.PE", "XKF1.PD"]))
    position = [dataTable.("XKF1.PE"), dataTable.("XKF1.PN"), -dataTable.("XKF1.PD")];
    sourceName = "XKF1";
    return;
end

time = readTime(dataTable);
altitude = readOptional(dataTable, "altitude_m", zeros(height(dataTable), 1));
horizontalSpeed = readOptional(dataTable, "horizontal_speed_mps", zeros(height(dataTable), 1));
position = [cumtrapz(time, horizontalSpeed), zeros(height(dataTable), 1), altitude];
sourceName = "упрощенная реконструкция по скорости и высоте";
warnings(end + 1, 1) = "Координаты не найдены; использована упрощенная реконструкция траектории.";
end

function plotSegments(axesHandle, dataTable, position, segments)
if isempty(segments) || ~hasVariable(dataTable, "t_s")
    return;
end

for index = 1:height(segments)
    mask = dataTable.t_s >= segments.t_start_s(index) & dataTable.t_s <= segments.t_end_s(index);
    if any(mask)
        plot3(axesHandle, position(mask, 1), position(mask, 2), position(mask, 3), 'LineWidth', 2.5);
    end
end
end

function options = normalizeOptions(options)
if ~isfield(options, 'visible')
    options.visible = 'off';
end

if ~isfield(options, 'resolution_dpi')
    options.resolution_dpi = 120;
end
end

function values = readOptional(dataTable, variableName, defaultValue)
if hasVariable(dataTable, variableName)
    values = double(dataTable.(variableName));
else
    values = defaultValue;
end
end

function time = readTime(dataTable)
if hasVariable(dataTable, "t_s")
    time = double(dataTable.t_s(:));
else
    time = seconds(dataTable.Properties.RowTimes);
end
end

function dataTable = localTable(dataSet)
if istimetable(dataSet)
    dataTable = timetable2table(dataSet, 'ConvertRowTimes', false);
else
    dataTable = dataSet;
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
