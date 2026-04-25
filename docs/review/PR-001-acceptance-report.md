# Отчет приемки PR №1

## 1. Идентификация PR

- Номер PR: №1.
- Ветка: `codex/matlab-quadcopter-model-v0`.
- SHA текущего проверяемого коммита перед формированием отчета: `7b79c202a0e873f2afe7093a21eff2d537cd4bdb`.
- Дата проверки: `2026-04-25 08:30:20 +03:00`.

Примечание: SHA выше фиксирует проверенное состояние программного обеспечения компьютерного моделирования перед добавлением данного отчета. SHA итогового коммита с отчетом указывается отдельно при передаче PR №1 на повторную проверку.

## 2. Сводка изменений

Команда:

```text
git diff --name-status main...HEAD
```

Результат:

```text
A	.gitignore
M	README.md
A	config/validation_basis_v0.json
A	config/vehicle_qc_ardupilot_v0.json
A	data/processed/.gitkeep
A	data/processed/README.md
A	data/raw/.gitkeep
A	data/raw/README.md
A	data/raw/ardupilot/bin/.gitkeep
A	data/raw/ardupilot/bin/README.md
A	data/raw/ardupilot/bin/manifest_template.json
A	docs/data_contract.md
A	docs/model_description.md
A	docs/simulink_preparation.md
A	docs/validation_basis/.gitkeep
A	docs/validation_basis/README.md
A	docs/validation_by_log_method.md
A	matlab/+copter/+config/defaultValidationBasis.m
A	matlab/+copter/+config/defaultVehicleConfig.m
A	matlab/+copter/+config/loadConfig.m
A	matlab/+copter/+config/saveConfig.m
A	matlab/+copter/+config/validateConfig.m
A	matlab/+copter/+data/assessDataQuality.m
A	matlab/+copter/+data/convertUnits.m
A	matlab/+copter/+data/inspectLog.m
A	matlab/+copter/+data/normalizeTime.m
A	matlab/+copter/+data/preprocessLogData.m
A	matlab/+copter/+data/readBinPlaceholder.m
A	matlab/+copter/+data/readMatData.m
A	matlab/+copter/+data/readTableLog.m
A	matlab/+copter/+data/selectSegments.m
A	matlab/+copter/+identification/computeDerivatives.m
A	matlab/+copter/+identification/estimateInputDelay.m
A	matlab/+copter/+identification/fitModel6DOF.m
A	matlab/+copter/+identification/fitRateModel.m
A	matlab/+copter/+models/BatteryModel.m
A	matlab/+copter/+models/Model6DOF.m
A	matlab/+copter/+models/ModelRate.m
A	matlab/+copter/+models/MotorModel.m
A	matlab/+copter/+models/coordinateSystems.m
A	matlab/+copter/+models/rhs6DOF.m
A	matlab/+copter/+models/rhsRateModel.m
A	matlab/+copter/+reports/makePlots.m
A	matlab/+copter/+reports/writeConfigurationRegistry.m
A	matlab/+copter/+reports/writeMarkdownReport.m
A	matlab/+copter/+utils/checkTableFields.m
A	matlab/+copter/+utils/hashFile.m
A	matlab/+copter/+utils/normalizePwm.m
A	matlab/+copter/+utils/readJson.m
A	matlab/+copter/+utils/writeJson.m
A	matlab/+copter/+validation/buildValidationMatrix.m
A	matlab/+copter/+validation/computeMetrics.m
A	matlab/+copter/+validation/simulateSegment.m
A	matlab/+copter/+validation/validateByLog.m
A	matlab/run_all_tests.m
A	matlab/startup.m
A	result/.gitkeep
A	result/README.md
A	scripts/01_create_project.m
A	scripts/02_inspect_log.m
A	scripts/03_preprocess_log_data.m
A	scripts/04_fit_rate_model.m
A	scripts/05_validate_by_log.m
A	scripts/06_run_model6dof_demo.m
A	tests/TestCodeFormat.m
A	tests/TestMetrics.m
A	tests/TestModel6DOFHover.m
A	tests/TestPreprocessLogData.m
A	tests/TestRateModel.m
A	tests/TestReportGeneration.m
A	tests/TestRepositoryFiles.m
A	tests/TestSyntheticEndToEnd.m
A	tests/TestUnitConversion.m
```

