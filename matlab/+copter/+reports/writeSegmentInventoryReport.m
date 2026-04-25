function writeSegmentInventoryReport(filePath, registry, logReports)
% Формирует отчет о найденных участках-кандидатах ВБ.

if nargin < 3
    logReports = struct([]);
end

folderPath = fileparts(char(filePath));
if ~isempty(folderPath) && ~isfolder(folderPath)
    mkdir(folderPath);
end

fileId = fopen(filePath, 'w', 'n', 'UTF-8');
assert(fileId > 0, 'Не удалось открыть отчет реестра участков для записи.');
cleanup = onCleanup(@() fclose(fileId));

fprintf(fileId, '# Реестр участков-кандидатов ВБ PR №3\n\n');
fprintf(fileId, 'Данная проверка выполнена по данным бортового журнала и не является полной независимой валидацией реального изделия по внешним средствам измерений.\n\n');
fprintf(fileId, '## Контроль условия В-01\n\n');
fprintf(fileId, 'Для `VB-01.alt_50m.BIN` имя файла указывает `alt_50m`, ');
fprintf(fileId, 'а случай `В-01` в валидационном базисе задан как установившееся висение на высоте 30 м. ');
fprintf(fileId, 'До ручного подтверждения по журналу это считается несоответствием имени файла и условия ВБ.\n\n');
fprintf(fileId, '## Проанализированные журналы\n\n');
writeLogReports(fileId, logReports);
fprintf(fileId, '\n## Найденные участки\n\n');

if isempty(registry)
    fprintf(fileId, 'Участки-кандидаты не выделены.\n');
    return;
end

fprintf(fileId, '| segment_id | журнал | ВБ | тип | начало, с | конец, с | высота, м | Vz, м/с | score | роль |\n');
fprintf(fileId, '|---|---|---|---|---:|---:|---:|---:|---:|---|\n');
hasRole = any(string(registry.Properties.VariableNames) == "split_role");
for index = 1:height(registry)
    role = "";
    if hasRole
        role = string(registry.split_role(index));
    end

    fprintf(fileId, '| %s | %s | %s | %s | %.3f | %.3f | %.3f | %.3f | %.3f | %s |\n', ...
        registry.segment_id(index), ...
        registry.log_file(index), ...
        registry.candidate_validation_case_id(index), ...
        registry.segment_type(index), ...
        registry.t_start_s(index), ...
        registry.t_end_s(index), ...
        registry.mean_altitude_m(index), ...
        registry.mean_vertical_speed_mps(index), ...
        registry.score(index), ...
        role);
end

fprintf(fileId, '\n## Предупреждения и ограничения\n\n');
for index = 1:height(registry)
    if strlength(string(registry.notes(index))) > 0
        fprintf(fileId, '- `%s`: %s\n', registry.segment_id(index), registry.notes(index));
    end
end
end

function writeLogReports(fileId, logReports)
if isempty(logReports)
    fprintf(fileId, 'Сведения о журналах отсутствуют.\n');
    return;
end

fprintf(fileId, '| журнал | строк | длительность, с | предупреждения |\n');
fprintf(fileId, '|---|---:|---:|---|\n');
for index = 1:numel(logReports)
    warningsText = "";
    if isfield(logReports(index), 'warnings')
        warningsText = strjoin(string(logReports(index).warnings), " ");
    end

    fprintf(fileId, '| %s | %d | %.3f | %s |\n', ...
        string(logReports(index).file_name), ...
        logReports(index).row_count, ...
        logReports(index).duration_s, ...
        warningsText);
end
end
