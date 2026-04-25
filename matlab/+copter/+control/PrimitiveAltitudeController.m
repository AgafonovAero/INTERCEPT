function [collectiveThrustN, normalizedCollective] = PrimitiveAltitudeController( ...
    desiredAltitudeM, desiredVerticalSpeedMps, currentAltitudeM, currentVerticalSpeedMps, massKg, gains)
% Примитивный регулятор высоты для демонстрационного полета.

if nargin < 6 || isempty(gains)
    gains = defaultGains();
end

gains = normalizeGains(gains);
altitudeError = double(desiredAltitudeM) - double(currentAltitudeM);
verticalSpeedError = double(desiredVerticalSpeedMps) - double(currentVerticalSpeedMps);
accelerationCommand = gains.kp_altitude * altitudeError + gains.kd_vertical_speed * verticalSpeedError;
accelerationCommand = max(-gains.max_acceleration_m_s2, min(gains.max_acceleration_m_s2, accelerationCommand));

collectiveThrustN = double(massKg) * (gains.g_m_s2 + accelerationCommand);
collectiveThrustN = max(0, collectiveThrustN);
if isfield(gains, 'kT') && isfinite(gains.kT) && gains.kT > 0
    normalizedCollective = sqrt(collectiveThrustN / (4 * gains.kT));
else
    normalizedCollective = collectiveThrustN / (double(massKg) * gains.g_m_s2 / gains.hover_collective);
end

normalizedCollective = max(0, min(1, normalizedCollective));
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
gains.kp_altitude = 0.9;
gains.kd_vertical_speed = 0.8;
gains.max_acceleration_m_s2 = 2.0;
gains.g_m_s2 = 9.80665;
gains.hover_collective = 0.5;
gains.kT = NaN;
end
