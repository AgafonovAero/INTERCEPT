function comparison = compareModel6DofBeforeAfterCalibration(baselineMetrics, calibratedMetrics)
% Сравнивает метрики Model6DOF до и после калибровки мотор-маппинга.

baseline = normalizeMetrics(baselineMetrics, "baseline");
calibrated = normalizeMetrics(calibratedMetrics, "calibrated");
channels = unique([baseline.key; calibrated.key], 'stable');
rows = struct([]);

for index = 1:numel(channels)
    key = channels(index);
    baseRow = findMetric(baseline, key);
    calRow = findMetric(calibrated, key);
    baselineRmse = baseRow.rmse;
    calibratedRmse = calRow.rmse;
    improvement = 100 * (baselineRmse - calibratedRmse) / max(abs(baselineRmse), eps);

    row = struct();
    row.log_file = baseRow.log_file;
    if strlength(row.log_file) == 0
        row.log_file = calRow.log_file;
    end
    row.channel = baseRow.channel;
    if strlength(row.channel) == 0
        row.channel = calRow.channel;
    end
    row.baseline_RMSE = baselineRmse;
    row.calibrated_RMSE = calibratedRmse;
    row.baseline_FIT = baseRow.fit_percent;
    row.calibrated_FIT = calRow.fit_percent;
    row.improvement_percent = improvement;
    row.pass_before = baseRow.pass_flag;
    row.pass_after = calRow.pass_flag;
    row.conclusion = makeConclusion(improvement, row.pass_before, row.pass_after);
    rows = [rows; row];
end

if isempty(rows)
    comparison = emptyComparison();
else
    comparison = struct2table(rows);
end
end

function metrics = normalizeMetrics(inputMetrics, prefix)
if nargin < 2
    prefix = "metrics";
end

if isempty(inputMetrics)
    metrics = emptyNormalized();
    return;
end

metrics = inputMetrics;
if ~any(string(metrics.Properties.VariableNames) == "log_file")
    metrics.log_file = repmat(prefix, height(metrics), 1);
end
if any(string(metrics.Properties.VariableNames) == "signal")
    channel = string(metrics.signal);
elseif any(string(metrics.Properties.VariableNames) == "channel")
    channel = string(metrics.channel);
else
    channel = "unknown";
end
if ~any(string(metrics.Properties.VariableNames) == "rmse")
    metrics.rmse = NaN(height(metrics), 1);
end
if ~any(string(metrics.Properties.VariableNames) == "fit_percent")
    metrics.fit_percent = NaN(height(metrics), 1);
end
if any(string(metrics.Properties.VariableNames) == "pass_preliminary_criterion")
    passFlag = logical(metrics.pass_preliminary_criterion);
else
    passFlag = false(height(metrics), 1);
end

metrics.channel = channel(:);
metrics.pass_flag = passFlag(:);
metrics.key = string(metrics.log_file(:)) + "|" + metrics.channel(:);
end

function row = findMetric(metrics, key)
row = struct();
row.log_file = "";
row.channel = "";
row.rmse = NaN;
row.fit_percent = NaN;
row.pass_flag = false;
mask = metrics.key == key;
if any(mask)
    index = find(mask, 1, 'first');
    row.log_file = string(metrics.log_file(index));
    row.channel = string(metrics.channel(index));
    row.rmse = double(metrics.rmse(index));
    row.fit_percent = double(metrics.fit_percent(index));
    row.pass_flag = logical(metrics.pass_flag(index));
end
end

function conclusion = makeConclusion(improvement, passBefore, passAfter)
if passAfter && ~passBefore
    conclusion = "После калибровки предварительный критерий выполнен.";
elseif isfinite(improvement) && improvement > 0
    conclusion = "RMSE уменьшилось, но результат требует проверки по валидационным окнам.";
elseif isfinite(improvement) && improvement < 0
    conclusion = "RMSE увеличилось; гипотеза калибровки требует доработки.";
else
    conclusion = "Недостаточно данных для вывода.";
end
end

function metrics = emptyNormalized()
metrics = table(strings(0, 1), strings(0, 1), zeros(0, 1), zeros(0, 1), false(0, 1), strings(0, 1), ...
    'VariableNames', {'log_file', 'channel', 'rmse', 'fit_percent', 'pass_flag', 'key'});
end

function comparison = emptyComparison()
comparison = table(strings(0, 1), strings(0, 1), zeros(0, 1), zeros(0, 1), zeros(0, 1), zeros(0, 1), ...
    zeros(0, 1), false(0, 1), false(0, 1), strings(0, 1), ...
    'VariableNames', {'log_file', 'channel', 'baseline_RMSE', 'calibrated_RMSE', 'baseline_FIT', ...
    'calibrated_FIT', 'improvement_percent', 'pass_before', 'pass_after', 'conclusion'});
end
