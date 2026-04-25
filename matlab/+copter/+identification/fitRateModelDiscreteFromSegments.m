function [model, fitReport, warnings] = fitRateModelDiscreteFromSegments(processedData, identificationSegments, settings)
% Идентифицирует диагностическую дискретную модель ModelRateDiscrete.

if nargin < 3 || isempty(settings)
    settings = defaultSettings();
end

settings = normalizeSettings(settings);
dataTable = localTable(processedData);
warnings = strings(0, 1);

if isempty(identificationSegments)
    model = copter.models.ModelRateDiscrete();
    fitReport = table();
    warnings(end + 1, 1) = "Участки identification отсутствуют; дискретная модель не идентифицирована.";
    return;
end

best = struct();
best.rmse = Inf;
best.delay = 0;
best.theta = [];
best.condition_number = Inf;
best.used_ridge = false;

delayCandidates = double(settings.input_delay_search_samples(:));
for delayIndex = 1:numel(delayCandidates)
    delay = delayCandidates(delayIndex);
    [designMatrix, targetMatrix] = buildRegression(dataTable, identificationSegments, delay);
    if heightFromMatrix(designMatrix) < 8
        continue;
    end

    [theta, conditionNumber, usedRidge] = solveRegression(designMatrix, targetMatrix, settings);
    residual = targetMatrix - designMatrix * theta;
    rmse = sqrt(mean(residual(:) .^ 2, 'omitnan'));
    if rmse < best.rmse
        best.rmse = rmse;
        best.delay = delay;
        best.theta = theta;
        best.condition_number = conditionNumber;
        best.used_ridge = usedRidge;
    end
end

if isempty(best.theta)
    model = copter.models.ModelRateDiscrete();
    fitReport = table();
    warnings(end + 1, 1) = "Недостаточно данных для дискретной идентификации ModelRateDiscrete.";
    return;
end

Ad = transpose(best.theta(1:3, :));
Bd = transpose(best.theta(4:6, :));
cd = transpose(best.theta(7, :));
model = copter.models.ModelRateDiscrete(Ad, Bd, cd, best.delay, estimateSampleTime(dataTable));

if best.used_ridge
    warnings(end + 1, 1) = "Для дискретной идентификации применена ridge-регуляризация.";
end

fitReport = table( ...
    best.delay, ...
    best.rmse, ...
    best.condition_number, ...
    best.used_ridge, ...
    {Ad}, ...
    {Bd}, ...
    {cd}, ...
    'VariableNames', { ...
    'selected_delay_samples', ...
    'rmse_rad_s', ...
    'condition_number', ...
    'used_ridge', ...
    'Ad', ...
    'Bd', ...
    'cd'});
end

function [designMatrix, targetMatrix] = buildRegression(dataTable, segments, delay)
designMatrix = zeros(0, 7);
targetMatrix = zeros(0, 3);

for segmentIndex = 1:height(segments)
    segmentData = selectSegment(dataTable, segments(segmentIndex, :));
    if height(segmentData) < 3
        continue;
    end

    omega = readRates(segmentData);
    input = readInputs(segmentData);
    for index = 1:(height(segmentData) - 1)
        inputIndex = index - delay;
        if inputIndex < 1 || inputIndex > height(segmentData)
            continue;
        end

        row = [omega(index, :), input(inputIndex, :), 1];
        target = omega(index + 1, :);
        if all(isfinite(row)) && all(isfinite(target))
            designMatrix(end + 1, :) = row;
            targetMatrix(end + 1, :) = target;
        end
    end
end
end

function [theta, conditionNumber, usedRidge] = solveRegression(designMatrix, targetMatrix, settings)
conditionNumber = cond(designMatrix);
usedRidge = conditionNumber > settings.max_condition_number;
if usedRidge
    lambda = settings.ridge_lambda;
    designTranspose = transpose(designMatrix);
    theta = (designTranspose * designMatrix + lambda * eye(size(designMatrix, 2))) ...
        \ (designTranspose * targetMatrix);
else
    theta = designMatrix \ targetMatrix;
end
end

function segmentData = selectSegment(dataTable, segment)
mask = dataTable.t_s >= segment.t_start_s & dataTable.t_s <= segment.t_end_s;
if hasVariable(dataTable, "log_file") && hasVariable(segment, "log_file")
    if strlength(string(segment.log_file)) > 0
        mask = mask & string(dataTable.log_file) == string(segment.log_file);
    end
end

segmentData = dataTable(mask, :);
end

function omega = readRates(dataTable)
names = ["RATE.R_rad_s", "RATE.P_rad_s", "RATE.Y_rad_s"];
fallbackNames = ["RATE.R", "RATE.P", "RATE.Y"];
omega = zeros(height(dataTable), 3);
for index = 1:3
    if hasVariable(dataTable, names(index))
        omega(:, index) = double(dataTable.(names(index)));
    else
        omega(:, index) = deg2rad(double(dataTable.(fallbackNames(index))));
    end
end
end

function input = readInputs(dataTable)
names = ["RATE.ROut", "RATE.POut", "RATE.YOut"];
input = zeros(height(dataTable), 3);
if all(hasVariables(dataTable, names))
    for index = 1:3
        input(:, index) = double(dataTable.(names(index)));
    end
    return;
end

motors = ["u_motor_1", "u_motor_2", "u_motor_3", "u_motor_4"];
if ~all(hasVariables(dataTable, motors))
    error('Не найдены RATE.*Out или u_motor_1...u_motor_4.');
end

c1 = double(dataTable.(motors(1)));
c2 = double(dataTable.(motors(2)));
c3 = double(dataTable.(motors(3)));
c4 = double(dataTable.(motors(4)));
input(:, 1) = 0.5 * (c2 + c3 - c1 - c4);
input(:, 2) = 0.5 * (c3 + c4 - c1 - c2);
input(:, 3) = 0.5 * (c1 + c3 - c2 - c4);
end

function sampleTime = estimateSampleTime(dataTable)
dt = diff(double(dataTable.t_s(:)));
sampleTime = median(dt(dt > 0), 'omitnan');
end

function count = heightFromMatrix(matrix)
count = size(matrix, 1);
end

function settings = normalizeSettings(settings)
defaults = defaultSettings();
fields = fieldnames(defaults);
for index = 1:numel(fields)
    fieldName = fields{index};
    if ~isfield(settings, fieldName)
        settings.(fieldName) = defaults.(fieldName);
    end
end
end

function settings = defaultSettings()
settings = struct();
settings.input_delay_search_samples = -10:10;
settings.max_condition_number = 1.0e8;
settings.ridge_lambda = 1.0e-6;
end

function dataTable = localTable(dataSet)
if istimetable(dataSet)
    dataTable = timetable2table(dataSet, 'ConvertRowTimes', false);
else
    dataTable = dataSet;
end
end

function result = hasVariables(dataTable, names)
result = false(size(names));
for index = 1:numel(names)
    result(index) = hasVariable(dataTable, names(index));
end
end

function result = hasVariable(dataTable, variableName)
result = any(string(dataTable.Properties.VariableNames) == string(variableName));
end
