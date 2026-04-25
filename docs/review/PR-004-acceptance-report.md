# Отчет приемки PR №4

## 1. Идентификация

- Ветка: `codex/pr4-curated-rate-identification`.
- SHA проверенного состояния до добавления отчета: `77e0243f0b6720948443edd40b7f816ac2f779e4`.
- Дата проверки: `2026-04-25 11:13:13 +03:00`.
- Назначение: инженерная фильтрация участков ВБ, диагностика причин провала `ModelRate` и повторная идентификация непрерывной и дискретной моделей угловых скоростей.

Данная проверка выполнена по данным бортового журнала и не является полной независимой валидацией реального изделия по внешним средствам измерений.

## 2. Подтверждение слияния PR №3

PR №3 слит в `main`:

```text
state: MERGED
baseRefName: main
headRefName: codex/pr3-validation-segments-rate-identification
mergeCommit: a44f2be19f7e1a4dcf12cdf5d307c51426585c53
mergedAt: 2026-04-25T07:48:59Z
```

Ветка PR №4 создана от `origin/main = a44f2be19f7e1a4dcf12cdf5d307c51426585c53`.

## 3. Сводка изменений

Команда:

```text
git diff --name-status main...HEAD
```

Результат:

```text
M	README.md
A	config/segment_curation_v0.json
M	docs/data_contract.md
M	docs/model_description.md
A	docs/review/PR-004-curated-segment-review.md
A	docs/review/PR-004-rate-model-diagnostics.md
A	docs/review/PR-004-rate-model-validation-summary.md
M	docs/validation_by_log_method.md
A	matlab/+copter/+data/diagnoseSignalUnits.m
A	matlab/+copter/+data/diagnoseTimebase.m
A	matlab/+copter/+identification/fitCuratedRateModels.m
A	matlab/+copter/+identification/fitRateModelDiscreteFromSegments.m
A	matlab/+copter/+models/ModelRateDiscrete.m
A	matlab/+copter/+models/simulateRateDiscrete.m
M	matlab/+copter/+reports/writeSegmentInventoryReport.m
A	matlab/+copter/+validation/compareRateModelVariants.m
M	matlab/+copter/+validation/computeMetrics.m
A	matlab/+copter/+validation/computeSegmentExcitationMetrics.m
A	matlab/+copter/+validation/curateValidationSegments.m
A	matlab/+copter/+validation/rankSegmentsForRateIdentification.m
A	matlab/+copter/+validation/removeOverlappingSegments.m
A	matlab/+copter/+validation/splitCuratedSegments.m
A	matlab/+copter/+validation/validateRateModelDiscreteOnSegments.m
M	matlab/+copter/+validation/validateRateModelOnSegments.m
A	scripts/09_curate_segments_and_refit_rate_model.m
A	scripts/curate_segments_and_refit_rate_model.m
A	tests/TestCuratedRateIdentificationSynthetic.m
A	tests/TestMetricRobustness.m
A	tests/TestRateDiscreteModelSynthetic.m
M	tests/TestRepositoryFiles.m
A	tests/TestSegmentCurationSynthetic.m
A	tests/TestSignalUnitDiagnostics.m
A	tests/TestTimebaseDiagnostics.m
```

Перед добавлением данного отчета `git status --short` был пустым.

## 4. Защита чувствительных данных

В Git отслеживаются только служебные файлы каталогов:

```text
data/raw/ardupilot/bin/.gitkeep
data/raw/ardupilot/bin/README.md
data/raw/ardupilot/bin/manifest_template.json
docs/validation_basis/.gitkeep
docs/validation_basis/README.md
result/.gitkeep
result/README.md
```

Проверка `.gitignore` подтвердила защиту:

```text
.gitignore:20:data/raw/ardupilot/bin/*.bin	data/raw/ardupilot/bin/VB-01.alt_50m.BIN
.gitignore:20:data/raw/ardupilot/bin/*.bin	data/raw/ardupilot/bin/full_fly_1.BIN
.gitignore:20:data/raw/ardupilot/bin/*.bin	data/raw/ardupilot/bin/full_fly_2.BIN
.gitignore:34:docs/validation_basis/*.pdf	docs/validation_basis/ValidationBasis_v0.pdf
.gitignore:29:result/*	result/rate_identification_curated/curated_segment_registry.csv
```

