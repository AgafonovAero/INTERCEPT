function [createdFiles, warnings] = plotLogOverview(dataSet, outputFolder, options)
% Строит обзорные графики обработанного бортового журнала.

if nargin < 2 || isempty(outputFolder)
    outputFolder = pwd;
end

if nargin < 3 || isempty(options)
    options = struct();
end

if ~isfolder(outputFolder)
    mkdir(outputFolder);
end

options = normalizeOptions(options);
dataTable = localTable(dataSet);
time = readTime(dataTable);
createdFiles = strings(0, 1);
warnings = strings(0, 1);

groups = buildGroups();
for groupIndex = 1:numel(groups)
    group = groups(groupIndex);
    [figureHandle, hasData] = plotGroup(time, dataTable, group, options);
    if hasData
        filePath = fullfile(outputFolder, group.file_name + ".png");
        exportgraphics(figureHandle, filePath, 'Resolution', options.resolution_dpi);
        createdFiles(end + 1, 1) = string(filePath);
    else
        warnings(end + 1, 1) = "Нет каналов для графика: " + group.title + ".";
    end
    close(figureHandle);
end
end

function [figureHandle, hasData] = plotGroup(time, dataTable, group, options)
figureHandle = figure('Visible', options.visible);
axesHandle = axes(figureHandle);
hold(axesHandle, 'on');
hasData = false;

for index = 1:numel(group.variables)
    variableName = group.variables(index);
    if hasVariable(dataTable, variableName)
        plot(axesHandle, time, double(dataTable.(variableName)), 'DisplayName', variableName);
        hasData = true;
    end
end

grid(axesHandle, 'on');
xlabel(axesHandle, 'Время, с');
ylabel(axesHandle, group.ylabel);
title(axesHandle, group.title);
if hasData
    legend(axesHandle, 'Interpreter', 'none', 'Location', 'best');
end
end

function groups = buildGroups()
groups = struct([]);
groups(end + 1).title = "Углы ориентации";
groups(end).ylabel = "Угол, град";
groups(end).file_name = "attitude";
groups(end).variables = ["ATT.Roll", "ATT.Pitch", "ATT.Yaw"];
groups(end + 1).title = "Угловые скорости";
groups(end).ylabel = "Угловая скорость, град/с";
groups(end).file_name = "rate";
groups(end).variables = ["RATE.R", "RATE.P", "RATE.Y"];
groups(end + 1).title = "Управляющие воздействия RATE";
groups(end).ylabel = "Нормированная команда";
groups(end).file_name = "rate_outputs";
groups(end).variables = ["RATE.ROut", "RATE.POut", "RATE.YOut"];
groups(end + 1).title = "Выходы RCOU";
groups(end).ylabel = "Ширина импульса, мкс";
groups(end).file_name = "rcou";
groups(end).variables = ["RCOU.C1", "RCOU.C2", "RCOU.C3", "RCOU.C4"];
groups(end + 1).title = "Нормированные команды двигателей";
groups(end).ylabel = "Команда, 0...1";
groups(end).file_name = "motor_commands";
groups(end).variables = ["u_motor_1", "u_motor_2", "u_motor_3", "u_motor_4"];
groups(end + 1).title = "Высота и скорости";
groups(end).ylabel = "м, м/с";
groups(end).file_name = "altitude_speed";
groups(end).variables = ["altitude_m", "vertical_speed_mps", "horizontal_speed_mps"];
groups(end + 1).title = "Аккумулятор";
groups(end).ylabel = "В, А";
groups(end).file_name = "battery";
groups(end).variables = ["BAT.Volt", "BAT.Curr"];
end

function options = normalizeOptions(options)
if ~isfield(options, 'visible')
    options.visible = 'off';
end

if ~isfield(options, 'resolution_dpi')
    options.resolution_dpi = 120;
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

function result = hasVariable(dataTable, variableName)
result = any(string(dataTable.Properties.VariableNames) == string(variableName));
end
