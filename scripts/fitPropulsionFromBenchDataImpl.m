% Подбирает первичные модели тяги, тока и аккумулятора по стендовым данным.

projectRoot = getProjectRoot();
run(fullfile(projectRoot, 'matlab', 'startup.m'));

benchFolder = fullfile(projectRoot, 'data', 'raw', 'bench', 'propulsion');
resultFolder = fullfile(projectRoot, 'result', 'propulsion_bench_fit');
reviewFolder = fullfile(projectRoot, 'docs', 'review');
ensureFolder(resultFolder);
ensureFolder(reviewFolder);

staticFile = fullfile(benchFolder, 'propulsion_static_test.csv');
batteryFile = fullfile(benchFolder, 'battery_discharge_test.csv');
[benchData, benchReadReport] = copter.propulsion.readPropulsionBenchData(staticFile);
benchQuality = copter.propulsion.validatePropulsionBenchData(benchData);
[thrustModel, thrustFitReport] = copter.propulsion.fitStaticThrustModel(benchData);
[currentModel, currentFitReport] = copter.propulsion.fitCurrentModel(benchData);
[batteryData, batteryReadReport] = copter.propulsion.readPropulsionBenchData(batteryFile);
[batteryModel, batteryFitReport] = copter.propulsion.fitBatteryInternalResistance(batteryData);

save(fullfile(resultFolder, 'propulsion_bench_fit.mat'), ...
    'thrustModel', 'currentModel', 'batteryModel', 'benchReadReport', 'benchQuality');

reportPath = fullfile(reviewFolder, 'PR-008-propulsion-bench-template-report.md');
writeBenchReport(reportPath, benchReadReport, benchQuality, thrustFitReport, currentFitReport, ...
    batteryReadReport, batteryFitReport);
fprintf('Отчет стендовой ВМГ сформирован: %s\n', reportPath);

function writeBenchReport(filePath, benchReadReport, quality, thrustReport, currentReport, batteryReadReport, batteryReport)
lines = [
    "# Стендовые данные ВМГ PR №8"
    ""
    mandatoryPhrase()
    ""
    hypothesisPhrase()
    ""
    "## Шаблоны"
    "- `data/raw/bench/propulsion/propulsion_static_test_template.csv`."
    "- `data/raw/bench/propulsion/battery_discharge_test_template.csv`."
    "- `data/raw/bench/propulsion/esc_current_voltage_template.csv`."
    ""
    "## Статус данных"
    "- Static bench data: `" + benchReadReport.status + "`."
    "- Battery bench data: `" + batteryReadReport.status + "`."
    "- Quality status: `" + quality.status + "`."
    ""
    "## Модели"
    "- Static thrust model: `" + thrustReport.status + "`."
    "- Current model: `" + currentReport.status + "`."
    "- Battery model: `" + batteryReport.status + "`."
    ""
    "## Ограничение"
    "Без стендовых данных параметры тяги, тока и аккумулятора остаются демонстрационными или журнальными гипотезами."
    ];
writelines(lines, filePath);
end

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
