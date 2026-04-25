function replayWindows = selectModel6DofReplayWindows(segmentRegistry, replaySettings)
% Выбирает короткие неперекрывающиеся окна для сопоставления Model6DOF с журналом.

if nargin < 2 || isempty(replaySettings)
    replaySettings = defaultSettings();
end

if isempty(segmentRegistry)
    replayWindows = emptyWindows();
    return;
end

allowedTypes = string(replaySettings.default_window_types(:));
registry = segmentRegistry;
duration = double(registry.duration_s);
typeMask = ismember(string(registry.segment_type), allowedTypes);
durationMask = duration >= replaySettings.min_window_duration_s ...
    & duration <= replaySettings.max_window_duration_s;

if any(string(registry.Properties.VariableNames) == "motor_saturation_percent")
    saturationMask = registry.motor_saturation_percent <= replaySettings.max_motor_saturation_percent;
else
    saturationMask = true(height(registry), 1);
end

candidateMask = typeMask & durationMask & saturationMask;
candidateRegistry = registry(candidateMask, :);
if isempty(candidateRegistry)
    replayWindows = emptyWindows();
    return;
end

if any(string(candidateRegistry.Properties.VariableNames) == "score")
    [~, order] = sort(candidateRegistry.score, 'descend', 'MissingPlacement', 'last');
else
    order = transpose(1:height(candidateRegistry));
end
candidateRegistry = candidateRegistry(order, :);
candidateRegistry = keepNonOverlapping(candidateRegistry);

maxWindows = min(8, height(candidateRegistry));
candidateRegistry = candidateRegistry(1:maxWindows, :);
splitRole = splitRoles(maxWindows);

replayWindows = table( ...
    string(candidateRegistry.segment_id), ...
    string(candidateRegistry.log_file), ...
    string(candidateRegistry.candidate_validation_case_id), ...
    string(candidateRegistry.segment_type), ...
    double(candidateRegistry.t_start_s), ...
    double(candidateRegistry.t_end_s), ...
    double(candidateRegistry.duration_s), ...
    splitRole, ...
    'VariableNames', { ...
    'window_id', ...
    'log_file', ...
    'candidate_validation_case_id', ...
    'window_type', ...
    't_start_s', ...
    't_end_s', ...
    'duration_s', ...
    'split_role'});
end

function registry = keepNonOverlapping(registry)
keep = false(height(registry), 1);
for index = 1:height(registry)
    overlaps = false;
    for keptIndex = transpose(find(keep))
        sameLog = string(registry.log_file(index)) == string(registry.log_file(keptIndex));
        if sameLog
            separated = registry.t_end_s(index) < registry.t_start_s(keptIndex) ...
                || registry.t_start_s(index) > registry.t_end_s(keptIndex);
            overlaps = overlaps || ~separated;
        end
    end
    keep(index) = ~overlaps;
end
registry = registry(keep, :);
end

function roles = splitRoles(rowCount)
roles = strings(rowCount, 1);
if rowCount == 1
    roles(1) = "validation";
    return;
end

identificationCount = max(1, floor(0.6 * rowCount));
roles(1:identificationCount) = "identification";
roles(identificationCount + 1:end) = "validation";
end

function settings = defaultSettings()
settings = struct();
settings.min_window_duration_s = 2.0;
settings.max_window_duration_s = 8.0;
settings.max_motor_saturation_percent = 5.0;
settings.default_window_types = [
    "hover_candidate"
    "roll_response_candidate"
    "pitch_response_candidate"
    "yaw_response_candidate"
    "thrust_response_candidate"
    "climb_candidate"
    "descent_candidate"
    ];
end

function replayWindows = emptyWindows()
replayWindows = table( ...
    strings(0, 1), ...
    strings(0, 1), ...
    strings(0, 1), ...
    strings(0, 1), ...
    zeros(0, 1), ...
    zeros(0, 1), ...
    zeros(0, 1), ...
    strings(0, 1), ...
    'VariableNames', { ...
    'window_id', ...
    'log_file', ...
    'candidate_validation_case_id', ...
    'window_type', ...
    't_start_s', ...
    't_end_s', ...
    'duration_s', ...
    'split_role'});
end
