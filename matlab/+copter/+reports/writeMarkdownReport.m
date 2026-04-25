function text = writeMarkdownReport(filePath, reportData)
% Формирует отчет оценки адекватности компьютерной модели.

if nargin < 1
    filePath = "";
end

if nargin < 2 || isempty(reportData)
    reportData = struct();
end

config = getField(reportData, 'config', copter.config.defaultVehicleConfig());
quality = getField(reportData, 'data_quality', struct());
fit = getField(reportData, 'identification', struct());
validation = getField(reportData, 'validation', struct());
segments = getField(reportData, 'segments', struct());
sourceHash = getField(reportData, 'source_data_hash', "");
processedHash = getField(reportData, 'processed_data_hash', "");
configHash = getField(reportData, 'config_hash', "");

lines = strings(0, 1);
lines(end + 1, 1) = "# Отчет оценки адекватности компьютерной модели";
lines(end + 1, 1) = "";
lines(end + 1, 1) = "**Данная проверка выполнена по данным бортового журнала и не является полной независимой валидацией реального изделия по внешним средствам измерений.**";
lines(end + 1, 1) = "";
lines(end + 1, 1) = "## Наименование изделия";
lines(end + 1, 1) = string(config.vehicle_name);
lines(end + 1, 1) = "";
lines(end + 1, 1) = "## Идентификатор изделия";
lines(end + 1, 1) = string(config.vehicle_id);
lines(end + 1, 1) = "";
lines(end + 1, 1) = "## Назначение расчета";
lines(end + 1, 1) = "Расчет компьютерной модели выполнен для оценки адекватности по данным бортового журнала ArduPilot.";
lines(end + 1, 1) = "";
lines(end + 1, 1) = "## Сведения о конфигурации изделия";
lines = appendLines(lines, configurationLines(config, configHash));
lines(end + 1, 1) = "";
lines(end + 1, 1) = "## Сведения о наборе данных";
lines(end + 1, 1) = "- Хэш исходного набора данных: " + string(sourceHash);
lines(end + 1, 1) = "- Хэш обработанного набора данных: " + string(processedHash);
lines(end + 1, 1) = channelLine(quality);
lines(end + 1, 1) = "";
lines(end + 1, 1) = "## Предупреждения по качеству исходных данных";
lines = appendLines(lines, warningLines(quality, config));
lines(end + 1, 1) = "";
lines(end + 1, 1) = "## Описание компьютерной модели";
lines(end + 1, 1) = "Использована модель угловых скоростей с уравнением `domega/dt = A * omega + B * u + c`.";
lines(end + 1, 1) = "Внутренние единицы угловых скоростей: рад/с. Для отчетов допускается представление в град/с.";
lines(end + 1, 1) = "";
lines(end + 1, 1) = "## Участки идентификации";
lines = appendLines(lines, segmentLines(segments, 'identification'));
lines(end + 1, 1) = "";
lines(end + 1, 1) = "## Участки проверки";
lines = appendLines(lines, segmentLines(segments, 'validation'));
lines(end + 1, 1) = "";
lines(end + 1, 1) = "## Параметры модели";
lines = appendLines(lines, parameterLines(fit));
lines(end + 1, 1) = "";
lines(end + 1, 1) = "## Показатели расхождения";
lines = appendLines(lines, metricsLines(validation));
lines(end + 1, 1) = "";
lines(end + 1, 1) = "## Матрица валидации";
lines = appendLines(lines, validationMatrixLines(validation));
lines(end + 1, 1) = "";
lines(end + 1, 1) = "## Ограничения применимости";
for index = 1:numel(config.applicability_limits)
    lines(end + 1, 1) = "- " + string(config.applicability_limits(index));
end
lines(end + 1, 1) = "- Критерии приемлемости являются предварительными и подлежат уточнению после накопления валидационного базиса.";
lines(end + 1, 1) = "";
lines(end + 1, 1) = "## Заключение";
lines(end + 1, 1) = "Выполнена оценка адекватности компьютерной модели по данным бортового журнала. Результат применим только в указанных границах применимости.";

text = strjoin(lines, newline);

if strlength(string(filePath)) > 0
    folderPath = fileparts(char(filePath));
    if ~isempty(folderPath) && ~isfolder(folderPath)
        mkdir(folderPath);
    end

    fileId = fopen(filePath, 'w', 'n', 'UTF-8');
    assert(fileId > 0, 'Не удалось открыть отчет для записи.');
    cleanup = onCleanup(@() fclose(fileId));
    fprintf(fileId, '%s', text);
end
end

