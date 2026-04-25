function result = evaluateMotorMapCandidate(processedData, windows, candidate, vehicleConfig, settings)
% Оценивает кандидатный мотор-маппинг по реакции RATE/ATT на команды RCOU.

if nargin < 4 || isempty(vehicleConfig)
    vehicleConfig = copter.config.defaultVehicleConfig();
end

if nargin < 5
    settings = struct();
end

dataTable = localTable(processedData);
candidateId = string(candidate.candidate_id(1));
[mappedData, mapReport] = copter.models.applyMotorMap(dataTable, candidate, vehicleConfig);
spinSign = readCellVector(candidate.spin_sign(1));
[positions, ~] = copter.models.transformMotorPositions(vehicleConfig, vehicleConfig.geometry.cad_to_body_matrix);
allocation = copter.models.buildQuadXAllocationMatrix(positions, spinSign, vehicleConfig.model6dof.kQ_over_kT_m);
mask = windowMask(mappedData, windows);

if ~any(mask)
    result = makeResult(candidateId, 0, NaN, Inf, "Нет данных в identification-окнах.", mapReport.warnings);
    return;
end

u = [
    mappedData.u_motor_1(mask), ...
    mappedData.u_motor_2(mask), ...
    mappedData.u_motor_3(mask), ...
    mappedData.u_motor_4(mask)
    ];
uCentered = u .^ 2 - mean(u .^ 2, 2, 'omitnan');
moments = transpose(allocation(2:4, :) * transpose(uCentered));
[target, targetWarnings] = readTargets(mappedData(mask, :));
warnings = [string(mapReport.warnings(:)); targetWarnings];

if isempty(target)
    result = makeResult(candidateId, 0, NaN, Inf, "Нет RATE-каналов для оценки кандидата.", warnings);
    return;
end

correlations = channelCorrelations(moments(:, 1:size(target, 2)), target);
meanCorrelation = mean(abs(correlations), 'omitnan');
rmseLike = mean((normalizeColumns(moments(:, 1:size(target, 2))) - normalizeColumns(target)) .^ 2, 'all', 'omitnan');
score = max(0, min(1, 0.75 * meanCorrelation + 0.25 / (1 + rmseLike)));
reason = "Оценка по корреляции расчетных моментов от RCOU с зарегистрированными RATE.";
result = makeResult(candidateId, score, meanCorrelation, rmseLike, reason, warnings);
end

function result = makeResult(candidateId, score, correlation, rmseLike, reasons, warnings)
result = struct();
result.candidate_id = string(candidateId);
result.score = double(score);
result.mean_correlation = double(correlation);
result.rmse_like = double(rmseLike);
result.reasons = string(reasons);
result.warnings = join(unique(string(warnings(:)), 'stable'), "; ");
end

function dataTable = localTable(data)
if istimetable(data)
    dataTable = timetable2table(data, 'ConvertRowTimes', false);
else
    dataTable = data;
end
end

function vector = readCellVector(value)
if iscell(value)
    vector = double(value{1}(:));
else
    vector = double(value(:));
end
end

function mask = windowMask(dataTable, windows)
if isempty(windows) || ~any(string(dataTable.Properties.VariableNames) == "t_s")
    mask = true(height(dataTable), 1);
    return;
end

mask = false(height(dataTable), 1);
for index = 1:height(windows)
    startTime = double(windows.t_start_s(index));
    endTime = double(windows.t_end_s(index));
    mask = mask | (dataTable.t_s >= startTime & dataTable.t_s <= endTime);
end
end

function [target, warnings] = readTargets(dataTable)
warnings = strings(0, 1);
target = [];
for index = 1:3
    radName = pickVariable(dataTable, rateNameCandidates(index, true));
    degName = pickVariable(dataTable, rateNameCandidates(index, false));
    if strlength(radName) > 0
        target(:, index) = double(dataTable.(radName));
    elseif strlength(degName) > 0
        target(:, index) = deg2rad(double(dataTable.(degName)));
        warnings(end + 1, 1) = "Канал " + degName + " принят как град/с и приведен к рад/с.";
    else
        warnings(end + 1, 1) = "Отсутствует канал RATE для оси " + string(index) + ".";
    end
end
end

function candidates = rateNameCandidates(axisIndex, isRadians)
axes = ["R", "P", "Y"];
axisName = axes(axisIndex);
if isRadians
    candidates = [
        "RATE." + axisName + "_rad_s"
        "RATE_" + axisName + "_rad_s"
        ];
else
    candidates = [
        "RATE." + axisName
        "RATE_" + axisName
        ];
end
end

function variableName = pickVariable(dataTable, candidates)
variableName = "";
names = string(dataTable.Properties.VariableNames);
for index = 1:numel(candidates)
    mask = names == candidates(index);
    if any(mask)
        variableName = names(find(mask, 1, 'first'));
        return;
    end
end
end

function correlations = channelCorrelations(modelInput, target)
correlations = NaN(1, size(target, 2));
for index = 1:size(target, 2)
    x = modelInput(:, index);
    y = target(:, index);
    valid = isfinite(x) & isfinite(y);
    if nnz(valid) < 3 || std(x(valid)) == 0 || std(y(valid)) == 0
        continue;
    end
    matrix = corrcoef(x(valid), y(valid));
    correlations(index) = matrix(1, 2);
end
end

function output = normalizeColumns(input)
output = input;
for index = 1:size(input, 2)
    value = input(:, index);
    value = value - mean(value, 'omitnan');
    scale = std(value, 'omitnan');
    if scale > 0
        output(:, index) = value ./ scale;
    else
        output(:, index) = value;
    end
end
end
