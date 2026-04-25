function [motorCommand, saturationFlags, mixerReport] = quadXMixer(collective, uRoll, uPitch, uYaw, config)
% Смешивает команды управления для схемы QUAD/X.

if nargin < 5 || isempty(config)
    config = copter.config.defaultVehicleConfig();
end

rawCommand = [
    collective - 0.5 * uRoll + 0.5 * uPitch + 0.5 * uYaw
    collective - 0.5 * uRoll - 0.5 * uPitch - 0.5 * uYaw
    collective + 0.5 * uRoll - 0.5 * uPitch + 0.5 * uYaw
    collective + 0.5 * uRoll + 0.5 * uPitch - 0.5 * uYaw
    ];

motorCommand = max(0, min(1, rawCommand));
saturationFlags = rawCommand < 0 | rawCommand > 1;
mixerReport = struct();
mixerReport.frame = string(config.geometry.motor_order(:));
mixerReport.note = "Смешивание выполнено для QUAD/X; знаки вращения требуют подтверждения по изделию.";
mixerReport.saturation_count = nnz(saturationFlags);
end
