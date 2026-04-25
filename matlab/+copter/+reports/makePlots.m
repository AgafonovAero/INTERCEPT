function plotPaths = makePlots(dataSet, simulation, outputFolder)
% Формирует графики сопоставления расчетных и зарегистрированных величин.

if nargin < 3 || isempty(outputFolder)
    outputFolder = fullfile(pwd, 'result');
end

if ~isfolder(outputFolder)
    mkdir(outputFolder);
end

dataTable = dataSet;
if istimetable(dataTable)
    dataTable = timetable2table(dataTable, 'ConvertRowTimes', false);
end

plotPaths = strings(0, 1);
channels = ["R", "P", "Y"];

for index = 1:3
    sourceName = "RATE." + channels(index) + "_rad_s";
    fallbackName = "RATE." + channels(index);
    if any(string(dataTable.Properties.VariableNames) == sourceName)
        reference = rad2deg(double(dataTable.(sourceName)));
    elseif any(string(dataTable.Properties.VariableNames) == fallbackName)
        reference = double(dataTable.(fallbackName));
    else
        continue;
    end

    calculated = simulation.("RATE_" + channels(index) + "_calc_deg_s");
    count = min(numel(reference), numel(calculated));
    figureHandle = figure('Visible', 'off');
    plot(dataTable.t_s(1:count), reference(1:count), 'LineWidth', 1.1);
    hold on;
    plot(simulation.t_s(1:count), calculated(1:count), '--', 'LineWidth', 1.1);
    grid on;
    xlabel('время, с');
    ylabel('угловая скорость, град/с');
    legend('зарегистрировано', 'расчет компьютерной модели', 'Location', 'best');
    title("Сопоставление RATE." + channels(index));
    plotPath = fullfile(outputFolder, "comparison_RATE_" + channels(index) + ".png");
    saveas(figureHandle, plotPath);
    close(figureHandle);
    plotPaths(end + 1, 1) = string(plotPath);
end
end
