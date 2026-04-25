# Отчет приемки PR №6

Данная проверка выполнена по данным бортового журнала и не является полной независимой валидацией реального изделия по внешним средствам измерений.

## Идентификация

- Номер PR: PR №6.
- Ветка: `codex/pr6-model6dof-log-replay-identification`.
- SHA проверяемой реализации перед добавлением данного отчета: `28e84d32a6935d49ae4e268f53c786a67794aa6d`.
- Дата проверки: `2026-04-25 12:41:17 +03:00`.
- Базовая ветка: `main`.

## Подтверждение слияния PR №5

PR №5 слит в `main` стандартным способом проекта.

```text
number: 5
state: MERGED
baseRefName: main
headRefName: codex/pr5-visual-flight-demo
isDraft: false
mergeCommit: 131cbf7a6e1ffe65ea84f53bd895589eebe91b6c
mergedAt: 2026-04-25T09:23:01Z
origin/main: 131cbf7a6e1ffe65ea84f53bd895589eebe91b6c
```

## Сводка изменений

Вывод `git diff --name-status main...HEAD`:

```text
M	README.md
A	config/model6dof_parameter_fit_v0.json
A	config/model6dof_replay_v0.json
M	docs/data_contract.md
M	docs/model_description.md
M	docs/review/PR-002-acceptance-report.md
M	docs/review/PR-005-model6dof-demo-report.md
M	docs/review/PR-005-visual-demo-report.md
A	docs/review/PR-006-model6dof-log-replay-report.md
A	docs/review/PR-006-model6dof-validation-summary.md
A	docs/review/PR-006-parameter-identification-report.md
M	docs/simulink_preparation.md
M	docs/validation_by_log_method.md
A	matlab/+copter/+data/buildInitialStateFromLog.m
A	matlab/+copter/+data/buildMotorInputsFromLog.m
A	matlab/+copter/+identification/estimateHoverThrustScale.m
A	matlab/+copter/+identification/estimateMotorLagFromLog.m
A	matlab/+copter/+identification/estimateSimpleDragFromLog.m
A	matlab/+copter/+identification/fitModel6DofParametersFromWindows.m
A	matlab/+copter/+validation/compareModel6DofToLog.m
A	matlab/+copter/+validation/selectModel6DofReplayWindows.m
A	matlab/+copter/+validation/simulateModel6DofOnLogWindow.m
A	matlab/+copter/+validation/validateModel6DofOnLogWindows.m
A	matlab/+copter/+visualization/plotModel6DofParameterFitSummary.m
A	matlab/+copter/+visualization/plotModel6DofReplayComparison.m
A	scripts/11_model6dof_log_replay_and_fit.m
A	scripts/model6dofLogReplayAndFitImpl.m
A	scripts/model6dof_log_replay_and_fit.m
A	tests/TestInitialStateFromLogSynthetic.m
A	tests/TestModel6DofComparisonMetrics.m
A	tests/TestModel6DofParameterFitSynthetic.m
A	tests/TestModel6DofReplaySynthetic.m
A	tests/TestMotorInputsFromLogSynthetic.m
A	tests/TestNoAbsoluteLocalPathsInDocs.m
M	tests/TestRepositoryFiles.m
```

## Состояние рабочего дерева

Вывод `git status --short` перед добавлением отчета:

```text

```

Рабочее дерево было чистым.

## Защита чувствительных данных

