# Отчет приемки PR №5

Данная проверка выполнена по данным бортового журнала и не является полной независимой валидацией реального изделия по внешним средствам измерений.

Демонстрационный полет Model6DOF в PR №5 предназначен для проверки работоспособности решателя, регулятора и постпроцессора. Он не подтверждает адекватность модели реальному изделию.

## Идентификация

- Номер PR: PR №5.
- Ветка: `codex/pr5-visual-flight-demo`.
- SHA проверяемой реализации перед добавлением данного отчета: `9c172a70f9072c9da64b8f257728fc5fa494c6c4`.
- Дата проверки: `2026-04-25 12:07:13 +03:00`.
- Базовая ветка: `main`.

## Подтверждение слияния PR №4

PR №4 слит в `main` стандартным способом проекта.

```text
number: 4
state: MERGED
baseRefName: main
headRefName: codex/pr4-curated-rate-identification
isDraft: false
mergeCommit: 9ee80a7f11cd699dc98ca047e26498ff1bb2bd20
mergedAt: 2026-04-25T08:33:02Z
origin/main: 9ee80a7f11cd699dc98ca047e26498ff1bb2bd20
```

## Сводка изменений

Вывод `git diff --name-status main...HEAD`:

```text
M	README.md
M	docs/data_contract.md
M	docs/model_description.md
A	docs/review/PR-005-model6dof-demo-report.md
A	docs/review/PR-005-visual-demo-report.md
A	docs/review/assets/pr5/synthetic_box_attitude.png
A	docs/review/assets/pr5/synthetic_box_flight.gif
A	docs/review/assets/pr5/synthetic_box_trajectory_3d.png
A	docs/review/assets/pr5/synthetic_hover_timeseries.png
A	docs/review/assets/pr5/synthetic_motor_commands.png
M	docs/simulink_preparation.md
M	docs/validation_by_log_method.md
A	matlab/+copter/+control/PrimitiveAltitudeController.m
A	matlab/+copter/+control/PrimitiveAttitudeController.m
A	matlab/+copter/+control/PrimitivePositionController.m
A	matlab/+copter/+control/generateBoxTrajectory.m
A	matlab/+copter/+control/quadXMixer.m
A	matlab/+copter/+control/simulatePrimitiveClosedLoop.m
M	matlab/+copter/+models/Model6DOF.m
A	matlab/+copter/+visualization/animateCopterFlight.m
A	matlab/+copter/+visualization/drawCopterFrame.m
A	matlab/+copter/+visualization/makeDemoDashboard.m
A	matlab/+copter/+visualization/plotFlightPath3D.m
A	matlab/+copter/+visualization/plotLogOverview.m
A	matlab/+copter/+visualization/plotModelVsLogComparison.m
A	scripts/10_visual_demo_and_model6dof_flight.m
A	scripts/visualDemoAndModel6dofFlightImpl.m
A	scripts/visual_demo_and_model6dof_flight.m
A	tests/TestBoxTrajectoryGenerator.m
A	tests/TestDrawCopterFrame.m
A	tests/TestModel6DOFClosedLoopDemo.m
A	tests/TestPrimitiveControllerHover.m
A	tests/TestQuadXMixer.m
M	tests/TestRepositoryFiles.m
A	tests/TestVisualizationSmoke.m
```

## Состояние рабочего дерева

Вывод `git status --short` перед добавлением отчета:

```text

```

Рабочее дерево было чистым.

## Проверка чувствительных данных

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

Реальные `.BIN` журналы, PDF валидационного базиса и расчетные выходы `result/*` в Git не добавлены.

Проверка `.gitignore`:

```text
.gitignore:20:data/raw/ardupilot/bin/*.bin	data/raw/ardupilot/bin/VB-01.alt_50m.BIN
.gitignore:20:data/raw/ardupilot/bin/*.bin	data/raw/ardupilot/bin/full_fly_1.BIN
.gitignore:20:data/raw/ardupilot/bin/*.bin	data/raw/ardupilot/bin/full_fly_2.BIN
.gitignore:34:docs/validation_basis/*.pdf	docs/validation_basis/ValidationBasis_v0.pdf
.gitignore:29:result/*	result/visual_demo/visual_demo_report.md
.gitignore:29:result/*	result/visual_demo/model6dof_demo/box_trajectory_3d.png
```

## Проверка JSON

Проверка `jsondecode` выполнена для конфигураций и реестров:

```text
config/vehicle_qc_ardupilot_v0.json: OK
config/validation_basis_v0.json: OK
config/log_manifest_v0.json: OK
config/segment_detection_v0.json: OK
config/model_rate_identification_v0.json: OK
config/segment_curation_v0.json: OK
data/raw/ardupilot/bin/manifest_template.json: OK
```

## Проверка MATLAB

Выполнены команды:

```matlab
run('matlab/startup.m')
run('matlab/run_all_tests.m')
```

Итоговый результат:

