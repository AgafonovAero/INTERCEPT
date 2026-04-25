function [model, fitReport, warnings] = fitRateModelFromSegments(processedData, identificationSegments, config)
% Идентифицирует ModelRate по участкам identification.

if nargin < 3 || isempty(config)
    config = copter.config.defaultVehicleConfig();
end

dataTable = localTable(processedData);
warnings = strings(0, 1);
fitRows = {};
models = {};

if isempty(identificationSegments)
    warnings(end + 1, 1) = "Участки identification отсутствуют; параметры ModelRate не идентифицированы.";
    model = copter.models.ModelRate();
    fitReport = table();
    return;
end

for index = 1:height(identificationSegments)
    segment = [identificationSegments.t_start_s(index), identificationSegments.t_end_s(index)];
    mask = dataTable.t_s >= segment(1) & dataTable.t_s <= segment(2);
    if sum(mask) < 6
        warnings(end + 1, 1) = "Участок " + string(identificationSegments.segment_id(index)) + " содержит недостаточно строк.";
        continue;
    end

    try
        result = copter.identification.fitRateModel(dataTable(mask, :), config, []);
        models{end + 1} = result.model;
        fitRows{end + 1} = makeFitRow(identificationSegments, index, result);
        if result.input_source ~= "RATE.ROut, RATE.POut, RATE.YOut"
            warnings(end + 1, 1) = "Для участка " + string(identificationSegments.segment_id(index)) + " входные воздействия восстановлены по RCOU.C1-C4.";
        end
    catch exception
        warnings(end + 1, 1) = "Идентификация на участке " + string(identificationSegments.segment_id(index)) + " не выполнена: " + string(exception.message);
    end
end

if isempty(models)
    model = copter.models.ModelRate();
    fitReport = table();
    warnings(end + 1, 1) = "Нет успешно идентифицированных участков; используется ModelRate по умолчанию.";
    return;
end

[A, B, c] = averageModels(models);
model = copter.models.ModelRate(A, B, c);
fitReport = struct2table([fitRows{:}]);
fitReport.final_A = repmat({A}, height(fitReport), 1);
fitReport.final_B = repmat({B}, height(fitReport), 1);
fitReport.final_c = repmat({c}, height(fitReport), 1);
end

function row = makeFitRow(segments, index, result)
row = struct();
row.segment_id = string(segments.segment_id(index));
row.log_file = string(segments.log_file(index));
row.t_start_s = segments.t_start_s(index);
row.t_end_s = segments.t_end_s(index);
row.input_source = string(result.input_source);
row.delay_R_samples = result.delay_steps(1);
row.delay_P_samples = result.delay_steps(2);
row.delay_Y_samples = result.delay_steps(3);
row.derivative_rmse_R = result.derivative_rmse(1);
row.derivative_rmse_P = result.derivative_rmse(2);
row.derivative_rmse_Y = result.derivative_rmse(3);
end

function [A, B, c] = averageModels(models)
modelCount = numel(models);
AStack = zeros(3, 3, modelCount);
BStack = zeros(3, 3, modelCount);
cStack = zeros(3, modelCount);

for index = 1:modelCount
    AStack(:, :, index) = models{index}.A;
    BStack(:, :, index) = models{index}.B;
    cStack(:, index) = models{index}.c(:);
end

A = mean(AStack, 3, 'omitnan');
B = mean(BStack, 3, 'omitnan');
c = mean(cStack, 2, 'omitnan');
end

function dataTable = localTable(dataSet)
if istimetable(dataSet)
    dataTable = timetable2table(dataSet, 'ConvertRowTimes', false);
else
    dataTable = dataSet;
end
end
