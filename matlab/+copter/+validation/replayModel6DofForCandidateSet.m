function metricsByCandidate = replayModel6DofForCandidateSet(processedData, windows, candidates, vehicleConfig, settings)
% Выполняет легкую диагностику набора кандидатных мотор-маппингов.

if nargin < 4 || isempty(vehicleConfig)
    vehicleConfig = copter.config.defaultVehicleConfig();
end

if nargin < 5
    settings = struct();
end

rows = struct([]);
for index = 1:height(candidates)
    candidate = candidates(index, :);
    result = copter.identification.evaluateMotorMapCandidate( ...
        processedData, windows, candidate, vehicleConfig, settings);
    rows = [rows; result];
end

if isempty(rows)
    metricsByCandidate = emptyMetrics();
else
    metricsByCandidate = struct2table(rows);
end
end

function metricsByCandidate = emptyMetrics()
metricsByCandidate = table( ...
    strings(0, 1), ...
    zeros(0, 1), ...
    zeros(0, 1), ...
    zeros(0, 1), ...
    strings(0, 1), ...
    strings(0, 1), ...
    'VariableNames', {'candidate_id', 'score', 'mean_correlation', 'rmse_like', 'reasons', 'warnings'});
end
