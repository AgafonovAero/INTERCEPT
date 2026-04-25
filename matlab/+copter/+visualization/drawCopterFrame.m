function handles = drawCopterFrame(axesHandle, position, attitude, geometry)
% Рисует простую 3D-раму квадрокоптера.

if nargin < 1 || isempty(axesHandle)
    figureHandle = figure('Visible', 'off');
    axesHandle = axes(figureHandle);
end

if nargin < 2 || isempty(position)
    position = zeros(3, 1);
end

if nargin < 3 || isempty(attitude)
    attitude = zeros(3, 1);
end

if nargin < 4 || isempty(geometry)
    geometry = struct();
end

geometry = normalizeGeometry(geometry);
rotation = copter.models.coordinateSystems(attitude, 'body_to_inertial');
motorBody = geometry.arm_length_m .* [
    -1, 1, 1, -1
    -1, -1, 1, 1
    0, 0, 0, 0
    ] ./ sqrt(2);
motorWorld = rotation * motorBody + position(:);
center = position(:);
handles = gobjects(0, 1);
hold(axesHandle, 'on');

for index = 1:4
    handles(end + 1, 1) = plot3(axesHandle, ...
        [center(1), motorWorld(1, index)], ...
        [center(2), motorWorld(2, index)], ...
        [center(3), motorWorld(3, index)], 'k-', 'LineWidth', 2);
    handles(end + 1, 1) = drawRotor(axesHandle, motorWorld(:, index), rotation, geometry.rotor_radius_m);
    text(axesHandle, motorWorld(1, index), motorWorld(2, index), motorWorld(3, index), ...
        "M" + string(index), 'FontSize', 8);
end

nose = rotation * [geometry.arm_length_m; 0; 0] + center;
handles(end + 1, 1) = plot3(axesHandle, [center(1), nose(1)], [center(2), nose(2)], ...
    [center(3), nose(3)], 'r-', 'LineWidth', 2.5);
handles(end + 1, 1) = scatter3(axesHandle, center(1), center(2), center(3), 50, 'filled');
end

function handle = drawRotor(axesHandle, center, rotation, radius)
angle = linspace(0, 2 * pi, 32);
circleBody = radius .* [cos(angle); sin(angle); zeros(size(angle))];
circleWorld = rotation * circleBody + center(:);
handle = plot3(axesHandle, circleWorld(1, :), circleWorld(2, :), circleWorld(3, :), ...
    'b-', 'LineWidth', 1.2);
end

function geometry = normalizeGeometry(geometry)
if ~isfield(geometry, 'arm_length_m')
    geometry.arm_length_m = 0.35;
end

if ~isfield(geometry, 'rotor_radius_m')
    geometry.rotor_radius_m = 0.08;
end
end
