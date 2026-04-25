function calibrationResult = calibrateMotorMapAndFrame(processedData, identificationWindows, validationWindows, vehicleConfig, motorSettings, frameSettings)
% Выбирает расчетную гипотезу мотор-маппинга и CAD -> body по identification-окнам.

if nargin < 4 || isempty(vehicleConfig)
    vehicleConfig = copter.config.defaultVehicleConfig();
end

if nargin < 5
    motorSettings = struct();
end

if nargin < 6
    frameSettings = struct();
end

motorCandidates = copter.models.generateMotorMapCandidates(vehicleConfig, motorSettings);
motorMetrics = copter.validation.replayModel6DofForCandidateSet( ...
    processedData, identificationWindows, motorCandidates, vehicleConfig, motorSettings);
rankedMotorMetrics = copter.validation.rankReplayCandidates(motorMetrics);
selectedMotorId = rankedMotorMetrics.candidate_id(1);
selectedMotorIndex = find(string(motorCandidates.candidate_id) == selectedMotorId, 1, 'first');
selectedMotorMap = motorCandidates(selectedMotorIndex, :);

frameCandidates = copter.models.generateCadToBodyCandidates(frameSettings);
frameRows = struct([]);
for index = 1:height(frameCandidates)
    frameRows = [frameRows; copter.identification.evaluateFrameCandidate( ...
        processedData, identificationWindows, frameCandidates(index, :), vehicleConfig)];
end
frameMetrics = struct2table(frameRows);
frameMetrics = sortrows(frameMetrics, "score", "descend");
selectedFrame = frameCandidates(string(frameCandidates.candidate_id) == frameMetrics.candidate_id(1), :);

validationMetrics = copter.validation.replayModel6DofForCandidateSet( ...
    processedData, validationWindows, selectedMotorMap, vehicleConfig, motorSettings);

calibrationResult = struct();
calibrationResult.selectedMotorMap = selectedMotorMap;
calibrationResult.selectedSpinSigns = selectedMotorMap.spin_sign{1};
calibrationResult.selectedCadToBodyTransform = selectedFrame.transform_matrix{1};
calibrationResult.motorCandidates = motorCandidates;
calibrationResult.frameCandidates = frameCandidates;
calibrationResult.motorMetrics = rankedMotorMetrics;
calibrationResult.frameMetrics = frameMetrics;
calibrationResult.validationMetrics = validationMetrics;
calibrationResult.calibrationMetrics = makeSummary(rankedMotorMetrics, frameMetrics, validationMetrics);
calibrationResult.warnings = [
    "Выбранный мотор-маппинг и преобразование CAD -> body являются расчетной гипотезой."
    "Для окончательного подтверждения требуется физическая проверка подключения моторов, направления вращения и системы координат изделия."
    ];
end

function summary = makeSummary(motorMetrics, frameMetrics, validationMetrics)
summary = struct();
summary.best_motor_score = motorMetrics.score(1);
summary.best_frame_score = frameMetrics.score(1);
if isempty(validationMetrics)
    summary.validation_score = NaN;
else
    summary.validation_score = validationMetrics.score(1);
end
summary.note = "Кандидат выбран только по identification-окнам; validation-окна использованы для проверки гипотезы.";
end
