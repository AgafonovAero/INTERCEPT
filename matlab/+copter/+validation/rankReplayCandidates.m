function rankedCandidates = rankReplayCandidates(metricsByCandidate, options)
% Ранжирует кандидаты replay с учетом качества сопоставления и предупреждений.

if nargin < 2
    options = struct();
end

if isempty(metricsByCandidate)
    rankedCandidates = metricsByCandidate;
    return;
end

rankedCandidates = metricsByCandidate;
score = double(rankedCandidates.score);
if any(string(rankedCandidates.Properties.VariableNames) == "warnings")
    hasWarnings = strlength(string(rankedCandidates.warnings)) > 0;
    score(hasWarnings) = score(hasWarnings) - 0.05;
end

if isfield(options, 'penalty')
    score = score - double(options.penalty);
end

rankedCandidates.rank_score = max(0, min(1, score));
rankedCandidates = sortrows(rankedCandidates, "rank_score", "descend");
end
