function writeRateIdentificationReport(filePath, model, fitReport, validationReport, splitRegistry)
% Формирует отчет первой идентификации ModelRate по участкам.

folderPath = fileparts(char(filePath));
if ~isempty(folderPath) && ~isfolder(folderPath)
    mkdir(folderPath);
end

fileId = fopen(filePath, 'w', 'n', 'UTF-8');
assert(fileId > 0, 'Не удалось открыть отчет идентификации ModelRate для записи.');
cleanup = onCleanup(@() fclose(fileId));

fprintf(fileId, '# Первая идентификация ModelRate по бортовым журналам\n\n');
fprintf(fileId, 'Данная проверка выполнена по данным бортового журнала и не является полной независимой валидацией реального изделия по внешним средствам измерений.\n\n');
fprintf(fileId, '## Описание компьютерной модели\n\n');
fprintf(fileId, '`ModelRate` является моделью первого уровня для угловых скоростей `omega = [p; q; r]`.\n\n');
fprintf(fileId, '```text\n');
fprintf(fileId, 'domega/dt = A * omega + B * u + c\n');
fprintf(fileId, '```\n\n');

fprintf(fileId, '## Участки identification и validation\n\n');
writeSplitTable(fileId, splitRegistry);

fprintf(fileId, '\n## Параметры модели\n\n');
writeMatrix(fileId, 'A', model.A);
writeMatrix(fileId, 'B', model.B);
writeMatrix(fileId, 'c', model.c);

fprintf(fileId, '\n## Отчет идентификации\n\n');
writeFitReport(fileId, fitReport);

fprintf(fileId, '\n## Показатели проверки на validation-участках\n\n');
writeMetrics(fileId, validationReport);

fprintf(fileId, '\n## Ограничения применимости\n\n');
fprintf(fileId, '- ModelRate не является полной моделью движения изделия.\n');
fprintf(fileId, '- Model6DOF будет настраиваться позже.\n');
fprintf(fileId, '- Реальные записи ESC не обнаружены, что ограничивает будущую модель винтомоторной группы и аккумулятора.\n');
fprintf(fileId, '- Графики и расчетные выходы хранятся локально в `result/rate_identification/` и не добавляются в Git.\n');
end

function writeSplitTable(fileId, splitRegistry)
if isempty(splitRegistry)
    fprintf(fileId, 'Участки не выделены.\n');
    return;
end

fprintf(fileId, '| segment_id | журнал | ВБ | тип | роль | начало, с | конец, с |\n');
fprintf(fileId, '|---|---|---|---|---|---:|---:|\n');
for index = 1:height(splitRegistry)
    fprintf(fileId, '| %s | %s | %s | %s | %s | %.3f | %.3f |\n', ...
        splitRegistry.segment_id(index), ...
        splitRegistry.log_file(index), ...
        splitRegistry.candidate_validation_case_id(index), ...
        splitRegistry.segment_type(index), ...
        splitRegistry.split_role(index), ...
        splitRegistry.t_start_s(index), ...
        splitRegistry.t_end_s(index));
end
end

function writeMatrix(fileId, name, value)
fprintf(fileId, '`%s`:\n\n', name);
fprintf(fileId, '```text\n');
for rowIndex = 1:size(value, 1)
    fprintf(fileId, '% .8g ', value(rowIndex, :));
    fprintf(fileId, '\n');
end
fprintf(fileId, '```\n\n');
end

function writeFitReport(fileId, fitReport)
if isempty(fitReport)
    fprintf(fileId, 'Идентификация не выполнена.\n');
    return;
end

fprintf(fileId, '| segment_id | источник входа | RMSE R | RMSE P | RMSE Y |\n');
fprintf(fileId, '|---|---|---:|---:|---:|\n');
for index = 1:height(fitReport)
    fprintf(fileId, '| %s | %s | %.6g | %.6g | %.6g |\n', ...
        fitReport.segment_id(index), ...
        fitReport.input_source(index), ...
        fitReport.derivative_rmse_R(index), ...
        fitReport.derivative_rmse_P(index), ...
        fitReport.derivative_rmse_Y(index));
end
end

function writeMetrics(fileId, validationReport)
metrics = validationReport.metricsBySegment;
if isempty(metrics)
    fprintf(fileId, 'Показатели не рассчитаны: validation-участки отсутствуют или расчет не выполнен.\n');
else
    fprintf(fileId, '| segment_id | ось | RMSE, рад/с | MAE, рад/с | max, рад/с | соответствие, %% |\n');
    fprintf(fileId, '|---|---|---:|---:|---:|---:|\n');
    for index = 1:height(metrics)
        fprintf(fileId, '| %s | %s | %.6g | %.6g | %.6g | %.3f |\n', ...
            metrics.segment_id(index), ...
            metrics.axis(index), ...
            metrics.rmse_rad_s(index), ...
            metrics.mae_rad_s(index), ...
            metrics.max_abs_rad_s(index), ...
            metrics.fit_percent(index));
    end
end

fprintf(fileId, '\n### Предварительное заключение\n\n');
conclusion = validationReport.channelConclusion;
for index = 1:height(conclusion)
    fprintf(fileId, '- %s: средний показатель соответствия %.3f %%, критерий %.3f %%. %s\n', ...
        conclusion.axis(index), ...
        conclusion.mean_fit_percent(index), ...
        conclusion.fit_min_percent(index), ...
        conclusion.conclusion(index));
end
end
