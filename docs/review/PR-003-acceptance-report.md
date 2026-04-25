# Отчет приемки PR №3

## 1. Идентификация

- Ветка: `codex/pr3-validation-segments-rate-identification`.
- SHA проверенного состояния до добавления отчета: `694c7cab2f0004dde743a3c263b76e991f883d34`.
- Дата проверки: `2026-04-25 10:35:35 +03:00`.
- Назначение: выделение участков валидационного базиса по реальным бортовым журналам ArduPilot DataFlash `.BIN`, формирование обработанных `timetable`-наборов и первая идентификация `ModelRate`.

Данная проверка выполнена по данным бортового журнала и не является полной независимой валидацией реального изделия по внешним средствам измерений.

## 2. Подтверждение слияния PR №2

PR №2 слит в `main`:

```text
state: MERGED
baseRefName: main
headRefName: codex/pr2-dataflash-bin-analysis
mergeCommit: e1879132ea068dd07f555c5704e034fadccc8621
mergedAt: 2026-04-25T07:11:40Z
```

Ветка PR №3 создана от `origin/main = e1879132ea068dd07f555c5704e034fadccc8621`.

## 3. Сводка изменений

Команда:

```text
git diff --name-status main...HEAD
```

Результат:

```text
M	README.md
A	config/model_rate_identification_v0.json
A	config/segment_detection_v0.json
M	docs/data_contract.md
M	docs/model_description.md
A	docs/review/PR-003-rate-model-validation-summary.md
A	docs/review/PR-003-segment-inventory.md
M	docs/validation_by_log_method.md
A	matlab/+copter/+data/buildProcessedTimetableFromBin.m
A	matlab/+copter/+data/computeDerivedSignals.m
A	matlab/+copter/+data/extractFlightSignals.m
A	matlab/+copter/+data/normalizeMotorOutputsFromRCOU.m
A	matlab/+copter/+data/synchronizeLogMessages.m
A	matlab/+copter/+identification/fitRateModelFromSegments.m
A	matlab/+copter/+reports/writeRateIdentificationReport.m
A	matlab/+copter/+reports/writeSegmentInventoryReport.m
A	matlab/+copter/+validation/buildSegmentRegistry.m
A	matlab/+copter/+validation/detectValidationSegments.m
A	matlab/+copter/+validation/scoreValidationCaseCandidates.m
A	matlab/+copter/+validation/splitSegmentsForIdentification.m
A	matlab/+copter/+validation/validateRateModelOnSegments.m
A	scripts/08_extract_segments_and_fit_rate_model.m
A	scripts/extract_segments_and_fit_rate_model.m
A	tests/TestBinToProcessedTimetable.m
A	tests/TestRateIdentificationFromSegmentsSynthetic.m
M	tests/TestRepositoryFiles.m
A	tests/TestTextFileLineEndings.m
A	tests/TestValidationSegmentDetectionSynthetic.m
```

## 4. Состояние рабочего дерева

Команда:

```text
git status --short
```

Результат перед добавлением данного отчета:

```text
(вывод пустой)
```

## 5. Защита чувствительных данных

В Git отслеживаются только служебные файлы каталогов:

```text
data/raw/ardupilot/bin/.gitkeep
data/raw/ardupilot/bin/manifest_template.json
data/raw/ardupilot/bin/README.md
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
.gitignore:29:result/*	result/rate_identification/segment_registry.csv
.gitignore:29:result/*	result/rate_identification/rate_identification_result.mat
```

Заключение: реальные `.BIN`, PDF ВБ и расчетные выходы `result` не добавлены в Git.

## 6. Проверка JSON

Проверены через MATLAB `jsondecode`:

```text
OK config/vehicle_qc_ardupilot_v0.json
OK config/validation_basis_v0.json
OK config/log_manifest_v0.json
OK config/segment_detection_v0.json
OK config/model_rate_identification_v0.json
OK data/raw/ardupilot/bin/manifest_template.json
```

