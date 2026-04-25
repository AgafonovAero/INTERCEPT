function writePhysicalConfigurationReport(filePath, physicalCheck, comparison, confirmedConfig)
% Формирует отчет о физической конфигурации изделия.

if nargin < 4
    confirmedConfig = struct();
end

fileId = fopen(filePath, 'w', 'n', 'UTF-8');
assert(fileId > 0, 'Не удалось открыть отчет физической конфигурации.');
cleanup = onCleanup(@() fclose(fileId));

fprintf(fileId, '# Физическая конфигурация PR №8\n\n');
fprintf(fileId, '%s\n\n', mandatoryPhrase());
fprintf(fileId, '%s\n\n', hypothesisPhrase());
fprintf(fileId, '## Статус\n\n');
fprintf(fileId, '- Физическая проверка: `%s`.\n', string(comparison.status));
fprintf(fileId, '- Motor map status: `%s`.\n', readStatus(confirmedConfig, "motor_map_status"));
fprintf(fileId, '- Spin sign status: `%s`.\n', readStatus(confirmedConfig, "spin_sign_status"));
fprintf(fileId, '- CAD -> body status: `%s`.\n', readStatus(confirmedConfig, "cad_to_body_status"));
fprintf(fileId, '- Propeller status: `%s`.\n\n', readStatus(confirmedConfig, "propeller_configuration_status"));

fprintf(fileId, '## Motor map\n\n');
fprintf(fileId, '- Физический порядок RCOU: `%s`.\n', join(string(comparison.physical_motor_order(:)), ", "));
fprintf(fileId, '- Знаки вращения: `%s`.\n', join(string(comparison.physical_spin_sign(:)), ", "));
fprintf(fileId, '- Совпадение с PR №7: `%s`.\n\n', string(comparison.matches_pr7_candidate));

fprintf(fileId, '## Винты\n\n');
fprintf(fileId, '- По исходному описанию: Gemfan 8060, 3 лопасти.\n');
fprintf(fileId, '- По CAD-выгрузке: APC 7x11E.\n');
fprintf(fileId, '- До физического подтверждения это остается противоречием исходных данных.\n\n');

fprintf(fileId, '## Рекомендации\n\n');
fprintf(fileId, '- %s\n', string(comparison.recommendation));
if isstruct(physicalCheck) && isfield(physicalCheck, 'file_path')
    fprintf(fileId, '- Источник проверки: `%s`.\n', displayPath(physicalCheck.file_path));
end
end

function value = readStatus(config, fieldName)
value = "unknown";
if isstruct(config) && isfield(config, 'configuration_status') ...
        && isfield(config.configuration_status, char(fieldName))
    value = string(config.configuration_status.(char(fieldName)));
end
end

function text = mandatoryPhrase()
text = "Данная проверка выполнена по данным бортового журнала и не является полной независимой валидацией реального изделия по внешним средствам измерений.";
end

function text = hypothesisPhrase()
text = "До физического подтверждения подключения моторов, направлений вращения и установленного типа винтов выбранная конфигурация Model6DOF должна рассматриваться как расчетная гипотеза.";
end

function text = displayPath(pathValue)
text = string(pathValue);
marker = "data" + filesep + "raw" + filesep;
position = strfind(text, marker);
if ~isempty(position)
    text = extractAfter(text, position(1) - 1);
end
text = replace(text, "\", "/");
end
