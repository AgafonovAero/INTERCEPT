% Применяет физическую конфигурацию и стендовую ВМГ, если данные доступны.

projectRoot = getProjectRoot();
run(fullfile(projectRoot, 'matlab', 'startup.m'));

vehicleConfig = copter.config.loadConfig(fullfile(projectRoot, 'config', 'vehicle_qc_ardupilot_v0.json'));
physicalFile = fullfile(projectRoot, 'data', 'raw', 'physical_checks', 'physical_configuration_check.json');
benchFile = fullfile(projectRoot, 'data', 'raw', 'bench', 'propulsion', 'propulsion_static_test.csv');
reviewFolder = fullfile(projectRoot, 'docs', 'review');
resultFolder = fullfile(projectRoot, 'result', 'confirmed_configuration_replay');
ensureFolder(reviewFolder);
ensureFolder(resultFolder);

[physicalCheck, physicalLoadReport] = copter.physical.loadPhysicalConfigurationCheck(physicalFile);
selectedCandidate = table("perm_7", {[2; 1; 3; 4]}, {[1; -1; 1; -1]}, ...
    'VariableNames', {'candidate_id', 'motor_order', 'spin_sign'});
[confirmedConfig, configReport] = copter.physical.buildConfirmedVehicleConfig( ...
    vehicleConfig, physicalCheck, selectedCandidate);

[benchData, benchReadReport] = copter.propulsion.readPropulsionBenchData(benchFile);
[thrustModel, thrustReport] = copter.propulsion.fitStaticThrustModel(benchData);
[currentModel, currentReport] = copter.propulsion.fitCurrentModel(benchData);
[confirmedConfig, propulsionReport] = copter.propulsion.updateModel6DofPropulsionParams( ...
    confirmedConfig, thrustModel, currentModel, struct());

comparison = configReport.comparison;
copter.physical.writePhysicalConfigurationReport( ...
    fullfile(reviewFolder, 'PR-008-physical-configuration-report.md'), ...
    physicalCheck, comparison, confirmedConfig);
writeStatusReport(fullfile(reviewFolder, 'PR-008-model6dof-configuration-status.md'), ...
    confirmedConfig, physicalLoadReport, benchReadReport, thrustReport, currentReport, propulsionReport);

save(fullfile(resultFolder, 'confirmed_vehicle_config_pr8.mat'), ...
    'confirmedConfig', 'configReport', 'thrustModel', 'currentModel');
fprintf('Статус конфигурации Model6DOF сформирован.\n');

function writeStatusReport(filePath, config, physicalReport, benchReport, thrustReport, currentReport, propulsionReport)
status = config.configuration_status;
lines = [
    "# Статус конфигурации Model6DOF PR №8"
    ""
    mandatoryPhrase()
    ""
    hypothesisPhrase()
    ""
    "## Статусы"
    "- motor_map_status: `" + status.motor_map_status + "`."
    "- spin_sign_status: `" + status.spin_sign_status + "`."
    "- cad_to_body_status: `" + status.cad_to_body_status + "`."
    "- propulsion_model_status: `" + status.propulsion_model_status + "`."
    "- propeller_configuration_status: `" + status.propeller_configuration_status + "`."
    ""
    "## Источники"
    "- Physical check: `" + physicalReport.status + "`."
    "- Bench data: `" + benchReport.status + "`."
    "- Thrust model: `" + thrustReport.status + "`."
    "- Current model: `" + currentReport.status + "`."
    "- Propulsion update: `" + propulsionReport.status + "`."
    ""
    "## Replay"
    "Повторный replay с физически подтвержденной конфигурацией не выполнялся, потому что заполненные physicalCheck или bench data отсутствуют."
    "После появления данных сценарий может быть повторен без изменения расчетного ядра."
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