## 7. Проверка MATLAB

Выполнены команды:

```matlab
run('matlab/startup.m')
run('matlab/run_all_tests.m')
```

Результат:

```text
Totals:
   16 Passed, 0 Failed, 0 Incomplete.
   4.8878 seconds testing time.
```

Новые тесты PR №3:

- `TestBinToProcessedTimetable`;
- `TestValidationSegmentDetectionSynthetic`;
- `TestRateIdentificationFromSegmentsSynthetic`;
- `TestTextFileLineEndings`.

## 8. Реальные журналы

Реальные журналы были доступны локально:

- `data/raw/ardupilot/bin/VB-01.alt_50m.BIN`;
- `data/raw/ardupilot/bin/full_fly_1.BIN`;
- `data/raw/ardupilot/bin/full_fly_2.BIN`.

Выполнен рабочий сценарий:

```matlab
run('scripts/extract_segments_and_fit_rate_model.m')
```

Файл `scripts/08_extract_segments_and_fit_rate_model.m` сохранен как номерной сценарий этапа. Для командного запуска используется wrapper с техническим именем, так как имя MATLAB-сценария, начинающееся с цифры, не является допустимым исполняемым именем в `run`.

## 9. Количество выделенных участков

Всего выделено участков-кандидатов: 824.

По журналам:

```text
VB-01.alt_50m.BIN   525
full_fly_1.BIN      212
full_fly_2.BIN       87
```

По случаям ВБ:

```text
В-01    11
В-06    34
В-08    40
В-10   127
В-09   446
В-11   158
В-12     8
```

## 10. Разделение identification / validation

```text
identification   491
validation       333
```

Участки `validation` не использованы для подбора параметров `ModelRate`.

## 11. Результаты ModelRate

Средний показатель соответствия на validation-участках:

```text
RATE.R  -58892994886.516 %
RATE.P  -186.669 %
RATE.Y  -4.48450566806696E+25 %
```

Предварительные критерии PR №3 не выполнены по `RATE.R`, `RATE.P` и `RATE.Y`. Это не является сбоем программного обеспечения: отчет фиксирует, что текущая модель первого уровня и автоматические участки требуют ручной доработки, уточнения разметки и последующей идентификации.

## 12. Ограничения PR №3

- PR №3 не является этапом полной независимой валидации.
- Данные получены из бортовой системы регистрации, а не из внешних средств измерений.
- Автоматически выделенные участки требуют инженерного просмотра перед использованием как окончательный валидационный базис.
- Для `VB-01.alt_50m.BIN` имя файла указывает `alt_50m`, а случай `В-01` задан как висение на высоте 30 м; это несоответствие отражено в `PR-003-segment-inventory.md`.
- `ModelRate` является моделью первого уровня и не является полной моделью движения изделия.
- Фактические записи `ESC` отсутствуют, что ограничивает дальнейшую модель винтомоторной группы и аккумулятора.
- `Model6DOF` в PR №3 не идентифицируется.

## 13. Рекомендации для PR №4

- Выполнить ручной просмотр участков-кандидатов и убрать ложные response-участки.
- Подтвердить фактическую высоту `VB-01.alt_50m.BIN` по журналу и согласовать связь с `В-01`.
- Уточнить критерии выделения участков ВБ и пороги управляющих воздействий.
- Повторить идентификацию `ModelRate` после ручной разметки.
- Подготовить графики сопоставления `RATE.R`, `RATE.P`, `RATE.Y` для выбранных участков.
- Начать подготовку `Model6DOF` только после стабилизации разметки и качества данных.

## 14. Итоговое заключение Codex

PR №3 готов к внешней проверке. Все MATLAB-тесты прошли, реальные журналы обработаны локально, чувствительные исходные данные в Git не добавлены. Предварительная проверка `ModelRate` на автоматически выделенных участках не прошла критерии соответствия, и это явно зафиксировано как ограничение текущего этапа.
