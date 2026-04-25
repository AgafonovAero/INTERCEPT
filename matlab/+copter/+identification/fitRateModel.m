function result = fitRateModel(dataSet, config, segment)
% Идентифицирует модель угловых скоростей по данным бортового журнала.

if nargin < 2 || isempty(config)
    config = copter.config.defaultVehicleConfig();
end

if nargin < 3
    segment = [];
end

dataTable = localTable(dataSet);
if ~isempty(segment)
    mask = dataTable.t_s >= segment(1) & dataTable.t_s <= segment(2);
    dataTable = dataTable(mask, :);
end

assert(height(dataTable) >= 6, 'Недостаточно строк для идентификации модели угловых скоростей.');

[measuredRate, measuredNames] = getMeasuredRates(dataTable);
[input, inputNames, inputSource] = getControlInput(dataTable);
timeSeconds = double(dataTable.t_s(:));

A = zeros(3);
B = zeros(3);
c = zeros(3, 1);
delays = zeros(3, 1);
errors = zeros(3, 1);
maxDelay = config.rate_model.max_input_delay_steps;

for axisIndex = 1:3
    signal = measuredRate(:, axisIndex);
    axisInput = input(:, axisIndex);
    derivative = copter.identification.computeDerivatives(timeSeconds, signal);
    [delay, ~] = copter.identification.estimateInputDelay(signal, derivative, axisInput, maxDelay);
    index = (1 + delay):numel(timeSeconds);
    designMatrix = [
        signal(index), ...
        axisInput(index - delay), ...
        ones(numel(index), 1)
        ];
    theta = designMatrix \ derivative(index);
    A(axisIndex, axisIndex) = theta(1);
    B(axisIndex, axisIndex) = theta(2);
    c(axisIndex) = theta(3);
    residual = derivative(index) - designMatrix * theta;
    errors(axisIndex) = sqrt(mean(residual .^ 2, 'omitnan'));
    delays(axisIndex) = delay;
end

result = struct();
result.model = copter.models.ModelRate(A, B, c);
result.A = A;
result.B = B;
result.c = c;
result.delay_steps = delays;
result.derivative_rmse = errors;
result.measured_channel_names = measuredNames;
result.input_channel_names = inputNames;
result.input_source = inputSource;
result.identification_segment_s = segment;
end

function dataTable = localTable(dataSet)
if istimetable(dataSet)
    dataTable = timetable2table(dataSet, 'ConvertRowTimes', false);
else
    dataTable = dataSet;
end
end

function [rates, names] = getMeasuredRates(dataTable)
names = ["RATE.R_rad_s", "RATE.P_rad_s", "RATE.Y_rad_s"];
fallbackNames = ["RATE.R", "RATE.P", "RATE.Y"];
rates = zeros(height(dataTable), 3);

for index = 1:3
    if hasColumn(dataTable, names(index))
        rates(:, index) = double(dataTable.(names(index)));
    elseif hasColumn(dataTable, fallbackNames(index))
        rates(:, index) = deg2rad(double(dataTable.(fallbackNames(index))));
        names(index) = fallbackNames(index);
    else
        error('Не найден канал измеренной угловой скорости: %s', fallbackNames(index));
    end
end
end

function [input, names, source] = getControlInput(dataTable)
names = ["RATE.ROut", "RATE.POut", "RATE.YOut"];
input = zeros(height(dataTable), 3);

if all(hasColumns(dataTable, names))
    for index = 1:3
        input(:, index) = double(dataTable.(names(index)));
    end
    source = "RATE.ROut, RATE.POut, RATE.YOut";
    return;
end

normalizedPwm = ["RCOU.C1_norm", "RCOU.C2_norm", "RCOU.C3_norm", "RCOU.C4_norm"];
rawPwm = ["RCOU.C1", "RCOU.C2", "RCOU.C3", "RCOU.C4"];
if all(hasColumns(dataTable, normalizedPwm))
    c1 = double(dataTable.(normalizedPwm(1)));
    c2 = double(dataTable.(normalizedPwm(2)));
    c3 = double(dataTable.(normalizedPwm(3)));
    c4 = double(dataTable.(normalizedPwm(4)));
elseif all(hasColumns(dataTable, rawPwm))
    c1 = copter.utils.normalizePwm(dataTable.(rawPwm(1)), 1000, 2000);
    c2 = copter.utils.normalizePwm(dataTable.(rawPwm(2)), 1000, 2000);
    c3 = copter.utils.normalizePwm(dataTable.(rawPwm(3)), 1000, 2000);
    c4 = copter.utils.normalizePwm(dataTable.(rawPwm(4)), 1000, 2000);
else
    error('Не найдены RATE.*Out или RCOU.C1-C4 для восстановления входных воздействий.');
end

input(:, 1) = 0.5 * (c2 + c3 - c1 - c4);
input(:, 2) = 0.5 * (c3 + c4 - c1 - c2);
input(:, 3) = 0.5 * (c1 + c3 - c2 - c4);
names = ["RCOU крен", "RCOU тангаж", "RCOU рыскание"];
source = "Приближенное восстановление по RCOU.C1-C4";
end

function result = hasColumn(dataTable, name)
result = any(string(dataTable.Properties.VariableNames) == string(name));
end

function result = hasColumns(dataTable, names)
result = false(size(names));
for index = 1:numel(names)
    result(index) = hasColumn(dataTable, names(index));
end
end
