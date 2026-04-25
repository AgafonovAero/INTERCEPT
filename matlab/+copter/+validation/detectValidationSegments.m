function segments = detectValidationSegments(processedData, validationBasis, settings, logFile)
% Выделяет кандидаты участков валидационного базиса по обработанным данным.

if nargin < 2
    validationBasis = struct();
end

if nargin < 3 || isempty(settings)
    settings = defaultSettings();
end

if nargin < 4
    logFile = "";
end

dataTable = localTable(processedData);
segmentRows = {};

segmentRows = [segmentRows; detectByMask(dataTable, dataTable.is_hover, "hover_candidate", "В-01", settings, logFile)];
segmentRows = [segmentRows; detectByMask(dataTable, dataTable.is_climb, "climb_candidate", "В-06", settings, logFile)];
segmentRows = [segmentRows; detectByMask(dataTable, dataTable.is_descent, "descent_candidate", "В-08", settings, logFile)];
segmentRows = [segmentRows; detectByMask(dataTable, dataTable.control_roll_amplitude >= settings.response_min_control_amplitude, "roll_response_candidate", "В-10", settings, logFile)];
segmentRows = [segmentRows; detectByMask(dataTable, dataTable.control_pitch_amplitude >= settings.response_min_control_amplitude, "pitch_response_candidate", "В-09", settings, logFile)];
segmentRows = [segmentRows; detectByMask(dataTable, dataTable.control_yaw_amplitude >= settings.response_min_control_amplitude, "yaw_response_candidate", "В-11", settings, logFile)];
segmentRows = [segmentRows; detectByMask(dataTable, dataTable.control_thrust_amplitude >= settings.response_min_control_amplitude, "thrust_response_candidate", "В-12", settings, logFile)];

segments = rowsToTable(segmentRows);
if isempty(segments)
    return;
end

scoredSegments = copter.validation.scoreValidationCaseCandidates(processedData, segments, validationBasis, settings);
segments.score = scoredSegments.score;
segments.reason = scoredSegments.reason;
segments.limitations = scoredSegments.limitations;
end

function rows = detectByMask(dataTable, mask, segmentType, caseId, settings, logFile)
mask = logical(mask(:));
mask(~isfinite(double(mask))) = false;
intervals = maskToIntervals(dataTable.t_s, mask, settings);
rows = cell(size(intervals, 1), 1);

for index = 1:size(intervals, 1)
    row = struct();
    row.segment_id = string(segmentType) + "_" + string(index);
    row.log_file = string(logFile);
    row.candidate_validation_case_id = string(caseId);
    row.segment_type = string(segmentType);
    row.t_start_s = intervals(index, 1);
    row.t_end_s = intervals(index, 2);
    row.duration_s = intervals(index, 2) - intervals(index, 1);
    row.score = NaN;
    row.reason = "";
    row.limitations = "";
    rows{index} = row;
end
end

function intervals = maskToIntervals(timeSeconds, mask, settings)
timeSeconds = double(timeSeconds(:));
if isempty(mask) || ~any(mask)
    intervals = zeros(0, 2);
    return;
end

edges = diff([false; mask; false]);
starts = find(edges == 1);
ends = find(edges == -1) - 1;
intervals = zeros(0, 2);

for index = 1:numel(starts)
    startTime = timeSeconds(starts(index));
    endTime = timeSeconds(ends(index));
    duration = endTime - startTime;
    if duration < settings.min_segment_duration_s
        centerTime = 0.5 * (startTime + endTime);
        startTime = max(timeSeconds(1), centerTime - settings.min_segment_duration_s / 2);
        endTime = min(timeSeconds(end), centerTime + settings.min_segment_duration_s / 2);
        duration = endTime - startTime;
    end

    if duration < settings.min_segment_duration_s
        continue;
    end

    while duration > settings.max_segment_duration_s
        intervals(end + 1, :) = [startTime, startTime + settings.max_segment_duration_s];
        startTime = startTime + settings.max_segment_duration_s;
        duration = endTime - startTime;
    end

    intervals(end + 1, :) = [startTime, endTime];
end
end

function segments = rowsToTable(rows)
if isempty(rows)
    segments = table();
    return;
end

segments = struct2table([rows{:}]);
segments.segment_id = reshape(string(segments.segment_id), [], 1);
segments.log_file = reshape(string(segments.log_file), [], 1);
segments.candidate_validation_case_id = reshape(string(segments.candidate_validation_case_id), [], 1);
segments.segment_type = reshape(string(segments.segment_type), [], 1);
end

function dataTable = localTable(dataSet)
if istimetable(dataSet)
    dataTable = timetable2table(dataSet, 'ConvertRowTimes', false);
else
    dataTable = dataSet;
end
end

function settings = defaultSettings()
settings = struct();
settings.min_segment_duration_s = 2;
settings.max_segment_duration_s = 20;
settings.hover_max_horizontal_speed_mps = 1.5;
settings.hover_max_vertical_speed_mps = 0.5;
settings.hover_max_roll_pitch_deg = 7;
settings.climb_vertical_speed_threshold_mps = 1.0;
settings.descent_vertical_speed_threshold_mps = 1.0;
settings.response_min_control_amplitude = 0.15;
settings.max_motor_saturation_percent = 5;
settings.allowed_nan_percent = 10;
end
