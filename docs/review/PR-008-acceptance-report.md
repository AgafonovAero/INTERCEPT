# Отчет приемки PR №8

Данная проверка выполнена по данным бортового журнала и не является полной независимой валидацией реального изделия по внешним средствам измерений.

До физического подтверждения подключения моторов, направлений вращения и установленного типа винтов выбранная конфигурация Model6DOF должна рассматриваться как расчетная гипотеза.

## Идентификация

- Ветка: `codex/pr8-physical-config-and-propulsion-baseline`.
- База: `main`.
- PR №7 слит в `main`: `d4b297b475b7191d90c1e47b9b80b9d903dc0351`.
- Дата слияния PR №7: `2026-04-25T12:03:28Z`.
- SHA реализации PR №8 перед отчетом приемки: `5f262c69aa2821391d4dc3c3b44076dc4a6e353c`.

## Сводка изменений

```text
M	.gitignore
M	README.md
A	config/confirmed_vehicle_config_v1_template.json
A	config/physical_configuration_check_v0.json
A	config/propulsion_bench_test_v0.json
A	data/raw/bench/propulsion/.gitkeep
A	data/raw/bench/propulsion/README.md
A	data/raw/bench/propulsion/battery_discharge_test_template.csv
A	data/raw/bench/propulsion/esc_current_voltage_template.csv
A	data/raw/bench/propulsion/propulsion_static_test_template.csv
A	data/raw/physical_checks/.gitkeep
A	data/raw/physical_checks/README.md
A	data/raw/physical_checks/motor_order_check_template.csv
A	data/raw/physical_checks/motor_spin_check_template.csv
A	data/raw/physical_checks/physical_configuration_check_template.json
A	data/raw/physical_checks/propeller_installation_check_template.csv
M	docs/data_contract.md
M	docs/model_description.md
A	docs/review/PR-008-model6dof-configuration-status.md
A	docs/review/PR-008-physical-configuration-report.md
A	docs/review/PR-008-physical-verification-package.md
A	docs/review/PR-008-propulsion-bench-template-report.md
M	docs/simulink_preparation.md
M	docs/validation_by_log_method.md
M	matlab/+copter/+config/defaultVehicleConfig.m
M	matlab/+copter/+models/Model6DOF.m
A	matlab/+copter/+physical/buildConfirmedVehicleConfig.m
A	matlab/+copter/+physical/comparePhysicalCheckWithCandidate.m
A	matlab/+copter/+physical/loadPhysicalConfigurationCheck.m
A	matlab/+copter/+physical/validatePhysicalConfigurationCheck.m
A	matlab/+copter/+physical/writePhysicalConfigurationReport.m
A	matlab/+copter/+propulsion/compareBenchThrustWithLogHover.m
A	matlab/+copter/+propulsion/fitBatteryInternalResistance.m
A	matlab/+copter/+propulsion/fitCurrentModel.m
A	matlab/+copter/+propulsion/fitStaticThrustModel.m
A	matlab/+copter/+propulsion/readPropulsionBenchData.m
A	matlab/+copter/+propulsion/updateModel6DofPropulsionParams.m
A	matlab/+copter/+propulsion/validatePropulsionBenchData.m
A	scripts/13_generate_physical_verification_package.m
A	scripts/14_fit_propulsion_from_bench_data.m
A	scripts/15_apply_confirmed_configuration_and_replay.m
A	scripts/applyConfirmedConfigurationAndReplayImpl.m
A	scripts/apply_confirmed_configuration_and_replay.m
A	scripts/fitPropulsionFromBenchDataImpl.m
A	scripts/fit_propulsion_from_bench_data.m
A	scripts/generatePhysicalVerificationPackageImpl.m
A	scripts/generate_physical_verification_package.m
A	tests/TestBatteryInternalResistanceSynthetic.m
A	tests/TestComparePhysicalCheckWithCandidate.m
A	tests/TestConfirmedVehicleConfigStatus.m
A	tests/TestNoSensitiveBenchDataInGit.m
A	tests/TestPhysicalConfigurationCheckSynthetic.m
A	tests/TestPropulsionBenchDataSynthetic.m
M	tests/TestRepositoryFiles.m
A	tests/TestStaticThrustModelFitSynthetic.m
```

## Защита чувствительных данных

В Git отслеживаются только служебные файлы и шаблоны:

