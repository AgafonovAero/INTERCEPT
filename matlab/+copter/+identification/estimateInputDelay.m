function [bestDelay, errors] = estimateInputDelay(signal, derivative, input, maxDelay)
% Подбирает целочисленную задержку входного воздействия.

if nargin < 4 || isempty(maxDelay)
    maxDelay = 5;
end

signal = double(signal(:));
derivative = double(derivative(:));
input = double(input(:));
errors = inf(maxDelay + 1, 1);

for delay = 0:maxDelay
    index = (1 + delay):numel(signal);
    if numel(index) < 4
        continue;
    end

    localSignal = signal(index);
    localDerivative = derivative(index);
    localInput = input(index - delay);
    designMatrix = [localSignal, localInput, ones(numel(localSignal), 1)];
    theta = designMatrix \ localDerivative;
    residual = localDerivative - designMatrix * theta;
    errors(delay + 1) = sqrt(mean(residual .^ 2, 'omitnan'));
end

[~, number] = min(errors);
bestDelay = number - 1;
end
