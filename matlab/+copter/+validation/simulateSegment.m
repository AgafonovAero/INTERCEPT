function simulation = simulateSegment(dataSet, model, segment)
% Выполняет расчет модели угловых скоростей на заданном участке.

dataTable = localTable(dataSet);
if nargin >= 3 && ~isempty(segment)
    mask = dataTable.t_s >= segment(1) & dataTable.t_s <= segment(2);
    dataTable = dataTable(mask, :);
end

assert(height(dataTable) >= 2, 'Недостаточно строк для расчета компьютерной модели.');

timeSeconds = double(dataTable.t_s(:));
initialRate = transpose(getMeasuredRates(dataTable(1, :)));
input = getControlInput(dataTable);
omega = zeros(numel(timeSeconds), 3);
omega(1, :) = transpose(initialRate(:));

for index = 1:(numel(timeSeconds) - 1)
    step = timeSeconds(index + 1) - timeSeconds(index);
    inputStart = transpose(input(index, :));
    inputEnd = transpose(input(index + 1, :));
    inputMiddle = 0.5 * (inputStart + inputEnd);
    state = transpose(omega(index, :));
    k1 = copter.models.rhsRateModel(timeSeconds(index), state, inputStart, model);
    k2 = copter.models.rhsRateModel(timeSeconds(index) + step / 2, state + step * k1 / 2, inputMiddle, model);
    k3 = copter.models.rhsRateModel(timeSeconds(index) + step / 2, state + step * k2 / 2, inputMiddle, model);
    k4 = copter.models.rhsRateModel(timeSeconds(index + 1), state + step * k3, inputEnd, model);
    omega(index + 1, :) = transpose(state + step * (k1 + 2 * k2 + 2 * k3 + k4) / 6);
end

simulation = table();
simulation.t_s = timeSeconds;
simulation.RATE_R_calc_rad_s = omega(:, 1);
simulation.RATE_P_calc_rad_s = omega(:, 2);
simulation.RATE_Y_calc_rad_s = omega(:, 3);
simulation.RATE_R_calc_deg_s = rad2deg(omega(:, 1));
simulation.RATE_P_calc_deg_s = rad2deg(omega(:, 2));
simulation.RATE_Y_calc_deg_s = rad2deg(omega(:, 3));
end

function dataTable = localTable(dataSet)
if istimetable(dataSet)
    dataTable = timetable2table(dataSet, 'ConvertRowTimes', false);
else
    dataTable = dataSet;
end
end

function rates = getMeasuredRates(dataTable)
names = ["RATE.R_rad_s", "RATE.P_rad_s", "RATE.Y_rad_s"];
fallbackNames = ["RATE.R", "RATE.P", "RATE.Y"];
rates = zeros(height(dataTable), 3);

for index = 1:3
    if hasColumn(dataTable, names(index))
        rates(:, index) = double(dataTable.(names(index)));
    elseif hasColumn(dataTable, fallbackNames(index))
        rates(:, index) = deg2rad(double(dataTable.(fallbackNames(index))));
    else
        error('Не найден канал измеренной угловой скорости: %s', fallbackNames(index));
    end
end
end

function input = getControlInput(dataTable)
names = ["RATE.ROut", "RATE.POut", "RATE.YOut"];
input = zeros(height(dataTable), 3);

if all(hasColumns(dataTable, names))
    for index = 1:3
        input(:, index) = double(dataTable.(names(index)));
    end
    return;
end

normalizedPwm = ["RCOU.C1_norm", "RCOU.C2_norm", "RCOU.C3_norm", "RCOU.C4_norm"];
if ~all(hasColumns(dataTable, normalizedPwm))
    error('Для расчета требуется RATE.*Out или нормированные RCOU.C1-C4.');
end

c1 = double(dataTable.(normalizedPwm(1)));
c2 = double(dataTable.(normalizedPwm(2)));
c3 = double(dataTable.(normalizedPwm(3)));
c4 = double(dataTable.(normalizedPwm(4)));
input(:, 1) = 0.5 * (c2 + c3 - c1 - c4);
input(:, 2) = 0.5 * (c3 + c4 - c1 - c2);
input(:, 3) = 0.5 * (c1 + c3 - c2 - c4);
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
