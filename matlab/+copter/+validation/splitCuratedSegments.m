function [splitSegments, splitReport] = splitCuratedSegments(curatedSegments, settings)
% Разделяет отфильтрованные участки на identification и validation.

if nargin < 2 || isempty(settings)
    settings = struct();
end

if ~isfield(settings, 'train_validation_split')
    settings.train_validation_split = 0.7;
end

if ~isfield(settings, 'random_seed')
    settings.random_seed = 42;
end

if ~isfield(settings, 'prefer_distinct_logs_for_validation')
    settings.prefer_distinct_logs_for_validation = true;
end

splitSegments = curatedSegments;
splitReport = struct();
splitReport.random_seed = settings.random_seed;
splitReport.strategy = "разделение по журналам или временным блокам без перекрытий";

if isempty(splitSegments)
    splitSegments.split_role = strings(0, 1);
    splitReport.identification_count = 0;
    splitReport.validation_count = 0;
    return;
end

splitSegments = sortrows(splitSegments, {'log_file', 't_start_s'});
splitSegments.split_role = repmat("identification", height(splitSegments), 1);

uniqueLogs = unique(string(splitSegments.log_file), 'stable');
if settings.prefer_distinct_logs_for_validation && numel(uniqueLogs) > 1
    validationLog = uniqueLogs(end);
    splitSegments.split_role(string(splitSegments.log_file) == validationLog) = "validation";
    splitReport.strategy = "validation выбран из отдельного журнала: " + validationLog;
else
    rng(settings.random_seed);
    validationCount = max(1, round(height(splitSegments) * (1 - settings.train_validation_split)));
    candidateIndex = round(linspace(1, height(splitSegments), validationCount + 2));
    validationIndex = unique(candidateIndex(2:end - 1));
    splitSegments.split_role(validationIndex) = "validation";
end

if ~any(splitSegments.split_role == "validation") && height(splitSegments) > 1
    splitSegments.split_role(end) = "validation";
end

if ~any(splitSegments.split_role == "identification") && height(splitSegments) > 1
    splitSegments.split_role(1) = "identification";
end

splitReport.identification_count = nnz(splitSegments.split_role == "identification");
splitReport.validation_count = nnz(splitSegments.split_role == "validation");
splitReport.logs = unique(string(splitSegments.log_file), 'stable');
end
