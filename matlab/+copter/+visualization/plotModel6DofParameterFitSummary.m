function [createdFiles, warnings] = plotModel6DofParameterFitSummary(fittedParams, validationReport, outputFolder, options)
% Строит сводные графики первичного подбора параметров Model6DOF.

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
createdFiles = strings(0, 1);
warnings = strings(0, 1);

createdFiles(end + 1, 1) = plotParameters(fittedParams, outputFolder, options);
if isstruct(validationReport) && isfield(validationReport, 'channelSummary') ...
        && ~isempty(validationReport.channelSummary)
    createdFiles(end + 1, 1) = plotMetrics(validationReport.channelSummary, outputFolder, options);
else
    warnings(end + 1, 1) = "Сводка метрик отсутствует; график pass/fail не построен.";
end
end

function filePath = plotParameters(fittedParams, outputFolder, options)
names = ["thrust_scale", "motor_tau_s", "kQ_over_kT", "linear_drag_x", "linear_drag_y", "linear_drag_z"];
values = NaN(numel(names), 1);
for index = 1:numel(names)
    if isfield(fittedParams, names(index))
        values(index) = double(fittedParams.(names(index)));
    end
end

figureHandle = figure('Visible', options.visible);
bar(values);
grid on;
set(gca, 'XTick', 1:numel(names), 'XTickLabel', names);
xtickangle(35);
ylabel('Значение параметра');
title('Параметры Model6DOF после первичного подбора');
filePath = string(fullfile(outputFolder, 'model6dof_parameters.png'));
exportgraphics(figureHandle, filePath, 'Resolution', options.resolution_dpi);
close(figureHandle);
end

function filePath = plotMetrics(channelSummary, outputFolder, options)
figureHandle = figure('Visible', options.visible);
bar(channelSummary.mean_rmse);
grid on;
set(gca, 'XTick', 1:height(channelSummary), 'XTickLabel', channelSummary.signal);
xtickangle(35);
ylabel('Среднеквадратическое отклонение');
title('Ошибки Model6DOF по validation-окнам');
filePath = string(fullfile(outputFolder, 'model6dof_validation_metrics.png'));
exportgraphics(figureHandle, filePath, 'Resolution', options.resolution_dpi);
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
