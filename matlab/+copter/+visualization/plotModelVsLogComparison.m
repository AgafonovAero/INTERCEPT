function [createdFiles, warnings] = plotModelVsLogComparison(logData, modelData, outputFolder, options)
% Строит сопоставление расчетных и зарегистрированных величин.

if nargin < 3 || isempty(outputFolder)
    outputFolder = pwd;
end

if nargin < 4 || isempty(options)
    options = struct();
end

if isempty(modelData)
    createdFiles = strings(0, 1);
    warnings = "Расчетные данные отсутствуют; сопоставление не построено.";
    return;
end

if ~isfolder(outputFolder)
    mkdir(outputFolder);
end

options = normalizeOptions(options);
logTable = localTable(logData);
modelTable = localTable(modelData);
createdFiles = strings(0, 1);
warnings = strings(0, 1);
groups = comparisonGroups();

for groupIndex = 1:numel(groups)
    group = groups(groupIndex);
    [figureHandle, hasData] = plotComparisonGroup(logTable, modelTable, group, options);
    if hasData
        filePath = fullfile(outputFolder, group.file_name + ".png");
        exportgraphics(figureHandle, filePath, 'Resolution', options.resolution_dpi);
        createdFiles(end + 1, 1) = string(filePath);
    else
        warnings(end + 1, 1) = "Нет данных для сопоставления: " + group.title + ".";
    end
    close(figureHandle);
end
end

function [figureHandle, hasData] = plotComparisonGroup(logTable, modelTable, group, options)
figureHandle = figure('Visible', options.visible);
axesHandle = axes(figureHandle);
hold(axesHandle, 'on');
hasData = false;
logTime = readTime(logTable);
modelTime = readTime(modelTable);

for index = 1:size(group.variables, 1)
    logName = group.variables(index, 1);
    modelName = group.variables(index, 2);
    if hasVariable(logTable, logName)
        plot(axesHandle, logTime, double(logTable.(logName)), 'DisplayName', logName + " журнал");
        hasData = true;
    end

    if hasVariable(modelTable, modelName)
        plot(axesHandle, modelTime, double(modelTable.(modelName)), '--', ...
            'DisplayName', modelName + " расчет");
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

function groups = comparisonGroups()
groups = struct([]);
groups(end + 1).title = "Угловые скорости";
groups(end).ylabel = "рад/с";
groups(end).file_name = "compare_rate";
groups(end).variables = [
    "RATE.R_rad_s", "p_rad_s"
    "RATE.P_rad_s", "q_rad_s"
    "RATE.Y_rad_s", "r_rad_s"
    ];
groups(end + 1).title = "Высота";
groups(end).ylabel = "м";
groups(end).file_name = "compare_altitude";
groups(end).variables = ["altitude_m", "z_m"];
groups(end + 1).title = "Команды двигателей";
groups(end).ylabel = "0...1";
groups(end).file_name = "compare_motor";
groups(end).variables = [
    "u_motor_1", "u_motor_1"
    "u_motor_2", "u_motor_2"
    "u_motor_3", "u_motor_3"
    "u_motor_4", "u_motor_4"
    ];
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
