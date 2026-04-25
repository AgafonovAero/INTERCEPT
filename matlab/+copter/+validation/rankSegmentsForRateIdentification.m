function rankedSegments = rankSegmentsForRateIdentification(segmentRegistry, excitationMetrics, settings)
% Присваивает участкам оценку пригодности для идентификации ModelRate.

if nargin < 3 || isempty(settings)
    settings = defaultSettings();
end

rankedSegments = segmentRegistry;
if isempty(rankedSegments)
    return;
end

rankedSegments.score_roll = zeros(height(rankedSegments), 1);
rankedSegments.score_pitch = zeros(height(rankedSegments), 1);
rankedSegments.score_yaw = zeros(height(rankedSegments), 1);
rankedSegments.rate_identification_score = zeros(height(rankedSegments), 1);
rankedSegments.score_reason = strings(height(rankedSegments), 1);

for index = 1:height(rankedSegments)
    metrics = excitationMetrics(index, :);
    rollScore = axisScore(metrics.std_ROut, metrics.std_RATE_R_deg_s, settings);
    pitchScore = axisScore(metrics.std_POut, metrics.std_RATE_P_deg_s, settings);
    yawScore = axisScore(metrics.std_YOut, metrics.std_RATE_Y_deg_s, settings);
    qualityPenalty = qualityPenaltyFromMetrics(metrics, settings);
    totalScore = max([rollScore, pitchScore, yawScore]) * qualityPenalty;

    rankedSegments.score_roll(index) = rollScore;
    rankedSegments.score_pitch(index) = pitchScore;
    rankedSegments.score_yaw(index) = yawScore;
    rankedSegments.rate_identification_score(index) = max(0, min(1, totalScore));
    rankedSegments.score_reason(index) = buildReason(rollScore, pitchScore, yawScore, qualityPenalty);
end
end

function score = axisScore(inputStd, rateStd, settings)
inputPart = min(1, max(0, inputStd / settings.min_input_std));
ratePart = min(1, max(0, rateStd / settings.min_rate_std_deg_s));
score = sqrt(inputPart * ratePart);
end

function penalty = qualityPenaltyFromMetrics(metrics, settings)
penalty = 1;
if metrics.nan_percent > settings.max_nan_percent
    penalty = penalty * 0.2;
end

if metrics.saturation_percent > settings.max_motor_saturation_percent
    penalty = penalty * 0.4;
end

if metrics.condition_estimate > settings.max_condition_number
    penalty = penalty * 0.5;
end
end

function reason = buildReason(rollScore, pitchScore, yawScore, qualityPenalty)
[bestScore, bestIndex] = max([rollScore, pitchScore, yawScore]);
axisNames = ["крен", "тангаж", "рыскание"];
reason = "наиболее информативный канал: " + axisNames(bestIndex) ...
    + ", оценка " + string(round(bestScore, 3));
if qualityPenalty < 1
    reason = reason + "; снижено из-за качества данных";
end
end

function settings = defaultSettings()
settings = struct();
settings.min_input_std = 0.02;
settings.min_rate_std_deg_s = 1.0;
settings.max_nan_percent = 1.0;
settings.max_motor_saturation_percent = 5.0;
settings.max_condition_number = 1.0e8;
end
