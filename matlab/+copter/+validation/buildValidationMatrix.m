function matrix = buildValidationMatrix(metrics, segment, config)
% Формирует минимальную матрицу валидации по данным бортового журнала.

if nargin < 2 || isempty(segment)
    segment = [NaN, NaN];
end

if nargin < 3 || isempty(config)
    config = copter.config.defaultVehicleConfig();
end

fit = metrics.fit_percent(:);
resultRoll = fit(1) >= config.criteria.rate_roll_pitch_fit_min_percent;
resultPitch = fit(2) >= config.criteria.rate_roll_pitch_fit_min_percent;
resultYaw = fit(3) >= config.criteria.rate_yaw_fit_min_percent;
timeInterval = string(sprintf('%.3f-%.3f с', segment(1), segment(2)));

matrix = table();
matrix.validation_check_id = ["RATE.R"; "RATE.P"; "RATE.Y"];
matrix.mode = repmat("Проверка по отложенному участку бортового журнала", 3, 1);
matrix.data_source = repmat("Бортовой журнал ArduPilot", 3, 1);
matrix.time_interval = repmat(timeInterval, 3, 1);
matrix.checked_parameters = [
    "угловая скорость крена"
    "угловая скорость тангажа"
    "угловая скорость рыскания"
    ];
matrix.metrics = [
    string(sprintf('показатель соответствия %.2f%%', fit(1)))
    string(sprintf('показатель соответствия %.2f%%', fit(2)))
    string(sprintf('показатель соответствия %.2f%%', fit(3)))
    ];
matrix.acceptance_criteria = [
    string(sprintf('не менее %.1f%%', config.criteria.rate_roll_pitch_fit_min_percent))
    string(sprintf('не менее %.1f%%', config.criteria.rate_roll_pitch_fit_min_percent))
    string(sprintf('не менее %.1f%%', config.criteria.rate_yaw_fit_min_percent))
    ];
matrix.result = [
    resultWord(resultRoll)
    resultWord(resultPitch)
    resultWord(resultYaw)
    ];
matrix.conclusion = [
    "Предварительная оценка по данным журнала"
    "Предварительная оценка по данным журнала"
    "Предварительная оценка по данным журнала"
    ];
matrix.limitations = repmat("Не является полной независимой валидацией реального изделия", 3, 1);

assert(height(matrix) == 3, 'Матрица валидации должна содержать три строки для RATE.R, RATE.P, RATE.Y.');
end

function word = resultWord(isPassed)
if isPassed
    word = "соответствует";
else
    word = "не соответствует";
end
end
