function diagnostics = diagnoseTimebase(dataSet, expectedSampleRateHz)
% Диагностирует временную базу обработанного набора данных.

if nargin < 2 || isempty(expectedSampleRateHz)
    expectedSampleRateHz = 100;
end

timeSeconds = readTimeSeconds(dataSet);
diagnostics = struct();
diagnostics.row_count = numel(timeSeconds);
diagnostics.expected_sample_rate_hz = expectedSampleRateHz;
diagnostics.warnings = strings(0, 1);

if numel(timeSeconds) < 2
    diagnostics.mean_dt_s = NaN;
    diagnostics.min_dt_s = NaN;
    diagnostics.max_dt_s = NaN;
    diagnostics.estimated_sample_rate_hz = NaN;
    diagnostics.duplicate_time_count = 0;
    diagnostics.missing_sample_percent = NaN;
    diagnostics.is_uniform = false;
    diagnostics.warnings(end + 1, 1) = "Недостаточно отсчетов для диагностики временной базы.";
    return;
end

timeSeconds = double(timeSeconds(:));
dt = diff(timeSeconds);
positiveDt = dt(dt > 0 & isfinite(dt));
expectedDt = 1 / expectedSampleRateHz;

diagnostics.mean_dt_s = mean(positiveDt, 'omitnan');
diagnostics.min_dt_s = min(positiveDt, [], 'omitnan');
diagnostics.max_dt_s = max(positiveDt, [], 'omitnan');
diagnostics.estimated_sample_rate_hz = 1 / diagnostics.mean_dt_s;
diagnostics.duplicate_time_count = nnz(dt == 0);
diagnostics.nonmonotonic_time_count = nnz(dt < 0);
diagnostics.is_uniform = all(abs(positiveDt - expectedDt) <= max(1.0e-6, 0.05 * expectedDt));

if isempty(positiveDt)
    diagnostics.missing_sample_percent = NaN;
else
    gapMask = positiveDt > 1.5 * expectedDt;
    diagnostics.missing_sample_percent = 100 * nnz(gapMask) / numel(positiveDt);
end

if diagnostics.duplicate_time_count > 0
    diagnostics.warnings(end + 1, 1) = "Обнаружены дубли времени.";
end

if diagnostics.nonmonotonic_time_count > 0
    diagnostics.warnings(end + 1, 1) = "Обнаружены нарушения монотонности времени.";
end

if ~diagnostics.is_uniform
    diagnostics.warnings(end + 1, 1) = "Временная сетка не является равномерной в пределах допуска.";
end

if diagnostics.missing_sample_percent > 0
    diagnostics.warnings(end + 1, 1) = "Обнаружены пропуски во временной сетке.";
end
end

function timeSeconds = readTimeSeconds(dataSet)
if istimetable(dataSet)
    if any(string(dataSet.Properties.VariableNames) == "t_s")
        timeSeconds = double(dataSet.t_s(:));
    else
        timeSeconds = seconds(dataSet.Properties.RowTimes);
    end
elseif istable(dataSet)
    if any(string(dataSet.Properties.VariableNames) == "t_s")
        timeSeconds = double(dataSet.t_s(:));
    else
        error('Для диагностики временной базы требуется t_s или timetable.');
    end
else
    timeSeconds = double(dataSet(:));
end
end
