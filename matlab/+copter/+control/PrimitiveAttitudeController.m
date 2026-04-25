function [uRoll, uPitch, uYaw] = PrimitiveAttitudeController( ...
    desiredAttitudeRad, desiredPqrRadS, currentAttitudeRad, currentPqrRadS, gains)
% Примитивный PD-регулятор углов и угловых скоростей.

if nargin < 5 || isempty(gains)
    gains = defaultGains();
end

gains = normalizeGains(gains);
attitudeError = wrapAngle(double(desiredAttitudeRad(:)) - double(currentAttitudeRad(:)));
rateError = double(desiredPqrRadS(:)) - double(currentPqrRadS(:));
command = gains.kp_angle(:) .* attitudeError + gains.kd_rate(:) .* rateError;
command = max(-gains.command_limit(:), min(gains.command_limit(:), command));

uRoll = command(1);
uPitch = command(2);
uYaw = command(3);
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
gains.kp_angle = [0.7; 0.7; 0.4];
gains.kd_rate = [0.45; 0.45; 0.20];
gains.command_limit = [0.025; 0.025; 0.015];
end

function angle = wrapAngle(angle)
angle = mod(angle + pi, 2 * pi) - pi;
end
