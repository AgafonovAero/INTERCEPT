# Отчет приемки PR №7

Данная проверка выполнена по данным бортового журнала и не является полной независимой валидацией реального изделия по внешним средствам измерений.

Выбранный мотор-маппинг и преобразование CAD -> body являются расчетной гипотезой, сформированной по бортовым журналам. Для окончательного подтверждения требуется физическая проверка подключения моторов, направления вращения и системы координат изделия.

## Идентификация

- Ветка: `codex/pr7-motor-map-frame-calibration`.
- База: `main`.
- PR №6 слит в `main`: `09081d9c49400573e33b6762229c186180324db6`.
- Дата слияния PR №6: `2026-04-25T10:00:46Z`.
- SHA реализации PR №7 перед отчетом приемки: `da872a62911d3a6593d8418f356bc59aea1ae4ce`.

## Сводка изменений

```text
M	README.md
A	config/coordinate_frame_calibration_v0.json
A	config/motor_map_calibration_v0.json
M	docs/data_contract.md
M	docs/model_description.md
A	docs/review/PR-007-ardupilot-params-report.md
A	docs/review/PR-007-coordinate-frame-report.md
A	docs/review/PR-007-model6dof-replay-improvement.md
A	docs/review/PR-007-motor-map-calibration-report.md
M	docs/simulink_preparation.md
M	docs/validation_by_log_method.md
A	matlab/+copter/+data/buildPwmNormalizationFromParams.m
A	matlab/+copter/+data/extractArduPilotParams.m
A	matlab/+copter/+data/inspectArduPilotFrameParams.m
M	matlab/+copter/+data/readBinLog.m
A	matlab/+copter/+identification/calibrateMotorMapAndFrame.m
A	matlab/+copter/+identification/evaluateFrameCandidate.m
A	matlab/+copter/+identification/evaluateMotorMapCandidate.m
A	matlab/+copter/+models/applyMotorMap.m
A	matlab/+copter/+models/buildQuadXAllocationMatrix.m
A	matlab/+copter/+models/generateCadToBodyCandidates.m
A	matlab/+copter/+models/generateMotorMapCandidates.m
A	matlab/+copter/+models/transformInertiaTensor.m
A	matlab/+copter/+models/transformMotorPositions.m
A	matlab/+copter/+models/validateMotorGeometry.m
A	matlab/+copter/+validation/compareModel6DofBeforeAfterCalibration.m
A	matlab/+copter/+validation/diagnoseCoordinateFrameConsistency.m
A	matlab/+copter/+validation/rankReplayCandidates.m
A	matlab/+copter/+validation/replayModel6DofForCandidateSet.m
A	scripts/12_calibrate_motor_map_and_frame.m
A	scripts/calibrateMotorMapAndFrameImpl.m
A	scripts/calibrate_motor_map_and_frame.m
A	tests/TestArduPilotParamExtractionSynthetic.m
A	tests/TestCadToBodyTransformSynthetic.m
A	tests/TestMotorMapCalibrationSynthetic.m
A	tests/TestMotorMapCandidateGeneration.m
A	tests/TestNoBidiControlChars.m
A	tests/TestPwmNormalizationFromParams.m
A	tests/TestQuadXAllocationMatrix.m
M	tests/TestRepositoryFiles.m
```

## Состояние рабочего дерева

Перед добавлением этого отчета рабочее дерево содержало только сам отчет приемки:

```text
?? docs/review/PR-007-acceptance-report.md
```

## Защита чувствительных данных

В Git отслеживаются только служебные файлы:

```text
data/raw/ardupilot/bin/.gitkeep
data/raw/ardupilot/bin/README.md
data/raw/ardupilot/bin/manifest_template.json
docs/validation_basis/.gitkeep
docs/validation_basis/README.md
result/.gitkeep
result/README.md
```

Проверка `.gitignore`:

```text
.gitignore:20:data/raw/ardupilot/bin/*.bin	data/raw/ardupilot/bin/VB-01.alt_50m.BIN
.gitignore:20:data/raw/ardupilot/bin/*.bin	data/raw/ardupilot/bin/full_fly_1.BIN
.gitignore:20:data/raw/ardupilot/bin/*.bin	data/raw/ardupilot/bin/full_fly_2.BIN
.gitignore:34:docs/validation_basis/*.pdf	docs/validation_basis/ValidationBasis_v0.pdf
.gitignore:29:result/*	result/motor_map_frame_calibration/reports/motor_map_frame_calibration_report.md
```

Реальные `.BIN`, PDF ВБ и расчетные выходы `result` не добавлены в Git.

## Проверка JSON

```text
config/vehicle_qc_ardupilot_v0.json: OK
config/model6dof_replay_v0.json: OK
config/model6dof_parameter_fit_v0.json: OK
config/motor_map_calibration_v0.json: OK
config/coordinate_frame_calibration_v0.json: OK
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
   53 Passed, 0 Failed, 0 Incomplete.
   33.7429 seconds testing time.
```

Добавленные тесты PR №7:

- `TestArduPilotParamExtractionSynthetic`;
- `TestPwmNormalizationFromParams`;
- `TestQuadXAllocationMatrix`;
- `TestMotorMapCandidateGeneration`;
- `TestCadToBodyTransformSynthetic`;
- `TestMotorMapCalibrationSynthetic`;
- `TestNoBidiControlChars`.

## Сценарий реальной калибровки

Команда:

```matlab
run('scripts/calibrate_motor_map_and_frame.m')
```

Результат:

```text
Калибровочный анализ журнала: data/raw/ardupilot/bin/VB-01.alt_50m.BIN
Калибровочный анализ журнала: data/raw/ardupilot/bin/full_fly_1.BIN
Калибровочный анализ журнала: data/raw/ardupilot/bin/full_fly_2.BIN
Калибровочный анализ PR №7 сформирован.
```

Реальные журналы были доступны локально и обработаны:

- `data/raw/ardupilot/bin/VB-01.alt_50m.BIN`;
- `data/raw/ardupilot/bin/full_fly_1.BIN`;
- `data/raw/ardupilot/bin/full_fly_2.BIN`.

## Результаты калибровки

- Проверено motor map candidates: 40.
- Проверено frame candidates: 7.
- Выбранный motor map candidate: `perm_7`.
- Выбранный CAD -> body candidate: `identity`.
- Извлечены PARM: 1297, 1243 и 1239 записей по трем журналам.
- `FRAME_CLASS` и `FRAME_TYPE` интерпретированы как `QUAD/X` для обработанных журналов.

## Ограничения

- PR №7 не является этапом полной независимой валидации.
- PR №7 не выполняет перенос в Simulink.
- Validation-окна не используются для выбора кандидатной конфигурации.
- Выбранная конфигурация требует физического подтверждения.
- Отсутствие ESC telemetry ограничивает прямое подтверждение направления вращения и оборотов моторов.
- Если replay Model6DOF не улучшается, это считается инженерным результатом, а не ошибкой тестов.

## Рекомендации для PR №8

- Физически подтвердить подключение моторов и направления вращения.
- Сопоставить выбранный motor map candidate с параметрами `SERVO*_FUNCTION`.
- Проверить выбранную гипотезу `CAD -> body` на независимых окнах.
- После подтверждения мотор-маппинга продолжить уточнение аэродинамики и параметров ВМГ.
- Перенос в Simulink выполнять только после устойчивого MATLAB replay-контура.

## Итог

PR №7 готов к внешней проверке. Все автоматические MATLAB-тесты пройдены, реальные журналы обработаны локально, чувствительные исходные данные не добавлены в Git.
