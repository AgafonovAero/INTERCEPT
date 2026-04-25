function [metricsTable, warnings] = compareModel6DofToLog(simData, processedData, replayWindow, options)
% Сравнивает расчет Model6DOF с зарегистрированными параметрами журнала.

if nargin < 4 || isempty(options)
    options = struct();
end

simTable = localTable(simData);
dataTable = localTable(processedData);
warnings = strings(0, 1);

if isempty(simTable) || isempty(dataTable)
    metricsTable = emptyMetrics();
    warnings(end + 1, 1) = "Нет данных для сопоставления Model6DOF с журналом.";
    return;
end

channels = channelMap();
rows = {};
for index = 1:numel(channels)
    channel = channels(index);
    if ~hasVariable(dataTable, channel.log_name) || ~hasVariable(simTable, channel.sim_name)
        warnings(end + 1, 1) = "Канал " + channel.report_name + " отсутствует в журнале или расчете.";
        continue;
    end

    simTime = double(simTable.t_s(:));
    logMask = dataTable.t_s >= min(simTime) & dataTable.t_s <= max(simTime);
    if nargin >= 3 && ~isempty(replayWindow)
        logMask = dataTable.t_s >= replayWindow.t_start_s(1) ...
            & dataTable.t_s <= replayWindow.t_end_s(1);
    end

    logTime = double(dataTable.t_s(logMask));
    logValue = double(dataTable.(channel.log_name)(logMask));
    simValue = double(simTable.(channel.sim_name));
    if numel(logTime) < 2 || numel(simTime) < 2
        warnings(end + 1, 1) = "Недостаточно точек для канала " + channel.report_name + ".";
        continue;
    end

    reference = interp1(logTime, logValue, simTime, 'linear', 'extrap');
    metrics = copter.validation.computeMetrics(reference, simValue, options);
    rows{end + 1, 1} = makeRow(channel, metrics);
end

if isempty(rows)
    metricsTable = emptyMetrics();
else
    metricsTable = struct2table([rows{:}]);
end
end

function row = makeRow(channel, metrics)
row = struct();
row.signal = channel.report_name;
row.unit = channel.unit;
row.rmse = metrics.rmse;
row.mae = metrics.mae;
row.max_abs_error = metrics.max_abs;
row.nrmse = metrics.nrmse;
row.fit_percent = metrics.fit_percent;
row.correlation = metrics.correlation;
row.bias = metrics.bias;
row.residual_std = metrics.residual_std;
row.valid_metric_flag = metrics.valid_metric_flag;
row.metric_warning = string(metrics.metric_warning);
end

function channels = channelMap()
template = makeChannel("", "", "", "");
channels = repmat(template, 0, 1);
channels(end + 1) = makeChannel("ATT.Roll_rad", "roll_rad", "ATT.Roll", "рад");
channels(end + 1) = makeChannel("ATT.Pitch_rad", "pitch_rad", "ATT.Pitch", "рад");
channels(end + 1) = makeChannel("ATT.Yaw_rad", "yaw_rad", "ATT.Yaw", "рад");
channels(end + 1) = makeChannel("RATE.R_rad_s", "p_rad_s", "RATE.R", "рад/с");
channels(end + 1) = makeChannel("RATE.P_rad_s", "q_rad_s", "RATE.P", "рад/с");
channels(end + 1) = makeChannel("RATE.Y_rad_s", "r_rad_s", "RATE.Y", "рад/с");
channels(end + 1) = makeChannel("altitude_m", "altitude_m", "altitude_m", "м");
channels(end + 1) = makeChannel("vertical_speed_mps", "vertical_speed_mps", "vertical_speed_mps", "м/с");
channels(end + 1) = makeChannel("horizontal_speed_mps", "horizontal_speed_mps", "horizontal_speed_mps", "м/с");
end

function channel = makeChannel(logName, simName, reportName, unit)
channel = struct();
channel.log_name = logName;
channel.sim_name = simName;
channel.report_name = reportName;
channel.unit = unit;
end

function metricsTable = emptyMetrics()
metricsTable = table( ...
    strings(0, 1), ...
    strings(0, 1), ...
    zeros(0, 1), ...
    zeros(0, 1), ...
    zeros(0, 1), ...
    zeros(0, 1), ...
    zeros(0, 1), ...
    zeros(0, 1), ...
    zeros(0, 1), ...
    zeros(0, 1), ...
    false(0, 1), ...
    strings(0, 1), ...
    'VariableNames', { ...
    'signal', ...
    'unit', ...
    'rmse', ...
    'mae', ...
    'max_abs_error', ...
    'nrmse', ...
    'fit_percent', ...
    'correlation', ...
    'bias', ...
    'residual_std', ...
    'valid_metric_flag', ...
    'metric_warning'});
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