## 3. Состояние рабочего дерева

Команда:

```text
git status --short
```

Результат:

```text
(вывод пустой)
```

Рабочее дерево чистое на момент проверки перед созданием данного отчета. Локальный документ `docs/validation_basis/ValidationBasis_v0.pdf` не включен в Git.

## 4. Проверка структуры проекта

| Путь | Состояние |
|---|---|
| `matlab/+copter` | существует |
| `matlab/+copter/+config` | существует |
| `matlab/+copter/+data` | существует |
| `matlab/+copter/+models` | существует |
| `matlab/+copter/+identification` | существует |
| `matlab/+copter/+validation` | существует |
| `matlab/+copter/+reports` | существует |
| `matlab/+copter/+utils` | существует |
| `config/vehicle_qc_ardupilot_v0.json` | существует |
| `config/validation_basis_v0.json` | существует |
| `docs/model_description.md` | существует |
| `docs/validation_by_log_method.md` | существует |
| `docs/data_contract.md` | существует |
| `docs/simulink_preparation.md` | существует |
| `data/raw/ardupilot/bin/README.md` | существует |
| `data/raw/ardupilot/bin/manifest_template.json` | существует |
| `docs/validation_basis/README.md` | существует |
| `result/README.md` | существует |

Заключение: обязательная структура PR №1 создана. Программное обеспечение компьютерного моделирования разделено на препроцессор, решатель, постпроцессор, средства верификации, оценки адекватности и управления конфигурацией.

## 5. Проверка отсутствия старых транслитерированных артефактов

Команда:

```text
git ls-files | grep -E "kopterkm|konfiguratsiya|dannye|modeli|identifikatsiya|validatsiya|otchety|sluzhebnye|izdeliye|otsenit|sformirovat|podgotovit|privesti|chitat|khesh|normalizatsiya" || true
```

Результат:

```text
(вывод пустой)
```

Команда:

```text
git grep -n -E "kopterkm|konfiguratsiya|dannye|modeli|identifikatsiya|validatsiya|otchety|sluzhebnye|otsenit|sformirovat|podgotovit|privesti|chitat|khesh|normalizatsiya" -- "*.m" || true
```

Результат:

```text
(вывод пустой)
```

Старые транслитерированные пути и функции не обнаружены.

## 6. Проверка JSON

Проверены через MATLAB `jsondecode`:

- `config/vehicle_qc_ardupilot_v0.json`;
- `config/validation_basis_v0.json`;
- `data/raw/ardupilot/bin/manifest_template.json`.

Результат:

```text
OK config/vehicle_qc_ardupilot_v0.json
OK config/validation_basis_v0.json
OK data/raw/ardupilot/bin/manifest_template.json
Количество случаев: 23
Первый case_id: В-01
Последний case_id: В-23
```

Заключение: JSON-файлы корректно разбираются средствами MATLAB.

## 7. Проверка валидационного базиса

- Количество случаев: 23.
- Первый `case_id`: `В-01`.
- Последний `case_id`: `В-23`.

Заключение: формализованный реестр валидационного базиса содержит случаи `В-01`...`В-23`. Статус случаев соответствует первому уровню: критерии и метод обработки подлежат уточнению после анализа реальных бортовых журналов и состава доступных каналов.

## 8. Проверка .gitignore для журналов

Команды:

```text
git check-ignore -v data/raw/ardupilot/bin/VB-01.alt_50m.BIN || true
git check-ignore -v data/raw/ardupilot/bin/full_fly_1.BIN || true
git check-ignore -v data/raw/ardupilot/bin/full_fly_2.BIN || true
```

