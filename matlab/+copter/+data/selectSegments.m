function segments = selectSegments(dataSet, segmentDurationS)
% Выделяет разные участки идентификации и проверки.

if nargin < 2 || isempty(segmentDurationS)
    segmentDurationS = 2;
end

timeSeconds = double(dataSet.t_s(:));
assert(numel(timeSeconds) >= 2, 'Недостаточно данных для выделения участков.');

startTime = timeSeconds(1);
endTime = timeSeconds(end);
duration = endTime - startTime;
segmentDurationS = min(max(0.5, segmentDurationS), max(0.5, duration / 2));

identEnd = startTime + segmentDurationS;
checkEnd = min(endTime, identEnd + segmentDurationS);
if checkEnd <= identEnd
    identEnd = startTime + duration / 2;
    checkEnd = endTime;
end

segments = struct();
segments.identification = [startTime, identEnd];
segments.validation = [identEnd, checkEnd];
segments.note = "Параметры на участке проверки не настраиваются.";
end
