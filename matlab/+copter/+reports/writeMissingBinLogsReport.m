function writeMissingBinLogsReport(filePath, missingLogs)
% Записывает отчет об отсутствующих бортовых журналах DataFlash.

fileId = fopen(filePath, 'w', 'n', 'UTF-8');
assert(fileId > 0, 'Не удалось открыть отчет об отсутствующих журналах для записи.');
cleanup = onCleanup(@() fclose(fileId));

fprintf(fileId, '# Отсутствующие бортовые журналы DataFlash\n\n');
fprintf(fileId, 'Реальные .BIN журналы отсутствовали в рабочей среде MATLAB для следующих путей:\n\n');
for index = 1:numel(missingLogs)
    fprintf(fileId, '- `%s`\n', missingLogs(index));
end

fprintf(fileId, '\nРазместите файлы в каталоге `data/raw/ardupilot/bin/` и повторите команду:\n\n');
fprintf(fileId, '```matlab\n');
fprintf(fileId, 'run(''scripts/07_analyze_bin_logs.m'')\n');
fprintf(fileId, '```\n');
end
