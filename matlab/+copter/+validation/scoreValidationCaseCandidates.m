function scoredSegments = scoreValidationCaseCandidates(processedData, segments, validationBasis, settings)
% Оценивает пригодность участков для случаев валидационного базиса.

if nargin < 3
    validationBasis = struct();
end

if nargin < 4 || isempty(settings)
    settings = struct();
    settings.max_motor_saturation_percent = 5;
    settings.allowed_nan_percent = 10;
end

dataTable = localTable(processedData);
score = zeros(height(segments), 1);
reason = strings(height(segments), 1);
limitations = strings(height(segments), 1);

for index = 1:height(segments)
    mask = dataTable.t_s >= segments.t_start_s(index) & dataTable.t_s <= segments.t_end_s(index);
    segmentData = dataTable(mask, :);
    [score(index), reason(index), limitations(index)] = scoreOneSegment(segmentData, segments.segment_type(index), validationBasis, settings);
end

scoredSegments = segments;
scoredSegments.score = score;
scoredSegments.reason = reason;
scoredSegments.limitations = limitations;
end

function [score, reason, limitations] = scoreOneSegment(segmentData, segmentType, validationBasis, settings)
score = 0.5;
limitations = strings(0, 1);

if isempty(segmentData)
    score = 0;
    reason = "Участок не содержит данных.";
    limitations = "Нет данных.";
    return;
end

nanPercent = 100 * mean(any(ismissing(segmentData), 2), 'omitnan');
motorSaturationPercent = 100 * mean(readColumn(segmentData, "motor_saturation_flag"), 'omitnan');
durationScore = min(1, height(segmentData) / 200);
qualityScore = max(0, 1 - nanPercent / max(settings.allowed_nan_percent, eps));
saturationScore = max(0, 1 - motorSaturationPercent / max(settings.max_motor_saturation_percent, eps));
caseScore = scoreByType(segmentData, segmentType);
score = mean([durationScore, qualityScore, saturationScore, caseScore], 'omitnan');

if nanPercent > settings.allowed_nan_percent
    limitations(end + 1, 1) = "Доля строк с пропусками выше настройки.";
end

if motorSaturationPercent > settings.max_motor_saturation_percent
    limitations(end + 1, 1) = "Доля насыщения RCOU выше настройки.";
end

if isempty(limitations)
    limitations = "Ограничения участка не выявлены на уровне автоматической оценки.";
else
    limitations = strjoin(limitations, " ");
end

reason = "Оценка учитывает длительность, пропуски, насыщение RCOU и соответствие признакам " + string(segmentType) + ".";
if isfield(validationBasis, 'cases')
    reason = reason + " Связь с ВБ проверена по формализованному реестру.";
end
end

function score = scoreByType(segmentData, segmentType)
if segmentType == "hover_candidate"
    score = mean(readColumn(segmentData, "is_hover"), 'omitnan');
elseif segmentType == "climb_candidate"
    score = mean(readColumn(segmentData, "is_climb"), 'omitnan');
elseif segmentType == "descent_candidate"
    score = mean(readColumn(segmentData, "is_descent"), 'omitnan');
elseif segmentType == "roll_response_candidate"
    score = scaledAmplitude(segmentData, "control_roll_amplitude");
elseif segmentType == "pitch_response_candidate"
    score = scaledAmplitude(segmentData, "control_pitch_amplitude");
elseif segmentType == "yaw_response_candidate"
    score = scaledAmplitude(segmentData, "control_yaw_amplitude");
elseif segmentType == "thrust_response_candidate"
    score = scaledAmplitude(segmentData, "control_thrust_amplitude");
else
    score = 0.5;
end
end

function score = scaledAmplitude(segmentData, variableName)
value = readColumn(segmentData, variableName);
score = min(1, max(value, [], 'omitnan') / 0.25);
if isnan(score)
    score = 0;
end
end

function value = readColumn(dataTable, variableName)
if any(string(dataTable.Properties.VariableNames) == string(variableName))
    value = double(dataTable.(variableName));
else
    value = NaN(height(dataTable), 1);
end
end

function dataTable = localTable(dataSet)
if istimetable(dataSet)
    dataTable = timetable2table(dataSet, 'ConvertRowTimes', false);
else
    dataTable = dataSet;
end
end
