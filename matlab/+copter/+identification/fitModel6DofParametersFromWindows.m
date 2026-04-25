function [fittedParams, fitDiagnostics, warnings] = fitModel6DofParametersFromWindows(processedData, identificationWindows, vehicleConfig, fitSettings)
% Выполняет первичный подбор параметров Model6DOF по identification-окнам.

if nargin < 3 || isempty(vehicleConfig)
    vehicleConfig = copter.config.defaultVehicleConfig();
end

if nargin < 4 || isempty(fitSettings)
    fitSettings = defaultSettings();
end

warnings = strings(0, 1);
[hoverEstimate, hoverWarnings] = copter.identification.estimateHoverThrustScale( ...
    processedData, identificationWindows, vehicleConfig);
[lagEstimate, lagWarnings] = copter.identification.estimateMotorLagFromLog( ...
    processedData, identificationWindows, vehicleConfig);
[dragEstimate, dragWarnings] = copter.identification.estimateSimpleDragFromLog( ...
    processedData, identificationWindows, vehicleConfig);
warnings = [warnings; hoverWarnings; lagWarnings; dragWarnings];

initialVector = [
    hoverEstimate.thrust_scale
    lagEstimate.motor_tau_s
    vehicleConfig.model6dof.kQ_over_kT_m
    dragEstimate.linear_drag(:)
    ];

bounds = readBounds(fitSettings);
initialVector = min(bounds.upper, max(bounds.lower, initialVector));

if isempty(identificationWindows) || fitSettings.max_iterations <= 0
    fittedVector = initialVector;
    method = "initial_estimate";
else
    [fittedVector, method, optimizeWarnings] = optimizeParameters( ...
        initialVector, bounds, processedData, identificationWindows, vehicleConfig, fitSettings);
    warnings = [warnings; optimizeWarnings];
end

fittedParams = vectorToParams(fittedVector);
fitDiagnostics = struct();
fitDiagnostics.method = method;
fitDiagnostics.initial_parameters = vectorToParams(initialVector);
fitDiagnostics.hover_thrust_scale = hoverEstimate;
fitDiagnostics.motor_lag = lagEstimate;
fitDiagnostics.drag = dragEstimate;
fitDiagnostics.warnings = unique(warnings, 'stable');
end

function [fittedVector, method, warnings] = optimizeParameters(initialVector, bounds, processedData, windows, vehicleConfig, fitSettings)
warnings = strings(0, 1);
maxIterations = min(double(fitSettings.max_iterations), 40);
objective = @(vector) objectiveValue(vector, bounds, processedData, windows, vehicleConfig);

if exist('lsqnonlin', 'file') == 2
    options = optimoptions('lsqnonlin', 'Display', 'off', 'MaxIterations', maxIterations);
    residual = @(vector) objectiveResidual(vector, bounds, processedData, windows, vehicleConfig);
    try
        fittedVector = lsqnonlin(residual, initialVector, bounds.lower, bounds.upper, options);
        method = "lsqnonlin";
        return;
    catch exception
        warnings(end + 1, 1) = "lsqnonlin не выполнен: " + string(exception.message);
    end
end

options = optimset('Display', 'off', 'MaxIter', maxIterations);
wrappedObjective = @(rawVector) objective(projectBounds(rawVector, bounds));
try
    fittedVector = fminsearch(wrappedObjective, initialVector, options);
    fittedVector = projectBounds(fittedVector, bounds);
    method = "fminsearch";
catch exception
    warnings(end + 1, 1) = "fminsearch не выполнен: " + string(exception.message);
    fittedVector = initialVector;
    method = "initial_estimate";
end
end

function value = objectiveValue(vector, bounds, processedData, windows, vehicleConfig)
residual = objectiveResidual(vector, bounds, processedData, windows, vehicleConfig);
value = mean(residual .^ 2, 'omitnan');
if ~isfinite(value)
    value = 1e9;
end
end

function residual = objectiveResidual(vector, bounds, processedData, windows, vehicleConfig)
vector = projectBounds(vector, bounds);
params = vectorToParams(vector);
residual = zeros(0, 1);
windowCount = min(height(windows), 3);
for index = 1:windowCount
    try
        [simData, ~] = copter.validation.simulateModel6DofOnLogWindow( ...
            processedData, windows(index, :), params, vehicleConfig);
        [metrics, ~] = copter.validation.compareModel6DofToLog(simData, processedData, windows(index, :));
        if ~isempty(metrics)
            residual = [residual; metrics.rmse(:)];
        end
    catch
        residual = [residual; 100];
    end
end

if isempty(residual)
    residual = 100;
end
residual(~isfinite(residual)) = 100;
end

function vector = projectBounds(vector, bounds)
vector = min(bounds.upper, max(bounds.lower, vector(:)));
end

function bounds = readBounds(settings)
if isfield(settings, 'parameter_bounds')
    raw = settings.parameter_bounds;
    bounds.lower = [
        raw.thrust_scale(1)
        raw.motor_tau_s(1)
        raw.kQ_over_kT(1)
        raw.linear_drag_x(1)
        raw.linear_drag_y(1)
        raw.linear_drag_z(1)
        ];
    bounds.upper = [
        raw.thrust_scale(2)
        raw.motor_tau_s(2)
        raw.kQ_over_kT(2)
        raw.linear_drag_x(2)
        raw.linear_drag_y(2)
        raw.linear_drag_z(2)
        ];
else
    bounds.lower = [0.25; 0.02; 0.001; 0; 0; 0];
    bounds.upper = [3.0; 0.5; 0.2; 5; 5; 5];
end
end

function params = vectorToParams(vector)
params = struct();
params.thrust_scale = double(vector(1));
params.motor_tau_s = double(vector(2));
params.kQ_over_kT = double(vector(3));
params.linear_drag_x = double(vector(4));
params.linear_drag_y = double(vector(5));
params.linear_drag_z = double(vector(6));
params.linear_drag = double(vector(4:6));
end

function settings = defaultSettings()
settings = struct();
settings.max_iterations = 30;
settings.parameter_bounds = struct();
settings.parameter_bounds.thrust_scale = [0.25, 3.0];
settings.parameter_bounds.motor_tau_s = [0.02, 0.5];
settings.parameter_bounds.kQ_over_kT = [0.001, 0.2];
settings.parameter_bounds.linear_drag_x = [0, 5];
settings.parameter_bounds.linear_drag_y = [0, 5];
settings.parameter_bounds.linear_drag_z = [0, 5];
end