Заключение: реальные `.BIN`, PDF ВБ и расчетные выходы `result` не добавлены в Git.

## 5. Проверка JSON

Проверены через MATLAB `jsondecode`:

```text
OK config/vehicle_qc_ardupilot_v0.json
OK config/validation_basis_v0.json
OK config/log_manifest_v0.json
OK config/segment_detection_v0.json
OK config/model_rate_identification_v0.json
OK config/segment_curation_v0.json
OK data/raw/ardupilot/bin/manifest_template.json
```

## 6. Проверка MATLAB

Выполнены команды:

```matlab
run('matlab/startup.m')
run('matlab/run_all_tests.m')
```

Результат:

```text
Totals:
   27 Passed, 0 Failed, 0 Incomplete.
   6.1602 seconds testing time.
```

## 7. Реальные журналы

Реальные журналы были доступны локально:

- `data/raw/ardupilot/bin/VB-01.alt_50m.BIN`;
- `data/raw/ardupilot/bin/full_fly_1.BIN`;
- `data/raw/ardupilot/bin/full_fly_2.BIN`.

Выполнен рабочий сценарий:

```matlab
run('scripts/curate_segments_and_refit_rate_model.m')
```

Номерной файл `scripts/09_curate_segments_and_refit_rate_model.m` сохранен как сценарий этапа. Для фактического запуска используется wrapper с техническим именем, потому что имя MATLAB-сценария, начинающееся с цифры, не является допустимым исполняемым именем для `run`.

## 8. Результаты фильтрации участков

- Исходных участков PR №3: 824.
- Прошли базовую инженерную фильтрацию: 591.
- Исключено базовой фильтрацией: 233.
- Осталось после удаления перекрытий: 66.
- Участков identification: 57.
- Участков validation: 9.

Покрытие случаев ВБ после фильтрации:

```text
В-01     5
В-09    29
В-10    22
В-11    10
```

Причины исключения на базовом этапе:

```text
насыщение RCOU                                             147
тип участка не предназначен для идентификации ModelRate     82
малая дисперсия входа                                        3
слишком большая длительность                                 1
```

## 9. Результаты ModelRate

Непрерывная модель:

```text
RATE.R  FIT -18423.769 %, RMSE 25.241143 рад/с
RATE.P  FIT -411.072 %, RMSE 1.461225 рад/с
RATE.Y  FIT -96658.160 %, RMSE 583.130658 рад/с
```

Дискретная диагностическая модель:

```text
RATE.R  FIT -3895.909 %, RMSE 9.502873 рад/с
RATE.P  FIT -1220.784 %, RMSE 3.480709 рад/с
RATE.Y  FIT -6702.976 %, RMSE 26.621429 рад/с
```

Предварительные критерии не выполнены ни для непрерывной, ни для дискретной модели. Дискретная модель заметно снижает RMSE по `RATE.R` и `RATE.Y`, но не достигает критериев оценки адекватности.

## 10. Итоговое заключение

PR №4 устранил главный дефект интерпретации PR №3: гигантские значения `FIT` больше не являются единственным выводом, а метрика защищена от почти нулевого знаменателя. Провал `ModelRate` теперь диагностируется как сочетание ограничений автоматической разметки, насыщения `RCOU`, качества участков, задержки входа и недостаточности модели первого уровня.

PR №4 готов к внешней проверке. Все программные проверки пройдены.

## 11. Рекомендации для PR №5

- Выполнить ручное утверждение curated-участков ВБ.
- Уточнить мотор-маппинг и знак управляющих воздействий по `RCOU`.
- Проверить задержки входа по каналам `RATE.R`, `RATE.P`, `RATE.Y` отдельно.
- Подготовить следующий уровень модели с учетом режимов движения и ограничений винтомоторной группы.
- Продолжить работу с `Model6DOF` после подтверждения качества участков и доступных каналов.