Результат:

```text
.gitignore:20:data/raw/ardupilot/bin/*.bin	data/raw/ardupilot/bin/VB-01.alt_50m.BIN
.gitignore:20:data/raw/ardupilot/bin/*.bin	data/raw/ardupilot/bin/full_fly_1.BIN
.gitignore:20:data/raw/ardupilot/bin/*.bin	data/raw/ardupilot/bin/full_fly_2.BIN
```

Заключение: сырые журналы DataFlash `BIN` игнорируются Git. Для хранения журналов в репозитории необходимо использовать Git LFS или закрытый репозиторий.

## 9. Проверка MATLAB-кода

Выполнены команды:

```matlab
run('matlab/startup.m')
run('matlab/run_all_tests.m')
```

Полный результат:

```text
Пути проекта компьютерного моделирования настроены.
Пути проекта компьютерного моделирования настроены.
 Running TestCodeFormat
  Setting up TestCodeFormat
  Done setting up TestCodeFormat in 0 seconds
   Running TestCodeFormat/testMatlabFilesFormat
   Done TestCodeFormat/testMatlabFilesFormat in 1.2231 seconds
  Tearing down TestCodeFormat
  Done tearing down TestCodeFormat in 0 seconds
 Done TestCodeFormat in 1.2231 seconds
__________

 Running TestMetrics
  Setting up TestMetrics
  Done setting up TestMetrics in 0 seconds
   Running TestMetrics/testMetrics
   Done TestMetrics/testMetrics in 0.23244 seconds
  Tearing down TestMetrics
  Done tearing down TestMetrics in 0 seconds
 Done TestMetrics in 0.23244 seconds
__________

 Running TestModel6DOFHover
  Setting up TestModel6DOFHover
  Done setting up TestModel6DOFHover in 0 seconds
   Running TestModel6DOFHover/testHover
   Done TestModel6DOFHover/testHover in 0.053308 seconds
  Tearing down TestModel6DOFHover
  Done tearing down TestModel6DOFHover in 0 seconds
 Done TestModel6DOFHover in 0.053308 seconds
__________

 Running TestPreprocessLogData
  Setting up TestPreprocessLogData
  Done setting up TestPreprocessLogData in 0 seconds
   Running TestPreprocessLogData/testPreprocess
   Done TestPreprocessLogData/testPreprocess in 0.42874 seconds
  Tearing down TestPreprocessLogData
  Done tearing down TestPreprocessLogData in 0 seconds
 Done TestPreprocessLogData in 0.42874 seconds
__________

 Running TestRateModel
  Setting up TestRateModel
  Done setting up TestRateModel in 0 seconds
   Running TestRateModel/testSyntheticIdentification
   Done TestRateModel/testSyntheticIdentification in 0.57381 seconds
  Tearing down TestRateModel
  Done tearing down TestRateModel in 0 seconds
 Done TestRateModel in 0.57381 seconds
__________

 Running TestReportGeneration
  Setting up TestReportGeneration
  Done setting up TestReportGeneration in 0 seconds
   Running TestReportGeneration/testReport
   Done TestReportGeneration/testReport in 0.076733 seconds
  Tearing down TestReportGeneration
  Done tearing down TestReportGeneration in 0 seconds
 Done TestReportGeneration in 0.076733 seconds
__________

 Running TestRepositoryFiles
  Setting up TestRepositoryFiles
  Done setting up TestRepositoryFiles in 0 seconds
   Running TestRepositoryFiles/testRequiredProjectStructure
   Done TestRepositoryFiles/testRequiredProjectStructure in 0.0076934 seconds
  Tearing down TestRepositoryFiles
  Done tearing down TestRepositoryFiles in 0 seconds
 Done TestRepositoryFiles in 0.0076934 seconds
__________

 Running TestSyntheticEndToEnd
  Setting up TestSyntheticEndToEnd
  Done setting up TestSyntheticEndToEnd in 0 seconds
   Running TestSyntheticEndToEnd/testEndToEnd
   Done TestSyntheticEndToEnd/testEndToEnd in 0.2904 seconds
  Tearing down TestSyntheticEndToEnd
  Done tearing down TestSyntheticEndToEnd in 0 seconds
 Done TestSyntheticEndToEnd in 0.2904 seconds
__________

 Running TestUnitConversion
  Setting up TestUnitConversion
  Done setting up TestUnitConversion in 0 seconds
   Running TestUnitConversion/testAngleAndRateConversion
   Done TestUnitConversion/testAngleAndRateConversion in 0.03107 seconds
   Running TestUnitConversion/testPwmNormalization
   Done TestUnitConversion/testPwmNormalization in 0.0049592 seconds
  Tearing down TestUnitConversion
  Done tearing down TestUnitConversion in 0 seconds
 Done TestUnitConversion in 0.036029 seconds
__________

  1�10 TestResult array with properties:

    Name
    Passed
    Failed
    Incomplete
    Duration
    Details

Totals:
   10 Passed, 0 Failed, 0 Incomplete.
   2.9223 seconds testing time.
```

