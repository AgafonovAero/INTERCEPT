function writeBinAnalysisSummary(markdownPath, jsonPath, summary, logData)
% Записывает краткий отчет анализа бортового журнала DataFlash.

writeMarkdown(markdownPath, summary, logData);
copter.utils.writeJson(jsonPath, makeSerializableSummary(summary, logData));
end

function writeMarkdown(filePath, summary, logData)
fileId = fopen(filePath, 'w', 'n', 'UTF-8');
assert(fileId > 0, 'Не удалось открыть отчет анализа BIN для записи.');
cleanup = onCleanup(@() fclose(fileId));

fprintf(fileId, '# Анализ бортового журнала DataFlash\n\n');
fprintf(fileId, 'Файл: `%s`\n\n', summary.file_name);
fprintf(fileId, 'Размер, байт: `%d`\n\n', summary.file_size_bytes);
fprintf(fileId, 'Длительность по TimeUS, с: `%.3f`\n\n', summary.duration_s);
fprintf(fileId, 'Количество пакетов: `%d`\n\n', summary.total_packets);
fprintf(fileId, '## Сообщения\n\n');
fprintf(fileId, '| Сообщение | Тип | Количество | TimeUS | Частота, Гц | Поля |\n');
fprintf(fileId, '|---|---:|---:|---|---:|---|\n');

for rowIndex = 1:height(summary.messages)
    row = summary.messages(rowIndex, :);
    fprintf(fileId, '| %s | %d | %d | %s | %.3f | %s |\n', ...
        row.message_name, ...
        row.message_type_id, ...
        row.count, ...
        string(row.has_TimeUS), ...
        row.estimated_rate_hz, ...
        row.fields);
end

fprintf(fileId, '\n## Прочитанные таблицы\n\n');
messageNames = string(fieldnames(logData.messages));
if isempty(messageNames)
    fprintf(fileId, 'Ключевые таблицы не созданы.\n\n');
else
    for index = 1:numel(messageNames)
        messageTable = logData.messages.(messageNames(index));
        fprintf(fileId, '- `%s`: %d строк.\n', messageNames(index), height(messageTable));
    end
    fprintf(fileId, '\n');
end

fprintf(fileId, '## Предупреждения\n\n');
if isempty(logData.warnings)
    fprintf(fileId, 'Предупреждения отсутствуют.\n');
else
    for index = 1:numel(logData.warnings)
        fprintf(fileId, '- %s\n', logData.warnings(index));
    end
end
end

function data = makeSerializableSummary(summary, logData)
data = struct();
data.file_name = summary.file_name;
data.file_size_bytes = summary.file_size_bytes;
data.duration_s = summary.duration_s;
data.total_packets = summary.total_packets;
data.messages = table2struct(summary.messages);
data.key_messages = table2struct(summary.key_messages);
data.read_tables = string(fieldnames(logData.messages));
data.warnings = logData.warnings;
end
