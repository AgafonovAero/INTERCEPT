function normalized = normalizePwm(pwm, pwmMin, pwmMax)
% Нормирует значения ШИМ в диапазон от 0 до 1.

if nargin < 2 || isempty(pwmMin)
    pwmMin = 1000;
end

if nargin < 3 || isempty(pwmMax)
    pwmMax = 2000;
end

normalized = (double(pwm) - pwmMin) ./ (pwmMax - pwmMin);
normalized = max(0, min(1, normalized));
end
