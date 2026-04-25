function [simData, simReport] = simulateModel6DofOnLogWindow(processedData, replayWindow, modelParameters, vehicleConfig)
% Выполняет расчет Model6DOF на коротком окне бортового журнала.

if nargin < 3 || isempty(modelParameters)
    modelParameters = struct();
end

if nargin < 4 || isempty(vehicleConfig)
    vehicleConfig = copter.config.defaultVehicleConfig();
end

model = buildModel(vehicleConfig, modelParameters);
[x0, stateWarnings] = copter.data.buildInitialStateFromLog( ...
    processedData, replayWindow.t_start_s(1), vehicleConfig);
[motorInputs, inputReport] = copter.data.buildMotorInputsFromLog( ...
    processedData, replayWindow, vehicleConfig);

inputTable = localTable(motorInputs);
if height(inputTable) < 2
    simData = timetable();
    simReport = struct();
    simReport.warnings = [
        stateWarnings
        inputReport.warnings
        "Недостаточно входных данных для расчета Model6DOF."
        ];
    return;
end

timeSeconds = double(inputTable.t_s(:));
u = [
    inputTable.u_motor_1, ...
    inputTable.u_motor_2, ...
    inputTable.u_motor_3, ...
    inputTable.u_motor_4
    ];
x0(13:16) = model.kT .* transpose(u(1, :) .^ 2);

state = zeros(numel(timeSeconds), 16);
state(1, :) = transpose(x0);
for index = 1:(numel(timeSeconds) - 1)
    step = timeSeconds(index + 1) - timeSeconds(index);
    if step <= 0 || ~isfinite(step)
        step = median(diff(timeSeconds), 'omitnan');
    end
    currentState = transpose(state(index, :));
    inputStart = transpose(u(index, :));
    inputEnd = transpose(u(index + 1, :));
    nextState = rk4Step(timeSeconds(index), currentState, step, inputStart, inputEnd, model);
    state(index + 1, :) = transpose(nextState);
end

simTable = buildSimulationTable(timeSeconds, state, u);
simData = table2timetable(simTable, 'RowTimes', seconds(timeSeconds));
simData.Properties.DimensionNames{1} = 'Time';

simReport = struct();
simReport.warnings = unique([stateWarnings; inputReport.warnings], 'stable');
simReport.saturation_percent = inputReport.saturation_percent;
simReport.duration_s = timeSeconds(end) - timeSeconds(1);
simReport.row_count = height(simData);
end

function nextState = rk4Step(timeNow, state, step, inputStart, inputEnd, model)
inputMiddle = 0.5 .* (inputStart + inputEnd);
k1 = copter.models.rhs6DOF(timeNow, state, inputStart, model);
k2 = copter.models.rhs6DOF(timeNow + step / 2, state + step .* k1 ./ 2, inputMiddle, model);
k3 = copter.models.rhs6DOF(timeNow + step / 2, state + step .* k2 ./ 2, inputMiddle, model);
k4 = copter.models.rhs6DOF(timeNow + step, state + step .* k3, inputEnd, model);
nextState = state + step .* (k1 + 2 .* k2 + 2 .* k3 + k4) ./ 6;
end

function model = buildModel(vehicleConfig, modelParameters)
model = copter.models.Model6DOF(vehicleConfig);
if isfield(modelParameters, 'thrust_scale')
    model.kT = model.kT .* double(modelParameters.thrust_scale);
end

if isfield(modelParameters, 'motor_tau_s')
    model.tau_motor_s = double(modelParameters.motor_tau_s);
end

if isfield(modelParameters, 'kQ_over_kT')
    model.kQ_over_kT_m = double(modelParameters.kQ_over_kT);
elseif isfield(modelParameters, 'kQ_over_kT_m')
    model.kQ_over_kT_m = double(modelParameters.kQ_over_kT_m);
end

if isfield(modelParameters, 'linear_drag')
    model.linear_drag = double(modelParameters.linear_drag(:));
elseif all(isfield(modelParameters, {'linear_drag_x', 'linear_drag_y', 'linear_drag_z'}))
    model.linear_drag = [
        double(modelParameters.linear_drag_x)
        double(modelParameters.linear_drag_y)
        double(modelParameters.linear_drag_z)
        ];
end
end

function simTable = buildSimulationTable(timeSeconds, state, u)
simTable = table();
simTable.t_s = timeSeconds;
simTable.x_m = state(:, 1);
simTable.y_m = state(:, 2);
simTable.z_m = state(:, 3);
simTable.altitude_m = state(:, 3);
simTable.vx_mps = state(:, 4);
simTable.vy_mps = state(:, 5);
simTable.vz_mps = state(:, 6);
simTable.vertical_speed_mps = state(:, 6);
simTable.horizontal_speed_mps = hypot(state(:, 4), state(:, 5));
simTable.roll_rad = state(:, 7);
simTable.pitch_rad = state(:, 8);
simTable.yaw_rad = state(:, 9);
simTable.ATT_Roll_calc_rad = state(:, 7);
simTable.ATT_Pitch_calc_rad = state(:, 8);
simTable.ATT_Yaw_calc_rad = state(:, 9);
simTable.ATT_Roll_calc_deg = rad2deg(state(:, 7));
simTable.ATT_Pitch_calc_deg = rad2deg(state(:, 8));
simTable.ATT_Yaw_calc_deg = rad2deg(state(:, 9));
simTable.p_rad_s = state(:, 10);
simTable.q_rad_s = state(:, 11);
simTable.r_rad_s = state(:, 12);
simTable.RATE_R_calc_rad_s = state(:, 10);
simTable.RATE_P_calc_rad_s = state(:, 11);
simTable.RATE_Y_calc_rad_s = state(:, 12);
simTable.RATE_R_calc_deg_s = rad2deg(state(:, 10));
simTable.RATE_P_calc_deg_s = rad2deg(state(:, 11));
simTable.RATE_Y_calc_deg_s = rad2deg(state(:, 12));
for index = 1:4
    simTable.("u_motor_" + string(index)) = u(:, index);
    simTable.("T_motor_" + string(index) + "_N") = state(:, 12 + index);
end
end

function dataTable = localTable(dataSet)
if istimetable(dataSet)
    dataTable = timetable2table(dataSet, 'ConvertRowTimes', false);
else
    dataTable = dataSet;
end
end
