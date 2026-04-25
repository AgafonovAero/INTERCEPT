function [desiredRollRad, desiredPitchRad, desiredYawRad, desiredAltitudeM] = PrimitivePositionController( ...
    desiredPosition, desiredVelocity, currentPosition, currentVelocity, gains)
% Примитивный внешний контур положения для демонстрационного полета.

if nargin < 5 || isempty(gains)
    gains = defaultGains();
end

gains = normalizeGains(gains);
desiredPosition = double(desiredPosition(:));
desiredVelocity = double(desiredVelocity(:));
currentPosition = double(currentPosition(:));
currentVelocity = double(currentVelocity(:));

positionError = desiredPosition - currentPosition;
velocityError = desiredVelocity - currentVelocity;
accelerationCommand = gains.kp_position(:) .* positionError + gains.kd_velocity(:) .* velocityError;
accelerationCommand = max(-gains.max_horizontal_acceleration_m_s2, ...
    min(gains.max_horizontal_acceleration_m_s2, accelerationCommand));

desiredPitchRad = accelerationCommand(1) / gains.g_m_s2;
desiredRollRad = -accelerationCommand(2) / gains.g_m_s2;
limitRad = deg2rad(gains.max_roll_pitch_deg);
desiredRollRad = max(-limitRad, min(limitRad, desiredRollRad));
desiredPitchRad = max(-limitRad, min(limitRad, desiredPitchRad));
desiredYawRad = gains.desired_yaw_rad;
desiredAltitudeM = desiredPosition(3);
end

function gains = normalizeGains(gains)
defaults = defaultGains();
fields = fieldnames(defaults);
for index = 1:numel(fields)
    fieldName = fields{index};
    if ~isfield(gains, fieldName)
        gains.(fieldName) = defaults.(fieldName);
    end
end
end

function gains = defaultGains()
gains = struct();
gains.kp_position = [0.04; 0.04; 0.0];
gains.kd_velocity = [0.15; 0.15; 0.0];
gains.max_horizontal_acceleration_m_s2 = 0.45;
gains.max_roll_pitch_deg = 3;
gains.g_m_s2 = 9.80665;
gains.desired_yaw_rad = 0;
end
