function quality = assessDataQuality(dataTable, config)
% Оценивает качество исходных данных бортового журнала.

if nargin < 2 || isempty(config)
    config = copter.config.defaultVehicleConfig();
end

keyChannels = [
    "TimeUS"
    "ATT.Roll"
    "ATT.Pitch"
    "ATT.Yaw"
    "RATE.R"
    "RATE.P"
    "RATE.Y"
    "RATE.ROut"
    "RATE.POut"
    "RATE.YOut"
    "RCOU.C1"
    "RCOU.C2"
    "RCOU.C3"
    "RCOU.C4"
    ];

optionalChannels = [
    "ATT.DesRoll"
    "ATT.DesPitch"
    "ATT.DesYaw"
    "RATE.RDes"
    "RATE.PDes"
    "RATE.YDes"
    "RATE.AOut"
    "BAT.Volt"
    "BAT.Curr"
    "BAT.CurrTot"
    "BAT.EnrgTot"
    "ESC.RPM"
    "ESC.Curr"
    "ESC.Volt"
    ];

[availableKey, missingKey] = copter.utils.checkTableFields(dataTable, keyChannels);
[availableOptional, missingOptional] = copter.utils.checkTableFields(dataTable, optionalChannels);
availableChannels = [availableKey(:); availableOptional(:)];
warnings = strings(0, 1);

if ~isempty(missingKey)
    warnings(end + 1, 1) = "Отсутствующие ключевые каналы: " + strjoin(missingKey, ", ");
end

if ~isempty(missingOptional)
    warnings(end + 1, 1) = "Отсутствующие необязательные каналы: " + strjoin(missingOptional, ", ");
end

durationSeconds = 0;
gapCount = 0;
if hasColumn(dataTable, "t_s")
    timeSeconds = double(dataTable.t_s(:));
    if numel(timeSeconds) > 1
        durationSeconds = max(timeSeconds) - min(timeSeconds);
        timeStep = diff(timeSeconds);
        medianStep = median(timeStep, 'omitnan');
        if medianStep > 0
            gapCount = sum(timeStep > 1.5 * medianStep);
        end
        if gapCount > 0
            warnings(end + 1, 1) = "Выявлены пропуски времени: " + string(gapCount);
        end
    end
end

nanFraction = computeNanFraction(dataTable);
if nanFraction > 0
    warnings(end + 1, 1) = "Доля NaN в числовых данных: " + string(nanFraction);
end

rcouSaturation = computePwmSaturation(dataTable, config);
if rcouSaturation > 0
    warnings(end + 1, 1) = "Доля насыщения RCOU: " + string(rcouSaturation);
end

hasBattery = any(startsWith(string(dataTable.Properties.VariableNames), "BAT."));
hasEsc = any(startsWith(string(dataTable.Properties.VariableNames), "ESC."));
if ~hasBattery
    warnings(end + 1, 1) = "Каналы BAT отсутствуют.";
end

if ~hasEsc
    warnings(end + 1, 1) = "Каналы ESC отсутствуют.";
end

warnings(end + 1, 1) = "Данная проверка выполняется по данным бортового журнала и не является полной независимой валидацией реального изделия по внешним средствам измерений.";
[~, configWarnings] = copter.config.validateConfig(config);
warnings = unique([warnings; configWarnings(:)], 'stable');

quality = struct();
quality.row_count = height(dataTable);
quality.duration_s = durationSeconds;
quality.available_channels = unique(availableChannels, 'stable');
quality.missing_key_channels = missingKey(:);
quality.missing_optional_channels = missingOptional(:);
quality.gap_count = gapCount;
quality.nan_fraction = nanFraction;
quality.rcou_saturation_fraction = rcouSaturation;
quality.has_battery_channels = hasBattery;
quality.has_esc_channels = hasEsc;
quality.warnings = warnings;
end

function result = hasColumn(dataTable, fieldName)
result = any(string(dataTable.Properties.VariableNames) == string(fieldName));
end

function fraction = computeNanFraction(dataTable)
names = string(dataTable.Properties.VariableNames);
totalCount = 0;
nanCount = 0;
for index = 1:numel(names)
    value = dataTable.(names(index));
    if isnumeric(value)
        totalCount = totalCount + numel(value);
        nanCount = nanCount + sum(isnan(value), 'all');
    end
end

if totalCount == 0
    fraction = 0;
else
    fraction = nanCount / totalCount;
end
end

function fraction = computePwmSaturation(dataTable, config)
count = 0;
total = 0;
for motorIndex = 1:4
    fieldName = "RCOU.C" + motorIndex;
    if hasColumn(dataTable, fieldName)
        value = double(dataTable.(fieldName));
        count = count + sum(value <= config.normalization.pwm_min | value >= config.normalization.pwm_max);
        total = total + numel(value);
    end
end

if total == 0
    fraction = 0;
else
    fraction = count / total;
end
end
