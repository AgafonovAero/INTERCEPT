# Статус конфигурации Model6DOF PR №8

Данная проверка выполнена по данным бортового журнала и не является полной независимой валидацией реального изделия по внешним средствам измерений.

До физического подтверждения подключения моторов, направлений вращения и установленного типа винтов выбранная конфигурация Model6DOF должна рассматриваться как расчетная гипотеза.

## Статусы
- motor_map_status: `hypothesis_from_log`.
- spin_sign_status: `hypothesis_from_log`.
- cad_to_body_status: `hypothesis_from_log`.
- propulsion_model_status: `bench_data_not_available`.
- propeller_configuration_status: `inconsistent_sources`.

## Источники
- Physical check: `not_available`.
- Bench data: `not_available`.
- Thrust model: `bench_data_not_available`.
- Current model: `bench_data_not_available`.
- Propulsion update: `bench_data_not_available`.

## Replay
Повторный replay с физически подтвержденной конфигурацией не выполнялся, потому что заполненные physicalCheck или bench data отсутствуют.
После появления данных сценарий может быть повторен без изменения расчетного ядра.
