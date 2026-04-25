function [dataTable, timeSeconds, timeInfo] = normalizeTime(dataTable)
% Приводит время бортового журнала к секундам.

timeInfo = struct();
timeInfo.source = "";
timeInfo.duplicate_count = 0;
timeInfo.duration_s = 0;

if istimetable(dataTable)
    timeSeconds = seconds(dataTable.Properties.RowTimes - dataTable.Properties.RowTimes(1));
    dataTable = timetable2table(dataTable, 'ConvertRowTimes', true);
    dataTable.t_s = double(timeSeconds(:));
    timeInfo.source = "RowTimes";
else
    names = string(dataTable.Properties.VariableNames);
    candidates = ["TimeUS", "TimeMS", "TimeS", "Time", "timestamp", "t", "time"];
    timeColumn = "";
    for index = 1:numel(candidates)
        if any(names == candidates(index))
            timeColumn = candidates(index);
            break;
        end
    end

    assert(strlength(timeColumn) > 0, 'Не найден столбец времени.');
    value = dataTable.(timeColumn);
    if isduration(value)
        timeSeconds = seconds(value - value(1));
    elseif isdatetime(value)
        timeSeconds = seconds(value - value(1));
    else
        numericValue = double(value);
        if timeColumn == "TimeUS"
            timeSeconds = numericValue ./ 1e6;
        elseif timeColumn == "TimeMS"
            timeSeconds = numericValue ./ 1e3;
        else
            timeSeconds = numericValue;
        end
        timeSeconds = timeSeconds - timeSeconds(1);
    end
    dataTable.t_s = double(timeSeconds(:));
    timeInfo.source = timeColumn;
end

[timeSeconds, order] = sort(double(dataTable.t_s(:)));
dataTable = dataTable(order, :);

[uniqueTime, uniqueIndex] = unique(timeSeconds, 'stable');
timeInfo.duplicate_count = numel(timeSeconds) - numel(uniqueTime);
dataTable = dataTable(uniqueIndex, :);
dataTable.t_s = uniqueTime(:);
timeSeconds = uniqueTime(:);

if numel(timeSeconds) > 1
    timeInfo.duration_s = timeSeconds(end) - timeSeconds(1);
end
end