```text
data/raw/ardupilot/bin/.gitkeep
data/raw/ardupilot/bin/README.md
data/raw/ardupilot/bin/manifest_template.json
data/raw/bench/propulsion/.gitkeep
data/raw/bench/propulsion/README.md
data/raw/bench/propulsion/battery_discharge_test_template.csv
data/raw/bench/propulsion/esc_current_voltage_template.csv
data/raw/bench/propulsion/propulsion_static_test_template.csv
data/raw/physical_checks/.gitkeep
data/raw/physical_checks/README.md
data/raw/physical_checks/motor_order_check_template.csv
data/raw/physical_checks/motor_spin_check_template.csv
data/raw/physical_checks/physical_configuration_check_template.json
data/raw/physical_checks/propeller_installation_check_template.csv
docs/validation_basis/.gitkeep
docs/validation_basis/README.md
result/.gitkeep
result/README.md
```

Проверка игнорирования реальных данных:

```text
.gitignore:39:data/raw/physical_checks/*	data/raw/physical_checks/physical_configuration_check.json
.gitignore:39:data/raw/physical_checks/*	data/raw/physical_checks/motor_spin_check.csv
.gitignore:47:data/raw/bench/propulsion/*	data/raw/bench/propulsion/propulsion_static_test.csv
.gitignore:47:data/raw/bench/propulsion/*	data/raw/bench/propulsion/battery_discharge_test.csv
.gitignore:31:result/*	result/propulsion_bench_fit/propulsion_bench_fit.mat
```

Реальные `.BIN`, PDF ВБ, стендовые данные, physicalCheck и `result` не добавлены в Git.

## Проверка JSON

```text
config/physical_configuration_check_v0.json: OK
config/propulsion_bench_test_v0.json: OK
config/confirmed_vehicle_config_v1_template.json: OK
config/vehicle_qc_ardupilot_v0.json: OK
```

## MATLAB-тесты

Команды:

```matlab
run('matlab/startup.m')
run('matlab/run_all_tests.m')
```

Результат:

```text
Totals:
   63 Passed, 0 Failed, 0 Incomplete.
   58.4276 seconds testing time.
```

Добавленные тесты PR №8:

- `TestPhysicalConfigurationCheckSynthetic`;
- `TestComparePhysicalCheckWithCandidate`;
- `TestPropulsionBenchDataSynthetic`;
- `TestStaticThrustModelFitSynthetic`;
- `TestBatteryInternalResistanceSynthetic`;
- `TestConfirmedVehicleConfigStatus`;
- `TestNoSensitiveBenchDataInGit`.

## Сценарии PR №8

Выполнены:

```matlab
run('scripts/generate_physical_verification_package.m')
run('scripts/fit_propulsion_from_bench_data.m')
run('scripts/apply_confirmed_configuration_and_replay.m')
```

Результат:

```text
Пакет физической проверки сформирован.
Отчет стендовой ВМГ сформирован.
Статус конфигурации Model6DOF сформирован.
```

Номерные файлы этапов созданы:

- `scripts/13_generate_physical_verification_package.m`;
- `scripts/14_fit_propulsion_from_bench_data.m`;
- `scripts/15_apply_confirmed_configuration_and_replay.m`.

## Статус данных

- Physical check: `not_available`.
- Bench data: `not_available`.
- Motor map status: `hypothesis_from_log`.
- Spin sign status: `hypothesis_from_log`.
- CAD -> body status: `hypothesis_from_log`.
- Propulsion model status: `bench_data_not_available`.
- Propeller configuration status: `inconsistent_sources`.

## Созданные отчеты

- `docs/review/PR-008-physical-verification-package.md`;
- `docs/review/PR-008-physical-configuration-report.md`;
- `docs/review/PR-008-propulsion-bench-template-report.md`;
- `docs/review/PR-008-model6dof-configuration-status.md`;
- `docs/review/PR-008-acceptance-report.md`.

## Ограничения

- PR №8 не является полной независимой валидацией.
- PR №8 не выполняет перенос в Simulink.
- Физическая проверка изделия в рабочей среде отсутствует.
- Стендовые данные ВМГ в рабочей среде отсутствуют.
- Без physicalCheck выбранный motor map `perm_7` остается расчетной гипотезой.
- Без стенда параметры тяги, тока и батареи не считаются подтвержденными.

## Рекомендации для PR №9

- Заполнить `data/raw/physical_checks/physical_configuration_check.json`.
- Провести безопасную проверку направления вращения со снятыми винтами, если тяга не требуется.
- Подготовить `data/raw/bench/propulsion/propulsion_static_test.csv`.
- Подготовить `data/raw/bench/propulsion/battery_discharge_test.csv`.
- После появления данных повторить сценарии PR №8 и replay Model6DOF.

## Итог

PR №8 готов к внешней проверке. Все автоматические MATLAB-тесты пройдены, шаблоны физической проверки и стенда созданы, чувствительные данные не добавлены в Git.
