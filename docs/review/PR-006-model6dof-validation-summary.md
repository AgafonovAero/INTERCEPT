# Сводка сопоставления Model6DOF с журналом PR №6

Данная проверка выполнена по данным бортового журнала и не является полной независимой валидацией реального изделия по внешним средствам измерений.

## Метрики по каналам
- VB-01.alt_50m.BIN, ATT.Roll: RMSE 16.6654, FIT -13529.71 %, предварительный критерий не выполнен.
- VB-01.alt_50m.BIN, ATT.Pitch: RMSE 0.79272, FIT -2684.805 %, предварительный критерий не выполнен.
- VB-01.alt_50m.BIN, ATT.Yaw: RMSE 46.8195, FIT -81256.541 %, предварительный критерий не выполнен.
- VB-01.alt_50m.BIN, RATE.R: RMSE 1.2771, FIT -92.95 %, предварительный критерий выполнен.
- VB-01.alt_50m.BIN, RATE.P: RMSE 22.7571, FIT -19454.438 %, предварительный критерий не выполнен.
- VB-01.alt_50m.BIN, RATE.Y: RMSE 1.5033, FIT -531.214 %, предварительный критерий не выполнен.
- VB-01.alt_50m.BIN, altitude_m: RMSE 17.3298, FIT -292.711 %, предварительный критерий не выполнен.
- VB-01.alt_50m.BIN, vertical_speed_mps: RMSE 7.4675, FIT -853.25 %, предварительный критерий не выполнен.
- VB-01.alt_50m.BIN, horizontal_speed_mps: RMSE 6.7636, FIT -196.901 %, предварительный критерий не выполнен.
- full_fly_1.BIN, ATT.Roll: RMSE 34.5033, FIT -6071.983 %, предварительный критерий не выполнен.
- full_fly_1.BIN, ATT.Pitch: RMSE 2.3537, FIT -1213.354 %, предварительный критерий не выполнен.
- full_fly_1.BIN, ATT.Yaw: RMSE 101.2754, FIT -18492.978 %, предварительный критерий не выполнен.
- full_fly_1.BIN, RATE.R: RMSE 1.0939, FIT -604.579 %, предварительный критерий выполнен.
- full_fly_1.BIN, RATE.P: RMSE 50.4903, FIT -16651.258 %, предварительный критерий не выполнен.
- full_fly_1.BIN, RATE.Y: RMSE 1.9946, FIT -359.261 %, предварительный критерий не выполнен.
- full_fly_1.BIN, altitude_m: RMSE 17.3409, FIT -483.536 %, предварительный критерий не выполнен.
- full_fly_1.BIN, vertical_speed_mps: RMSE 13.6289, FIT -791.675 %, предварительный критерий не выполнен.
- full_fly_1.BIN, horizontal_speed_mps: RMSE 12.6921, FIT -360.718 %, предварительный критерий не выполнен.
- full_fly_2.BIN, ATT.Roll: RMSE 0.81897, FIT -456.873 %, предварительный критерий не выполнен.
- full_fly_2.BIN, ATT.Pitch: RMSE 1.0122, FIT -1024.861 %, предварительный критерий не выполнен.
- full_fly_2.BIN, ATT.Yaw: RMSE 17.3898, FIT -8549.931 %, предварительный критерий не выполнен.
- full_fly_2.BIN, RATE.R: RMSE 0.80164, FIT -293.028 %, предварительный критерий выполнен.
- full_fly_2.BIN, RATE.P: RMSE 17.9529, FIT -5628.12 %, предварительный критерий не выполнен.
- full_fly_2.BIN, RATE.Y: RMSE 1.328, FIT -942.491 %, предварительный критерий выполнен.
- full_fly_2.BIN, altitude_m: RMSE 5.1489, FIT -179.047 %, предварительный критерий выполнен.
- full_fly_2.BIN, vertical_speed_mps: RMSE 6.2085, FIT -307.083 %, предварительный критерий не выполнен.
- full_fly_2.BIN, horizontal_speed_mps: RMSE 14.5644, FIT -1357.15 %, предварительный критерий не выполнен.

## Где модель согласуется с журналом
- VB-01.alt_50m.BIN, RATE.R.
- full_fly_1.BIN, RATE.R.
- full_fly_2.BIN, RATE.R.
- full_fly_2.BIN, RATE.Y.
- full_fly_2.BIN, altitude_m.

## Где модель не согласуется с журналом
- VB-01.alt_50m.BIN, ATT.Roll.
- VB-01.alt_50m.BIN, ATT.Pitch.
- VB-01.alt_50m.BIN, ATT.Yaw.
- VB-01.alt_50m.BIN, RATE.P.
- VB-01.alt_50m.BIN, RATE.Y.
- VB-01.alt_50m.BIN, altitude_m.
- VB-01.alt_50m.BIN, vertical_speed_mps.
- VB-01.alt_50m.BIN, horizontal_speed_mps.
- full_fly_1.BIN, ATT.Roll.
- full_fly_1.BIN, ATT.Pitch.
- full_fly_1.BIN, ATT.Yaw.
- full_fly_1.BIN, RATE.P.
- full_fly_1.BIN, RATE.Y.
- full_fly_1.BIN, altitude_m.
- full_fly_1.BIN, vertical_speed_mps.
- full_fly_1.BIN, horizontal_speed_mps.
- full_fly_2.BIN, ATT.Roll.
- full_fly_2.BIN, ATT.Pitch.
- full_fly_2.BIN, ATT.Yaw.
- full_fly_2.BIN, RATE.P.
- full_fly_2.BIN, vertical_speed_mps.
- full_fly_2.BIN, horizontal_speed_mps.

## Рекомендации для PR №7
- Уточнить мотор-маппинг и знаки вращения после подтверждения системы координат.
- Расширить подбор параметров по независимым участкам ВБ.
- Добавить сопоставление Model6DOF и ModelRate на одинаковых окнах.
- Подготовить перенос устойчивого replay-контура в Simulink.
