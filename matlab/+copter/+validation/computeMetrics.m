function metrics = computeMetrics(reference, calculated, options)
% Рассчитывает показатели расхождения расчетных и зарегистрированных величин.

if nargin < 3 || isempty(options)
    options = struct();
end

if ~isfield(options, 'fit_epsilon_denominator')
    options.fit_epsilon_denominator = 1.0e-9;
end

reference = double(reference);
calculated = double(calculated);
assert(isequal(size(reference), size(calculated)), 'Размеры сравниваемых данных должны совпадать.');

errorValue = reference - calculated;
metrics = struct();
metrics.rmse = sqrt(mean(errorValue .^ 2, 1, 'omitnan'));
metrics.mae = mean(abs(errorValue), 1, 'omitnan');
metrics.max_abs = max(abs(errorValue), [], 1, 'omitnan');
metrics.bias = mean(errorValue, 1, 'omitnan');
metrics.residual_std = std(errorValue, 0, 1, 'omitnan');

range = max(reference, [], 1, 'omitnan') - min(reference, [], 1, 'omitnan');
range(range < options.fit_epsilon_denominator) = NaN;
metrics.nrmse = metrics.rmse ./ range;

columnCount = size(reference, 2);
fit = NaN(1, columnCount);
correlation = NaN(1, columnCount);
validMetricFlag = false(1, columnCount);
metricWarning = strings(1, columnCount);

for index = 1:columnCount
    refColumn = reference(:, index);
    calcColumn = calculated(:, index);
    errorColumn = errorValue(:, index);
    validMask = isfinite(refColumn) & isfinite(calcColumn);

    if nnz(validMask) < 2
        metricWarning(index) = "Недостаточно конечных значений для расчета показателей.";
        continue;
    end

    refValid = refColumn(validMask);
    calcValid = calcColumn(validMask);
    errorValid = errorColumn(validMask);
    denominator = norm(refValid - mean(refValid, 'omitnan'));

    if denominator < options.fit_epsilon_denominator
        fit(index) = NaN;
        metricWarning(index) = "Показатель соответствия не применим из-за малой изменчивости эталонного сигнала.";
    else
        fit(index) = 100 * (1 - norm(errorValid) / denominator);
        validMetricFlag(index) = true;
    end

    if std(refValid, 0, 'omitnan') >= options.fit_epsilon_denominator ...
            && std(calcValid, 0, 'omitnan') >= options.fit_epsilon_denominator
        correlationMatrix = corrcoef(refValid, calcValid, 'Rows', 'complete');
        correlation(index) = correlationMatrix(1, 2);
    else
        if strlength(metricWarning(index)) == 0
            metricWarning(index) = "Корреляция не применима из-за малой изменчивости одного из сигналов.";
        end
    end
end

metrics.fit_percent = fit;
metrics.correlation = correlation;
metrics.valid_metric_flag = validMetricFlag;
metrics.metric_warning = metricWarning;
metrics.russian_names = struct( ...
    'rmse', "среднеквадратическое отклонение", ...
    'mae', "среднее абсолютное отклонение", ...
    'max_abs', "максимальное абсолютное отклонение", ...
    'nrmse', "нормированное среднеквадратическое отклонение", ...
    'fit_percent', "показатель соответствия", ...
    'bias', "среднее смещение", ...
    'residual_std', "среднеквадратическое отклонение невязки", ...
    'correlation', "коэффициент корреляции");
end