Вывод `git ls-files data/raw/ardupilot/bin docs/validation_basis result`:

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
.gitignore:29:result/*	result/model6dof_log_replay/reports/model6dof_log_replay_report.md
```

Реальные `.BIN`, PDF ВБ и расчетные выходы `result/*` в Git не добавлены.

## Проверка JSON

Проверка `jsondecode` выполнена:

```text
config/vehicle_qc_ardupilot_v0.json: OK
config/validation_basis_v0.json: OK
config/log_manifest_v0.json: OK
config/segment_detection_v0.json: OK
config/model_rate_identification_v0.json: OK
config/segment_curation_v0.json: OK
config/model6dof_replay_v0.json: OK
config/model6dof_parameter_fit_v0.json: OK
data/raw/ardupilot/bin/manifest_template.json: OK
```

## Проверка MATLAB

Выполнены команды:

```matlab
run('matlab/startup.m')
run('matlab/run_all_tests.m')
```

Итог:

```text
Totals:
   42 Passed, 0 Failed, 0 Incomplete.
   25.2507 seconds testing time.
```

Новые тесты PR №6:

- `TestInitialStateFromLogSynthetic` прошел.
- `TestMotorInputsFromLogSynthetic` прошел.
- `TestModel6DofReplaySynthetic` прошел.
- `TestModel6DofParameterFitSynthetic` прошел.
- `TestModel6DofComparisonMetrics` прошел.
- `TestNoAbsoluteLocalPathsInDocs` прошел.

## Запуск replay-сценария

Фактический запуск выполнен командой:

```matlab
run('scripts/model6dof_log_replay_and_fit.m')
```

Файл `scripts/11_model6dof_log_replay_and_fit.m` оставлен как номерной идентификатор этапа. Технический wrapper используется потому, что MATLAB не исполняет сценарии, имя которых начинается с цифры.

Результат:

```text
Replay Model6DOF по журналу: data/raw/ardupilot/bin/VB-01.alt_50m.BIN
Replay Model6DOF по журналу: data/raw/ardupilot/bin/full_fly_1.BIN
Replay Model6DOF по журналу: data/raw/ardupilot/bin/full_fly_2.BIN
Сопоставление Model6DOF с журналами сформировано.
```

## Доступность реальных журналов

Реальные журналы были доступны локально:

- `data/raw/ardupilot/bin/VB-01.alt_50m.BIN`;
- `data/raw/ardupilot/bin/full_fly_1.BIN`;
- `data/raw/ardupilot/bin/full_fly_2.BIN`.

## Окна replay

- Всего replay-окон: 24.
- Окон `identification`: 12.
- Окон `validation`: 12.

По журналам:

- `VB-01.alt_50m.BIN`: 8 окон.
- `full_fly_1.BIN`: 8 окон.
- `full_fly_2.BIN`: 8 окон.

## Первичная идентификация Model6DOF

Оценены параметры:

- `thrust_scale`;
- `motor_tau_s`;
- `kQ_over_kT`;
- `linear_drag_x`;
- `linear_drag_y`;
- `linear_drag_z`.

Последний сформированный набор параметров в сводном отчете:

- `thrust_scale`: 0.67481.
- `motor_tau_s`: 0.16361 с.
- `kQ_over_kT`: 0.015941.
- `linear_drag_x`: 1.4738.
- `linear_drag_y`: 0.034622.
- `linear_drag_z`: 3.929.

Параметры являются первичной настройкой по коротким окнам и не являются подтвержденной характеристикой реального изделия.

## Результаты Model6DOF

Предварительные критерии выполнены для 5 из 27 строк сводки каналов.

Каналы, где предварительное согласование зафиксировано:

- `VB-01.alt_50m.BIN`, `RATE.R`;
- `full_fly_1.BIN`, `RATE.R`;
- `full_fly_2.BIN`, `RATE.R`;
- `full_fly_2.BIN`, `RATE.Y`;
- `full_fly_2.BIN`, `altitude_m`.

Остальные каналы зафиксированы как несогласованные с журналом на текущем уровне настройки. Это не является отказом тестов, а является инженерным результатом PR №6.

## Локальные результаты

Локальные материалы сформированы и не добавлены в Git:

- `result/model6dof_log_replay/plots/`;
- `result/model6dof_log_replay/reports/`;
- `result/model6dof_log_replay/parameters/`.

## Ограничения PR №6

- PR №6 не является этапом полной независимой валидации.
- Replay-расчет используется для первичной настройки и диагностики `Model6DOF`.
- Короткие окна ограничивают накопление ошибки, но не заменяют матрицу валидации.
- Validation-окна не использовались для подбора параметров.
- Мотор-маппинг, знаки вращения, аэродинамика и параметры винтомоторной группы требуют уточнения.
- Отсутствие ESC telemetry сохраняет ограничение для модели винтомоторной группы и аккумулятора.

## Рекомендации для PR №7

- Уточнить мотор-маппинг и знаки вращения с учетом системы координат изделия.
- Расширить подбор параметров по независимым участкам ВБ.
- Добавить совместное сопоставление `Model6DOF` и `ModelRate` на одинаковых окнах.
- Подготовить устойчивый replay-контур к переносу в Simulink.
- Ввести отдельную несекретную витрину графиков без координат и времени полета.

## Итоговое заключение

PR №6 готов к внешней проверке. Критерии приемки выполнены:

- PR №5 слит в `main`.
- Создана ветка `codex/pr6-model6dof-log-replay-identification`.
- Реализовано построение начальных условий из журнала.
- Реализовано построение motor inputs из `RCOU`.
- Реализован replay `Model6DOF` на коротких окнах.
- Реализовано сравнение `Model6DOF` с журналом.
- Реализована первичная идентификация параметров `Model6DOF`.
- Overlay-графики сформированы локально в `result/model6dof_log_replay/`.
- Отчеты PR №6 созданы.
- Добавлен тест запрета абсолютных локальных путей в документации.
- Все MATLAB-тесты прошли.
- Реальные `.BIN`, PDF ВБ и `result/*` не добавлены в Git.
