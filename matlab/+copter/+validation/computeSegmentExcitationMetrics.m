function metrics = computeSegmentExcitationMetrics(segmentRegistry, processedData)
% Считает информативность участков для идентификации ModelRate.

if isempty(segmentRegistry)
    metrics = emptyMetrics();
    return;
end

dataTable = localTable(processedData);
metrics = emptyMetrics();

for index = 1:height(segmentRegistry)
    segmentData = selectSegment(dataTable, segmentRegistry(index, :));
    row = table( ...
        string(segmentRegistry.segment_id(index)), ...
        stdRate(segmentData, "R"), ...
        stdRate(segmentData, "P"), ...
        stdRate(segmentData, "Y"), ...
        stdInput(segmentData, "RATE.ROut"), ...
        stdInput(segmentData, "RATE.POut"), ...
        stdInput(segmentData, "RATE.YOut"), ...
        signalEnergy(readInput(segmentData, "RATE.ROut")), ...
        signalEnergy(readInput(segmentData, "RATE.POut")), ...
        signalEnergy(readInput(segmentData, "RATE.YOut")), ...
        signalEnergy(readRateDeg(segmentData, "R")), ...
        signalEnergy(readRateDeg(segmentData, "P")), ...
        signalEnergy(readRateDeg(segmentData, "Y")), ...
        conditionEstimate(segmentData), ...
        nanPercent(segmentData), ...
        saturationPercent(segmentData), ...
        'VariableNames', emptyMetrics().Properties.VariableNames);
    metrics = [metrics; row];
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

function value = stdRate(dataTable, axisName)
value = std(readRateDeg(dataTable, axisName), 0, 'omitnan');
end

function values = readRateDeg(dataTable, axisName)
degreeName = "RATE." + axisName;
radName = degreeName + "_rad_s";
if hasVariable(dataTable, degreeName)
    values = double(dataTable.(degreeName));
elseif hasVariable(dataTable, radName)
    values = rad2deg(double(dataTable.(radName)));
else
    values = NaN(height(dataTable), 1);
end
end

function value = stdInput(dataTable, variableName)
value = std(readInput(dataTable, variableName), 0, 'omitnan');
end

function values = readInput(dataTable, variableName)
if hasVariable(dataTable, variableName)
    values = double(dataTable.(variableName));
    return;
end

if variableName == "RATE.ROut"
    values = reconstructedAxis(dataTable, 1);
elseif variableName == "RATE.POut"
    values = reconstructedAxis(dataTable, 2);
elseif variableName == "RATE.YOut"
    values = reconstructedAxis(dataTable, 3);
else
    values = NaN(height(dataTable), 1);
end
end

function axisValue = reconstructedAxis(dataTable, axisIndex)
motors = NaN(height(dataTable), 4);
for index = 1:4
    name = "u_motor_" + string(index);
    if hasVariable(dataTable, name)
        motors(:, index) = double(dataTable.(name));
    end
end

c1 = motors(:, 1);
c2 = motors(:, 2);
c3 = motors(:, 3);
c4 = motors(:, 4);
if axisIndex == 1
    axisValue = 0.5 * (c2 + c3 - c1 - c4);
elseif axisIndex == 2
    axisValue = 0.5 * (c3 + c4 - c1 - c2);
else
    axisValue = 0.5 * (c1 + c3 - c2 - c4);
end
end

function value = signalEnergy(values)
value = mean(double(values) .^ 2, 'omitnan');
end

function value = conditionEstimate(dataTable)
omega = [
    deg2rad(readRateDeg(dataTable, "R")), ...
    deg2rad(readRateDeg(dataTable, "P")), ...
    deg2rad(readRateDeg(dataTable, "Y"))
    ];
input = [
    readInput(dataTable, "RATE.ROut"), ...
    readInput(dataTable, "RATE.POut"), ...
    readInput(dataTable, "RATE.YOut")
    ];
designMatrix = [omega, input, ones(height(dataTable), 1)];
validMask = all(isfinite(designMatrix), 2);
if nnz(validMask) < 8
    value = Inf;
else
    value = cond(designMatrix(validMask, :));
end
end

function value = nanPercent(dataTable)
if isempty(dataTable)
    value = 100;
else
    keyMatrix = buildKeyMatrix(dataTable);
    if isempty(keyMatrix)
        value = 100;
    else
        value = 100 * mean(any(~isfinite(keyMatrix), 2), 'omitnan');
    end
end
end

function keyMatrix = buildKeyMatrix(dataTable)
keyMatrix = zeros(height(dataTable), 0);
rateAxes = ["R", "P", "Y"];
for index = 1:numel(rateAxes)
    keyMatrix(:, end + 1) = readRateDeg(dataTable, rateAxes(index));
end

inputNames = ["RATE.ROut", "RATE.POut", "RATE.YOut"];
if all(hasVariables(dataTable, inputNames))
    for index = 1:numel(inputNames)
        keyMatrix(:, end + 1) = readInput(dataTable, inputNames(index));
    end
else
    motorNames = ["u_motor_1", "u_motor_2", "u_motor_3", "u_motor_4"];
    for index = 1:numel(motorNames)
        if hasVariable(dataTable, motorNames(index))
            keyMatrix(:, end + 1) = double(dataTable.(motorNames(index)));
        end
    end
end
end

function value = saturationPercent(dataTable)
if hasVariable(dataTable, "motor_saturation_flag")
    value = 100 * mean(double(dataTable.motor_saturation_flag), 'omitnan');
    return;
end

motors = ["u_motor_1", "u_motor_2", "u_motor_3", "u_motor_4"];
mask = false(height(dataTable), numel(motors));
for index = 1:numel(motors)
    if hasVariable(dataTable, motors(index))
        values = double(dataTable.(motors(index)));
        mask(:, index) = values <= 0 | values >= 1;
    end
end

value = 100 * mean(any(mask, 2), 'omitnan');
end

function dataTable = localTable(dataSet)
if istimetable(dataSet)
    dataTable = timetable2table(dataSet, 'ConvertRowTimes', false);
else
    dataTable = dataSet;
end
end

function result = hasVariable(dataTable, variableName)
result = any(string(dataTable.Properties.VariableNames) == string(variableName));
end

function result = hasVariables(dataTable, variableNames)
result = false(size(variableNames));
for index = 1:numel(variableNames)
    result(index) = hasVariable(dataTable, variableNames(index));
end
end

function metrics = emptyMetrics()
metrics = table( ...
    strings(0, 1), ...
    NaN(0, 1), ...
    NaN(0, 1), ...
    NaN(0, 1), ...
    NaN(0, 1), ...
    NaN(0, 1), ...
    NaN(0, 1), ...
    NaN(0, 1), ...
    NaN(0, 1), ...
    NaN(0, 1), ...
    NaN(0, 1), ...
    NaN(0, 1), ...
    NaN(0, 1), ...
    Inf(0, 1), ...
    NaN(0, 1), ...
    NaN(0, 1), ...
    'VariableNames', { ...
    'segment_id', ...
    'std_RATE_R_deg_s', ...
    'std_RATE_P_deg_s', ...
    'std_RATE_Y_deg_s', ...
    'std_ROut', ...
    'std_POut', ...
    'std_YOut', ...
    'input_energy_roll', ...
    'input_energy_pitch', ...
    'input_energy_yaw', ...
    'rate_energy_roll', ...
    'rate_energy_pitch', ...
    'rate_energy_yaw', ...
    'condition_estimate', ...
    'nan_percent', ...
    'saturation_percent'});
end