```text
Totals:
   36 Passed, 0 Failed, 0 Incomplete.
   30.5505 seconds testing time.
```

Ключевые новые тесты PR №5:

- `TestVisualizationSmoke` прошел.
- `TestDrawCopterFrame` прошел.
- `TestPrimitiveControllerHover` прошел.
- `TestQuadXMixer` прошел.
- `TestModel6DOFClosedLoopDemo` прошел.
- `TestBoxTrajectoryGenerator` прошел.

## Доступность реальных журналов

Реальные журналы были доступны локально и обработаны сценарием визуального демонстратора:

- `data/raw/ardupilot/bin/VB-01.alt_50m.BIN`: 10406 строк, 208.1 с.
- `data/raw/ardupilot/bin/full_fly_1.BIN`: 7146 строк, 142.9 с.
- `data/raw/ardupilot/bin/full_fly_2.BIN`: 4805 строк, 96.08 с.

Команда демонстратора:

```matlab
run('scripts/visual_demo_and_model6dof_flight.m')
```

Примечание: файл `scripts/10_visual_demo_and_model6dof_flight.m` оставлен как номерной сценарий этапа, а технический запуск выполняется через обертку `scripts/visual_demo_and_model6dof_flight.m`, так как имена сценариев MATLAB не должны начинаться с цифры при запуске через `run`.

## Созданные графики и анимации

Локальные результаты сформированы в `result/visual_demo/` и не добавлены в Git:

- `result/visual_demo/log_overview/` — обзорные графики ATT, RATE, RATE outputs, RCOU, команд двигателей, высоты, скорости и батареи.
- `result/visual_demo/log_replay/` — 3D-траектории и GIF replay по доступным реальным журналам.
- `result/visual_demo/model6dof_demo/` — синтетические графики демонстрационного расчета Model6DOF.
- `result/visual_demo/visual_demo_report.md` — локальный отчет запуска демонстратора.

В Git добавлены только несекретные синтетические материалы:

- `docs/review/assets/pr5/synthetic_hover_timeseries.png` — 29362 байт.
- `docs/review/assets/pr5/synthetic_box_trajectory_3d.png` — 67621 байт.
- `docs/review/assets/pr5/synthetic_box_attitude.png` — 81508 байт.
- `docs/review/assets/pr5/synthetic_motor_commands.png` — 86438 байт.
- `docs/review/assets/pr5/synthetic_box_flight.gif` — 353099 байт.

## Результат демонстрационного полета Model6DOF

Демонстрационная компьютерная модель выполнила три сценария:

- Висение: конечная высота 5 м.
- Набор высоты: конечная высота 7.887 м.
- Полет по прямоугольнику: конечная высота -0.109 м после посадочного участка.

Примитивный регулятор включает:

- внешний контур положения;
- контур высоты;
- PD-регулятор углов и угловых скоростей;
- смеситель `quadXMixer` для схемы `QUAD/X`;
- ограничение нормированных команд двигателей в диапазоне 0...1.

## Ограничения PR №5

- PR №5 не является этапом полной независимой валидации.
- Replay по журналу показывает зарегистрированные или оцененные бортовой системой состояния и не заменяет верификацию и валидацию модели.
- Model6DOF в PR №5 работает в demonstration mode.
- Параметры тяги заданы демонстрационно и подлежат идентификации по стендовым или летным данным.
- Полноценная аэродинамика, подтвержденная модель винтомоторной группы и ESC telemetry пока не используются.
- Демонстрационные синтетические изображения не являются доказательством адекватности модели реальному изделию.
- Реальные графики и GIF по журналам не добавлены в Git, так как могут содержать чувствительные сведения.

## Рекомендации для PR №6

- Перенести расчетное ядро демонстрационного контура Model6DOF в подготовленную структуру Simulink.
- Добавить управляемый режим сравнения replay журнала и расчета Model6DOF на одних временных интервалах.
- Начать идентификацию параметров тяги, задержки винтомоторной группы и сопротивления воздуха по фактическим данным.
- Уточнить координатные преобразования CAD -> связанная система координат изделия до использования произведений инерции.
- Добавить экспорт несекретных сводных графиков для внешней проверки без раскрытия координат и времени полета.

## Итоговое заключение

PR №5 готов к внешней проверке. Критерии приемки выполнены:

- PR №4 слит в `main`.
- Создана ветка `codex/pr5-visual-flight-demo`.
- Добавлены пакеты `copter.visualization` и `copter.control`.
- Реализованы графики, 3D replay и анимация.
- Реализован демонстрационный расчет Model6DOF с примитивным регулятором.
- Синтетическое висение и полет по прямоугольнику выполняются.
- Сценарий визуального демонстратора создан.
- Отчеты PR №5 созданы.
- Синтетические демонстрационные изображения добавлены в Git.
- Все MATLAB-тесты прошли.
- Реальные `.BIN`, PDF валидационного базиса и `result/*` не добавлены в Git.
