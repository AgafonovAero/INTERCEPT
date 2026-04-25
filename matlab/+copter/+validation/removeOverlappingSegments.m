function [keptSegments, excludedSegments] = removeOverlappingSegments(segments, settings)
% Удаляет перекрывающиеся участки, оставляя более качественные.

if nargin < 2 || isempty(settings)
    settings = struct();
end

if ~isfield(settings, 'min_time_gap_between_segments_s')
    settings.min_time_gap_between_segments_s = 1.0;
end

if isempty(segments)
    keptSegments = segments;
    excludedSegments = segments;
    return;
end

segments = ensureReasonColumn(segments);
scoreName = chooseScoreName(segments);
[~, order] = sort(segments.(scoreName), 'descend', 'MissingPlacement', 'last');
sortedSegments = segments(order, :);

keepMask = false(height(sortedSegments), 1);
excludeReason = sortedSegments.exclusion_reason;

for index = 1:height(sortedSegments)
    candidate = sortedSegments(index, :);
    if ~overlapsKept(candidate, sortedSegments(keepMask, :), settings.min_time_gap_between_segments_s)
        keepMask(index) = true;
    else
        excludeReason(index) = "перекрытие с более качественным участком";
    end
end

sortedSegments.exclusion_reason = excludeReason;
keptSegments = sortedSegments(keepMask, :);
excludedSegments = sortedSegments(~keepMask, :);

if ~isempty(keptSegments)
    keptSegments = sortrows(keptSegments, {'log_file', 't_start_s'});
end
end

function result = overlapsKept(candidate, keptSegments, minGap)
result = false;
for index = 1:height(keptSegments)
    sameLog = string(candidate.log_file) == string(keptSegments.log_file(index));
    if ~sameLog
        continue;
    end

    left = candidate.t_start_s - minGap;
    right = candidate.t_end_s + minGap;
    keptLeft = keptSegments.t_start_s(index);
    keptRight = keptSegments.t_end_s(index);
    if left <= keptRight && right >= keptLeft
        result = true;
        return;
    end
end
end

function segments = ensureReasonColumn(segments)
if ~any(string(segments.Properties.VariableNames) == "exclusion_reason")
    segments.exclusion_reason = strings(height(segments), 1);
end
end

function scoreName = chooseScoreName(segments)
if any(string(segments.Properties.VariableNames) == "rate_identification_score")
    scoreName = "rate_identification_score";
else
    scoreName = "score";
end
end