function value = getField(data, fieldName, defaultValue)
if isstruct(data) && isfield(data, fieldName)
    value = data.(fieldName);
else
    value = defaultValue;
end
end

function lines = appendLines(lines, newLines)
newLines = string(newLines);
lines = [lines; newLines(:)];
end

function lines = configurationLines(config, configHash)
lines = [
    "- Схема: " + string(config.vehicle.frame)
    "- Прошивка: " + string(config.vehicle.firmware)
    "- Хэш прошивки: " + string(config.vehicle.firmware_hash)
    "- Полетный контроллер: " + string(config.vehicle.flight_controller)
    "- Двигатели: " + string(config.vehicle.motors)
    "- Винты по исходному описанию: " + string(config.vehicle.props_declared)
    "- Винты по CAD: " + string(config.vehicle.props_from_cad)
    "- Масса по CAD, кг: " + string(config.vehicle.mass_kg_from_cad)
    "- Хэш конфигурации: " + string(configHash)
    ];
end

function line = channelLine(quality)
if isstruct(quality) && isfield(quality, 'available_channels')
    line = "Использованные каналы: " + strjoin(string(quality.available_channels), ", ") + ".";
else
    line = "Использованные каналы: не заданы.";
end
end

function lines = warningLines(quality, config)
warnings = strings(0, 1);
if isstruct(quality) && isfield(quality, 'warnings')
    warnings = [warnings; string(quality.warnings(:))];
end

if isfield(config, 'warnings')
    warnings = [warnings; string(config.warnings(:))];
end

warnings(end + 1, 1) = "В исходном описании указаны винты Gemfan 8060, а в CAD-выгрузке присутствуют винты APC 7x11E. До уточнения состава изделия это рассматривается как противоречие исходных данных.";
warnings = unique(warnings, 'stable');
lines = "- " + warnings;
end

function lines = segmentLines(segments, fieldName)
if isstruct(segments) && isfield(segments, fieldName)
    segment = segments.(fieldName);
    lines = string(sprintf('- Участок: %.3f-%.3f с.', segment(1), segment(2)));
else
    lines = "- Участок не задан.";
end
end

function lines = parameterLines(fit)
if isstruct(fit) && isfield(fit, 'A')
    lines = [
        "Матрица A:"
        "```"
        string(mat2str(fit.A, 6))
        "```"
        "Матрица B:"
        "```"
        string(mat2str(fit.B, 6))
        "```"
        "Вектор c:"
        "```"
        string(mat2str(fit.c, 6))
        "```"
        ];
else
    lines = "Параметры модели не заданы.";
end
end

function lines = metricsLines(validation)
if ~isstruct(validation) || ~isfield(validation, 'metrics')
    lines = "Показатели расхождения не заданы.";
    return;
end

metrics = validation.metrics;
lines = [
    "| Параметр | Среднеквадратическое отклонение | Среднее абсолютное отклонение | Максимальное абсолютное отклонение | Нормированное среднеквадратическое отклонение | Показатель соответствия, % |"
    "|---|---:|---:|---:|---:|---:|"
    ];
names = ["p", "q", "r"];

for index = 1:3
    lines(end + 1, 1) = sprintf( ...
        '| %s | %.6g | %.6g | %.6g | %.6g | %.3f |', ...
        names(index), ...
        metrics.rmse(index), ...
        metrics.mae(index), ...
        metrics.max_abs(index), ...
        metrics.nrmse(index), ...
        metrics.fit_percent(index));
end
end

function lines = validationMatrixLines(validation)
if ~isstruct(validation) || ~isfield(validation, 'validation_matrix')
    lines = "Матрица валидации не задана.";
    return;
end

matrix = validation.validation_matrix;
lines = [
    "| Идентификатор проверки | Режим | Источник данных | Участок времени | Проверяемые параметры | Показатели расхождения | Критерий приемлемости | Результат | Вывод | Ограничения |"
    "|---|---|---|---|---|---|---|---|---|---|"
    ];

for index = 1:height(matrix)
    lines(end + 1, 1) = "| " + string(matrix.validation_check_id(index)) + ...
        " | " + string(matrix.mode(index)) + ...
        " | " + string(matrix.data_source(index)) + ...
        " | " + string(matrix.time_interval(index)) + ...
        " | " + string(matrix.checked_parameters(index)) + ...
        " | " + string(matrix.metrics(index)) + ...
        " | " + string(matrix.acceptance_criteria(index)) + ...
        " | " + string(matrix.result(index)) + ...
        " | " + string(matrix.conclusion(index)) + ...
        " | " + string(matrix.limitations(index)) + " |";
end
end
