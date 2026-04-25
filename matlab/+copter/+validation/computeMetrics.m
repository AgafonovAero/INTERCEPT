function metrics = computeMetrics(reference, calculated)
% Рассчитывает показатели расхождения расчетных и зарегистрированных величин.

reference = double(reference);
calculated = double(calculated);
assert(isequal(size(reference), size(calculated)), 'Размеры сравниваемых данных должны совпадать.');

errorValue = reference - calculated;
metrics = struct();
metrics.rmse = sqrt(mean(errorValue .^ 2, 1, 'omitnan'));
metrics.mae = mean(abs(errorValue), 1, 'omitnan');
metrics.max_abs = max(abs(errorValue), [], 1, 'omitnan');

range = max(reference, [], 1, 'omitnan') - min(reference, [], 1, 'omitnan');
range(range < eps) = NaN;
metrics.nrmse = metrics.rmse ./ range;

fit = zeros(1, size(reference, 2));
for index = 1:size(reference, 2)
    denominator = norm(reference(:, index) - mean(reference(:, index), 'omitnan'));
    if denominator < eps
        fit(index) = NaN;
    else
        fit(index) = 100 * (1 - norm(errorValue(:, index)) / denominator);
    end
end

metrics.fit_percent = fit;
metrics.russian_names = struct( ...
    'rmse', "среднеквадратическое отклонение", ...
    'mae', "среднее абсолютное отклонение", ...
    'max_abs', "максимальное абсолютное отклонение", ...
    'nrmse', "нормированное среднеквадратическое отклонение", ...
    'fit_percent', "показатель соответствия");
end
