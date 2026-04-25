function report = diagnoseCoordinateFrameConsistency(processedData, frameCandidates, vehicleConfig)
% Диагностирует согласованность знаков осей по данным журнала и геометрии.

if nargin < 2 || isempty(frameCandidates)
    frameCandidates = copter.models.generateCadToBodyCandidates();
end

if nargin < 3 || isempty(vehicleConfig)
    vehicleConfig = copter.config.defaultVehicleConfig();
end

dataTable = localTable(processedData);
rows = struct([]);
for index = 1:height(frameCandidates)
    transform = frameCandidates.transform_matrix{index};
    [positions, positionReport] = copter.models.transformMotorPositions(vehicleConfig, transform);
    geometryReport = copter.models.validateMotorGeometry(vehicleConfig);
    signScore = estimateSignScore(dataTable);
    symmetryScore = max(0, min(1, 1 / max(1, geometryReport.arm_spread_percent)));
    score = 0.7 * signScore + 0.3 * symmetryScore;

    row = struct();
    row.candidate_id = string(frameCandidates.candidate_id(index));
    row.score = score;
    row.mean_arm_m = positionReport.mean_arm_m;
    row.transform_matrix = {transform};
    row.reasons = "Оценка основана на знаках RATE/RCOU и симметрии CAD-геометрии.";
    row.warnings = join(unique(string(positionReport.warnings(:)), 'stable'), "; ");
    row.motor_positions_body_m = {positions};
    rows = [rows; row];
end

ranking = struct2table(rows);
ranking = sortrows(ranking, "score", "descend");
report = struct();
report.ranked_candidates = ranking;
report.warnings = "Диагностика систем координат является расчетной гипотезой и требует физического подтверждения.";
end

function score = estimateSignScore(dataTable)
rateNames = [
    pickVariable(dataTable, ["RATE.R_rad_s", "RATE_R_rad_s", "RATE.R"])
    pickVariable(dataTable, ["RATE.P_rad_s", "RATE_P_rad_s", "RATE.P"])
    pickVariable(dataTable, ["RATE.Y_rad_s", "RATE_Y_rad_s", "RATE.Y"])
    ];
if any(strlength(rateNames) == 0)
    score = 0.5;
    return;
end

rateStd = [
    std(double(dataTable.(rateNames(1))), 'omitnan')
    std(double(dataTable.(rateNames(2))), 'omitnan')
    std(double(dataTable.(rateNames(3))), 'omitnan')
    ];
score = min(1, mean(rateStd > 0.01) + 0.25);
end

function variableName = pickVariable(dataTable, candidates)
variableName = "";
names = string(dataTable.Properties.VariableNames);
for index = 1:numel(candidates)
    mask = names == candidates(index);
    if any(mask)
        variableName = names(find(mask, 1, 'first'));
        return;
    end
end
end

function dataTable = localTable(data)
if istimetable(data)
    dataTable = timetable2table(data, 'ConvertRowTimes', false);
elseif istable(data)
    dataTable = data;
else
    dataTable = table();
end
end
