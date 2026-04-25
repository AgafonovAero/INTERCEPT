function result = evaluateFrameCandidate(processedData, windows, frameCandidate, vehicleConfig)
% Оценивает кандидатное преобразование CAD -> body по геометрии и данным журнала.

if nargin < 4 || isempty(vehicleConfig)
    vehicleConfig = copter.config.defaultVehicleConfig();
end

transform = frameCandidate.transform_matrix{1};
[positions, positionReport] = copter.models.transformMotorPositions(vehicleConfig, transform);
[inertia, inertiaReport] = copter.models.transformInertiaTensor(vehicleConfig, transform);
geometrySpread = max(positionReport.arm_lengths_m) - min(positionReport.arm_lengths_m);
symmetryScore = max(0, 1 - geometrySpread / max(mean(positionReport.arm_lengths_m), eps));

dataScore = 0.5;
if nargin >= 2 && ~isempty(windows) && ~isempty(processedData)
    frameReport = copter.validation.diagnoseCoordinateFrameConsistency( ...
        processedData, frameCandidate, vehicleConfig);
    if ~isempty(frameReport.ranked_candidates)
        dataScore = frameReport.ranked_candidates.score(1);
    end
end

result = struct();
result.candidate_id = string(frameCandidate.candidate_id(1));
result.score = 0.6 * symmetryScore + 0.4 * dataScore;
result.transform_matrix = {transform};
result.inertia_body = {inertia};
result.motor_positions_body_m = {positions};
result.reasons = "Оценка по симметрии геометрии и согласованности данных бортового журнала.";
result.warnings = join(unique([string(positionReport.warnings(:)); string(inertiaReport.warnings(:))], 'stable'), "; ");
end
