function validationReport = validateRateModelOnSegments(model, processedData, validationSegments, config)
% Проверяет ModelRate на отложенных участках validation.

if nargin < 4 || isempty(config)
    config = copter.config.defaultVehicleConfig();
end

dataTable = localTable(processedData);
metricsRows = {};
warnings = strings(0, 1);

for index = 1:height(validationSegments)
    segment = [validationSegments.t_start_s(index), validationSegments.t_end_s(index)];
    mask = dataTable.t_s >= segment(1) & dataTable.t_s <= segment(2);
    segmentData = dataTable(mask, :);
    if height(segmentData) < 2
        warnings(end + 1, 1) = "Участок validation " + string(validationSegments.segment_id(index)) + " содержит недостаточно строк.";
        continue;
    end

    try
        simulation = copter.validation.simulateSegment(segmentData, model, []);
        reference = readReferenceRates(segmentData);
        calculated = [
            simulation.RATE_R_calc_rad_s, ...
            simulation.RATE_P_calc_rad_s, ...
            simulation.RATE_Y_calc_rad_s
            ];
        metrics = copter.validation.computeMetrics(reference, calculated);
        metricsRows = [metricsRows; makeMetricRows(validationSegments, index, metrics)];
    catch exception
        warnings(end + 1, 1) = "Проверка участка " + string(validationSegments.segment_id(index)) + " не выполнена: " + string(exception.message);
    end
end

validationReport = struct();
validationReport.metricsBySegment = rowsToTable(metricsRows);
validationReport.criteria = acceptanceCriteria(config);
validationReport.channelConclusion = buildConclusion(validationReport.metricsBySegment, validationReport.criteria);
validationReport.warnings = warnings;
end

function reference = readReferenceRates(dataTable)
reference = zeros(height(dataTable), 3);
names = ["RATE.R_rad_s", "RATE.P_rad_s", "RATE.Y_rad_s"];
fallback = ["RATE.R", "RATE.P", "RATE.Y"];

for index = 1:3
    if hasVariable(dataTable, names(index))
        reference(:, index) = double(dataTable.(names(index)));
    else
        reference(:, index) = deg2rad(double(dataTable.(fallback(index))));
    end
end
end

function rows = makeMetricRows(segments, index, metrics)
axes = ["RATE.R"; "RATE.P"; "RATE.Y"];
rows = cell(3, 1);

for axisIndex = 1:3
    row = struct();
    row.segment_id = string(segments.segment_id(index));
    row.log_file = string(segments.log_file(index));
    row.axis = axes(axisIndex);
    row.rmse_rad_s = metrics.rmse(axisIndex);
    row.mae_rad_s = metrics.mae(axisIndex);
    row.max_abs_rad_s = metrics.max_abs(axisIndex);
    row.nrmse = metrics.nrmse(axisIndex);
    row.fit_percent = metrics.fit_percent(axisIndex);
    rows{axisIndex} = row;
end
end

function tableOut = rowsToTable(rows)
if isempty(rows)
    tableOut = table();
else
    tableOut = struct2table([rows{:}]);
end
end

function criteria = acceptanceCriteria(config)
criteria = struct();
criteria.RATE_R_fit_min_percent = config.criteria.rate_roll_pitch_fit_min_percent;
criteria.RATE_P_fit_min_percent = config.criteria.rate_roll_pitch_fit_min_percent;
criteria.RATE_Y_fit_min_percent = config.criteria.rate_yaw_fit_min_percent;
end

function conclusion = buildConclusion(metricsTable, criteria)
axes = ["RATE.R"; "RATE.P"; "RATE.Y"];
limits = [
    criteria.RATE_R_fit_min_percent
    criteria.RATE_P_fit_min_percent
    criteria.RATE_Y_fit_min_percent
    ];
passed = false(3, 1);
meanFit = NaN(3, 1);
text = strings(3, 1);

for index = 1:3
    if isempty(metricsTable)
        text(index) = axes(index) + ": нет участков validation.";
        continue;
    end

    mask = metricsTable.axis == axes(index);
    meanFit(index) = mean(metricsTable.fit_percent(mask), 'omitnan');
    passed(index) = meanFit(index) >= limits(index);
    if passed(index)
        text(index) = axes(index) + ": предварительный критерий выполнен.";
    else
        text(index) = axes(index) + ": предварительный критерий не выполнен.";
    end
end

conclusion = table(axes, limits, meanFit, passed, text, ...
    'VariableNames', {'axis', 'fit_min_percent', 'mean_fit_percent', 'passed', 'conclusion'});
end

function result = hasVariable(dataTable, variableName)
result = any(string(dataTable.Properties.VariableNames) == string(variableName));
end

function dataTable = localTable(dataSet)
if istimetable(dataSet)
    dataTable = timetable2table(dataSet, 'ConvertRowTimes', false);
else
    dataTable = dataSet;
end
end
