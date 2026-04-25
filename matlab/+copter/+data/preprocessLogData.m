function [processedData, quality] = preprocessLogData(source, config, sampleRateHz)
% Выполняет препроцессорную подготовку данных для расчета компьютерной модели.

if nargin < 2 || isempty(config)
    config = copter.config.defaultVehicleConfig();
end

if nargin < 3 || isempty(sampleRateHz)
    sampleRateHz = config.normalization.sample_rate_hz;
end

rawTable = copter.data.readTableLog(source);
[dataTable, timeSeconds, timeInfo] = copter.data.normalizeTime(rawTable);
dataTable = copter.data.convertUnits(dataTable, config);
quality = copter.data.assessDataQuality(dataTable, config);
quality.time = timeInfo;
quality.sample_rate_hz = sampleRateHz;

if numel(timeSeconds) < 2
    processedData = table2timetable(dataTable, 'RowTimes', seconds(dataTable.t_s));
    return;
end

step = 1 / sampleRateHz;
uniformTime = transpose(timeSeconds(1):step:timeSeconds(end));
regularTable = table();
regularTable.t_s = uniformTime;
names = string(dataTable.Properties.VariableNames);

for index = 1:numel(names)
    fieldName = names(index);
    if fieldName == "t_s"
        continue;
    end

    value = dataTable.(fieldName);
    if isnumeric(value) || islogical(value)
        numericValue = double(value);
        if isvector(numericValue)
            regularTable.(fieldName) = interp1(timeSeconds, numericValue(:), uniformTime, 'linear', 'extrap');
        end
    end
end

processedData = table2timetable(regularTable, 'RowTimes', seconds(regularTable.t_s));
processedData.Properties.DimensionNames{1} = 'Time';
end
