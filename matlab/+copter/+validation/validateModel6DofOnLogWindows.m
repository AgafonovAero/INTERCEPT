function validationReport = validateModel6DofOnLogWindows(modelParameters, processedData, validationWindows, vehicleConfig)
% Выполняет проверочные replay-расчеты Model6DOF на отложенных окнах.

if nargin < 4 || isempty(vehicleConfig)
    vehicleConfig = copter.config.defaultVehicleConfig();
end

metricsByWindow = table();
warnings = strings(0, 1);

for index = 1:height(validationWindows)
    replayWindow = validationWindows(index, :);
    try
        [simData, simReport] = copter.validation.simulateModel6DofOnLogWindow( ...
            processedData, replayWindow, modelParameters, vehicleConfig);
        [metrics, compareWarnings] = copter.validation.compareModel6DofToLog( ...
            simData, processedData, replayWindow);
        if ~isempty(metrics)
            metrics.window_id = repmat(string(replayWindow.window_id), height(metrics), 1);
            metrics.log_file = repmat(string(replayWindow.log_file), height(metrics), 1);
            metricsByWindow = [metricsByWindow; metrics];
        end
        warnings = [warnings; simReport.warnings; compareWarnings];
    catch exception
        warnings(end + 1, 1) = "Окно " + string(replayWindow.window_id) ...
            + " не рассчитано: " + string(exception.message);
    end
end

validationReport = struct();
validationReport.metricsByWindow = metricsByWindow;
validationReport.channelSummary = summarizeChannels(metricsByWindow);
validationReport.warnings = unique(warnings, 'stable');
end

function summary = summarizeChannels(metricsByWindow)
if isempty(metricsByWindow)
    summary = table();
    return;
end

signals = unique(string(metricsByWindow.signal), 'stable');
summary = table();
for index = 1:numel(signals)
    signal = signals(index);
    mask = string(metricsByWindow.signal) == signal;
    signalMetrics = metricsByWindow(mask, :);
    validMask = signalMetrics.valid_metric_flag;
    meanFit = mean(signalMetrics.fit_percent(validMask), 'omitnan');
    meanRmse = mean(signalMetrics.rmse, 'omitnan');
    pass = preliminaryPass(signal, meanFit, meanRmse);
    row = table( ...
        signal, ...
        meanRmse, ...
        mean(signalMetrics.mae, 'omitnan'), ...
        meanFit, ...
        mean(signalMetrics.correlation(validMask), 'omitnan'), ...
        nnz(validMask), ...
        height(signalMetrics) - nnz(validMask), ...
        pass, ...
        conclusionText(pass, meanFit), ...
        'VariableNames', { ...
        'signal', ...
        'mean_rmse', ...
        'mean_mae', ...
        'mean_fit_percent', ...
        'mean_correlation', ...
        'valid_metric_count', ...
        'invalid_metric_count', ...
        'pass_preliminary_criterion', ...
        'conclusion'});
    summary = [summary; row];
end
end

function pass = preliminaryPass(signal, meanFit, meanRmse)
if contains(signal, "ATT")
    pass = isfinite(meanRmse) && meanRmse <= deg2rad(10);
elseif contains(signal, "RATE")
    pass = isfinite(meanRmse) && meanRmse <= deg2rad(80);
elseif signal == "altitude_m"
    pass = isfinite(meanRmse) && meanRmse <= 10;
elseif signal == "vertical_speed_mps"
    pass = isfinite(meanRmse) && meanRmse <= 5;
else
    pass = isfinite(meanFit) && meanFit >= 0;
end
end

function text = conclusionText(pass, meanFit)
if pass
    text = "предварительный критерий выполнен";
elseif ~isfinite(meanFit)
    text = "показатель соответствия не применим; требуется инженерная оценка";
else
    text = "предварительный критерий не выполнен";
end
end
