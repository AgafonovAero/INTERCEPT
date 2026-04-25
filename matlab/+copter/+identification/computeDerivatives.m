function derivative = computeDerivatives(timeSeconds, signal)
% Рассчитывает производные устойчивой центральной разностью.

timeSeconds = double(timeSeconds(:));
signal = double(signal(:));
assert(numel(timeSeconds) == numel(signal), 'Размеры времени и измерения должны совпадать.');
assert(numel(timeSeconds) >= 3, 'Для расчета производной требуется не менее трех точек.');

derivative = zeros(size(signal));
derivative(2:end - 1) = (signal(3:end) - signal(1:end - 2)) ./ ...
    (timeSeconds(3:end) - timeSeconds(1:end - 2));
derivative(1) = (signal(2) - signal(1)) ./ (timeSeconds(2) - timeSeconds(1));
derivative(end) = (signal(end) - signal(end - 1)) ./ ...
    (timeSeconds(end) - timeSeconds(end - 1));

derivative = suppressOutliers(derivative);
end

function derivative = suppressOutliers(derivative)
medianValue = median(derivative, 'omitnan');
medianDeviation = median(abs(derivative - medianValue), 'omitnan');

if medianDeviation <= eps || isnan(medianDeviation)
    return;
end

threshold = 12 * 1.4826 * medianDeviation;
outlierIndex = abs(derivative - medianValue) > threshold;
if any(outlierIndex)
    derivative(outlierIndex) = medianValue;
end
end