Заключение: проверка MATLAB-кода пройдена. Исполняемый расчет компьютерной модели отделен от чтения файлов, построения графиков и формирования отчетов.

## 10. Перечень тестов

| Тест | Состояние |
|---|---|
| `TestCodeFormat` | существует и выполняется |
| `TestRepositoryFiles` | существует и выполняется |
| `TestUnitConversion` | существует и выполняется |
| `TestRateModel` | существует и выполняется |
| `TestModel6DOFHover` | существует и выполняется |
| `TestMetrics` | существует и выполняется |
| `TestPreprocessLogData` | существует и выполняется |
| `TestReportGeneration` | существует и выполняется |
| `TestSyntheticEndToEnd` | существует и выполняется |

Итог `matlab.unittest`: 10 проверок пройдено, 0 ошибок, 0 неполных проверок.

## 11. Проверка обязательных предупреждений

Проверено наличие обязательной фразы:

```text
Данная проверка выполнена по данным бортового журнала и не является полной независимой валидацией реального изделия по внешним средствам измерений.
```

Проверено наличие предупреждения о противоречии исходных данных:

```text
В исходном описании указаны винты Gemfan 8060, а в CAD-выгрузке присутствуют винты APC 7x11E.
```

Заключение: обязательные предупреждения присутствуют в отчетной части и документации. Текущий уровень работ определяется как оценка адекватности компьютерной модели по данным бортового журнала, а не полная независимая валидация реального изделия по внешним средствам измерений.

## 12. Места для исходных данных

Реальные бортовые журналы ArduPilot DataFlash следует положить локально:

```text
data/raw/ardupilot/bin/VB-01.alt_50m.BIN
data/raw/ardupilot/bin/full_fly_1.BIN
data/raw/ardupilot/bin/full_fly_2.BIN
```

Документ валидационного базиса следует положить локально:

```text
docs/validation_basis/ValidationBasis_v0.pdf
```

Файл PDF валидационного базиса может содержать чувствительную информацию и не должен добавляться в обычный Git. Для хранения такого документа в репозитории следует использовать закрытый репозиторий или согласованную процедуру управления конфигурацией.

## 13. Ограничения первого этапа

- Полноценное чтение DataFlash `.BIN` еще не реализовано.
- Текущая рабочая обработка рассчитана на `CSV`, `MAT`, `table` и `timetable`.
- Проверка является оценкой адекватности по данным бортового журнала, а не независимой валидацией по внешним средствам измерений.
- Модель угловых скоростей является первым уровнем компьютерной модели.
- `Model6DOF` пока является расчетной заготовкой для дальнейшей идентификации и проверки.
- Критерии приемлемости предварительные и подлежат уточнению после накопления валидационного базиса и анализа реальных бортовых журналов.

## 14. Итоговое заключение Codex

PR №1 готов к внешней проверке. Все проверки пройдены.
