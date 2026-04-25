function report = validateMotorGeometry(vehicleConfig)
% Проверяет геометрию моторов QUAD/X по исходным CAD-координатам.

if nargin < 1 || isempty(vehicleConfig)
    vehicleConfig = copter.config.defaultVehicleConfig();
end

[positions, positionReport] = copter.models.transformMotorPositions( ...
    vehicleConfig, vehicleConfig.geometry.cad_to_body_matrix);
armLengths = sqrt(sum(positions(1:2, :) .^ 2, 1));
meanArm = mean(armLengths, 'omitnan');
spreadPercent = 100 * (max(armLengths) - min(armLengths)) / max(meanArm, eps);
warnings = string(positionReport.warnings(:));

if spreadPercent > 5
    warnings(end + 1, 1) = "Плечи моторов отличаются более чем на 5 процентов.";
end

if abs(mean(positions(1, :), 'omitnan')) > 0.02 || abs(mean(positions(2, :), 'omitnan')) > 0.02
    warnings(end + 1, 1) = "Геометрический центр моторов смещен относительно связанной системы координат.";
end

report = struct();
report.motor_positions_body_m = positions;
report.arm_lengths_m = transpose(armLengths(:));
report.mean_arm_m = meanArm;
report.arm_spread_percent = spreadPercent;
report.is_quad_x_like = spreadPercent <= 10 && size(positions, 2) == 4;
report.warnings = unique(warnings, 'stable');
end
