function [curatedSegments, excludedSegments, diagnosticTable] = curateValidationSegments(segmentRegistry, processedData, settings)
% Выполняет инженерную фильтрацию участков для идентификации ModelRate.

if nargin < 3 || isempty(settings)
    settings = defaultSettings();
end

if isempty(segmentRegistry)
    curatedSegments = table();
    excludedSegments = table();
    diagnosticTable = table();
    return;
end

settings = normalizeSettings(settings);
excitationMetrics = copter.validation.computeSegmentExcitationMetrics(segmentRegistry, processedData);
rankedSegments = copter.validation.rankSegmentsForRateIdentification(segmentRegistry, excitationMetrics, settings);
diagnosticTable = [rankedSegments, excitationMetrics(:, 2:end)];

isCurated = true(height(diagnosticTable), 1);
exclusionReason = strings(height(diagnosticTable), 1);

for index = 1:height(diagnosticTable)
    [isCurated(index), exclusionReason(index)] = evaluateSegment(diagnosticTable(index, :), settings);
end

diagnosticTable.is_curated = isCurated;
diagnosticTable.exclusion_reason = exclusionReason;
curatedSegments = diagnosticTable(isCurated, :);
excludedSegments = diagnosticTable(~isCurated, :);
end

function [isCurated, reason] = evaluateSegment(segment, settings)
isCurated = false;
reason = "";

if ~any(string(segment.segment_type) == settings.candidate_types_for_rate_identification)
    reason = "тип участка не предназначен для идентификации ModelRate";
    return;
end

if any(string(segment.segment_type) == settings.exclude_candidate_types_for_rate_identification)
    reason = "тип участка исключен из первичной идентификации ModelRate";
    return;
end

if segment.duration_s < settings.min_duration_s
    reason = "малая длительность";
    return;
end

if segment.duration_s > settings.max_duration_s
    reason = "слишком большая длительность";
    return;
end

inputStd = [segment.std_ROut, segment.std_POut, segment.std_YOut];
rateStd = [segment.std_RATE_R_deg_s, segment.std_RATE_P_deg_s, segment.std_RATE_Y_deg_s];
if all(~isfinite(inputStd)) || all(~isfinite(rateStd))
    reason = "неопределенная метрика";
    return;
end

if max(inputStd, [], 'omitnan') < settings.min_input_std
    reason = "малая дисперсия входа";
    return;
end

if max(rateStd, [], 'omitnan') < settings.min_rate_std_deg_s
    reason = "малая дисперсия выходного сигнала";
    return;
end

if segment.nan_percent > settings.max_nan_percent
    reason = "пропуски данных";
    return;
end

if segment.saturation_percent > settings.max_motor_saturation_percent
    reason = "насыщение RCOU";
    return;
end

if segment.rate_identification_score <= 0 || ~isfinite(segment.rate_identification_score)
    reason = "неопределенная метрика";
    return;
end

isCurated = true;
reason = "участок пригоден для первичной идентификации ModelRate";
end

function settings = normalizeSettings(settings)
defaults = defaultSettings();
fields = fieldnames(defaults);
for index = 1:numel(fields)
    fieldName = fields{index};
    if ~isfield(settings, fieldName)
        settings.(fieldName) = defaults.(fieldName);
    end
end

settings.candidate_types_for_rate_identification = string(settings.candidate_types_for_rate_identification);
settings.exclude_candidate_types_for_rate_identification = string(settings.exclude_candidate_types_for_rate_identification);
end

function settings = defaultSettings()
settings = struct();
settings.min_duration_s = 2.0;
settings.max_duration_s = 12.0;
settings.min_input_std = 0.02;
settings.min_rate_std_deg_s = 1.0;
settings.max_nan_percent = 1.0;
settings.max_motor_saturation_percent = 5.0;
settings.max_condition_number = 1.0e8;
settings.candidate_types_for_rate_identification = [
    "roll_response_candidate"
    "pitch_response_candidate"
    "yaw_response_candidate"
    "hover_candidate"
    ];
settings.exclude_candidate_types_for_rate_identification = [
    "climb_candidate"
    "descent_candidate"
    "thrust_response_candidate"
    ];
end
