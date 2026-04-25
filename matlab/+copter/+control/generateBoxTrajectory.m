function trajectory = generateBoxTrajectory(options)
% Формирует демонстрационную траекторию взлета, прямоугольника и посадки.

if nargin < 1 || isempty(options)
    options = struct();
end

options = normalizeOptions(options);
[time, position, velocity, phase] = buildSamples(options);

trajectory = table();
trajectory.t_s = time(:);
trajectory.x_m = position(:, 1);
trajectory.y_m = position(:, 2);
trajectory.z_m = position(:, 3);
trajectory.vx_mps = velocity(:, 1);
trajectory.vy_mps = velocity(:, 2);
trajectory.vz_mps = velocity(:, 3);
trajectory.yaw_rad = zeros(height(trajectory), 1);
trajectory.phase = phase;
trajectory = table2timetable(trajectory, 'RowTimes', seconds(trajectory.t_s));
trajectory.Properties.DimensionNames{1} = 'Time';
end

function [time, position, velocity, phase] = buildSamples(options)
height = options.height_m;
side = options.side_m;
points = [
    0, 0, 0
    0, 0, height
    0, 0, height
    side, 0, height
    side, side, height
    0, side, height
    0, 0, height
    0, 0, height
    0, 0, 0
    ];
segmentNames = [
    "взлет"
    "висение перед маршрутом"
    "сторона 1"
    "сторона 2"
    "сторона 3"
    "сторона 4"
    "висение после маршрута"
    "посадка"
    ];

time = zeros(0, 1);
position = zeros(0, 3);
velocity = zeros(0, 3);
phase = strings(0, 1);
currentTime = 0;

for index = 1:(size(points, 1) - 1)
    startPoint = points(index, :);
    endPoint = points(index + 1, :);
    delta = endPoint - startPoint;
    distance = norm(delta);
    if distance < eps
        duration = options.hover_duration_s;
    else
        duration = distance / options.speed_mps;
    end

    localTime = transpose(0:options.dt_s:duration);
    if localTime(end) < duration
        localTime(end + 1, 1) = duration;
    end

    alpha = localTime ./ max(duration, options.dt_s);
    localPosition = startPoint + alpha .* delta;
    localVelocity = repmat(delta ./ max(duration, options.dt_s), numel(localTime), 1);
    localPhase = repmat(segmentNames(index), numel(localTime), 1);
    if ~isempty(time)
        localTime = localTime(2:end);
        localPosition = localPosition(2:end, :);
        localVelocity = localVelocity(2:end, :);
        localPhase = localPhase(2:end);
    end

    time = [time; currentTime + localTime];
    position = [position; localPosition];
    velocity = [velocity; localVelocity];
    phase = [phase; localPhase];
    currentTime = time(end);
end
end

function options = normalizeOptions(options)
defaults = struct();
defaults.height_m = 10;
defaults.side_m = 20;
defaults.speed_mps = 2;
defaults.hover_duration_s = 3;
defaults.dt_s = 0.05;
fields = fieldnames(defaults);
for index = 1:numel(fields)
    fieldName = fields{index};
    if ~isfield(options, fieldName)
        options.(fieldName) = defaults.(fieldName);
    end
end
end
