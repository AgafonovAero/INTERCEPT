% Формирует пакет шаблонов физической проверки конфигурации изделия.

projectRoot = getProjectRoot();
run(fullfile(projectRoot, 'matlab', 'startup.m'));

physicalFolder = fullfile(projectRoot, 'data', 'raw', 'physical_checks');
reviewFolder = fullfile(projectRoot, 'docs', 'review');
ensureFolder(physicalFolder);
ensureFolder(reviewFolder);

reportPath = fullfile(reviewFolder, 'PR-008-physical-verification-package.md');
lines = [
    "# Пакет физической проверки PR №8"
    ""
    mandatoryPhrase()
    ""
    hypothesisPhrase()
    ""
    "## Назначение"
    "Пакет нужен для снятия неоднозначности PR №7 по motor map, spin signs и CAD -> body."
    ""
    "## Файлы для заполнения"
    "- `data/raw/physical_checks/physical_configuration_check_template.json`."
    "- `data/raw/physical_checks/motor_spin_check_template.csv`."
    "- `data/raw/physical_checks/motor_order_check_template.csv`."
    "- `data/raw/physical_checks/propeller_installation_check_template.csv`."
    ""
    "## Обязательные поля"
    "- номер мотора и физическое положение;"
    "- канал `RCOU` или `SERVO`;"
    "- направление вращения;"
    "- установленный тип винта;"
    "- направление установки винта;"
    "- направление носа изделия;"
    "- исполнитель и дата проверки."
    ""
    "## Меры безопасности"
    "Проверка выполняется только уполномоченным специалистом."
    "При проверке направления вращения без необходимости тяги воздушные винты должны быть сняты."
    ""
    "## Статус"
    "Если заполненные файлы отсутствуют, конфигурация остается в состоянии `hypothesis_only`."
    ];
writelines(lines, reportPath);

fprintf('Пакет физической проверки сформирован: %s\n', reportPath);

function projectRoot = getProjectRoot()
projectRoot = pwd;
if ~isfolder(fullfile(projectRoot, 'matlab'))
    projectRoot = fileparts(projectRoot);
end
end

function ensureFolder(folderPath)
if ~isfolder(folderPath)
    mkdir(folderPath);
end
end

function text = mandatoryPhrase()
text = "Данная проверка выполнена по данным бортового журнала и не является полной независимой валидацией реального изделия по внешним средствам измерений.";
end

function text = hypothesisPhrase()
text = "До физического подтверждения подключения моторов, направлений вращения и установленного типа винтов выбранная конфигурация Model6DOF должна рассматриваться как расчетная гипотеза.";
end
