# Визуальный демонстратор PR №5

Данная проверка выполнена по данным бортового журнала и не является полной независимой валидацией реального изделия по внешним средствам измерений.

## Доступность журналов
- VB-01.alt_50m.BIN: 10406 строк, 208.1 с.
- full_fly_1.BIN: 7146 строк, 142.9 с.
- full_fly_2.BIN: 4805 строк, 96.08 с.

## Сформированные графики
- Обзорные графики реальных журналов сохранены локально в `result/visual_demo/log_overview/`.
- 3D-траектории и replay сохранены локально в `result/visual_demo/log_replay/`.

## Синтетические изображения в Git
- `docs/review/assets/pr5/synthetic_hover_timeseries.png`.
- `docs/review/assets/pr5/synthetic_box_trajectory_3d.png`.
- `docs/review/assets/pr5/synthetic_box_attitude.png`.
- `docs/review/assets/pr5/synthetic_motor_commands.png`.
- `docs/review/assets/pr5/synthetic_box_flight.gif`.

## Ограничения
- Изображения по реальным журналам не добавлены в Git из-за чувствительности данных.
- Replay показывает зарегистрированные или оцененные бортовой системой состояния.
- Каталог синтетических материалов: `docs/review/assets/pr5/`.
