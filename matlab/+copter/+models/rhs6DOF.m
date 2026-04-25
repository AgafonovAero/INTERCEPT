function dx = rhs6DOF(~, x, input, model)
% Правая часть модели движения с шестью степенями свободы.

x = double(x(:));
input = max(0, min(1, double(input(:))));

velocity = x(4:6);
angles = x(7:9);
omega = x(10:12);
thrust = x(13:16);

rotationBodyToInertial = copter.models.coordinateSystems(angles, 'body_to_inertial');
totalThrust = sum(thrust);
thrustForce = rotationBodyToInertial * [0; 0; totalThrust];
gravityForce = [0; 0; -model.mass_kg * model.g_m_s2];
dragForce = -model.linear_drag(:) .* velocity;
acceleration = (thrustForce + gravityForce + dragForce) ./ model.mass_kg;

moment = zeros(3, 1);
for motorIndex = 1:4
    bodyForce = [0; 0; thrust(motorIndex)];
    moment = moment + cross(model.motor_positions_m(:, motorIndex), bodyForce);
    yawMoment = model.spin_sign(motorIndex) * model.kQ_over_kT_m * thrust(motorIndex);
    moment = moment + [0; 0; yawMoment];
end

inertia = model.inertia_kg_m2;
angularAcceleration = inertia \ (moment - cross(omega, inertia * omega));
angleRates = eulerRateMatrix(angles) * omega;
commandedThrust = model.kT .* (input .^ 2);
thrustRates = (commandedThrust - thrust) ./ model.tau_motor_s;

dx = zeros(16, 1);
dx(1:3) = velocity;
dx(4:6) = acceleration;
dx(7:9) = angleRates;
dx(10:12) = angularAcceleration;
dx(13:16) = thrustRates;
end

function matrix = eulerRateMatrix(angles)
roll = angles(1);
pitch = angles(2);
cosPitch = cos(pitch);

if abs(cosPitch) < 1e-6
    cosPitch = sign(cosPitch + eps) * 1e-6;
end

matrix = [
    1, sin(roll) * tan(pitch), cos(roll) * tan(pitch)
    0, cos(roll), -sin(roll)
    0, sin(roll) / cosPitch, cos(roll) / cosPitch
    ];
end
