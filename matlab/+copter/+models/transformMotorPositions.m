function [positionsBodyM, report] = transformMotorPositions(positionSource, cadToBodyMatrix)
% Преобразует CAD-координаты моторов в связанную систему координат изделия.

if nargin < 2 || isempty(cadToBodyMatrix)
    cadToBodyMatrix = eye(3);
end

[positionsCadM, sourceText] = readCadPositions(positionSource);
transform = double(cadToBodyMatrix);
positionsBodyM = transform * positionsCadM;
armLengths = sqrt(sum(positionsBodyM(1:2, :) .^ 2, 1));
warnings = strings(0, 1);

if any(~isfinite(positionsBodyM), 'all')
    warnings(end + 1, 1) = "Преобразованные координаты моторов содержат нечисловые значения.";
end

if max(armLengths) - min(armLengths) > 0.03
    warnings(end + 1, 1) = "После преобразования плечи моторов заметно различаются.";
end

report = struct();
report.source = sourceText;
report.transform_matrix = transform;
report.arm_lengths_m = transpose(armLengths(:));
report.mean_arm_m = mean(armLengths, 'omitnan');
report.warnings = unique(warnings, 'stable');
end

function [positionsCadM, sourceText] = readCadPositions(source)
sourceText = "matrix";
if isnumeric(source)
    positionsCadM = double(source);
    if size(positionsCadM, 1) ~= 3 && size(positionsCadM, 2) == 3
        positionsCadM = transpose(positionsCadM);
    end
    return;
end

if nargin < 1 || isempty(source)
    source = copter.config.defaultVehicleConfig();
end

if isstruct(source) && isfield(source, 'geometry')
    geometry = source.geometry;
    centerOfMass = double(geometry.cad_cg_mm(:));
    positionsCadMm = [
        double(geometry.motor_1_raw_cad_mm(:)) - centerOfMass, ...
        double(geometry.motor_2_raw_cad_mm(:)) - centerOfMass, ...
        double(geometry.motor_3_raw_cad_mm(:)) - centerOfMass, ...
        double(geometry.motor_4_raw_cad_mm(:)) - centerOfMass
        ];
    positionsCadM = positionsCadMm ./ 1000;
    sourceText = "vehicle_config_cad";
else
    positionsCadM = zeros(3, 4);
    sourceText = "empty";
end
end
