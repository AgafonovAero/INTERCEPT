function result = coordinateSystems(angles, action)
% Возвращает матрицы преобразования координат.

if nargin < 2
    action = 'body_to_inertial';
end

angles = double(angles(:));
roll = angles(1);
pitch = angles(2);
yaw = angles(3);

rotationYaw = [
    cos(yaw), -sin(yaw), 0
    sin(yaw), cos(yaw), 0
    0, 0, 1
    ];

rotationPitch = [
    cos(pitch), 0, sin(pitch)
    0, 1, 0
    -sin(pitch), 0, cos(pitch)
    ];

rotationRoll = [
    1, 0, 0
    0, cos(roll), -sin(roll)
    0, sin(roll), cos(roll)
    ];

rotation = rotationYaw * rotationPitch * rotationRoll;

switch char(action)
    case 'body_to_inertial'
        result = rotation;
    case 'inertial_to_body'
        result = transpose(rotation);
    otherwise
        error('Неизвестное действие преобразования координат.');
end
end
