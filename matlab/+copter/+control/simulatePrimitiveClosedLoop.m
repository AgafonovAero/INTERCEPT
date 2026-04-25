function simulation = simulatePrimitiveClosedLoop(trajectory, config, options)
% Выполняет демонстрационный расчет Model6DOF с примитивным регулятором.

if nargin < 2 || isempty(config)
    config = copter.config.defaultVehicleConfig();
end

if nargin < 3 || isempty(options)
    options = struct();
end

options = normalizeOptions(options);
model = copter.models.Model6DOF(config);
dataTable = localTable(trajectory);
time = double(dataTable.t_s(:));
state = initialState(model, dataTable);
stateHistory = zeros(numel(time), numel(state));
commandHistory = zeros(numel(time), 4);
saturationHistory = false(numel(time), 4);

for index = 1:numel(time)
    stateHistory(index, :) = transpose(state);
    [motorCommand, saturationFlags] = controllerStep(state, dataTable(index, :), model, config, options);
    commandHistory(index, :) = transpose(motorCommand);
    saturationHistory(index, :) = transpose(saturationFlags);

    if index == numel(time)
        break;
    end

    step = time(index + 1) - time(index);
    state = rk4Step(state, motorCommand, model, step);
end

simulation = buildOutputTable(time, stateHistory, commandHistory, saturationHistory, dataTable);
simulation = table2timetable(simulation, 'RowTimes', seconds(simulation.t_s));
simulation.Properties.DimensionNames{1} = 'Time';
end

function [motorCommand, saturationFlags] = controllerStep(state, desiredRow, model, config, options)
position = state(1:3);
velocity = state(4:6);
attitude = state(7:9);
pqr = state(10:12);
desiredPosition = [
    desiredRow.x_m
    desiredRow.y_m
    desiredRow.z_m
    ];
desiredVelocity = [
    desiredRow.vx_mps
    desiredRow.vy_mps
    desiredRow.vz_mps
    ];

[rollCmd, pitchCmd, yawCmd, altitudeCmd] = copter.control.PrimitivePositionController( ...
    desiredPosition, desiredVelocity, position, velocity, options.position_gains);
altitudeGains = options.altitude_gains;
altitudeGains.kT = model.kT;
[~, collective] = copter.control.PrimitiveAltitudeController( ...
    altitudeCmd, desiredVelocity(3), position(3), velocity(3), model.mass_kg, altitudeGains);
[uRoll, uPitch, uYaw] = copter.control.PrimitiveAttitudeController( ...
    [rollCmd; pitchCmd; yawCmd], zeros(3, 1), attitude, pqr, options.attitude_gains);
[motorCommand, saturationFlags] = copter.control.quadXMixer(collective, uRoll, uPitch, uYaw, config);
end

function nextState = rk4Step(state, input, model, step)
k1 = copter.models.rhs6DOF(0, state, input, model);
k2 = copter.models.rhs6DOF(step / 2, state + step * k1 / 2, input, model);
k3 = copter.models.rhs6DOF(step / 2, state + step * k2 / 2, input, model);
k4 = copter.models.rhs6DOF(step, state + step * k3, input, model);
nextState = state + step * (k1 + 2 * k2 + 2 * k3 + k4) / 6;
nextState(7:9) = wrapAngles(nextState(7:9));
end

function state = initialState(model, dataTable)
state = zeros(16, 1);
state(1:3) = [dataTable.x_m(1); dataTable.y_m(1); dataTable.z_m(1)];
hoverThrust = model.mass_kg * model.g_m_s2 / 4;
state(13:16) = hoverThrust;
end

function tableOut = buildOutputTable(time, stateHistory, commandHistory, saturationHistory, desiredTable)
tableOut = table();
tableOut.t_s = time;
tableOut.x_m = stateHistory(:, 1);
tableOut.y_m = stateHistory(:, 2);
tableOut.z_m = stateHistory(:, 3);
tableOut.vx_mps = stateHistory(:, 4);
tableOut.vy_mps = stateHistory(:, 5);
tableOut.vz_mps = stateHistory(:, 6);
tableOut.roll_rad = stateHistory(:, 7);
tableOut.pitch_rad = stateHistory(:, 8);
tableOut.yaw_rad = stateHistory(:, 9);
tableOut.p_rad_s = stateHistory(:, 10);
tableOut.q_rad_s = stateHistory(:, 11);
tableOut.r_rad_s = stateHistory(:, 12);
tableOut.thrust_1_N = stateHistory(:, 13);
tableOut.thrust_2_N = stateHistory(:, 14);
tableOut.thrust_3_N = stateHistory(:, 15);
tableOut.thrust_4_N = stateHistory(:, 16);
tableOut.u_motor_1 = commandHistory(:, 1);
tableOut.u_motor_2 = commandHistory(:, 2);
tableOut.u_motor_3 = commandHistory(:, 3);
tableOut.u_motor_4 = commandHistory(:, 4);
tableOut.motor_saturation_flag = any(saturationHistory, 2);
tableOut.desired_x_m = desiredTable.x_m;
tableOut.desired_y_m = desiredTable.y_m;
tableOut.desired_z_m = desiredTable.z_m;
end

function angles = wrapAngles(angles)
angles = mod(angles + pi, 2 * pi) - pi;
end

function dataTable = localTable(trajectory)
if istimetable(trajectory)
    dataTable = timetable2table(trajectory, 'ConvertRowTimes', false);
else
    dataTable = trajectory;
end
end

function options = normalizeOptions(options)
if ~isfield(options, 'position_gains')
    options.position_gains = struct();
end

if ~isfield(options, 'altitude_gains')
    options.altitude_gains = struct();
end

if ~isfield(options, 'attitude_gains')
    options.attitude_gains = struct();
end
end
