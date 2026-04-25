function result = validateByLog(dataSet, model, segment, config)
% Выполняет оценку адекватности компьютерной модели по бортовому журналу.

if nargin < 4 || isempty(config)
    config = copter.config.defaultVehicleConfig();
end

simulation = copter.validation.simulateSegment(dataSet, model, segment);
dataTable = localTable(dataSet);
mask = dataTable.t_s >= segment(1) & dataTable.t_s <= segment(2);
dataTable = dataTable(mask, :);

reference = [
    getRate(dataTable, "RATE.R"), ...
    getRate(dataTable, "RATE.P"), ...
    getRate(dataTable, "RATE.Y")
    ];
calculated = [
    simulation.RATE_R_calc_rad_s, ...
    simulation.RATE_P_calc_rad_s, ...
    simulation.RATE_Y_calc_rad_s
    ];
metrics = copter.validation.computeMetrics(reference, calculated);
validationMatrix = copter.validation.buildValidationMatrix(metrics, segment, config);

result = struct();
result.simulation = simulation;
result.metrics = metrics;
result.validation_matrix = validationMatrix;
result.validation_segment_s = segment;
result.warning = "Данная проверка выполнена по данным бортового журнала и не является полной независимой валидацией реального изделия по внешним средствам измерений.";
end

function dataTable = localTable(dataSet)
if istimetable(dataSet)
    dataTable = timetable2table(dataSet, 'ConvertRowTimes', false);
else
    dataTable = dataSet;
end
end

function rate = getRate(dataTable, name)
radName = name + "_rad_s";
if any(string(dataTable.Properties.VariableNames) == radName)
    rate = double(dataTable.(radName));
else
    rate = deg2rad(double(dataTable.(name)));
end
end
