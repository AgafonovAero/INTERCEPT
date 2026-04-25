# Первая идентификация ModelRate по бортовым журналам

Данная проверка выполнена по данным бортового журнала и не является полной независимой валидацией реального изделия по внешним средствам измерений.

## Описание компьютерной модели

`ModelRate` является моделью первого уровня для угловых скоростей `omega = [p; q; r]`.

```text
domega/dt = A * omega + B * u + c
```

## Участки identification и validation

| segment_id | журнал | ВБ | тип | роль | начало, с | конец, с |
|---|---|---|---|---|---:|---:|
| VB-01.alt_50m.BIN_hover_candidate_1 | VB-01.alt_50m.BIN | В-01 | hover_candidate | identification | 0.030 | 4.250 |
| VB-01.alt_50m.BIN_hover_candidate_2 | VB-01.alt_50m.BIN | В-01 | hover_candidate | identification | 103.115 | 105.115 |
| VB-01.alt_50m.BIN_hover_candidate_3 | VB-01.alt_50m.BIN | В-01 | hover_candidate | identification | 125.865 | 127.865 |
| VB-01.alt_50m.BIN_hover_candidate_4 | VB-01.alt_50m.BIN | В-01 | hover_candidate | identification | 192.170 | 194.170 |
| VB-01.alt_50m.BIN_climb_candidate_1 | VB-01.alt_50m.BIN | В-06 | climb_candidate | identification | 4.460 | 8.230 |
| VB-01.alt_50m.BIN_climb_candidate_2 | VB-01.alt_50m.BIN | В-06 | climb_candidate | validation | 8.320 | 12.600 |
| VB-01.alt_50m.BIN_climb_candidate_3 | VB-01.alt_50m.BIN | В-06 | climb_candidate | validation | 12.260 | 14.260 |
| VB-01.alt_50m.BIN_climb_candidate_4 | VB-01.alt_50m.BIN | В-06 | climb_candidate | identification | 14.690 | 16.690 |
| VB-01.alt_50m.BIN_climb_candidate_5 | VB-01.alt_50m.BIN | В-06 | climb_candidate | identification | 15.660 | 17.660 |
| VB-01.alt_50m.BIN_climb_candidate_6 | VB-01.alt_50m.BIN | В-06 | climb_candidate | validation | 18.230 | 28.260 |
| VB-01.alt_50m.BIN_climb_candidate_7 | VB-01.alt_50m.BIN | В-06 | climb_candidate | validation | 32.810 | 44.820 |
| VB-01.alt_50m.BIN_climb_candidate_8 | VB-01.alt_50m.BIN | В-06 | climb_candidate | identification | 57.160 | 66.460 |
| VB-01.alt_50m.BIN_climb_candidate_9 | VB-01.alt_50m.BIN | В-06 | climb_candidate | identification | 100.765 | 102.765 |
| VB-01.alt_50m.BIN_climb_candidate_10 | VB-01.alt_50m.BIN | В-06 | climb_candidate | identification | 132.530 | 137.520 |
| VB-01.alt_50m.BIN_climb_candidate_11 | VB-01.alt_50m.BIN | В-06 | climb_candidate | identification | 140.640 | 145.970 |
| VB-01.alt_50m.BIN_climb_candidate_12 | VB-01.alt_50m.BIN | В-06 | climb_candidate | validation | 151.040 | 157.100 |
| VB-01.alt_50m.BIN_climb_candidate_13 | VB-01.alt_50m.BIN | В-06 | climb_candidate | identification | 159.770 | 164.650 |
| VB-01.alt_50m.BIN_climb_candidate_14 | VB-01.alt_50m.BIN | В-06 | climb_candidate | identification | 174.555 | 176.555 |
| VB-01.alt_50m.BIN_climb_candidate_15 | VB-01.alt_50m.BIN | В-06 | climb_candidate | identification | 176.080 | 179.180 |
| VB-01.alt_50m.BIN_descent_candidate_1 | VB-01.alt_50m.BIN | В-08 | descent_candidate | identification | 29.350 | 32.270 |
| VB-01.alt_50m.BIN_descent_candidate_2 | VB-01.alt_50m.BIN | В-08 | descent_candidate | identification | 45.570 | 57.040 |
| VB-01.alt_50m.BIN_descent_candidate_3 | VB-01.alt_50m.BIN | В-08 | descent_candidate | validation | 66.770 | 86.770 |
| VB-01.alt_50m.BIN_descent_candidate_4 | VB-01.alt_50m.BIN | В-08 | descent_candidate | validation | 86.770 | 89.850 |
| VB-01.alt_50m.BIN_descent_candidate_5 | VB-01.alt_50m.BIN | В-08 | descent_candidate | validation | 93.040 | 100.380 |
| VB-01.alt_50m.BIN_descent_candidate_6 | VB-01.alt_50m.BIN | В-08 | descent_candidate | identification | 104.970 | 106.970 |
| VB-01.alt_50m.BIN_descent_candidate_7 | VB-01.alt_50m.BIN | В-08 | descent_candidate | identification | 106.640 | 109.050 |
| VB-01.alt_50m.BIN_descent_candidate_8 | VB-01.alt_50m.BIN | В-08 | descent_candidate | identification | 128.010 | 131.360 |
| VB-01.alt_50m.BIN_descent_candidate_9 | VB-01.alt_50m.BIN | В-08 | descent_candidate | identification | 138.410 | 140.410 |
| VB-01.alt_50m.BIN_descent_candidate_10 | VB-01.alt_50m.BIN | В-08 | descent_candidate | validation | 146.160 | 150.780 |
| VB-01.alt_50m.BIN_descent_candidate_11 | VB-01.alt_50m.BIN | В-08 | descent_candidate | identification | 157.040 | 159.040 |
| VB-01.alt_50m.BIN_descent_candidate_12 | VB-01.alt_50m.BIN | В-08 | descent_candidate | validation | 165.470 | 174.920 |
| VB-01.alt_50m.BIN_descent_candidate_13 | VB-01.alt_50m.BIN | В-08 | descent_candidate | identification | 179.960 | 188.900 |
| VB-01.alt_50m.BIN_descent_candidate_14 | VB-01.alt_50m.BIN | В-08 | descent_candidate | validation | 188.665 | 190.665 |
| VB-01.alt_50m.BIN_descent_candidate_15 | VB-01.alt_50m.BIN | В-08 | descent_candidate | identification | 190.470 | 192.470 |
| VB-01.alt_50m.BIN_roll_response_candidate_1 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | identification | 3.375 | 5.375 |
| VB-01.alt_50m.BIN_roll_response_candidate_2 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | identification | 3.620 | 5.620 |
| VB-01.alt_50m.BIN_roll_response_candidate_3 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | validation | 3.770 | 5.770 |
| VB-01.alt_50m.BIN_roll_response_candidate_4 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | validation | 4.050 | 6.050 |
| VB-01.alt_50m.BIN_roll_response_candidate_5 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | identification | 4.725 | 6.725 |
| VB-01.alt_50m.BIN_roll_response_candidate_6 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | identification | 5.140 | 7.140 |
| VB-01.alt_50m.BIN_roll_response_candidate_7 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | identification | 6.015 | 8.015 |
| VB-01.alt_50m.BIN_roll_response_candidate_8 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | identification | 6.055 | 8.055 |
| VB-01.alt_50m.BIN_roll_response_candidate_9 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | identification | 6.225 | 8.225 |
| VB-01.alt_50m.BIN_roll_response_candidate_10 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | identification | 6.260 | 8.260 |
| VB-01.alt_50m.BIN_roll_response_candidate_11 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | validation | 7.075 | 9.075 |
| VB-01.alt_50m.BIN_roll_response_candidate_12 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | validation | 7.375 | 9.375 |
| VB-01.alt_50m.BIN_roll_response_candidate_13 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | validation | 7.410 | 9.410 |
| VB-01.alt_50m.BIN_roll_response_candidate_14 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | validation | 7.870 | 9.870 |
| VB-01.alt_50m.BIN_roll_response_candidate_15 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | identification | 8.330 | 10.330 |
| VB-01.alt_50m.BIN_roll_response_candidate_16 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | identification | 8.355 | 10.355 |
| VB-01.alt_50m.BIN_roll_response_candidate_17 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | validation | 8.625 | 10.625 |
| VB-01.alt_50m.BIN_roll_response_candidate_18 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | identification | 8.855 | 10.855 |
| VB-01.alt_50m.BIN_roll_response_candidate_19 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | validation | 8.895 | 10.895 |
| VB-01.alt_50m.BIN_roll_response_candidate_20 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | identification | 8.920 | 10.920 |
| VB-01.alt_50m.BIN_roll_response_candidate_21 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | identification | 9.295 | 11.295 |
| VB-01.alt_50m.BIN_roll_response_candidate_22 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | validation | 9.640 | 11.640 |
| VB-01.alt_50m.BIN_roll_response_candidate_23 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | validation | 10.015 | 12.015 |
| VB-01.alt_50m.BIN_roll_response_candidate_24 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | validation | 10.320 | 12.320 |
| VB-01.alt_50m.BIN_roll_response_candidate_25 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | validation | 10.555 | 12.555 |
| VB-01.alt_50m.BIN_roll_response_candidate_26 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | identification | 10.660 | 12.660 |
| VB-01.alt_50m.BIN_roll_response_candidate_27 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | validation | 10.820 | 12.820 |
| VB-01.alt_50m.BIN_roll_response_candidate_28 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | validation | 10.860 | 12.860 |
| VB-01.alt_50m.BIN_roll_response_candidate_29 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | identification | 11.080 | 13.080 |
| VB-01.alt_50m.BIN_roll_response_candidate_30 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | identification | 11.120 | 13.120 |
| VB-01.alt_50m.BIN_roll_response_candidate_31 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | identification | 11.335 | 13.335 |
| VB-01.alt_50m.BIN_roll_response_candidate_32 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | identification | 11.485 | 13.485 |
| VB-01.alt_50m.BIN_roll_response_candidate_33 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | identification | 12.240 | 14.240 |
| VB-01.alt_50m.BIN_roll_response_candidate_34 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | validation | 12.360 | 14.360 |
| VB-01.alt_50m.BIN_roll_response_candidate_35 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | validation | 12.390 | 14.390 |
| VB-01.alt_50m.BIN_roll_response_candidate_36 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | validation | 12.540 | 14.540 |
| VB-01.alt_50m.BIN_roll_response_candidate_37 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | identification | 12.790 | 14.790 |
| VB-01.alt_50m.BIN_roll_response_candidate_38 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | identification | 12.845 | 14.845 |
| VB-01.alt_50m.BIN_roll_response_candidate_39 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | validation | 13.030 | 15.030 |
| VB-01.alt_50m.BIN_roll_response_candidate_40 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | identification | 13.090 | 15.090 |
| VB-01.alt_50m.BIN_roll_response_candidate_41 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | validation | 13.540 | 15.540 |
| VB-01.alt_50m.BIN_roll_response_candidate_42 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | validation | 13.600 | 15.600 |
| VB-01.alt_50m.BIN_roll_response_candidate_43 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | identification | 15.040 | 17.040 |
| VB-01.alt_50m.BIN_roll_response_candidate_44 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | validation | 15.480 | 17.480 |
| VB-01.alt_50m.BIN_roll_response_candidate_45 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | identification | 15.715 | 17.715 |
| VB-01.alt_50m.BIN_roll_response_candidate_46 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | validation | 15.760 | 17.760 |
| VB-01.alt_50m.BIN_roll_response_candidate_47 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | validation | 15.920 | 17.920 |
| VB-01.alt_50m.BIN_roll_response_candidate_48 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | identification | 17.320 | 19.320 |
| VB-01.alt_50m.BIN_roll_response_candidate_49 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | validation | 17.370 | 19.370 |
| VB-01.alt_50m.BIN_roll_response_candidate_50 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | identification | 18.430 | 20.430 |
| VB-01.alt_50m.BIN_roll_response_candidate_51 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | identification | 19.190 | 21.190 |
| VB-01.alt_50m.BIN_roll_response_candidate_52 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | validation | 19.850 | 21.850 |
| VB-01.alt_50m.BIN_roll_response_candidate_53 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | identification | 20.480 | 22.480 |
| VB-01.alt_50m.BIN_roll_response_candidate_54 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | identification | 20.790 | 22.790 |
| VB-01.alt_50m.BIN_roll_response_candidate_55 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | identification | 21.440 | 23.440 |
| VB-01.alt_50m.BIN_roll_response_candidate_56 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | identification | 21.560 | 23.560 |
| VB-01.alt_50m.BIN_roll_response_candidate_57 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | identification | 22.660 | 24.660 |
| VB-01.alt_50m.BIN_roll_response_candidate_58 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | identification | 23.180 | 25.180 |
| VB-01.alt_50m.BIN_roll_response_candidate_59 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | identification | 23.270 | 25.270 |
| VB-01.alt_50m.BIN_roll_response_candidate_60 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | validation | 23.530 | 25.530 |
| VB-01.alt_50m.BIN_roll_response_candidate_61 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | identification | 25.510 | 27.510 |
| VB-01.alt_50m.BIN_roll_response_candidate_62 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | identification | 31.110 | 33.110 |
| VB-01.alt_50m.BIN_roll_response_candidate_63 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | identification | 31.160 | 33.160 |
| VB-01.alt_50m.BIN_roll_response_candidate_64 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | identification | 31.290 | 33.290 |
| VB-01.alt_50m.BIN_roll_response_candidate_65 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | identification | 31.440 | 33.440 |
| VB-01.alt_50m.BIN_roll_response_candidate_66 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | validation | 31.650 | 33.650 |
| VB-01.alt_50m.BIN_roll_response_candidate_67 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | identification | 50.400 | 52.400 |
| VB-01.alt_50m.BIN_roll_response_candidate_68 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | identification | 51.070 | 53.070 |
| VB-01.alt_50m.BIN_roll_response_candidate_69 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | identification | 53.670 | 55.670 |
| VB-01.alt_50m.BIN_roll_response_candidate_70 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | validation | 55.695 | 57.695 |
| VB-01.alt_50m.BIN_roll_response_candidate_71 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | validation | 57.520 | 59.520 |
| VB-01.alt_50m.BIN_roll_response_candidate_72 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | identification | 58.530 | 60.530 |
| VB-01.alt_50m.BIN_roll_response_candidate_73 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | identification | 58.560 | 60.560 |
| VB-01.alt_50m.BIN_roll_response_candidate_74 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | validation | 58.840 | 60.840 |
| VB-01.alt_50m.BIN_roll_response_candidate_75 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | identification | 155.960 | 157.960 |
| VB-01.alt_50m.BIN_roll_response_candidate_76 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | identification | 181.680 | 183.680 |
| VB-01.alt_50m.BIN_roll_response_candidate_77 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | validation | 191.775 | 193.775 |
| VB-01.alt_50m.BIN_roll_response_candidate_78 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | identification | 192.190 | 194.190 |
| VB-01.alt_50m.BIN_roll_response_candidate_79 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | validation | 192.400 | 194.400 |
| VB-01.alt_50m.BIN_roll_response_candidate_80 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | identification | 192.795 | 194.795 |
| VB-01.alt_50m.BIN_roll_response_candidate_81 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | validation | 193.165 | 195.165 |
| VB-01.alt_50m.BIN_roll_response_candidate_82 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | identification | 193.235 | 195.235 |
| VB-01.alt_50m.BIN_roll_response_candidate_83 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | identification | 193.290 | 195.290 |
| VB-01.alt_50m.BIN_roll_response_candidate_84 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | validation | 193.340 | 195.340 |
| VB-01.alt_50m.BIN_roll_response_candidate_85 | VB-01.alt_50m.BIN | В-10 | roll_response_candidate | validation | 193.415 | 195.415 |
| VB-01.alt_50m.BIN_pitch_response_candidate_1 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 2.245 | 4.245 |
| VB-01.alt_50m.BIN_pitch_response_candidate_2 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 2.515 | 4.515 |
| VB-01.alt_50m.BIN_pitch_response_candidate_3 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 2.605 | 4.605 |
| VB-01.alt_50m.BIN_pitch_response_candidate_4 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 2.790 | 4.790 |
| VB-01.alt_50m.BIN_pitch_response_candidate_5 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 2.870 | 4.870 |
| VB-01.alt_50m.BIN_pitch_response_candidate_6 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 2.940 | 4.940 |
| VB-01.alt_50m.BIN_pitch_response_candidate_7 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 3.310 | 5.310 |
| VB-01.alt_50m.BIN_pitch_response_candidate_8 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 3.555 | 5.555 |
| VB-01.alt_50m.BIN_pitch_response_candidate_9 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 3.700 | 5.700 |
| VB-01.alt_50m.BIN_pitch_response_candidate_10 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 3.740 | 5.740 |
| VB-01.alt_50m.BIN_pitch_response_candidate_11 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 3.950 | 5.950 |
| VB-01.alt_50m.BIN_pitch_response_candidate_12 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 4.020 | 6.020 |
| VB-01.alt_50m.BIN_pitch_response_candidate_13 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 4.050 | 6.050 |
| VB-01.alt_50m.BIN_pitch_response_candidate_14 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 4.180 | 6.180 |
| VB-01.alt_50m.BIN_pitch_response_candidate_15 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 4.345 | 6.345 |
| VB-01.alt_50m.BIN_pitch_response_candidate_16 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 4.600 | 6.600 |
| VB-01.alt_50m.BIN_pitch_response_candidate_17 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 4.690 | 6.690 |
| VB-01.alt_50m.BIN_pitch_response_candidate_18 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 4.730 | 6.730 |
| VB-01.alt_50m.BIN_pitch_response_candidate_19 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 5.410 | 7.410 |
| VB-01.alt_50m.BIN_pitch_response_candidate_20 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 5.850 | 7.850 |
| VB-01.alt_50m.BIN_pitch_response_candidate_21 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 6.015 | 8.015 |
| VB-01.alt_50m.BIN_pitch_response_candidate_22 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 6.055 | 8.055 |
| VB-01.alt_50m.BIN_pitch_response_candidate_23 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 6.230 | 8.230 |
| VB-01.alt_50m.BIN_pitch_response_candidate_24 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 6.260 | 8.260 |
| VB-01.alt_50m.BIN_pitch_response_candidate_25 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 6.680 | 8.680 |
| VB-01.alt_50m.BIN_pitch_response_candidate_26 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 6.710 | 8.710 |
| VB-01.alt_50m.BIN_pitch_response_candidate_27 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 7.075 | 9.075 |
| VB-01.alt_50m.BIN_pitch_response_candidate_28 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 7.105 | 9.105 |
| VB-01.alt_50m.BIN_pitch_response_candidate_29 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 7.380 | 9.380 |
| VB-01.alt_50m.BIN_pitch_response_candidate_30 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 8.330 | 10.330 |
| VB-01.alt_50m.BIN_pitch_response_candidate_31 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 8.360 | 10.360 |
| VB-01.alt_50m.BIN_pitch_response_candidate_32 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 8.595 | 10.595 |
| VB-01.alt_50m.BIN_pitch_response_candidate_33 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 8.625 | 10.625 |
| VB-01.alt_50m.BIN_pitch_response_candidate_34 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 8.895 | 10.895 |
| VB-01.alt_50m.BIN_pitch_response_candidate_35 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 8.925 | 10.925 |
| VB-01.alt_50m.BIN_pitch_response_candidate_36 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 9.295 | 11.295 |
| VB-01.alt_50m.BIN_pitch_response_candidate_37 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 9.330 | 11.330 |
| VB-01.alt_50m.BIN_pitch_response_candidate_38 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 9.810 | 11.810 |
| VB-01.alt_50m.BIN_pitch_response_candidate_39 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 10.015 | 12.015 |
| VB-01.alt_50m.BIN_pitch_response_candidate_40 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 10.135 | 12.135 |
| VB-01.alt_50m.BIN_pitch_response_candidate_41 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 10.560 | 12.560 |
| VB-01.alt_50m.BIN_pitch_response_candidate_42 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 10.720 | 12.720 |
| VB-01.alt_50m.BIN_pitch_response_candidate_43 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 10.750 | 12.750 |
| VB-01.alt_50m.BIN_pitch_response_candidate_44 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 10.825 | 12.825 |
| VB-01.alt_50m.BIN_pitch_response_candidate_45 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 10.860 | 12.860 |
| VB-01.alt_50m.BIN_pitch_response_candidate_46 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 11.155 | 13.155 |
| VB-01.alt_50m.BIN_pitch_response_candidate_47 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 11.265 | 13.265 |
| VB-01.alt_50m.BIN_pitch_response_candidate_48 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 11.560 | 13.560 |
| VB-01.alt_50m.BIN_pitch_response_candidate_49 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 11.760 | 13.760 |
| VB-01.alt_50m.BIN_pitch_response_candidate_50 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 11.865 | 13.865 |
| VB-01.alt_50m.BIN_pitch_response_candidate_51 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 12.030 | 14.030 |
| VB-01.alt_50m.BIN_pitch_response_candidate_52 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 12.180 | 14.180 |
| VB-01.alt_50m.BIN_pitch_response_candidate_53 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 12.245 | 14.245 |
| VB-01.alt_50m.BIN_pitch_response_candidate_54 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 12.360 | 14.360 |
| VB-01.alt_50m.BIN_pitch_response_candidate_55 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 12.770 | 14.770 |
| VB-01.alt_50m.BIN_pitch_response_candidate_56 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 12.790 | 14.790 |
| VB-01.alt_50m.BIN_pitch_response_candidate_57 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 12.850 | 14.850 |
| VB-01.alt_50m.BIN_pitch_response_candidate_58 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 12.880 | 14.880 |
| VB-01.alt_50m.BIN_pitch_response_candidate_59 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 13.010 | 15.010 |
| VB-01.alt_50m.BIN_pitch_response_candidate_60 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 13.100 | 15.100 |
| VB-01.alt_50m.BIN_pitch_response_candidate_61 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 13.370 | 15.370 |
| VB-01.alt_50m.BIN_pitch_response_candidate_62 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 13.440 | 15.440 |
| VB-01.alt_50m.BIN_pitch_response_candidate_63 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 13.515 | 15.515 |
| VB-01.alt_50m.BIN_pitch_response_candidate_64 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 13.600 | 15.600 |
| VB-01.alt_50m.BIN_pitch_response_candidate_65 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 13.825 | 15.825 |
| VB-01.alt_50m.BIN_pitch_response_candidate_66 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 13.990 | 15.990 |
| VB-01.alt_50m.BIN_pitch_response_candidate_67 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 14.225 | 16.225 |
| VB-01.alt_50m.BIN_pitch_response_candidate_68 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 14.370 | 16.370 |
| VB-01.alt_50m.BIN_pitch_response_candidate_69 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 14.905 | 16.905 |
| VB-01.alt_50m.BIN_pitch_response_candidate_70 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 15.040 | 17.040 |
| VB-01.alt_50m.BIN_pitch_response_candidate_71 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 15.175 | 17.175 |
| VB-01.alt_50m.BIN_pitch_response_candidate_72 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 15.240 | 17.240 |
| VB-01.alt_50m.BIN_pitch_response_candidate_73 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 15.310 | 17.310 |
| VB-01.alt_50m.BIN_pitch_response_candidate_74 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 15.355 | 17.355 |
| VB-01.alt_50m.BIN_pitch_response_candidate_75 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 15.970 | 17.970 |
| VB-01.alt_50m.BIN_pitch_response_candidate_76 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 16.630 | 18.630 |
| VB-01.alt_50m.BIN_pitch_response_candidate_77 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 16.920 | 18.920 |
| VB-01.alt_50m.BIN_pitch_response_candidate_78 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 17.020 | 19.020 |
| VB-01.alt_50m.BIN_pitch_response_candidate_79 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 17.910 | 19.910 |
| VB-01.alt_50m.BIN_pitch_response_candidate_80 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 18.020 | 20.020 |
| VB-01.alt_50m.BIN_pitch_response_candidate_81 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 18.430 | 20.430 |
| VB-01.alt_50m.BIN_pitch_response_candidate_82 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 18.600 | 20.600 |
| VB-01.alt_50m.BIN_pitch_response_candidate_83 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 18.690 | 20.690 |
| VB-01.alt_50m.BIN_pitch_response_candidate_84 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 18.860 | 20.860 |
| VB-01.alt_50m.BIN_pitch_response_candidate_85 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 19.100 | 21.100 |
| VB-01.alt_50m.BIN_pitch_response_candidate_86 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 19.190 | 21.190 |
| VB-01.alt_50m.BIN_pitch_response_candidate_87 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 20.050 | 22.050 |
| VB-01.alt_50m.BIN_pitch_response_candidate_88 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 20.380 | 22.380 |
| VB-01.alt_50m.BIN_pitch_response_candidate_89 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 20.970 | 22.970 |
| VB-01.alt_50m.BIN_pitch_response_candidate_90 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 22.020 | 24.020 |
| VB-01.alt_50m.BIN_pitch_response_candidate_91 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 22.660 | 24.660 |
| VB-01.alt_50m.BIN_pitch_response_candidate_92 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 22.830 | 24.830 |
| VB-01.alt_50m.BIN_pitch_response_candidate_93 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 28.400 | 30.400 |
| VB-01.alt_50m.BIN_pitch_response_candidate_94 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 28.930 | 30.930 |
| VB-01.alt_50m.BIN_pitch_response_candidate_95 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 28.950 | 30.950 |
| VB-01.alt_50m.BIN_pitch_response_candidate_96 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 29.055 | 31.055 |
| VB-01.alt_50m.BIN_pitch_response_candidate_97 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 29.740 | 31.740 |
| VB-01.alt_50m.BIN_pitch_response_candidate_98 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 29.990 | 31.990 |
| VB-01.alt_50m.BIN_pitch_response_candidate_99 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 30.950 | 32.950 |
| VB-01.alt_50m.BIN_pitch_response_candidate_100 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 31.080 | 33.080 |
| VB-01.alt_50m.BIN_pitch_response_candidate_101 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 31.100 | 33.100 |
| VB-01.alt_50m.BIN_pitch_response_candidate_102 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 31.230 | 33.230 |
| VB-01.alt_50m.BIN_pitch_response_candidate_103 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 31.250 | 33.250 |
| VB-01.alt_50m.BIN_pitch_response_candidate_104 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 31.290 | 33.290 |
| VB-01.alt_50m.BIN_pitch_response_candidate_105 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 31.420 | 33.420 |
| VB-01.alt_50m.BIN_pitch_response_candidate_106 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 31.440 | 33.440 |
| VB-01.alt_50m.BIN_pitch_response_candidate_107 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 31.480 | 33.480 |
| VB-01.alt_50m.BIN_pitch_response_candidate_108 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 31.510 | 33.510 |
| VB-01.alt_50m.BIN_pitch_response_candidate_109 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 31.570 | 33.570 |
| VB-01.alt_50m.BIN_pitch_response_candidate_110 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 31.660 | 33.660 |
| VB-01.alt_50m.BIN_pitch_response_candidate_111 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 31.790 | 33.790 |
| VB-01.alt_50m.BIN_pitch_response_candidate_112 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 31.810 | 33.810 |
| VB-01.alt_50m.BIN_pitch_response_candidate_113 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 31.850 | 33.850 |
| VB-01.alt_50m.BIN_pitch_response_candidate_114 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 31.940 | 33.940 |
| VB-01.alt_50m.BIN_pitch_response_candidate_115 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 32.090 | 34.090 |
| VB-01.alt_50m.BIN_pitch_response_candidate_116 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 32.175 | 34.175 |
| VB-01.alt_50m.BIN_pitch_response_candidate_117 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 32.210 | 34.210 |
| VB-01.alt_50m.BIN_pitch_response_candidate_118 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 32.450 | 34.450 |
| VB-01.alt_50m.BIN_pitch_response_candidate_119 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 32.500 | 34.500 |
| VB-01.alt_50m.BIN_pitch_response_candidate_120 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 32.600 | 34.600 |
| VB-01.alt_50m.BIN_pitch_response_candidate_121 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 32.670 | 34.670 |
| VB-01.alt_50m.BIN_pitch_response_candidate_122 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 32.700 | 34.700 |
| VB-01.alt_50m.BIN_pitch_response_candidate_123 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 32.720 | 34.720 |
| VB-01.alt_50m.BIN_pitch_response_candidate_124 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 32.770 | 34.770 |
| VB-01.alt_50m.BIN_pitch_response_candidate_125 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 32.880 | 34.880 |
| VB-01.alt_50m.BIN_pitch_response_candidate_126 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 32.920 | 34.920 |
| VB-01.alt_50m.BIN_pitch_response_candidate_127 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 33.190 | 35.190 |
| VB-01.alt_50m.BIN_pitch_response_candidate_128 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 33.640 | 35.640 |
| VB-01.alt_50m.BIN_pitch_response_candidate_129 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 33.670 | 35.670 |
| VB-01.alt_50m.BIN_pitch_response_candidate_130 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 33.720 | 35.720 |
| VB-01.alt_50m.BIN_pitch_response_candidate_131 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 33.740 | 35.740 |
| VB-01.alt_50m.BIN_pitch_response_candidate_132 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 33.770 | 35.770 |
| VB-01.alt_50m.BIN_pitch_response_candidate_133 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 33.800 | 35.800 |
| VB-01.alt_50m.BIN_pitch_response_candidate_134 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 34.070 | 36.070 |
| VB-01.alt_50m.BIN_pitch_response_candidate_135 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 34.210 | 36.210 |
| VB-01.alt_50m.BIN_pitch_response_candidate_136 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 34.320 | 36.320 |
| VB-01.alt_50m.BIN_pitch_response_candidate_137 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 34.460 | 36.460 |
| VB-01.alt_50m.BIN_pitch_response_candidate_138 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 34.700 | 36.700 |
| VB-01.alt_50m.BIN_pitch_response_candidate_139 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 34.750 | 36.750 |
| VB-01.alt_50m.BIN_pitch_response_candidate_140 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 34.910 | 36.910 |
| VB-01.alt_50m.BIN_pitch_response_candidate_141 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 34.990 | 36.990 |
| VB-01.alt_50m.BIN_pitch_response_candidate_142 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 35.050 | 37.050 |
| VB-01.alt_50m.BIN_pitch_response_candidate_143 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 35.080 | 37.080 |
| VB-01.alt_50m.BIN_pitch_response_candidate_144 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 35.110 | 37.110 |
| VB-01.alt_50m.BIN_pitch_response_candidate_145 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 35.130 | 37.130 |
| VB-01.alt_50m.BIN_pitch_response_candidate_146 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 35.180 | 37.180 |
| VB-01.alt_50m.BIN_pitch_response_candidate_147 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 35.210 | 37.210 |
| VB-01.alt_50m.BIN_pitch_response_candidate_148 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 35.280 | 37.280 |
| VB-01.alt_50m.BIN_pitch_response_candidate_149 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 35.315 | 37.315 |
| VB-01.alt_50m.BIN_pitch_response_candidate_150 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 35.345 | 37.345 |
| VB-01.alt_50m.BIN_pitch_response_candidate_151 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 35.370 | 37.370 |
| VB-01.alt_50m.BIN_pitch_response_candidate_152 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 35.430 | 37.430 |
| VB-01.alt_50m.BIN_pitch_response_candidate_153 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 35.560 | 37.560 |
| VB-01.alt_50m.BIN_pitch_response_candidate_154 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 35.660 | 37.660 |
| VB-01.alt_50m.BIN_pitch_response_candidate_155 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 35.910 | 37.910 |
| VB-01.alt_50m.BIN_pitch_response_candidate_156 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 35.940 | 37.940 |
| VB-01.alt_50m.BIN_pitch_response_candidate_157 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 36.080 | 38.080 |
| VB-01.alt_50m.BIN_pitch_response_candidate_158 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 36.150 | 38.150 |
| VB-01.alt_50m.BIN_pitch_response_candidate_159 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 36.290 | 38.290 |
| VB-01.alt_50m.BIN_pitch_response_candidate_160 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 36.380 | 38.380 |
| VB-01.alt_50m.BIN_pitch_response_candidate_161 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 36.510 | 38.510 |
| VB-01.alt_50m.BIN_pitch_response_candidate_162 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 37.110 | 39.110 |
| VB-01.alt_50m.BIN_pitch_response_candidate_163 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 37.130 | 39.130 |
| VB-01.alt_50m.BIN_pitch_response_candidate_164 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 37.310 | 39.310 |
| VB-01.alt_50m.BIN_pitch_response_candidate_165 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 37.350 | 39.350 |
| VB-01.alt_50m.BIN_pitch_response_candidate_166 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 37.640 | 39.640 |
| VB-01.alt_50m.BIN_pitch_response_candidate_167 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 39.600 | 41.600 |
| VB-01.alt_50m.BIN_pitch_response_candidate_168 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 44.770 | 46.770 |
| VB-01.alt_50m.BIN_pitch_response_candidate_169 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 44.890 | 46.890 |
| VB-01.alt_50m.BIN_pitch_response_candidate_170 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 46.560 | 48.560 |
| VB-01.alt_50m.BIN_pitch_response_candidate_171 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 46.580 | 48.580 |
| VB-01.alt_50m.BIN_pitch_response_candidate_172 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 46.660 | 48.660 |
| VB-01.alt_50m.BIN_pitch_response_candidate_173 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 46.735 | 48.735 |
| VB-01.alt_50m.BIN_pitch_response_candidate_174 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 46.760 | 48.760 |
| VB-01.alt_50m.BIN_pitch_response_candidate_175 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 46.850 | 48.850 |
| VB-01.alt_50m.BIN_pitch_response_candidate_176 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 46.980 | 48.980 |
| VB-01.alt_50m.BIN_pitch_response_candidate_177 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 48.930 | 50.930 |
| VB-01.alt_50m.BIN_pitch_response_candidate_178 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 49.300 | 51.300 |
| VB-01.alt_50m.BIN_pitch_response_candidate_179 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 49.320 | 51.320 |
| VB-01.alt_50m.BIN_pitch_response_candidate_180 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 49.900 | 51.900 |
| VB-01.alt_50m.BIN_pitch_response_candidate_181 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 50.350 | 52.350 |
| VB-01.alt_50m.BIN_pitch_response_candidate_182 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 50.400 | 52.400 |
| VB-01.alt_50m.BIN_pitch_response_candidate_183 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 51.230 | 53.230 |
| VB-01.alt_50m.BIN_pitch_response_candidate_184 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 51.390 | 53.390 |
| VB-01.alt_50m.BIN_pitch_response_candidate_185 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 51.850 | 53.850 |
| VB-01.alt_50m.BIN_pitch_response_candidate_186 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 51.930 | 53.930 |
| VB-01.alt_50m.BIN_pitch_response_candidate_187 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 52.200 | 54.200 |
| VB-01.alt_50m.BIN_pitch_response_candidate_188 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 52.310 | 54.310 |
| VB-01.alt_50m.BIN_pitch_response_candidate_189 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 52.330 | 54.330 |
| VB-01.alt_50m.BIN_pitch_response_candidate_190 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 52.530 | 54.530 |
| VB-01.alt_50m.BIN_pitch_response_candidate_191 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 52.550 | 54.550 |
| VB-01.alt_50m.BIN_pitch_response_candidate_192 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 52.650 | 54.650 |
| VB-01.alt_50m.BIN_pitch_response_candidate_193 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 52.750 | 54.750 |
| VB-01.alt_50m.BIN_pitch_response_candidate_194 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 52.770 | 54.770 |
| VB-01.alt_50m.BIN_pitch_response_candidate_195 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 52.990 | 54.990 |
| VB-01.alt_50m.BIN_pitch_response_candidate_196 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 53.130 | 55.130 |
| VB-01.alt_50m.BIN_pitch_response_candidate_197 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 53.220 | 55.220 |
| VB-01.alt_50m.BIN_pitch_response_candidate_198 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 53.550 | 55.550 |
| VB-01.alt_50m.BIN_pitch_response_candidate_199 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 53.580 | 55.580 |
| VB-01.alt_50m.BIN_pitch_response_candidate_200 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 53.660 | 55.660 |
| VB-01.alt_50m.BIN_pitch_response_candidate_201 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 53.870 | 55.870 |
| VB-01.alt_50m.BIN_pitch_response_candidate_202 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 54.090 | 56.090 |
| VB-01.alt_50m.BIN_pitch_response_candidate_203 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 54.245 | 56.245 |
| VB-01.alt_50m.BIN_pitch_response_candidate_204 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 54.285 | 56.285 |
| VB-01.alt_50m.BIN_pitch_response_candidate_205 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 54.310 | 56.310 |
| VB-01.alt_50m.BIN_pitch_response_candidate_206 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 54.335 | 56.335 |
| VB-01.alt_50m.BIN_pitch_response_candidate_207 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 54.960 | 56.960 |
| VB-01.alt_50m.BIN_pitch_response_candidate_208 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 55.180 | 57.180 |
| VB-01.alt_50m.BIN_pitch_response_candidate_209 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 55.400 | 57.400 |
| VB-01.alt_50m.BIN_pitch_response_candidate_210 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 55.530 | 57.530 |
| VB-01.alt_50m.BIN_pitch_response_candidate_211 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 55.590 | 57.590 |
| VB-01.alt_50m.BIN_pitch_response_candidate_212 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 55.610 | 57.610 |
| VB-01.alt_50m.BIN_pitch_response_candidate_213 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 55.660 | 57.660 |
| VB-01.alt_50m.BIN_pitch_response_candidate_214 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 55.775 | 57.775 |
| VB-01.alt_50m.BIN_pitch_response_candidate_215 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 55.810 | 57.810 |
| VB-01.alt_50m.BIN_pitch_response_candidate_216 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 55.835 | 57.835 |
| VB-01.alt_50m.BIN_pitch_response_candidate_217 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 55.865 | 57.865 |
| VB-01.alt_50m.BIN_pitch_response_candidate_218 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 55.890 | 57.890 |
| VB-01.alt_50m.BIN_pitch_response_candidate_219 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 55.925 | 57.925 |
| VB-01.alt_50m.BIN_pitch_response_candidate_220 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 55.980 | 57.980 |
| VB-01.alt_50m.BIN_pitch_response_candidate_221 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 56.020 | 58.020 |
| VB-01.alt_50m.BIN_pitch_response_candidate_222 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 56.050 | 58.050 |
| VB-01.alt_50m.BIN_pitch_response_candidate_223 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 56.070 | 58.070 |
| VB-01.alt_50m.BIN_pitch_response_candidate_224 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 56.105 | 58.105 |
| VB-01.alt_50m.BIN_pitch_response_candidate_225 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 56.130 | 58.130 |
| VB-01.alt_50m.BIN_pitch_response_candidate_226 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 56.150 | 58.150 |
| VB-01.alt_50m.BIN_pitch_response_candidate_227 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 56.240 | 58.240 |
| VB-01.alt_50m.BIN_pitch_response_candidate_228 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 56.260 | 58.260 |
| VB-01.alt_50m.BIN_pitch_response_candidate_229 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 56.340 | 58.340 |
| VB-01.alt_50m.BIN_pitch_response_candidate_230 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 56.370 | 58.370 |
| VB-01.alt_50m.BIN_pitch_response_candidate_231 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 56.390 | 58.390 |
| VB-01.alt_50m.BIN_pitch_response_candidate_232 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 56.440 | 58.440 |
| VB-01.alt_50m.BIN_pitch_response_candidate_233 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 56.470 | 58.470 |
| VB-01.alt_50m.BIN_pitch_response_candidate_234 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 56.500 | 58.500 |
| VB-01.alt_50m.BIN_pitch_response_candidate_235 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 56.520 | 58.520 |
| VB-01.alt_50m.BIN_pitch_response_candidate_236 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 56.570 | 58.570 |
| VB-01.alt_50m.BIN_pitch_response_candidate_237 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 56.630 | 58.630 |
| VB-01.alt_50m.BIN_pitch_response_candidate_238 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 56.650 | 58.650 |
| VB-01.alt_50m.BIN_pitch_response_candidate_239 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 56.775 | 58.775 |
| VB-01.alt_50m.BIN_pitch_response_candidate_240 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 57.060 | 59.060 |
| VB-01.alt_50m.BIN_pitch_response_candidate_241 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 57.140 | 59.140 |
| VB-01.alt_50m.BIN_pitch_response_candidate_242 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 57.160 | 59.160 |
| VB-01.alt_50m.BIN_pitch_response_candidate_243 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 57.270 | 59.270 |
| VB-01.alt_50m.BIN_pitch_response_candidate_244 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 57.525 | 59.525 |
| VB-01.alt_50m.BIN_pitch_response_candidate_245 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 57.690 | 59.690 |
| VB-01.alt_50m.BIN_pitch_response_candidate_246 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 57.850 | 59.850 |
| VB-01.alt_50m.BIN_pitch_response_candidate_247 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 57.870 | 59.870 |
| VB-01.alt_50m.BIN_pitch_response_candidate_248 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 58.140 | 60.140 |
| VB-01.alt_50m.BIN_pitch_response_candidate_249 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 58.260 | 60.260 |
| VB-01.alt_50m.BIN_pitch_response_candidate_250 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 58.540 | 60.540 |
| VB-01.alt_50m.BIN_pitch_response_candidate_251 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 58.560 | 60.560 |
| VB-01.alt_50m.BIN_pitch_response_candidate_252 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 58.670 | 60.670 |
| VB-01.alt_50m.BIN_pitch_response_candidate_253 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 58.790 | 60.790 |
| VB-01.alt_50m.BIN_pitch_response_candidate_254 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 58.810 | 60.810 |
| VB-01.alt_50m.BIN_pitch_response_candidate_255 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 58.830 | 60.830 |
| VB-01.alt_50m.BIN_pitch_response_candidate_256 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 58.970 | 60.970 |
| VB-01.alt_50m.BIN_pitch_response_candidate_257 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 59.140 | 61.140 |
| VB-01.alt_50m.BIN_pitch_response_candidate_258 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 59.160 | 61.160 |
| VB-01.alt_50m.BIN_pitch_response_candidate_259 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 59.220 | 61.220 |
| VB-01.alt_50m.BIN_pitch_response_candidate_260 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 59.240 | 61.240 |
| VB-01.alt_50m.BIN_pitch_response_candidate_261 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 59.270 | 61.270 |
| VB-01.alt_50m.BIN_pitch_response_candidate_262 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 59.290 | 61.290 |
| VB-01.alt_50m.BIN_pitch_response_candidate_263 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 59.440 | 61.440 |
| VB-01.alt_50m.BIN_pitch_response_candidate_264 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 59.970 | 61.970 |
| VB-01.alt_50m.BIN_pitch_response_candidate_265 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 60.210 | 62.210 |
| VB-01.alt_50m.BIN_pitch_response_candidate_266 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 60.265 | 62.265 |
| VB-01.alt_50m.BIN_pitch_response_candidate_267 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 60.340 | 62.340 |
| VB-01.alt_50m.BIN_pitch_response_candidate_268 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 61.090 | 63.090 |
| VB-01.alt_50m.BIN_pitch_response_candidate_269 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 61.120 | 63.120 |
| VB-01.alt_50m.BIN_pitch_response_candidate_270 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 61.280 | 63.280 |
| VB-01.alt_50m.BIN_pitch_response_candidate_271 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 61.680 | 63.680 |
| VB-01.alt_50m.BIN_pitch_response_candidate_272 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 62.030 | 64.030 |
| VB-01.alt_50m.BIN_pitch_response_candidate_273 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 62.050 | 64.050 |
| VB-01.alt_50m.BIN_pitch_response_candidate_274 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 62.230 | 64.230 |
| VB-01.alt_50m.BIN_pitch_response_candidate_275 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 64.260 | 66.260 |
| VB-01.alt_50m.BIN_pitch_response_candidate_276 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 66.130 | 68.130 |
| VB-01.alt_50m.BIN_pitch_response_candidate_277 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 67.170 | 69.170 |
| VB-01.alt_50m.BIN_pitch_response_candidate_278 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 67.190 | 69.190 |
| VB-01.alt_50m.BIN_pitch_response_candidate_279 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 68.440 | 70.440 |
| VB-01.alt_50m.BIN_pitch_response_candidate_280 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 68.460 | 70.460 |
| VB-01.alt_50m.BIN_pitch_response_candidate_281 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 69.380 | 71.380 |
| VB-01.alt_50m.BIN_pitch_response_candidate_282 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 69.420 | 71.420 |
| VB-01.alt_50m.BIN_pitch_response_candidate_283 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 69.670 | 71.670 |
| VB-01.alt_50m.BIN_pitch_response_candidate_284 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 69.730 | 71.730 |
| VB-01.alt_50m.BIN_pitch_response_candidate_285 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 69.840 | 71.840 |
| VB-01.alt_50m.BIN_pitch_response_candidate_286 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 70.060 | 72.060 |
| VB-01.alt_50m.BIN_pitch_response_candidate_287 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 70.500 | 72.500 |
| VB-01.alt_50m.BIN_pitch_response_candidate_288 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 70.830 | 72.830 |
| VB-01.alt_50m.BIN_pitch_response_candidate_289 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 71.950 | 73.950 |
| VB-01.alt_50m.BIN_pitch_response_candidate_290 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 72.190 | 74.190 |
| VB-01.alt_50m.BIN_pitch_response_candidate_291 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 72.990 | 74.990 |
| VB-01.alt_50m.BIN_pitch_response_candidate_292 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 73.260 | 75.260 |
| VB-01.alt_50m.BIN_pitch_response_candidate_293 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 73.400 | 75.400 |
| VB-01.alt_50m.BIN_pitch_response_candidate_294 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 73.580 | 75.580 |
| VB-01.alt_50m.BIN_pitch_response_candidate_295 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 75.740 | 77.740 |
| VB-01.alt_50m.BIN_pitch_response_candidate_296 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 76.570 | 78.570 |
| VB-01.alt_50m.BIN_pitch_response_candidate_297 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 76.590 | 78.590 |
| VB-01.alt_50m.BIN_pitch_response_candidate_298 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 77.080 | 79.080 |
| VB-01.alt_50m.BIN_pitch_response_candidate_299 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 78.760 | 80.760 |
| VB-01.alt_50m.BIN_pitch_response_candidate_300 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 79.350 | 81.350 |
| VB-01.alt_50m.BIN_pitch_response_candidate_301 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 87.970 | 89.970 |
| VB-01.alt_50m.BIN_pitch_response_candidate_302 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 88.080 | 90.080 |
| VB-01.alt_50m.BIN_pitch_response_candidate_303 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 88.110 | 90.110 |
| VB-01.alt_50m.BIN_pitch_response_candidate_304 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 88.130 | 90.130 |
| VB-01.alt_50m.BIN_pitch_response_candidate_305 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 145.430 | 147.430 |
| VB-01.alt_50m.BIN_pitch_response_candidate_306 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 145.575 | 147.575 |
| VB-01.alt_50m.BIN_pitch_response_candidate_307 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 145.820 | 147.820 |
| VB-01.alt_50m.BIN_pitch_response_candidate_308 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 146.115 | 148.115 |
| VB-01.alt_50m.BIN_pitch_response_candidate_309 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 146.240 | 148.240 |
| VB-01.alt_50m.BIN_pitch_response_candidate_310 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 146.450 | 148.450 |
| VB-01.alt_50m.BIN_pitch_response_candidate_311 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 146.970 | 148.970 |
| VB-01.alt_50m.BIN_pitch_response_candidate_312 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 147.035 | 149.035 |
| VB-01.alt_50m.BIN_pitch_response_candidate_313 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 147.760 | 149.760 |
| VB-01.alt_50m.BIN_pitch_response_candidate_314 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 147.880 | 149.880 |
| VB-01.alt_50m.BIN_pitch_response_candidate_315 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 149.385 | 151.385 |
| VB-01.alt_50m.BIN_pitch_response_candidate_316 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 149.410 | 151.410 |
| VB-01.alt_50m.BIN_pitch_response_candidate_317 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 149.515 | 151.515 |
| VB-01.alt_50m.BIN_pitch_response_candidate_318 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 172.240 | 174.240 |
| VB-01.alt_50m.BIN_pitch_response_candidate_319 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 172.755 | 174.755 |
| VB-01.alt_50m.BIN_pitch_response_candidate_320 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 173.090 | 175.090 |
| VB-01.alt_50m.BIN_pitch_response_candidate_321 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 173.150 | 175.150 |
| VB-01.alt_50m.BIN_pitch_response_candidate_322 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 173.235 | 175.235 |
| VB-01.alt_50m.BIN_pitch_response_candidate_323 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 173.455 | 175.455 |
| VB-01.alt_50m.BIN_pitch_response_candidate_324 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 173.610 | 175.610 |
| VB-01.alt_50m.BIN_pitch_response_candidate_325 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 179.925 | 181.925 |
| VB-01.alt_50m.BIN_pitch_response_candidate_326 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 180.895 | 182.895 |
| VB-01.alt_50m.BIN_pitch_response_candidate_327 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 181.120 | 183.120 |
| VB-01.alt_50m.BIN_pitch_response_candidate_328 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 184.295 | 186.295 |
| VB-01.alt_50m.BIN_pitch_response_candidate_329 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 184.915 | 186.915 |
| VB-01.alt_50m.BIN_pitch_response_candidate_330 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 185.030 | 187.030 |
| VB-01.alt_50m.BIN_pitch_response_candidate_331 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 188.695 | 190.695 |
| VB-01.alt_50m.BIN_pitch_response_candidate_332 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 189.280 | 191.280 |
| VB-01.alt_50m.BIN_pitch_response_candidate_333 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | identification | 190.830 | 192.830 |
| VB-01.alt_50m.BIN_pitch_response_candidate_334 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 191.800 | 193.800 |
| VB-01.alt_50m.BIN_pitch_response_candidate_335 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 192.620 | 194.620 |
| VB-01.alt_50m.BIN_pitch_response_candidate_336 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 192.915 | 194.915 |
| VB-01.alt_50m.BIN_pitch_response_candidate_337 | VB-01.alt_50m.BIN | В-09 | pitch_response_candidate | validation | 194.020 | 208.100 |
| VB-01.alt_50m.BIN_yaw_response_candidate_1 | VB-01.alt_50m.BIN | В-11 | yaw_response_candidate | identification | 23.085 | 25.085 |
| VB-01.alt_50m.BIN_yaw_response_candidate_2 | VB-01.alt_50m.BIN | В-11 | yaw_response_candidate | validation | 23.645 | 25.645 |
| VB-01.alt_50m.BIN_yaw_response_candidate_3 | VB-01.alt_50m.BIN | В-11 | yaw_response_candidate | identification | 24.805 | 26.805 |
| VB-01.alt_50m.BIN_yaw_response_candidate_4 | VB-01.alt_50m.BIN | В-11 | yaw_response_candidate | identification | 29.140 | 31.140 |
| VB-01.alt_50m.BIN_yaw_response_candidate_5 | VB-01.alt_50m.BIN | В-11 | yaw_response_candidate | identification | 30.985 | 32.985 |
| VB-01.alt_50m.BIN_yaw_response_candidate_6 | VB-01.alt_50m.BIN | В-11 | yaw_response_candidate | identification | 31.170 | 33.170 |
| VB-01.alt_50m.BIN_yaw_response_candidate_7 | VB-01.alt_50m.BIN | В-11 | yaw_response_candidate | validation | 44.925 | 46.925 |
| VB-01.alt_50m.BIN_yaw_response_candidate_8 | VB-01.alt_50m.BIN | В-11 | yaw_response_candidate | identification | 47.385 | 49.385 |
| VB-01.alt_50m.BIN_yaw_response_candidate_9 | VB-01.alt_50m.BIN | В-11 | yaw_response_candidate | identification | 47.550 | 49.550 |
| VB-01.alt_50m.BIN_yaw_response_candidate_10 | VB-01.alt_50m.BIN | В-11 | yaw_response_candidate | validation | 47.865 | 49.865 |
| VB-01.alt_50m.BIN_yaw_response_candidate_11 | VB-01.alt_50m.BIN | В-11 | yaw_response_candidate | identification | 49.010 | 51.010 |
| VB-01.alt_50m.BIN_yaw_response_candidate_12 | VB-01.alt_50m.BIN | В-11 | yaw_response_candidate | identification | 50.425 | 52.425 |
| VB-01.alt_50m.BIN_yaw_response_candidate_13 | VB-01.alt_50m.BIN | В-11 | yaw_response_candidate | validation | 51.395 | 53.395 |
| VB-01.alt_50m.BIN_yaw_response_candidate_14 | VB-01.alt_50m.BIN | В-11 | yaw_response_candidate | identification | 51.665 | 53.665 |
| VB-01.alt_50m.BIN_yaw_response_candidate_15 | VB-01.alt_50m.BIN | В-11 | yaw_response_candidate | identification | 52.575 | 54.575 |
| VB-01.alt_50m.BIN_yaw_response_candidate_16 | VB-01.alt_50m.BIN | В-11 | yaw_response_candidate | validation | 53.830 | 55.830 |
| VB-01.alt_50m.BIN_yaw_response_candidate_17 | VB-01.alt_50m.BIN | В-11 | yaw_response_candidate | validation | 55.105 | 57.105 |
| VB-01.alt_50m.BIN_yaw_response_candidate_18 | VB-01.alt_50m.BIN | В-11 | yaw_response_candidate | validation | 55.775 | 57.775 |
| VB-01.alt_50m.BIN_yaw_response_candidate_19 | VB-01.alt_50m.BIN | В-11 | yaw_response_candidate | validation | 56.005 | 58.005 |
| VB-01.alt_50m.BIN_yaw_response_candidate_20 | VB-01.alt_50m.BIN | В-11 | yaw_response_candidate | validation | 69.610 | 71.610 |
| VB-01.alt_50m.BIN_yaw_response_candidate_21 | VB-01.alt_50m.BIN | В-11 | yaw_response_candidate | validation | 70.115 | 72.115 |
| VB-01.alt_50m.BIN_yaw_response_candidate_22 | VB-01.alt_50m.BIN | В-11 | yaw_response_candidate | identification | 70.430 | 72.430 |
| VB-01.alt_50m.BIN_yaw_response_candidate_23 | VB-01.alt_50m.BIN | В-11 | yaw_response_candidate | validation | 72.220 | 74.220 |
| VB-01.alt_50m.BIN_yaw_response_candidate_24 | VB-01.alt_50m.BIN | В-11 | yaw_response_candidate | identification | 73.080 | 75.080 |
| VB-01.alt_50m.BIN_yaw_response_candidate_25 | VB-01.alt_50m.BIN | В-11 | yaw_response_candidate | validation | 73.530 | 75.530 |
| VB-01.alt_50m.BIN_yaw_response_candidate_26 | VB-01.alt_50m.BIN | В-11 | yaw_response_candidate | identification | 74.165 | 76.165 |
| VB-01.alt_50m.BIN_yaw_response_candidate_27 | VB-01.alt_50m.BIN | В-11 | yaw_response_candidate | validation | 74.330 | 76.330 |
| VB-01.alt_50m.BIN_yaw_response_candidate_28 | VB-01.alt_50m.BIN | В-11 | yaw_response_candidate | identification | 74.725 | 76.725 |
| VB-01.alt_50m.BIN_yaw_response_candidate_29 | VB-01.alt_50m.BIN | В-11 | yaw_response_candidate | identification | 75.990 | 77.990 |
| VB-01.alt_50m.BIN_yaw_response_candidate_30 | VB-01.alt_50m.BIN | В-11 | yaw_response_candidate | identification | 76.415 | 78.415 |
| VB-01.alt_50m.BIN_yaw_response_candidate_31 | VB-01.alt_50m.BIN | В-11 | yaw_response_candidate | validation | 77.560 | 80.360 |
| VB-01.alt_50m.BIN_yaw_response_candidate_32 | VB-01.alt_50m.BIN | В-11 | yaw_response_candidate | validation | 79.440 | 81.440 |
| VB-01.alt_50m.BIN_yaw_response_candidate_33 | VB-01.alt_50m.BIN | В-11 | yaw_response_candidate | identification | 80.390 | 82.390 |
| VB-01.alt_50m.BIN_yaw_response_candidate_34 | VB-01.alt_50m.BIN | В-11 | yaw_response_candidate | identification | 83.310 | 85.310 |
| VB-01.alt_50m.BIN_yaw_response_candidate_35 | VB-01.alt_50m.BIN | В-11 | yaw_response_candidate | validation | 87.440 | 89.440 |
| VB-01.alt_50m.BIN_yaw_response_candidate_36 | VB-01.alt_50m.BIN | В-11 | yaw_response_candidate | identification | 87.795 | 89.795 |
| VB-01.alt_50m.BIN_yaw_response_candidate_37 | VB-01.alt_50m.BIN | В-11 | yaw_response_candidate | validation | 88.070 | 90.070 |
| VB-01.alt_50m.BIN_yaw_response_candidate_38 | VB-01.alt_50m.BIN | В-11 | yaw_response_candidate | identification | 88.205 | 90.205 |
| VB-01.alt_50m.BIN_yaw_response_candidate_39 | VB-01.alt_50m.BIN | В-11 | yaw_response_candidate | validation | 91.285 | 93.285 |
| VB-01.alt_50m.BIN_yaw_response_candidate_40 | VB-01.alt_50m.BIN | В-11 | yaw_response_candidate | identification | 93.880 | 99.000 |
| VB-01.alt_50m.BIN_yaw_response_candidate_41 | VB-01.alt_50m.BIN | В-11 | yaw_response_candidate | validation | 98.245 | 100.245 |
| VB-01.alt_50m.BIN_yaw_response_candidate_42 | VB-01.alt_50m.BIN | В-11 | yaw_response_candidate | identification | 147.555 | 149.555 |
| VB-01.alt_50m.BIN_yaw_response_candidate_43 | VB-01.alt_50m.BIN | В-11 | yaw_response_candidate | identification | 147.715 | 149.715 |
| VB-01.alt_50m.BIN_yaw_response_candidate_44 | VB-01.alt_50m.BIN | В-11 | yaw_response_candidate | identification | 148.365 | 150.365 |
| VB-01.alt_50m.BIN_yaw_response_candidate_45 | VB-01.alt_50m.BIN | В-11 | yaw_response_candidate | identification | 152.620 | 154.620 |
| VB-01.alt_50m.BIN_yaw_response_candidate_46 | VB-01.alt_50m.BIN | В-11 | yaw_response_candidate | identification | 153.940 | 155.940 |
| VB-01.alt_50m.BIN_yaw_response_candidate_47 | VB-01.alt_50m.BIN | В-11 | yaw_response_candidate | validation | 154.105 | 156.105 |
| VB-01.alt_50m.BIN_yaw_response_candidate_48 | VB-01.alt_50m.BIN | В-11 | yaw_response_candidate | validation | 155.295 | 157.295 |
| VB-01.alt_50m.BIN_yaw_response_candidate_49 | VB-01.alt_50m.BIN | В-11 | yaw_response_candidate | identification | 156.965 | 158.965 |
| VB-01.alt_50m.BIN_yaw_response_candidate_50 | VB-01.alt_50m.BIN | В-11 | yaw_response_candidate | identification | 162.050 | 164.050 |
| VB-01.alt_50m.BIN_yaw_response_candidate_51 | VB-01.alt_50m.BIN | В-11 | yaw_response_candidate | validation | 167.745 | 169.745 |
| VB-01.alt_50m.BIN_yaw_response_candidate_52 | VB-01.alt_50m.BIN | В-11 | yaw_response_candidate | identification | 167.955 | 169.955 |
| VB-01.alt_50m.BIN_yaw_response_candidate_53 | VB-01.alt_50m.BIN | В-11 | yaw_response_candidate | validation | 170.110 | 172.110 |
| VB-01.alt_50m.BIN_yaw_response_candidate_54 | VB-01.alt_50m.BIN | В-11 | yaw_response_candidate | identification | 172.485 | 174.485 |
| VB-01.alt_50m.BIN_yaw_response_candidate_55 | VB-01.alt_50m.BIN | В-11 | yaw_response_candidate | validation | 173.640 | 175.640 |
| VB-01.alt_50m.BIN_yaw_response_candidate_56 | VB-01.alt_50m.BIN | В-11 | yaw_response_candidate | validation | 179.770 | 181.770 |
| VB-01.alt_50m.BIN_yaw_response_candidate_57 | VB-01.alt_50m.BIN | В-11 | yaw_response_candidate | identification | 180.520 | 182.520 |
| VB-01.alt_50m.BIN_yaw_response_candidate_58 | VB-01.alt_50m.BIN | В-11 | yaw_response_candidate | identification | 181.255 | 183.255 |
| VB-01.alt_50m.BIN_yaw_response_candidate_59 | VB-01.alt_50m.BIN | В-11 | yaw_response_candidate | identification | 181.840 | 183.840 |
| VB-01.alt_50m.BIN_yaw_response_candidate_60 | VB-01.alt_50m.BIN | В-11 | yaw_response_candidate | identification | 182.990 | 185.150 |
| VB-01.alt_50m.BIN_yaw_response_candidate_61 | VB-01.alt_50m.BIN | В-11 | yaw_response_candidate | identification | 185.230 | 187.410 |
| VB-01.alt_50m.BIN_yaw_response_candidate_62 | VB-01.alt_50m.BIN | В-11 | yaw_response_candidate | validation | 187.030 | 189.030 |
| VB-01.alt_50m.BIN_yaw_response_candidate_63 | VB-01.alt_50m.BIN | В-11 | yaw_response_candidate | identification | 188.850 | 190.850 |
| VB-01.alt_50m.BIN_yaw_response_candidate_64 | VB-01.alt_50m.BIN | В-11 | yaw_response_candidate | validation | 191.800 | 193.800 |
| VB-01.alt_50m.BIN_yaw_response_candidate_65 | VB-01.alt_50m.BIN | В-11 | yaw_response_candidate | identification | 192.190 | 194.190 |
| VB-01.alt_50m.BIN_yaw_response_candidate_66 | VB-01.alt_50m.BIN | В-11 | yaw_response_candidate | identification | 193.130 | 195.130 |
| VB-01.alt_50m.BIN_thrust_response_candidate_1 | VB-01.alt_50m.BIN | В-12 | thrust_response_candidate | identification | 36.820 | 38.820 |
| VB-01.alt_50m.BIN_thrust_response_candidate_2 | VB-01.alt_50m.BIN | В-12 | thrust_response_candidate | validation | 151.770 | 153.770 |
| VB-01.alt_50m.BIN_thrust_response_candidate_3 | VB-01.alt_50m.BIN | В-12 | thrust_response_candidate | identification | 172.400 | 174.400 |
| full_fly_1.BIN_hover_candidate_1 | full_fly_1.BIN | В-01 | hover_candidate | validation | 218.220 | 221.480 |
| full_fly_1.BIN_hover_candidate_2 | full_fly_1.BIN | В-01 | hover_candidate | validation | 311.750 | 313.750 |
| full_fly_1.BIN_climb_candidate_1 | full_fly_1.BIN | В-06 | climb_candidate | identification | 222.720 | 224.720 |
| full_fly_1.BIN_climb_candidate_2 | full_fly_1.BIN | В-06 | climb_candidate | validation | 225.260 | 239.040 |
| full_fly_1.BIN_climb_candidate_3 | full_fly_1.BIN | В-06 | climb_candidate | validation | 256.860 | 264.190 |
| full_fly_1.BIN_climb_candidate_4 | full_fly_1.BIN | В-06 | climb_candidate | validation | 268.935 | 270.935 |
| full_fly_1.BIN_climb_candidate_5 | full_fly_1.BIN | В-06 | climb_candidate | validation | 274.075 | 276.075 |
| full_fly_1.BIN_climb_candidate_6 | full_fly_1.BIN | В-06 | climb_candidate | validation | 279.070 | 286.740 |
| full_fly_1.BIN_climb_candidate_7 | full_fly_1.BIN | В-06 | climb_candidate | identification | 286.985 | 288.985 |
| full_fly_1.BIN_climb_candidate_8 | full_fly_1.BIN | В-06 | climb_candidate | validation | 289.800 | 297.240 |
| full_fly_1.BIN_climb_candidate_9 | full_fly_1.BIN | В-06 | climb_candidate | identification | 296.445 | 298.445 |
| full_fly_1.BIN_climb_candidate_10 | full_fly_1.BIN | В-06 | climb_candidate | validation | 297.670 | 300.070 |
| full_fly_1.BIN_climb_candidate_11 | full_fly_1.BIN | В-06 | climb_candidate | identification | 306.130 | 312.350 |
| full_fly_1.BIN_climb_candidate_12 | full_fly_1.BIN | В-06 | climb_candidate | identification | 320.750 | 322.750 |
| full_fly_1.BIN_climb_candidate_13 | full_fly_1.BIN | В-06 | climb_candidate | identification | 322.940 | 326.930 |
| full_fly_1.BIN_descent_candidate_1 | full_fly_1.BIN | В-08 | descent_candidate | validation | 220.615 | 222.615 |
| full_fly_1.BIN_descent_candidate_2 | full_fly_1.BIN | В-08 | descent_candidate | validation | 239.260 | 241.600 |
| full_fly_1.BIN_descent_candidate_3 | full_fly_1.BIN | В-08 | descent_candidate | identification | 242.650 | 247.410 |
| full_fly_1.BIN_descent_candidate_4 | full_fly_1.BIN | В-08 | descent_candidate | identification | 248.460 | 250.460 |
| full_fly_1.BIN_descent_candidate_5 | full_fly_1.BIN | В-08 | descent_candidate | identification | 251.980 | 256.300 |
| full_fly_1.BIN_descent_candidate_6 | full_fly_1.BIN | В-08 | descent_candidate | identification | 264.830 | 268.990 |
| full_fly_1.BIN_descent_candidate_7 | full_fly_1.BIN | В-08 | descent_candidate | identification | 270.145 | 272.145 |
| full_fly_1.BIN_descent_candidate_8 | full_fly_1.BIN | В-08 | descent_candidate | validation | 272.580 | 274.580 |
| full_fly_1.BIN_descent_candidate_9 | full_fly_1.BIN | В-08 | descent_candidate | identification | 276.320 | 278.320 |
| full_fly_1.BIN_descent_candidate_10 | full_fly_1.BIN | В-08 | descent_candidate | validation | 288.420 | 290.420 |
| full_fly_1.BIN_descent_candidate_11 | full_fly_1.BIN | В-08 | descent_candidate | identification | 300.270 | 305.620 |
| full_fly_1.BIN_descent_candidate_12 | full_fly_1.BIN | В-08 | descent_candidate | identification | 313.600 | 321.330 |
| full_fly_1.BIN_descent_candidate_13 | full_fly_1.BIN | В-08 | descent_candidate | validation | 327.420 | 344.240 |
| full_fly_1.BIN_roll_response_candidate_1 | full_fly_1.BIN | В-10 | roll_response_candidate | identification | 237.410 | 239.410 |
| full_fly_1.BIN_roll_response_candidate_2 | full_fly_1.BIN | В-10 | roll_response_candidate | identification | 260.580 | 262.580 |
| full_fly_1.BIN_roll_response_candidate_3 | full_fly_1.BIN | В-10 | roll_response_candidate | identification | 260.905 | 262.905 |
| full_fly_1.BIN_roll_response_candidate_4 | full_fly_1.BIN | В-10 | roll_response_candidate | validation | 262.220 | 265.610 |
| full_fly_1.BIN_roll_response_candidate_5 | full_fly_1.BIN | В-10 | roll_response_candidate | identification | 264.700 | 266.700 |
| full_fly_1.BIN_roll_response_candidate_6 | full_fly_1.BIN | В-10 | roll_response_candidate | identification | 285.005 | 287.005 |
| full_fly_1.BIN_roll_response_candidate_7 | full_fly_1.BIN | В-10 | roll_response_candidate | identification | 289.275 | 291.275 |
| full_fly_1.BIN_roll_response_candidate_8 | full_fly_1.BIN | В-10 | roll_response_candidate | identification | 290.345 | 292.345 |
| full_fly_1.BIN_roll_response_candidate_9 | full_fly_1.BIN | В-10 | roll_response_candidate | identification | 302.435 | 304.435 |
| full_fly_1.BIN_roll_response_candidate_10 | full_fly_1.BIN | В-10 | roll_response_candidate | validation | 305.395 | 307.395 |
| full_fly_1.BIN_roll_response_candidate_11 | full_fly_1.BIN | В-10 | roll_response_candidate | validation | 305.615 | 307.615 |
| full_fly_1.BIN_roll_response_candidate_12 | full_fly_1.BIN | В-10 | roll_response_candidate | identification | 306.025 | 308.025 |
| full_fly_1.BIN_roll_response_candidate_13 | full_fly_1.BIN | В-10 | roll_response_candidate | validation | 306.090 | 308.090 |
| full_fly_1.BIN_roll_response_candidate_14 | full_fly_1.BIN | В-10 | roll_response_candidate | validation | 306.235 | 308.235 |
| full_fly_1.BIN_roll_response_candidate_15 | full_fly_1.BIN | В-10 | roll_response_candidate | identification | 306.820 | 308.820 |
| full_fly_1.BIN_roll_response_candidate_16 | full_fly_1.BIN | В-10 | roll_response_candidate | identification | 306.935 | 308.935 |
| full_fly_1.BIN_roll_response_candidate_17 | full_fly_1.BIN | В-10 | roll_response_candidate | identification | 306.995 | 308.995 |
| full_fly_1.BIN_roll_response_candidate_18 | full_fly_1.BIN | В-10 | roll_response_candidate | identification | 307.115 | 309.115 |
| full_fly_1.BIN_roll_response_candidate_19 | full_fly_1.BIN | В-10 | roll_response_candidate | validation | 307.185 | 309.185 |
| full_fly_1.BIN_roll_response_candidate_20 | full_fly_1.BIN | В-10 | roll_response_candidate | validation | 307.270 | 309.270 |
| full_fly_1.BIN_roll_response_candidate_21 | full_fly_1.BIN | В-10 | roll_response_candidate | identification | 307.385 | 309.385 |
| full_fly_1.BIN_roll_response_candidate_22 | full_fly_1.BIN | В-10 | roll_response_candidate | validation | 314.625 | 316.625 |
| full_fly_1.BIN_roll_response_candidate_23 | full_fly_1.BIN | В-10 | roll_response_candidate | validation | 342.580 | 344.580 |
| full_fly_1.BIN_roll_response_candidate_24 | full_fly_1.BIN | В-10 | roll_response_candidate | validation | 342.635 | 344.635 |
| full_fly_1.BIN_roll_response_candidate_25 | full_fly_1.BIN | В-10 | roll_response_candidate | identification | 342.750 | 344.750 |
| full_fly_1.BIN_roll_response_candidate_26 | full_fly_1.BIN | В-10 | roll_response_candidate | identification | 342.880 | 344.880 |
| full_fly_1.BIN_roll_response_candidate_27 | full_fly_1.BIN | В-10 | roll_response_candidate | validation | 342.975 | 344.975 |
| full_fly_1.BIN_roll_response_candidate_28 | full_fly_1.BIN | В-10 | roll_response_candidate | identification | 343.190 | 345.190 |
| full_fly_1.BIN_roll_response_candidate_29 | full_fly_1.BIN | В-10 | roll_response_candidate | identification | 343.245 | 345.245 |
| full_fly_1.BIN_roll_response_candidate_30 | full_fly_1.BIN | В-10 | roll_response_candidate | identification | 343.350 | 345.350 |
| full_fly_1.BIN_roll_response_candidate_31 | full_fly_1.BIN | В-10 | roll_response_candidate | validation | 343.495 | 345.495 |
| full_fly_1.BIN_roll_response_candidate_32 | full_fly_1.BIN | В-10 | roll_response_candidate | identification | 343.650 | 345.650 |
| full_fly_1.BIN_roll_response_candidate_33 | full_fly_1.BIN | В-10 | roll_response_candidate | validation | 344.690 | 347.730 |
| full_fly_1.BIN_pitch_response_candidate_1 | full_fly_1.BIN | В-09 | pitch_response_candidate | identification | 219.770 | 221.770 |
| full_fly_1.BIN_pitch_response_candidate_2 | full_fly_1.BIN | В-09 | pitch_response_candidate | validation | 219.885 | 221.885 |
| full_fly_1.BIN_pitch_response_candidate_3 | full_fly_1.BIN | В-09 | pitch_response_candidate | identification | 220.800 | 222.800 |
| full_fly_1.BIN_pitch_response_candidate_4 | full_fly_1.BIN | В-09 | pitch_response_candidate | identification | 221.160 | 223.160 |
| full_fly_1.BIN_pitch_response_candidate_5 | full_fly_1.BIN | В-09 | pitch_response_candidate | identification | 222.850 | 224.850 |
| full_fly_1.BIN_pitch_response_candidate_6 | full_fly_1.BIN | В-09 | pitch_response_candidate | identification | 223.200 | 225.200 |
| full_fly_1.BIN_pitch_response_candidate_7 | full_fly_1.BIN | В-09 | pitch_response_candidate | identification | 223.830 | 225.830 |
| full_fly_1.BIN_pitch_response_candidate_8 | full_fly_1.BIN | В-09 | pitch_response_candidate | identification | 223.870 | 225.870 |
| full_fly_1.BIN_pitch_response_candidate_9 | full_fly_1.BIN | В-09 | pitch_response_candidate | identification | 223.915 | 225.915 |
| full_fly_1.BIN_pitch_response_candidate_10 | full_fly_1.BIN | В-09 | pitch_response_candidate | identification | 224.060 | 226.060 |
| full_fly_1.BIN_pitch_response_candidate_11 | full_fly_1.BIN | В-09 | pitch_response_candidate | validation | 224.220 | 226.220 |
| full_fly_1.BIN_pitch_response_candidate_12 | full_fly_1.BIN | В-09 | pitch_response_candidate | identification | 224.465 | 226.465 |
| full_fly_1.BIN_pitch_response_candidate_13 | full_fly_1.BIN | В-09 | pitch_response_candidate | identification | 224.725 | 226.725 |
| full_fly_1.BIN_pitch_response_candidate_14 | full_fly_1.BIN | В-09 | pitch_response_candidate | validation | 224.955 | 226.955 |
| full_fly_1.BIN_pitch_response_candidate_15 | full_fly_1.BIN | В-09 | pitch_response_candidate | identification | 226.190 | 228.190 |
| full_fly_1.BIN_pitch_response_candidate_16 | full_fly_1.BIN | В-09 | pitch_response_candidate | identification | 238.530 | 242.160 |
| full_fly_1.BIN_pitch_response_candidate_17 | full_fly_1.BIN | В-09 | pitch_response_candidate | identification | 243.645 | 245.645 |
| full_fly_1.BIN_pitch_response_candidate_18 | full_fly_1.BIN | В-09 | pitch_response_candidate | identification | 246.140 | 248.140 |
| full_fly_1.BIN_pitch_response_candidate_19 | full_fly_1.BIN | В-09 | pitch_response_candidate | identification | 279.515 | 281.515 |
| full_fly_1.BIN_pitch_response_candidate_20 | full_fly_1.BIN | В-09 | pitch_response_candidate | identification | 279.635 | 281.635 |
| full_fly_1.BIN_pitch_response_candidate_21 | full_fly_1.BIN | В-09 | pitch_response_candidate | identification | 279.980 | 281.980 |
| full_fly_1.BIN_pitch_response_candidate_22 | full_fly_1.BIN | В-09 | pitch_response_candidate | validation | 280.455 | 282.455 |
| full_fly_1.BIN_pitch_response_candidate_23 | full_fly_1.BIN | В-09 | pitch_response_candidate | validation | 280.725 | 282.725 |
| full_fly_1.BIN_pitch_response_candidate_24 | full_fly_1.BIN | В-09 | pitch_response_candidate | validation | 280.780 | 282.780 |
| full_fly_1.BIN_pitch_response_candidate_25 | full_fly_1.BIN | В-09 | pitch_response_candidate | validation | 286.035 | 288.035 |
| full_fly_1.BIN_pitch_response_candidate_26 | full_fly_1.BIN | В-09 | pitch_response_candidate | identification | 287.000 | 289.000 |
| full_fly_1.BIN_pitch_response_candidate_27 | full_fly_1.BIN | В-09 | pitch_response_candidate | validation | 287.215 | 289.215 |
| full_fly_1.BIN_pitch_response_candidate_28 | full_fly_1.BIN | В-09 | pitch_response_candidate | identification | 288.350 | 291.580 |
| full_fly_1.BIN_pitch_response_candidate_29 | full_fly_1.BIN | В-09 | pitch_response_candidate | validation | 290.890 | 292.890 |
| full_fly_1.BIN_pitch_response_candidate_30 | full_fly_1.BIN | В-09 | pitch_response_candidate | validation | 291.445 | 293.445 |
| full_fly_1.BIN_pitch_response_candidate_31 | full_fly_1.BIN | В-09 | pitch_response_candidate | identification | 291.630 | 293.630 |
| full_fly_1.BIN_pitch_response_candidate_32 | full_fly_1.BIN | В-09 | pitch_response_candidate | validation | 292.580 | 294.580 |
| full_fly_1.BIN_pitch_response_candidate_33 | full_fly_1.BIN | В-09 | pitch_response_candidate | identification | 292.835 | 294.835 |
| full_fly_1.BIN_pitch_response_candidate_34 | full_fly_1.BIN | В-09 | pitch_response_candidate | validation | 293.475 | 295.475 |
| full_fly_1.BIN_pitch_response_candidate_35 | full_fly_1.BIN | В-09 | pitch_response_candidate | validation | 294.170 | 296.170 |
| full_fly_1.BIN_pitch_response_candidate_36 | full_fly_1.BIN | В-09 | pitch_response_candidate | identification | 296.105 | 298.105 |
| full_fly_1.BIN_pitch_response_candidate_37 | full_fly_1.BIN | В-09 | pitch_response_candidate | identification | 297.390 | 299.390 |
| full_fly_1.BIN_pitch_response_candidate_38 | full_fly_1.BIN | В-09 | pitch_response_candidate | identification | 298.340 | 300.340 |
| full_fly_1.BIN_pitch_response_candidate_39 | full_fly_1.BIN | В-09 | pitch_response_candidate | validation | 298.360 | 300.360 |
| full_fly_1.BIN_pitch_response_candidate_40 | full_fly_1.BIN | В-09 | pitch_response_candidate | validation | 298.410 | 300.410 |
| full_fly_1.BIN_pitch_response_candidate_41 | full_fly_1.BIN | В-09 | pitch_response_candidate | identification | 298.950 | 300.950 |
| full_fly_1.BIN_pitch_response_candidate_42 | full_fly_1.BIN | В-09 | pitch_response_candidate | identification | 299.820 | 301.820 |
| full_fly_1.BIN_pitch_response_candidate_43 | full_fly_1.BIN | В-09 | pitch_response_candidate | validation | 300.140 | 302.140 |
| full_fly_1.BIN_pitch_response_candidate_44 | full_fly_1.BIN | В-09 | pitch_response_candidate | validation | 300.480 | 302.480 |
| full_fly_1.BIN_pitch_response_candidate_45 | full_fly_1.BIN | В-09 | pitch_response_candidate | identification | 300.660 | 302.660 |
| full_fly_1.BIN_pitch_response_candidate_46 | full_fly_1.BIN | В-09 | pitch_response_candidate | validation | 300.840 | 302.840 |
| full_fly_1.BIN_pitch_response_candidate_47 | full_fly_1.BIN | В-09 | pitch_response_candidate | identification | 301.535 | 303.535 |
| full_fly_1.BIN_pitch_response_candidate_48 | full_fly_1.BIN | В-09 | pitch_response_candidate | identification | 311.985 | 313.985 |
| full_fly_1.BIN_pitch_response_candidate_49 | full_fly_1.BIN | В-09 | pitch_response_candidate | identification | 312.275 | 314.275 |
| full_fly_1.BIN_pitch_response_candidate_50 | full_fly_1.BIN | В-09 | pitch_response_candidate | identification | 312.470 | 314.470 |
| full_fly_1.BIN_pitch_response_candidate_51 | full_fly_1.BIN | В-09 | pitch_response_candidate | identification | 312.575 | 314.575 |
| full_fly_1.BIN_pitch_response_candidate_52 | full_fly_1.BIN | В-09 | pitch_response_candidate | validation | 312.880 | 314.880 |
| full_fly_1.BIN_pitch_response_candidate_53 | full_fly_1.BIN | В-09 | pitch_response_candidate | validation | 313.160 | 315.160 |
| full_fly_1.BIN_pitch_response_candidate_54 | full_fly_1.BIN | В-09 | pitch_response_candidate | identification | 313.460 | 315.460 |
| full_fly_1.BIN_pitch_response_candidate_55 | full_fly_1.BIN | В-09 | pitch_response_candidate | validation | 313.810 | 315.810 |
| full_fly_1.BIN_pitch_response_candidate_56 | full_fly_1.BIN | В-09 | pitch_response_candidate | identification | 314.005 | 316.005 |
| full_fly_1.BIN_pitch_response_candidate_57 | full_fly_1.BIN | В-09 | pitch_response_candidate | identification | 314.460 | 316.460 |
| full_fly_1.BIN_pitch_response_candidate_58 | full_fly_1.BIN | В-09 | pitch_response_candidate | validation | 315.380 | 317.380 |
| full_fly_1.BIN_pitch_response_candidate_59 | full_fly_1.BIN | В-09 | pitch_response_candidate | identification | 316.395 | 318.395 |
| full_fly_1.BIN_pitch_response_candidate_60 | full_fly_1.BIN | В-09 | pitch_response_candidate | validation | 316.550 | 318.550 |
| full_fly_1.BIN_pitch_response_candidate_61 | full_fly_1.BIN | В-09 | pitch_response_candidate | identification | 316.605 | 318.605 |
| full_fly_1.BIN_pitch_response_candidate_62 | full_fly_1.BIN | В-09 | pitch_response_candidate | validation | 318.505 | 320.505 |
| full_fly_1.BIN_pitch_response_candidate_63 | full_fly_1.BIN | В-09 | pitch_response_candidate | identification | 318.580 | 320.580 |
| full_fly_1.BIN_pitch_response_candidate_64 | full_fly_1.BIN | В-09 | pitch_response_candidate | identification | 318.815 | 320.815 |
| full_fly_1.BIN_pitch_response_candidate_65 | full_fly_1.BIN | В-09 | pitch_response_candidate | identification | 319.025 | 321.025 |
| full_fly_1.BIN_pitch_response_candidate_66 | full_fly_1.BIN | В-09 | pitch_response_candidate | validation | 319.285 | 321.285 |
| full_fly_1.BIN_pitch_response_candidate_67 | full_fly_1.BIN | В-09 | pitch_response_candidate | validation | 319.645 | 321.645 |
| full_fly_1.BIN_pitch_response_candidate_68 | full_fly_1.BIN | В-09 | pitch_response_candidate | identification | 320.045 | 322.045 |
| full_fly_1.BIN_pitch_response_candidate_69 | full_fly_1.BIN | В-09 | pitch_response_candidate | identification | 320.250 | 322.250 |
| full_fly_1.BIN_pitch_response_candidate_70 | full_fly_1.BIN | В-09 | pitch_response_candidate | validation | 321.675 | 323.675 |
| full_fly_1.BIN_pitch_response_candidate_71 | full_fly_1.BIN | В-09 | pitch_response_candidate | validation | 321.820 | 323.820 |
| full_fly_1.BIN_pitch_response_candidate_72 | full_fly_1.BIN | В-09 | pitch_response_candidate | identification | 322.890 | 325.480 |
| full_fly_1.BIN_pitch_response_candidate_73 | full_fly_1.BIN | В-09 | pitch_response_candidate | identification | 324.645 | 326.645 |
| full_fly_1.BIN_pitch_response_candidate_74 | full_fly_1.BIN | В-09 | pitch_response_candidate | validation | 332.830 | 334.830 |
| full_fly_1.BIN_pitch_response_candidate_75 | full_fly_1.BIN | В-09 | pitch_response_candidate | identification | 337.135 | 339.135 |
| full_fly_1.BIN_pitch_response_candidate_76 | full_fly_1.BIN | В-09 | pitch_response_candidate | identification | 337.600 | 339.600 |
| full_fly_1.BIN_pitch_response_candidate_77 | full_fly_1.BIN | В-09 | pitch_response_candidate | identification | 342.520 | 344.520 |
| full_fly_1.BIN_pitch_response_candidate_78 | full_fly_1.BIN | В-09 | pitch_response_candidate | identification | 342.875 | 344.875 |
| full_fly_1.BIN_pitch_response_candidate_79 | full_fly_1.BIN | В-09 | pitch_response_candidate | validation | 343.110 | 345.110 |
| full_fly_1.BIN_pitch_response_candidate_80 | full_fly_1.BIN | В-09 | pitch_response_candidate | identification | 344.290 | 347.800 |
| full_fly_1.BIN_yaw_response_candidate_1 | full_fly_1.BIN | В-11 | yaw_response_candidate | validation | 221.090 | 223.090 |
| full_fly_1.BIN_yaw_response_candidate_2 | full_fly_1.BIN | В-11 | yaw_response_candidate | identification | 237.510 | 239.510 |
| full_fly_1.BIN_yaw_response_candidate_3 | full_fly_1.BIN | В-11 | yaw_response_candidate | validation | 238.200 | 240.200 |
| full_fly_1.BIN_yaw_response_candidate_4 | full_fly_1.BIN | В-11 | yaw_response_candidate | identification | 238.510 | 240.510 |
| full_fly_1.BIN_yaw_response_candidate_5 | full_fly_1.BIN | В-11 | yaw_response_candidate | validation | 238.685 | 240.685 |
| full_fly_1.BIN_yaw_response_candidate_6 | full_fly_1.BIN | В-11 | yaw_response_candidate | validation | 239.155 | 241.155 |
| full_fly_1.BIN_yaw_response_candidate_7 | full_fly_1.BIN | В-11 | yaw_response_candidate | validation | 239.270 | 241.270 |
| full_fly_1.BIN_yaw_response_candidate_8 | full_fly_1.BIN | В-11 | yaw_response_candidate | validation | 240.285 | 242.285 |
| full_fly_1.BIN_yaw_response_candidate_9 | full_fly_1.BIN | В-11 | yaw_response_candidate | identification | 241.375 | 243.375 |
| full_fly_1.BIN_yaw_response_candidate_10 | full_fly_1.BIN | В-11 | yaw_response_candidate | validation | 261.830 | 266.000 |
| full_fly_1.BIN_yaw_response_candidate_11 | full_fly_1.BIN | В-11 | yaw_response_candidate | identification | 284.560 | 286.560 |
| full_fly_1.BIN_yaw_response_candidate_12 | full_fly_1.BIN | В-11 | yaw_response_candidate | identification | 285.280 | 287.280 |
| full_fly_1.BIN_yaw_response_candidate_13 | full_fly_1.BIN | В-11 | yaw_response_candidate | validation | 285.945 | 287.945 |
| full_fly_1.BIN_yaw_response_candidate_14 | full_fly_1.BIN | В-11 | yaw_response_candidate | identification | 286.910 | 288.910 |
| full_fly_1.BIN_yaw_response_candidate_15 | full_fly_1.BIN | В-11 | yaw_response_candidate | validation | 287.260 | 289.260 |
| full_fly_1.BIN_yaw_response_candidate_16 | full_fly_1.BIN | В-11 | yaw_response_candidate | identification | 287.960 | 289.960 |
| full_fly_1.BIN_yaw_response_candidate_17 | full_fly_1.BIN | В-11 | yaw_response_candidate | identification | 288.935 | 290.935 |
| full_fly_1.BIN_yaw_response_candidate_18 | full_fly_1.BIN | В-11 | yaw_response_candidate | identification | 289.560 | 291.560 |
| full_fly_1.BIN_yaw_response_candidate_19 | full_fly_1.BIN | В-11 | yaw_response_candidate | identification | 289.870 | 291.870 |
| full_fly_1.BIN_yaw_response_candidate_20 | full_fly_1.BIN | В-11 | yaw_response_candidate | identification | 290.425 | 292.425 |
| full_fly_1.BIN_yaw_response_candidate_21 | full_fly_1.BIN | В-11 | yaw_response_candidate | validation | 290.970 | 292.970 |
| full_fly_1.BIN_yaw_response_candidate_22 | full_fly_1.BIN | В-11 | yaw_response_candidate | identification | 292.215 | 294.215 |
| full_fly_1.BIN_yaw_response_candidate_23 | full_fly_1.BIN | В-11 | yaw_response_candidate | identification | 293.600 | 295.600 |
| full_fly_1.BIN_yaw_response_candidate_24 | full_fly_1.BIN | В-11 | yaw_response_candidate | validation | 293.755 | 295.755 |
| full_fly_1.BIN_yaw_response_candidate_25 | full_fly_1.BIN | В-11 | yaw_response_candidate | validation | 296.870 | 298.870 |
| full_fly_1.BIN_yaw_response_candidate_26 | full_fly_1.BIN | В-11 | yaw_response_candidate | identification | 300.505 | 302.505 |
| full_fly_1.BIN_yaw_response_candidate_27 | full_fly_1.BIN | В-11 | yaw_response_candidate | identification | 300.635 | 302.635 |
| full_fly_1.BIN_yaw_response_candidate_28 | full_fly_1.BIN | В-11 | yaw_response_candidate | validation | 301.000 | 303.000 |
| full_fly_1.BIN_yaw_response_candidate_29 | full_fly_1.BIN | В-11 | yaw_response_candidate | identification | 301.210 | 303.210 |
| full_fly_1.BIN_yaw_response_candidate_30 | full_fly_1.BIN | В-11 | yaw_response_candidate | validation | 301.500 | 303.500 |
| full_fly_1.BIN_yaw_response_candidate_31 | full_fly_1.BIN | В-11 | yaw_response_candidate | validation | 301.970 | 303.970 |
| full_fly_1.BIN_yaw_response_candidate_32 | full_fly_1.BIN | В-11 | yaw_response_candidate | identification | 307.500 | 309.500 |
| full_fly_1.BIN_yaw_response_candidate_33 | full_fly_1.BIN | В-11 | yaw_response_candidate | validation | 309.300 | 311.300 |
| full_fly_1.BIN_yaw_response_candidate_34 | full_fly_1.BIN | В-11 | yaw_response_candidate | validation | 314.010 | 316.010 |
| full_fly_1.BIN_yaw_response_candidate_35 | full_fly_1.BIN | В-11 | yaw_response_candidate | validation | 314.310 | 316.310 |
| full_fly_1.BIN_yaw_response_candidate_36 | full_fly_1.BIN | В-11 | yaw_response_candidate | identification | 314.995 | 316.995 |
| full_fly_1.BIN_yaw_response_candidate_37 | full_fly_1.BIN | В-11 | yaw_response_candidate | identification | 316.205 | 318.205 |
| full_fly_1.BIN_yaw_response_candidate_38 | full_fly_1.BIN | В-11 | yaw_response_candidate | identification | 319.555 | 321.555 |
| full_fly_1.BIN_yaw_response_candidate_39 | full_fly_1.BIN | В-11 | yaw_response_candidate | identification | 322.995 | 324.995 |
| full_fly_1.BIN_yaw_response_candidate_40 | full_fly_1.BIN | В-11 | yaw_response_candidate | validation | 323.475 | 325.475 |
| full_fly_1.BIN_yaw_response_candidate_41 | full_fly_1.BIN | В-11 | yaw_response_candidate | identification | 323.935 | 325.935 |
| full_fly_1.BIN_yaw_response_candidate_42 | full_fly_1.BIN | В-11 | yaw_response_candidate | validation | 327.965 | 329.965 |
| full_fly_1.BIN_yaw_response_candidate_43 | full_fly_1.BIN | В-11 | yaw_response_candidate | identification | 328.575 | 330.575 |
| full_fly_1.BIN_yaw_response_candidate_44 | full_fly_1.BIN | В-11 | yaw_response_candidate | identification | 329.610 | 331.610 |
| full_fly_1.BIN_yaw_response_candidate_45 | full_fly_1.BIN | В-11 | yaw_response_candidate | identification | 331.420 | 333.420 |
| full_fly_1.BIN_yaw_response_candidate_46 | full_fly_1.BIN | В-11 | yaw_response_candidate | identification | 331.820 | 333.820 |
| full_fly_1.BIN_yaw_response_candidate_47 | full_fly_1.BIN | В-11 | yaw_response_candidate | validation | 332.015 | 334.015 |
| full_fly_1.BIN_yaw_response_candidate_48 | full_fly_1.BIN | В-11 | yaw_response_candidate | identification | 332.345 | 334.345 |
| full_fly_1.BIN_yaw_response_candidate_49 | full_fly_1.BIN | В-11 | yaw_response_candidate | validation | 332.585 | 334.585 |
| full_fly_1.BIN_yaw_response_candidate_50 | full_fly_1.BIN | В-11 | yaw_response_candidate | validation | 332.955 | 334.955 |
| full_fly_1.BIN_yaw_response_candidate_51 | full_fly_1.BIN | В-11 | yaw_response_candidate | identification | 333.640 | 335.640 |
| full_fly_1.BIN_yaw_response_candidate_52 | full_fly_1.BIN | В-11 | yaw_response_candidate | identification | 334.160 | 336.160 |
| full_fly_1.BIN_yaw_response_candidate_53 | full_fly_1.BIN | В-11 | yaw_response_candidate | identification | 334.760 | 336.760 |
| full_fly_1.BIN_yaw_response_candidate_54 | full_fly_1.BIN | В-11 | yaw_response_candidate | validation | 335.100 | 337.100 |
| full_fly_1.BIN_yaw_response_candidate_55 | full_fly_1.BIN | В-11 | yaw_response_candidate | identification | 335.460 | 337.460 |
| full_fly_1.BIN_yaw_response_candidate_56 | full_fly_1.BIN | В-11 | yaw_response_candidate | identification | 335.950 | 337.950 |
| full_fly_1.BIN_yaw_response_candidate_57 | full_fly_1.BIN | В-11 | yaw_response_candidate | identification | 336.525 | 338.525 |
| full_fly_1.BIN_yaw_response_candidate_58 | full_fly_1.BIN | В-11 | yaw_response_candidate | validation | 336.975 | 338.975 |
| full_fly_1.BIN_yaw_response_candidate_59 | full_fly_1.BIN | В-11 | yaw_response_candidate | validation | 337.340 | 339.340 |
| full_fly_1.BIN_yaw_response_candidate_60 | full_fly_1.BIN | В-11 | yaw_response_candidate | validation | 337.735 | 339.735 |
| full_fly_1.BIN_yaw_response_candidate_61 | full_fly_1.BIN | В-11 | yaw_response_candidate | identification | 338.610 | 340.610 |
| full_fly_1.BIN_yaw_response_candidate_62 | full_fly_1.BIN | В-11 | yaw_response_candidate | identification | 339.630 | 341.630 |
| full_fly_1.BIN_yaw_response_candidate_63 | full_fly_1.BIN | В-11 | yaw_response_candidate | identification | 340.595 | 342.595 |
| full_fly_1.BIN_yaw_response_candidate_64 | full_fly_1.BIN | В-11 | yaw_response_candidate | identification | 342.360 | 344.360 |
| full_fly_1.BIN_yaw_response_candidate_65 | full_fly_1.BIN | В-11 | yaw_response_candidate | identification | 342.840 | 344.840 |
| full_fly_1.BIN_yaw_response_candidate_66 | full_fly_1.BIN | В-11 | yaw_response_candidate | identification | 343.055 | 345.055 |
| full_fly_1.BIN_yaw_response_candidate_67 | full_fly_1.BIN | В-11 | yaw_response_candidate | identification | 343.245 | 345.245 |
| full_fly_1.BIN_thrust_response_candidate_1 | full_fly_1.BIN | В-12 | thrust_response_candidate | identification | 298.325 | 300.325 |
| full_fly_1.BIN_thrust_response_candidate_2 | full_fly_1.BIN | В-12 | thrust_response_candidate | validation | 299.995 | 301.995 |
| full_fly_1.BIN_thrust_response_candidate_3 | full_fly_1.BIN | В-12 | thrust_response_candidate | validation | 300.685 | 302.685 |
| full_fly_1.BIN_thrust_response_candidate_4 | full_fly_1.BIN | В-12 | thrust_response_candidate | validation | 319.460 | 321.460 |
| full_fly_2.BIN_hover_candidate_1 | full_fly_2.BIN | В-01 | hover_candidate | identification | 371.160 | 374.080 |
| full_fly_2.BIN_hover_candidate_2 | full_fly_2.BIN | В-01 | hover_candidate | validation | 446.145 | 448.145 |
| full_fly_2.BIN_hover_candidate_3 | full_fly_2.BIN | В-01 | hover_candidate | validation | 446.735 | 448.735 |
| full_fly_2.BIN_hover_candidate_4 | full_fly_2.BIN | В-01 | hover_candidate | identification | 449.265 | 451.265 |
| full_fly_2.BIN_hover_candidate_5 | full_fly_2.BIN | В-01 | hover_candidate | validation | 450.650 | 452.650 |
| full_fly_2.BIN_climb_candidate_1 | full_fly_2.BIN | В-06 | climb_candidate | identification | 374.310 | 389.300 |
| full_fly_2.BIN_climb_candidate_2 | full_fly_2.BIN | В-06 | climb_candidate | identification | 391.455 | 393.455 |
| full_fly_2.BIN_climb_candidate_3 | full_fly_2.BIN | В-06 | climb_candidate | validation | 402.960 | 404.960 |
| full_fly_2.BIN_climb_candidate_4 | full_fly_2.BIN | В-06 | climb_candidate | identification | 411.550 | 417.610 |
| full_fly_2.BIN_climb_candidate_5 | full_fly_2.BIN | В-06 | climb_candidate | identification | 432.455 | 434.455 |
| full_fly_2.BIN_climb_candidate_6 | full_fly_2.BIN | В-06 | climb_candidate | validation | 438.060 | 441.400 |
| full_fly_2.BIN_descent_candidate_1 | full_fly_2.BIN | В-08 | descent_candidate | validation | 389.480 | 391.480 |
| full_fly_2.BIN_descent_candidate_2 | full_fly_2.BIN | В-08 | descent_candidate | identification | 394.350 | 403.060 |
| full_fly_2.BIN_descent_candidate_3 | full_fly_2.BIN | В-08 | descent_candidate | identification | 405.035 | 407.035 |
| full_fly_2.BIN_descent_candidate_4 | full_fly_2.BIN | В-08 | descent_candidate | validation | 406.190 | 408.190 |
| full_fly_2.BIN_descent_candidate_5 | full_fly_2.BIN | В-08 | descent_candidate | validation | 409.625 | 411.625 |
| full_fly_2.BIN_descent_candidate_6 | full_fly_2.BIN | В-08 | descent_candidate | identification | 417.640 | 419.640 |
| full_fly_2.BIN_descent_candidate_7 | full_fly_2.BIN | В-08 | descent_candidate | identification | 420.720 | 428.950 |
| full_fly_2.BIN_descent_candidate_8 | full_fly_2.BIN | В-08 | descent_candidate | identification | 429.730 | 432.560 |
| full_fly_2.BIN_descent_candidate_9 | full_fly_2.BIN | В-08 | descent_candidate | validation | 435.360 | 437.360 |
| full_fly_2.BIN_descent_candidate_10 | full_fly_2.BIN | В-08 | descent_candidate | identification | 442.190 | 446.740 |
| full_fly_2.BIN_descent_candidate_11 | full_fly_2.BIN | В-08 | descent_candidate | validation | 447.990 | 449.990 |
| full_fly_2.BIN_descent_candidate_12 | full_fly_2.BIN | В-08 | descent_candidate | identification | 451.060 | 453.060 |
| full_fly_2.BIN_roll_response_candidate_1 | full_fly_2.BIN | В-10 | roll_response_candidate | identification | 387.710 | 389.710 |
| full_fly_2.BIN_roll_response_candidate_2 | full_fly_2.BIN | В-10 | roll_response_candidate | identification | 388.275 | 390.275 |
| full_fly_2.BIN_roll_response_candidate_3 | full_fly_2.BIN | В-10 | roll_response_candidate | identification | 388.785 | 390.785 |
| full_fly_2.BIN_roll_response_candidate_4 | full_fly_2.BIN | В-10 | roll_response_candidate | identification | 411.520 | 413.520 |
| full_fly_2.BIN_roll_response_candidate_5 | full_fly_2.BIN | В-10 | roll_response_candidate | identification | 412.520 | 414.520 |
| full_fly_2.BIN_roll_response_candidate_6 | full_fly_2.BIN | В-10 | roll_response_candidate | validation | 451.180 | 453.180 |
| full_fly_2.BIN_roll_response_candidate_7 | full_fly_2.BIN | В-10 | roll_response_candidate | identification | 451.475 | 453.475 |
| full_fly_2.BIN_roll_response_candidate_8 | full_fly_2.BIN | В-10 | roll_response_candidate | validation | 451.655 | 453.655 |
| full_fly_2.BIN_roll_response_candidate_9 | full_fly_2.BIN | В-10 | roll_response_candidate | validation | 451.705 | 453.705 |
| full_fly_2.BIN_pitch_response_candidate_1 | full_fly_2.BIN | В-09 | pitch_response_candidate | identification | 388.620 | 390.620 |
| full_fly_2.BIN_pitch_response_candidate_2 | full_fly_2.BIN | В-09 | pitch_response_candidate | validation | 389.650 | 393.680 |
| full_fly_2.BIN_pitch_response_candidate_3 | full_fly_2.BIN | В-09 | pitch_response_candidate | validation | 392.740 | 394.740 |
| full_fly_2.BIN_pitch_response_candidate_4 | full_fly_2.BIN | В-09 | pitch_response_candidate | identification | 395.355 | 397.355 |
| full_fly_2.BIN_pitch_response_candidate_5 | full_fly_2.BIN | В-09 | pitch_response_candidate | validation | 401.930 | 403.930 |
| full_fly_2.BIN_pitch_response_candidate_6 | full_fly_2.BIN | В-09 | pitch_response_candidate | validation | 410.265 | 412.265 |
| full_fly_2.BIN_pitch_response_candidate_7 | full_fly_2.BIN | В-09 | pitch_response_candidate | validation | 410.360 | 412.360 |
| full_fly_2.BIN_pitch_response_candidate_8 | full_fly_2.BIN | В-09 | pitch_response_candidate | identification | 410.445 | 412.445 |
| full_fly_2.BIN_pitch_response_candidate_9 | full_fly_2.BIN | В-09 | pitch_response_candidate | validation | 410.480 | 412.480 |
| full_fly_2.BIN_pitch_response_candidate_10 | full_fly_2.BIN | В-09 | pitch_response_candidate | identification | 410.675 | 412.675 |
| full_fly_2.BIN_pitch_response_candidate_11 | full_fly_2.BIN | В-09 | pitch_response_candidate | validation | 410.895 | 412.895 |
| full_fly_2.BIN_pitch_response_candidate_12 | full_fly_2.BIN | В-09 | pitch_response_candidate | validation | 411.550 | 413.550 |
| full_fly_2.BIN_pitch_response_candidate_13 | full_fly_2.BIN | В-09 | pitch_response_candidate | identification | 412.620 | 415.810 |
| full_fly_2.BIN_pitch_response_candidate_14 | full_fly_2.BIN | В-09 | pitch_response_candidate | identification | 414.890 | 416.890 |
| full_fly_2.BIN_pitch_response_candidate_15 | full_fly_2.BIN | В-09 | pitch_response_candidate | validation | 415.190 | 417.190 |
| full_fly_2.BIN_pitch_response_candidate_16 | full_fly_2.BIN | В-09 | pitch_response_candidate | validation | 436.915 | 438.915 |
| full_fly_2.BIN_pitch_response_candidate_17 | full_fly_2.BIN | В-09 | pitch_response_candidate | validation | 437.130 | 439.130 |
| full_fly_2.BIN_pitch_response_candidate_18 | full_fly_2.BIN | В-09 | pitch_response_candidate | identification | 437.350 | 439.350 |
| full_fly_2.BIN_pitch_response_candidate_19 | full_fly_2.BIN | В-09 | pitch_response_candidate | validation | 437.435 | 439.435 |
| full_fly_2.BIN_pitch_response_candidate_20 | full_fly_2.BIN | В-09 | pitch_response_candidate | validation | 437.530 | 439.530 |
| full_fly_2.BIN_pitch_response_candidate_21 | full_fly_2.BIN | В-09 | pitch_response_candidate | identification | 438.550 | 440.930 |
| full_fly_2.BIN_pitch_response_candidate_22 | full_fly_2.BIN | В-09 | pitch_response_candidate | identification | 439.965 | 441.965 |
| full_fly_2.BIN_pitch_response_candidate_23 | full_fly_2.BIN | В-09 | pitch_response_candidate | identification | 445.325 | 447.325 |
| full_fly_2.BIN_pitch_response_candidate_24 | full_fly_2.BIN | В-09 | pitch_response_candidate | validation | 451.455 | 453.455 |
| full_fly_2.BIN_pitch_response_candidate_25 | full_fly_2.BIN | В-09 | pitch_response_candidate | identification | 451.825 | 453.825 |
| full_fly_2.BIN_pitch_response_candidate_26 | full_fly_2.BIN | В-09 | pitch_response_candidate | validation | 451.955 | 453.955 |
| full_fly_2.BIN_pitch_response_candidate_27 | full_fly_2.BIN | В-09 | pitch_response_candidate | identification | 452.045 | 454.045 |
| full_fly_2.BIN_pitch_response_candidate_28 | full_fly_2.BIN | В-09 | pitch_response_candidate | identification | 452.135 | 454.135 |
| full_fly_2.BIN_pitch_response_candidate_29 | full_fly_2.BIN | В-09 | pitch_response_candidate | validation | 452.260 | 454.260 |
| full_fly_2.BIN_yaw_response_candidate_1 | full_fly_2.BIN | В-11 | yaw_response_candidate | validation | 388.300 | 390.340 |
| full_fly_2.BIN_yaw_response_candidate_2 | full_fly_2.BIN | В-11 | yaw_response_candidate | identification | 389.490 | 391.490 |
| full_fly_2.BIN_yaw_response_candidate_3 | full_fly_2.BIN | В-11 | yaw_response_candidate | validation | 390.760 | 393.390 |
| full_fly_2.BIN_yaw_response_candidate_4 | full_fly_2.BIN | В-11 | yaw_response_candidate | identification | 392.585 | 394.585 |
| full_fly_2.BIN_yaw_response_candidate_5 | full_fly_2.BIN | В-11 | yaw_response_candidate | identification | 411.580 | 413.580 |
| full_fly_2.BIN_yaw_response_candidate_6 | full_fly_2.BIN | В-11 | yaw_response_candidate | identification | 412.425 | 414.425 |
| full_fly_2.BIN_yaw_response_candidate_7 | full_fly_2.BIN | В-11 | yaw_response_candidate | identification | 412.905 | 414.905 |
| full_fly_2.BIN_yaw_response_candidate_8 | full_fly_2.BIN | В-11 | yaw_response_candidate | identification | 413.665 | 415.665 |
| full_fly_2.BIN_yaw_response_candidate_9 | full_fly_2.BIN | В-11 | yaw_response_candidate | identification | 414.080 | 416.080 |
| full_fly_2.BIN_yaw_response_candidate_10 | full_fly_2.BIN | В-11 | yaw_response_candidate | validation | 414.275 | 416.275 |
| full_fly_2.BIN_yaw_response_candidate_11 | full_fly_2.BIN | В-11 | yaw_response_candidate | validation | 437.850 | 439.850 |
| full_fly_2.BIN_yaw_response_candidate_12 | full_fly_2.BIN | В-11 | yaw_response_candidate | identification | 438.250 | 440.250 |
| full_fly_2.BIN_yaw_response_candidate_13 | full_fly_2.BIN | В-11 | yaw_response_candidate | validation | 438.680 | 440.680 |
| full_fly_2.BIN_yaw_response_candidate_14 | full_fly_2.BIN | В-11 | yaw_response_candidate | validation | 442.340 | 444.340 |
| full_fly_2.BIN_yaw_response_candidate_15 | full_fly_2.BIN | В-11 | yaw_response_candidate | identification | 442.575 | 444.575 |
| full_fly_2.BIN_yaw_response_candidate_16 | full_fly_2.BIN | В-11 | yaw_response_candidate | validation | 443.065 | 445.065 |
| full_fly_2.BIN_yaw_response_candidate_17 | full_fly_2.BIN | В-11 | yaw_response_candidate | identification | 443.385 | 445.385 |
| full_fly_2.BIN_yaw_response_candidate_18 | full_fly_2.BIN | В-11 | yaw_response_candidate | identification | 444.555 | 446.555 |
| full_fly_2.BIN_yaw_response_candidate_19 | full_fly_2.BIN | В-11 | yaw_response_candidate | validation | 445.325 | 447.325 |
| full_fly_2.BIN_yaw_response_candidate_20 | full_fly_2.BIN | В-11 | yaw_response_candidate | identification | 445.620 | 447.620 |
| full_fly_2.BIN_yaw_response_candidate_21 | full_fly_2.BIN | В-11 | yaw_response_candidate | identification | 451.175 | 453.175 |
| full_fly_2.BIN_yaw_response_candidate_22 | full_fly_2.BIN | В-11 | yaw_response_candidate | identification | 451.645 | 453.645 |
| full_fly_2.BIN_yaw_response_candidate_23 | full_fly_2.BIN | В-11 | yaw_response_candidate | validation | 451.805 | 453.805 |
| full_fly_2.BIN_yaw_response_candidate_24 | full_fly_2.BIN | В-11 | yaw_response_candidate | validation | 452.025 | 454.025 |
| full_fly_2.BIN_yaw_response_candidate_25 | full_fly_2.BIN | В-11 | yaw_response_candidate | identification | 452.120 | 454.120 |
| full_fly_2.BIN_thrust_response_candidate_1 | full_fly_2.BIN | В-12 | thrust_response_candidate | identification | 411.695 | 413.695 |

## Параметры модели

`A`:

```text
 1.4644559  0  0 
 0 -5.5419838  0 
 0  0  3.0965926 
```

`B`:

```text
 90.096499  0  0 
 0  41.491076  0 
 0  0  34.967592 
```

`c`:

```text
-0.21238667 
-0.57599287 
 0.2370421 
```


## Отчет идентификации

| segment_id | источник входа | RMSE R | RMSE P | RMSE Y |
|---|---|---:|---:|---:|
| VB-01.alt_50m.BIN_hover_candidate_1 | RATE.ROut, RATE.POut, RATE.YOut | 1.90286 | 1.26253 | 1.90178 |
| VB-01.alt_50m.BIN_hover_candidate_2 | RATE.ROut, RATE.POut, RATE.YOut | 2.42153 | 2.03267 | 0.881122 |
| VB-01.alt_50m.BIN_hover_candidate_3 | RATE.ROut, RATE.POut, RATE.YOut | 2.12671 | 1.74102 | 0.90032 |
| VB-01.alt_50m.BIN_hover_candidate_4 | RATE.ROut, RATE.POut, RATE.YOut | 9.26368 | 8.95328 | 5.49427 |
| VB-01.alt_50m.BIN_climb_candidate_1 | RATE.ROut, RATE.POut, RATE.YOut | 7.01222 | 5.85844 | 1.91254 |
| VB-01.alt_50m.BIN_climb_candidate_4 | RATE.ROut, RATE.POut, RATE.YOut | 8.03088 | 9.73689 | 1.86746 |
| VB-01.alt_50m.BIN_climb_candidate_5 | RATE.ROut, RATE.POut, RATE.YOut | 10.2177 | 8.97671 | 1.87871 |
| VB-01.alt_50m.BIN_climb_candidate_8 | RATE.ROut, RATE.POut, RATE.YOut | 4.01048 | 5.59479 | 1.57364 |
| VB-01.alt_50m.BIN_climb_candidate_9 | RATE.ROut, RATE.POut, RATE.YOut | 2.46805 | 1.97834 | 0.811393 |
| VB-01.alt_50m.BIN_climb_candidate_10 | RATE.ROut, RATE.POut, RATE.YOut | 2.90925 | 1.61267 | 0.874272 |
| VB-01.alt_50m.BIN_climb_candidate_11 | RATE.ROut, RATE.POut, RATE.YOut | 2.01663 | 2.38576 | 1.07165 |
| VB-01.alt_50m.BIN_climb_candidate_13 | RATE.ROut, RATE.POut, RATE.YOut | 2.81275 | 1.30139 | 1.23205 |
| VB-01.alt_50m.BIN_climb_candidate_14 | RATE.ROut, RATE.POut, RATE.YOut | 2.81832 | 2.10751 | 1.25333 |
| VB-01.alt_50m.BIN_climb_candidate_15 | RATE.ROut, RATE.POut, RATE.YOut | 3.21743 | 1.95972 | 1.55981 |
| VB-01.alt_50m.BIN_descent_candidate_1 | RATE.ROut, RATE.POut, RATE.YOut | 6.46317 | 6.14498 | 3.54668 |
| VB-01.alt_50m.BIN_descent_candidate_2 | RATE.ROut, RATE.POut, RATE.YOut | 5.44976 | 7.4627 | 4.92153 |
| VB-01.alt_50m.BIN_descent_candidate_6 | RATE.ROut, RATE.POut, RATE.YOut | 2.64817 | 2.21535 | 1.03738 |
| VB-01.alt_50m.BIN_descent_candidate_7 | RATE.ROut, RATE.POut, RATE.YOut | 2.69328 | 2.11662 | 1.2761 |
| VB-01.alt_50m.BIN_descent_candidate_8 | RATE.ROut, RATE.POut, RATE.YOut | 2.58664 | 1.68365 | 0.694702 |
| VB-01.alt_50m.BIN_descent_candidate_9 | RATE.ROut, RATE.POut, RATE.YOut | 2.42112 | 1.30402 | 0.866683 |
| VB-01.alt_50m.BIN_descent_candidate_11 | RATE.ROut, RATE.POut, RATE.YOut | 2.8991 | 1.13775 | 1.14531 |
| VB-01.alt_50m.BIN_descent_candidate_13 | RATE.ROut, RATE.POut, RATE.YOut | 2.84924 | 3.49409 | 2.45705 |
| VB-01.alt_50m.BIN_descent_candidate_15 | RATE.ROut, RATE.POut, RATE.YOut | 2.54176 | 3.23295 | 1.16209 |
| VB-01.alt_50m.BIN_roll_response_candidate_1 | RATE.ROut, RATE.POut, RATE.YOut | 6.12248 | 6.88059 | 2.50329 |
| VB-01.alt_50m.BIN_roll_response_candidate_2 | RATE.ROut, RATE.POut, RATE.YOut | 6.36377 | 6.777 | 2.34117 |
| VB-01.alt_50m.BIN_roll_response_candidate_5 | RATE.ROut, RATE.POut, RATE.YOut | 7.11827 | 5.91406 | 1.80746 |
| VB-01.alt_50m.BIN_roll_response_candidate_6 | RATE.ROut, RATE.POut, RATE.YOut | 6.90264 | 6.33695 | 1.80315 |
| VB-01.alt_50m.BIN_roll_response_candidate_7 | RATE.ROut, RATE.POut, RATE.YOut | 5.82971 | 4.77517 | 1.87949 |
| VB-01.alt_50m.BIN_roll_response_candidate_8 | RATE.ROut, RATE.POut, RATE.YOut | 5.77453 | 4.50015 | 1.90602 |
| VB-01.alt_50m.BIN_roll_response_candidate_9 | RATE.ROut, RATE.POut, RATE.YOut | 5.85623 | 4.75586 | 1.89322 |
| VB-01.alt_50m.BIN_roll_response_candidate_10 | RATE.ROut, RATE.POut, RATE.YOut | 5.84726 | 4.86343 | 1.90421 |
| VB-01.alt_50m.BIN_roll_response_candidate_15 | RATE.ROut, RATE.POut, RATE.YOut | 8.14548 | 5.39879 | 2.05074 |
| VB-01.alt_50m.BIN_roll_response_candidate_16 | RATE.ROut, RATE.POut, RATE.YOut | 8.01037 | 5.44771 | 2.03632 |
| VB-01.alt_50m.BIN_roll_response_candidate_18 | RATE.ROut, RATE.POut, RATE.YOut | 8.42934 | 5.75976 | 2.11192 |
| VB-01.alt_50m.BIN_roll_response_candidate_20 | RATE.ROut, RATE.POut, RATE.YOut | 8.52862 | 5.72596 | 2.07284 |
| VB-01.alt_50m.BIN_roll_response_candidate_21 | RATE.ROut, RATE.POut, RATE.YOut | 9.61297 | 7.11338 | 2.06429 |
| VB-01.alt_50m.BIN_roll_response_candidate_26 | RATE.ROut, RATE.POut, RATE.YOut | 10.5921 | 8.53425 | 2.03208 |
| VB-01.alt_50m.BIN_roll_response_candidate_29 | RATE.ROut, RATE.POut, RATE.YOut | 9.99794 | 8.61009 | 1.93466 |
| VB-01.alt_50m.BIN_roll_response_candidate_30 | RATE.ROut, RATE.POut, RATE.YOut | 10.0493 | 8.6205 | 1.97331 |
| VB-01.alt_50m.BIN_roll_response_candidate_31 | RATE.ROut, RATE.POut, RATE.YOut | 9.72075 | 8.49574 | 2.04257 |
| VB-01.alt_50m.BIN_roll_response_candidate_32 | RATE.ROut, RATE.POut, RATE.YOut | 9.80974 | 8.8035 | 2.06686 |
| VB-01.alt_50m.BIN_roll_response_candidate_33 | RATE.ROut, RATE.POut, RATE.YOut | 9.98932 | 8.57288 | 2.34222 |
| VB-01.alt_50m.BIN_roll_response_candidate_37 | RATE.ROut, RATE.POut, RATE.YOut | 10.888 | 9.32307 | 2.36699 |
| VB-01.alt_50m.BIN_roll_response_candidate_38 | RATE.ROut, RATE.POut, RATE.YOut | 10.9916 | 9.41206 | 2.37595 |
| VB-01.alt_50m.BIN_roll_response_candidate_40 | RATE.ROut, RATE.POut, RATE.YOut | 11.0117 | 9.57719 | 2.23326 |
| VB-01.alt_50m.BIN_roll_response_candidate_43 | RATE.ROut, RATE.POut, RATE.YOut | 9.6102 | 9.61403 | 1.89059 |
| VB-01.alt_50m.BIN_roll_response_candidate_45 | RATE.ROut, RATE.POut, RATE.YOut | 10.2484 | 9.06998 | 1.91505 |
| VB-01.alt_50m.BIN_roll_response_candidate_48 | RATE.ROut, RATE.POut, RATE.YOut | 9.4727 | 5.62985 | 1.92423 |
| VB-01.alt_50m.BIN_roll_response_candidate_50 | RATE.ROut, RATE.POut, RATE.YOut | 9.59611 | 5.64977 | 1.88601 |
| VB-01.alt_50m.BIN_roll_response_candidate_51 | RATE.ROut, RATE.POut, RATE.YOut | 9.57151 | 5.65907 | 1.86946 |
| VB-01.alt_50m.BIN_roll_response_candidate_53 | RATE.ROut, RATE.POut, RATE.YOut | 9.44546 | 6.93275 | 1.92722 |
| VB-01.alt_50m.BIN_roll_response_candidate_54 | RATE.ROut, RATE.POut, RATE.YOut | 9.1903 | 7.24139 | 2.0398 |
| VB-01.alt_50m.BIN_roll_response_candidate_55 | RATE.ROut, RATE.POut, RATE.YOut | 9.40436 | 7.46727 | 2.10966 |
| VB-01.alt_50m.BIN_roll_response_candidate_56 | RATE.ROut, RATE.POut, RATE.YOut | 9.40095 | 7.59413 | 2.10972 |
| VB-01.alt_50m.BIN_roll_response_candidate_57 | RATE.ROut, RATE.POut, RATE.YOut | 8.81424 | 6.15999 | 2.34101 |
| VB-01.alt_50m.BIN_roll_response_candidate_58 | RATE.ROut, RATE.POut, RATE.YOut | 8.86443 | 6.64583 | 2.49934 |
| VB-01.alt_50m.BIN_roll_response_candidate_59 | RATE.ROut, RATE.POut, RATE.YOut | 8.73519 | 6.64785 | 2.49662 |
| VB-01.alt_50m.BIN_roll_response_candidate_61 | RATE.ROut, RATE.POut, RATE.YOut | 6.8171 | 5.29819 | 2.35949 |
| VB-01.alt_50m.BIN_roll_response_candidate_62 | RATE.ROut, RATE.POut, RATE.YOut | 7.22042 | 7.10431 | 3.85989 |
| VB-01.alt_50m.BIN_roll_response_candidate_63 | RATE.ROut, RATE.POut, RATE.YOut | 7.29066 | 7.10348 | 3.97037 |
| VB-01.alt_50m.BIN_roll_response_candidate_64 | RATE.ROut, RATE.POut, RATE.YOut | 7.40581 | 7.58307 | 3.93736 |
| VB-01.alt_50m.BIN_roll_response_candidate_65 | RATE.ROut, RATE.POut, RATE.YOut | 7.50423 | 7.76807 | 4.01788 |
| VB-01.alt_50m.BIN_roll_response_candidate_67 | RATE.ROut, RATE.POut, RATE.YOut | 4.73175 | 6.55438 | 3.44081 |
| VB-01.alt_50m.BIN_roll_response_candidate_68 | RATE.ROut, RATE.POut, RATE.YOut | 4.58158 | 6.82212 | 3.57799 |
| VB-01.alt_50m.BIN_roll_response_candidate_69 | RATE.ROut, RATE.POut, RATE.YOut | 5.08554 | 7.7584 | 4.41968 |
| VB-01.alt_50m.BIN_roll_response_candidate_72 | RATE.ROut, RATE.POut, RATE.YOut | 5.5967 | 7.10944 | 1.87795 |
| VB-01.alt_50m.BIN_roll_response_candidate_73 | RATE.ROut, RATE.POut, RATE.YOut | 5.39102 | 6.83926 | 1.88438 |
| VB-01.alt_50m.BIN_roll_response_candidate_75 | RATE.ROut, RATE.POut, RATE.YOut | 3.95025 | 1.05176 | 1.8219 |
| VB-01.alt_50m.BIN_roll_response_candidate_76 | RATE.ROut, RATE.POut, RATE.YOut | 2.97515 | 3.90193 | 3.03405 |
| VB-01.alt_50m.BIN_roll_response_candidate_78 | RATE.ROut, RATE.POut, RATE.YOut | 9.73617 | 9.58719 | 5.59559 |
| VB-01.alt_50m.BIN_roll_response_candidate_80 | RATE.ROut, RATE.POut, RATE.YOut | 11.2882 | 15.371 | 6.38995 |
| VB-01.alt_50m.BIN_roll_response_candidate_82 | RATE.ROut, RATE.POut, RATE.YOut | 8.31442 | 10.9433 | 4.20179 |
| VB-01.alt_50m.BIN_roll_response_candidate_83 | RATE.ROut, RATE.POut, RATE.YOut | 8.20791 | 10.9179 | 3.58885 |
| VB-01.alt_50m.BIN_pitch_response_candidate_1 | RATE.ROut, RATE.POut, RATE.YOut | 2.72678 | 3.56623 | 2.55643 |
| VB-01.alt_50m.BIN_pitch_response_candidate_4 | RATE.ROut, RATE.POut, RATE.YOut | 5.2258 | 6.13325 | 2.80147 |
| VB-01.alt_50m.BIN_pitch_response_candidate_9 | RATE.ROut, RATE.POut, RATE.YOut | 6.55543 | 7.02215 | 2.11256 |
| VB-01.alt_50m.BIN_pitch_response_candidate_10 | RATE.ROut, RATE.POut, RATE.YOut | 6.90691 | 7.24814 | 2.20188 |
| VB-01.alt_50m.BIN_pitch_response_candidate_11 | RATE.ROut, RATE.POut, RATE.YOut | 7.03787 | 6.39202 | 2.17917 |
| VB-01.alt_50m.BIN_pitch_response_candidate_12 | RATE.ROut, RATE.POut, RATE.YOut | 7.04848 | 6.28903 | 2.16246 |
| VB-01.alt_50m.BIN_pitch_response_candidate_13 | RATE.ROut, RATE.POut, RATE.YOut | 7.07465 | 6.25479 | 2.15598 |
| VB-01.alt_50m.BIN_pitch_response_candidate_14 | RATE.ROut, RATE.POut, RATE.YOut | 7.28667 | 6.24842 | 2.04721 |
| VB-01.alt_50m.BIN_pitch_response_candidate_15 | RATE.ROut, RATE.POut, RATE.YOut | 7.18022 | 5.99705 | 1.81525 |
| VB-01.alt_50m.BIN_pitch_response_candidate_16 | RATE.ROut, RATE.POut, RATE.YOut | 7.12597 | 5.97134 | 1.83925 |
| VB-01.alt_50m.BIN_pitch_response_candidate_17 | RATE.ROut, RATE.POut, RATE.YOut | 7.10381 | 5.95454 | 1.89212 |
| VB-01.alt_50m.BIN_pitch_response_candidate_18 | RATE.ROut, RATE.POut, RATE.YOut | 7.09429 | 5.89898 | 1.8062 |
| VB-01.alt_50m.BIN_pitch_response_candidate_20 | RATE.ROut, RATE.POut, RATE.YOut | 5.85221 | 5.31974 | 1.92154 |
| VB-01.alt_50m.BIN_pitch_response_candidate_22 | RATE.ROut, RATE.POut, RATE.YOut | 5.77453 | 4.50015 | 1.90602 |
| VB-01.alt_50m.BIN_pitch_response_candidate_23 | RATE.ROut, RATE.POut, RATE.YOut | 5.8504 | 4.74077 | 1.88712 |
| VB-01.alt_50m.BIN_pitch_response_candidate_24 | RATE.ROut, RATE.POut, RATE.YOut | 5.84726 | 4.86343 | 1.90421 |
| VB-01.alt_50m.BIN_pitch_response_candidate_25 | RATE.ROut, RATE.POut, RATE.YOut | 6.22545 | 5.0288 | 1.86821 |
| VB-01.alt_50m.BIN_pitch_response_candidate_27 | RATE.ROut, RATE.POut, RATE.YOut | 5.94214 | 4.7779 | 1.81133 |
| VB-01.alt_50m.BIN_pitch_response_candidate_28 | RATE.ROut, RATE.POut, RATE.YOut | 5.84589 | 4.68262 | 1.82306 |
| VB-01.alt_50m.BIN_pitch_response_candidate_29 | RATE.ROut, RATE.POut, RATE.YOut | 5.83253 | 4.72388 | 1.70524 |
| VB-01.alt_50m.BIN_pitch_response_candidate_31 | RATE.ROut, RATE.POut, RATE.YOut | 8.00044 | 5.43863 | 2.03998 |
| VB-01.alt_50m.BIN_pitch_response_candidate_32 | RATE.ROut, RATE.POut, RATE.YOut | 8.21988 | 5.60542 | 2.02664 |
| VB-01.alt_50m.BIN_pitch_response_candidate_33 | RATE.ROut, RATE.POut, RATE.YOut | 8.27224 | 5.58512 | 2.02039 |
| VB-01.alt_50m.BIN_pitch_response_candidate_35 | RATE.ROut, RATE.POut, RATE.YOut | 8.55012 | 5.70748 | 2.07469 |
| VB-01.alt_50m.BIN_pitch_response_candidate_36 | RATE.ROut, RATE.POut, RATE.YOut | 9.61297 | 7.11338 | 2.06429 |
| VB-01.alt_50m.BIN_pitch_response_candidate_37 | RATE.ROut, RATE.POut, RATE.YOut | 9.35809 | 7.26739 | 2.0188 |
| VB-01.alt_50m.BIN_pitch_response_candidate_38 | RATE.ROut, RATE.POut, RATE.YOut | 10.008 | 7.95343 | 2.02838 |
| VB-01.alt_50m.BIN_pitch_response_candidate_40 | RATE.ROut, RATE.POut, RATE.YOut | 10.5895 | 8.21354 | 2.13051 |
| VB-01.alt_50m.BIN_pitch_response_candidate_42 | RATE.ROut, RATE.POut, RATE.YOut | 10.3419 | 8.63736 | 2.00277 |
| VB-01.alt_50m.BIN_pitch_response_candidate_43 | RATE.ROut, RATE.POut, RATE.YOut | 10.3339 | 8.67859 | 2.00717 |
| VB-01.alt_50m.BIN_pitch_response_candidate_44 | RATE.ROut, RATE.POut, RATE.YOut | 10.2624 | 8.66071 | 1.97449 |
| VB-01.alt_50m.BIN_pitch_response_candidate_45 | RATE.ROut, RATE.POut, RATE.YOut | 10.3288 | 8.85079 | 1.97072 |
| VB-01.alt_50m.BIN_pitch_response_candidate_46 | RATE.ROut, RATE.POut, RATE.YOut | 9.96444 | 8.59345 | 1.93287 |
| VB-01.alt_50m.BIN_pitch_response_candidate_48 | RATE.ROut, RATE.POut, RATE.YOut | 9.73592 | 8.66329 | 2.04961 |
| VB-01.alt_50m.BIN_pitch_response_candidate_49 | RATE.ROut, RATE.POut, RATE.YOut | 9.99349 | 8.58417 | 2.10287 |
| VB-01.alt_50m.BIN_pitch_response_candidate_50 | RATE.ROut, RATE.POut, RATE.YOut | 9.75942 | 8.77493 | 2.18309 |
| VB-01.alt_50m.BIN_pitch_response_candidate_51 | RATE.ROut, RATE.POut, RATE.YOut | 9.87896 | 8.69464 | 2.42118 |
| VB-01.alt_50m.BIN_pitch_response_candidate_52 | RATE.ROut, RATE.POut, RATE.YOut | 10.1194 | 8.77731 | 2.34257 |
| VB-01.alt_50m.BIN_pitch_response_candidate_54 | RATE.ROut, RATE.POut, RATE.YOut | 10.1211 | 8.76002 | 2.29534 |
| VB-01.alt_50m.BIN_pitch_response_candidate_55 | RATE.ROut, RATE.POut, RATE.YOut | 10.8074 | 9.2203 | 2.34548 |
| VB-01.alt_50m.BIN_pitch_response_candidate_57 | RATE.ROut, RATE.POut, RATE.YOut | 10.9529 | 9.39958 | 2.3688 |
| VB-01.alt_50m.BIN_pitch_response_candidate_59 | RATE.ROut, RATE.POut, RATE.YOut | 10.878 | 9.52275 | 2.28223 |
| VB-01.alt_50m.BIN_pitch_response_candidate_60 | RATE.ROut, RATE.POut, RATE.YOut | 10.9347 | 9.54117 | 2.24241 |
| VB-01.alt_50m.BIN_pitch_response_candidate_61 | RATE.ROut, RATE.POut, RATE.YOut | 11.0125 | 9.66528 | 2.08358 |
| VB-01.alt_50m.BIN_pitch_response_candidate_62 | RATE.ROut, RATE.POut, RATE.YOut | 11.0609 | 9.63131 | 2.07333 |
| VB-01.alt_50m.BIN_pitch_response_candidate_63 | RATE.ROut, RATE.POut, RATE.YOut | 11.0938 | 9.89341 | 2.11681 |
| VB-01.alt_50m.BIN_pitch_response_candidate_64 | RATE.ROut, RATE.POut, RATE.YOut | 10.9318 | 9.78902 | 2.08834 |
| VB-01.alt_50m.BIN_pitch_response_candidate_68 | RATE.ROut, RATE.POut, RATE.YOut | 8.23528 | 9.79076 | 1.86898 |
| VB-01.alt_50m.BIN_pitch_response_candidate_69 | RATE.ROut, RATE.POut, RATE.YOut | 9.28204 | 9.67816 | 1.93755 |
| VB-01.alt_50m.BIN_pitch_response_candidate_73 | RATE.ROut, RATE.POut, RATE.YOut | 9.99267 | 9.46943 | 1.93577 |
| VB-01.alt_50m.BIN_pitch_response_candidate_74 | RATE.ROut, RATE.POut, RATE.YOut | 10.1455 | 9.33931 | 1.93829 |
| VB-01.alt_50m.BIN_pitch_response_candidate_77 | RATE.ROut, RATE.POut, RATE.YOut | 10.4142 | 5.68365 | 2.01167 |
| VB-01.alt_50m.BIN_pitch_response_candidate_78 | RATE.ROut, RATE.POut, RATE.YOut | 10.1719 | 5.86089 | 1.98468 |
| VB-01.alt_50m.BIN_pitch_response_candidate_80 | RATE.ROut, RATE.POut, RATE.YOut | 8.24379 | 5.86988 | 1.92016 |
| VB-01.alt_50m.BIN_pitch_response_candidate_84 | RATE.ROut, RATE.POut, RATE.YOut | 9.57883 | 5.66071 | 1.88799 |
| VB-01.alt_50m.BIN_pitch_response_candidate_85 | RATE.ROut, RATE.POut, RATE.YOut | 9.62963 | 5.7373 | 1.91739 |
| VB-01.alt_50m.BIN_pitch_response_candidate_86 | RATE.ROut, RATE.POut, RATE.YOut | 9.57151 | 5.65907 | 1.86946 |
| VB-01.alt_50m.BIN_pitch_response_candidate_88 | RATE.ROut, RATE.POut, RATE.YOut | 9.08276 | 6.95705 | 1.92073 |
| VB-01.alt_50m.BIN_pitch_response_candidate_91 | RATE.ROut, RATE.POut, RATE.YOut | 8.81424 | 6.15999 | 2.34101 |
| VB-01.alt_50m.BIN_pitch_response_candidate_93 | RATE.ROut, RATE.POut, RATE.YOut | 6.72026 | 6.02176 | 3.17221 |
| VB-01.alt_50m.BIN_pitch_response_candidate_94 | RATE.ROut, RATE.POut, RATE.YOut | 6.34899 | 5.88666 | 3.26948 |
| VB-01.alt_50m.BIN_pitch_response_candidate_96 | RATE.ROut, RATE.POut, RATE.YOut | 6.36829 | 5.979 | 3.24661 |
| VB-01.alt_50m.BIN_pitch_response_candidate_98 | RATE.ROut, RATE.POut, RATE.YOut | 5.64113 | 5.6536 | 3.01524 |
| VB-01.alt_50m.BIN_pitch_response_candidate_99 | RATE.ROut, RATE.POut, RATE.YOut | 7.31268 | 7.09692 | 3.80626 |
| VB-01.alt_50m.BIN_pitch_response_candidate_101 | RATE.ROut, RATE.POut, RATE.YOut | 7.32234 | 7.39661 | 3.87755 |
| VB-01.alt_50m.BIN_pitch_response_candidate_102 | RATE.ROut, RATE.POut, RATE.YOut | 7.32529 | 7.70928 | 3.91965 |
| VB-01.alt_50m.BIN_pitch_response_candidate_104 | RATE.ROut, RATE.POut, RATE.YOut | 7.40581 | 7.58307 | 3.93736 |
| VB-01.alt_50m.BIN_pitch_response_candidate_105 | RATE.ROut, RATE.POut, RATE.YOut | 7.49104 | 7.8121 | 4.02959 |
| VB-01.alt_50m.BIN_pitch_response_candidate_106 | RATE.ROut, RATE.POut, RATE.YOut | 7.50423 | 7.76807 | 4.01788 |
| VB-01.alt_50m.BIN_pitch_response_candidate_109 | RATE.ROut, RATE.POut, RATE.YOut | 7.60087 | 7.90681 | 4.10871 |
| VB-01.alt_50m.BIN_pitch_response_candidate_110 | RATE.ROut, RATE.POut, RATE.YOut | 7.62631 | 8.05795 | 4.12263 |
| VB-01.alt_50m.BIN_pitch_response_candidate_111 | RATE.ROut, RATE.POut, RATE.YOut | 7.89636 | 8.56365 | 4.16854 |
| VB-01.alt_50m.BIN_pitch_response_candidate_112 | RATE.ROut, RATE.POut, RATE.YOut | 8.00392 | 8.44523 | 4.19045 |
| VB-01.alt_50m.BIN_pitch_response_candidate_114 | RATE.ROut, RATE.POut, RATE.YOut | 7.85519 | 8.92667 | 3.98861 |
| VB-01.alt_50m.BIN_pitch_response_candidate_117 | RATE.ROut, RATE.POut, RATE.YOut | 7.48398 | 8.88449 | 3.46063 |
| VB-01.alt_50m.BIN_pitch_response_candidate_119 | RATE.ROut, RATE.POut, RATE.YOut | 6.96965 | 8.60346 | 2.99325 |
| VB-01.alt_50m.BIN_pitch_response_candidate_121 | RATE.ROut, RATE.POut, RATE.YOut | 6.74365 | 8.13452 | 2.87153 |
| VB-01.alt_50m.BIN_pitch_response_candidate_122 | RATE.ROut, RATE.POut, RATE.YOut | 6.54184 | 8.02394 | 2.69949 |
| VB-01.alt_50m.BIN_pitch_response_candidate_123 | RATE.ROut, RATE.POut, RATE.YOut | 6.48599 | 8.13482 | 2.6248 |
| VB-01.alt_50m.BIN_pitch_response_candidate_125 | RATE.ROut, RATE.POut, RATE.YOut | 6.23874 | 9.25717 | 2.53561 |
| VB-01.alt_50m.BIN_pitch_response_candidate_126 | RATE.ROut, RATE.POut, RATE.YOut | 6.35708 | 9.31196 | 2.56756 |
| VB-01.alt_50m.BIN_pitch_response_candidate_127 | RATE.ROut, RATE.POut, RATE.YOut | 6.03115 | 9.19365 | 2.92269 |
| VB-01.alt_50m.BIN_pitch_response_candidate_129 | RATE.ROut, RATE.POut, RATE.YOut | 5.60405 | 9.46271 | 3.08111 |
| VB-01.alt_50m.BIN_pitch_response_candidate_130 | RATE.ROut, RATE.POut, RATE.YOut | 5.49021 | 9.30086 | 3.12802 |
| VB-01.alt_50m.BIN_pitch_response_candidate_132 | RATE.ROut, RATE.POut, RATE.YOut | 5.51681 | 9.34161 | 3.26403 |
| VB-01.alt_50m.BIN_pitch_response_candidate_134 | RATE.ROut, RATE.POut, RATE.YOut | 5.11105 | 9.23708 | 3.29937 |
| VB-01.alt_50m.BIN_pitch_response_candidate_137 | RATE.ROut, RATE.POut, RATE.YOut | 5.34652 | 9.95937 | 3.39452 |
| VB-01.alt_50m.BIN_pitch_response_candidate_139 | RATE.ROut, RATE.POut, RATE.YOut | 5.53944 | 9.10258 | 3.42213 |
| VB-01.alt_50m.BIN_pitch_response_candidate_140 | RATE.ROut, RATE.POut, RATE.YOut | 5.57167 | 8.82335 | 3.34063 |
| VB-01.alt_50m.BIN_pitch_response_candidate_142 | RATE.ROut, RATE.POut, RATE.YOut | 5.2918 | 8.50623 | 3.20174 |
| VB-01.alt_50m.BIN_pitch_response_candidate_143 | RATE.ROut, RATE.POut, RATE.YOut | 5.82609 | 8.48005 | 3.20454 |
| VB-01.alt_50m.BIN_pitch_response_candidate_145 | RATE.ROut, RATE.POut, RATE.YOut | 5.12065 | 8.13439 | 3.13194 |
| VB-01.alt_50m.BIN_pitch_response_candidate_147 | RATE.ROut, RATE.POut, RATE.YOut | 5.151 | 7.71789 | 3.04533 |
| VB-01.alt_50m.BIN_pitch_response_candidate_150 | RATE.ROut, RATE.POut, RATE.YOut | 4.97507 | 7.43798 | 2.98483 |
| VB-01.alt_50m.BIN_pitch_response_candidate_152 | RATE.ROut, RATE.POut, RATE.YOut | 5.00434 | 7.6205 | 3.01239 |
| VB-01.alt_50m.BIN_pitch_response_candidate_153 | RATE.ROut, RATE.POut, RATE.YOut | 5.10249 | 7.35021 | 3.02277 |
| VB-01.alt_50m.BIN_pitch_response_candidate_157 | RATE.ROut, RATE.POut, RATE.YOut | 4.20069 | 7.52614 | 2.13078 |
| VB-01.alt_50m.BIN_pitch_response_candidate_160 | RATE.ROut, RATE.POut, RATE.YOut | 4.14514 | 7.67396 | 2.18664 |
| VB-01.alt_50m.BIN_pitch_response_candidate_161 | RATE.ROut, RATE.POut, RATE.YOut | 4.40174 | 7.78174 | 2.10825 |
| VB-01.alt_50m.BIN_pitch_response_candidate_164 | RATE.ROut, RATE.POut, RATE.YOut | 3.81273 | 7.86403 | 2.7085 |
| VB-01.alt_50m.BIN_pitch_response_candidate_166 | RATE.ROut, RATE.POut, RATE.YOut | 3.73844 | 7.61995 | 2.79995 |
| VB-01.alt_50m.BIN_pitch_response_candidate_168 | RATE.ROut, RATE.POut, RATE.YOut | 3.53747 | 3.13321 | 1.85963 |
| VB-01.alt_50m.BIN_pitch_response_candidate_170 | RATE.ROut, RATE.POut, RATE.YOut | 4.24731 | 5.97932 | 4.29392 |
| VB-01.alt_50m.BIN_pitch_response_candidate_171 | RATE.ROut, RATE.POut, RATE.YOut | 4.26153 | 5.98454 | 4.28671 |
| VB-01.alt_50m.BIN_pitch_response_candidate_172 | RATE.ROut, RATE.POut, RATE.YOut | 4.2717 | 6.12716 | 4.36738 |
| VB-01.alt_50m.BIN_pitch_response_candidate_173 | RATE.ROut, RATE.POut, RATE.YOut | 4.38061 | 6.27224 | 4.48482 |
| VB-01.alt_50m.BIN_pitch_response_candidate_176 | RATE.ROut, RATE.POut, RATE.YOut | 4.24308 | 6.24448 | 4.47056 |
| VB-01.alt_50m.BIN_pitch_response_candidate_178 | RATE.ROut, RATE.POut, RATE.YOut | 4.43728 | 5.97159 | 2.80943 |
| VB-01.alt_50m.BIN_pitch_response_candidate_182 | RATE.ROut, RATE.POut, RATE.YOut | 4.73175 | 6.55438 | 3.44081 |
| VB-01.alt_50m.BIN_pitch_response_candidate_183 | RATE.ROut, RATE.POut, RATE.YOut | 4.63012 | 6.88351 | 3.60496 |
| VB-01.alt_50m.BIN_pitch_response_candidate_185 | RATE.ROut, RATE.POut, RATE.YOut | 5.40087 | 7.64512 | 3.27034 |
| VB-01.alt_50m.BIN_pitch_response_candidate_186 | RATE.ROut, RATE.POut, RATE.YOut | 5.59463 | 7.91121 | 3.33636 |
| VB-01.alt_50m.BIN_pitch_response_candidate_189 | RATE.ROut, RATE.POut, RATE.YOut | 5.04353 | 7.72435 | 3.06054 |
| VB-01.alt_50m.BIN_pitch_response_candidate_190 | RATE.ROut, RATE.POut, RATE.YOut | 4.793 | 7.62946 | 3.10051 |
| VB-01.alt_50m.BIN_pitch_response_candidate_191 | RATE.ROut, RATE.POut, RATE.YOut | 4.81464 | 7.76473 | 3.08279 |
| VB-01.alt_50m.BIN_pitch_response_candidate_192 | RATE.ROut, RATE.POut, RATE.YOut | 4.89606 | 8.13534 | 3.31137 |
| VB-01.alt_50m.BIN_pitch_response_candidate_193 | RATE.ROut, RATE.POut, RATE.YOut | 5.28606 | 7.95854 | 3.30375 |
| VB-01.alt_50m.BIN_pitch_response_candidate_194 | RATE.ROut, RATE.POut, RATE.YOut | 5.36863 | 8.17228 | 3.55627 |
| VB-01.alt_50m.BIN_pitch_response_candidate_195 | RATE.ROut, RATE.POut, RATE.YOut | 5.47423 | 8.13829 | 3.63636 |
| VB-01.alt_50m.BIN_pitch_response_candidate_196 | RATE.ROut, RATE.POut, RATE.YOut | 5.37056 | 8.11105 | 3.9413 |
| VB-01.alt_50m.BIN_pitch_response_candidate_199 | RATE.ROut, RATE.POut, RATE.YOut | 5.1389 | 7.83076 | 4.37376 |
| VB-01.alt_50m.BIN_pitch_response_candidate_200 | RATE.ROut, RATE.POut, RATE.YOut | 5.06035 | 7.73169 | 4.39057 |
| VB-01.alt_50m.BIN_pitch_response_candidate_201 | RATE.ROut, RATE.POut, RATE.YOut | 5.01828 | 7.57818 | 4.3744 |
| VB-01.alt_50m.BIN_pitch_response_candidate_202 | RATE.ROut, RATE.POut, RATE.YOut | 4.9546 | 7.29501 | 4.40248 |
| VB-01.alt_50m.BIN_pitch_response_candidate_204 | RATE.ROut, RATE.POut, RATE.YOut | 5.16264 | 7.34424 | 4.41828 |
| VB-01.alt_50m.BIN_pitch_response_candidate_205 | RATE.ROut, RATE.POut, RATE.YOut | 5.21741 | 7.30592 | 4.4595 |
| VB-01.alt_50m.BIN_pitch_response_candidate_206 | RATE.ROut, RATE.POut, RATE.YOut | 5.21532 | 7.49191 | 4.59819 |
| VB-01.alt_50m.BIN_pitch_response_candidate_207 | RATE.ROut, RATE.POut, RATE.YOut | 6.59848 | 8.76237 | 7.83978 |
| VB-01.alt_50m.BIN_pitch_response_candidate_209 | RATE.ROut, RATE.POut, RATE.YOut | 6.9454 | 9.33073 | 7.37699 |
| VB-01.alt_50m.BIN_pitch_response_candidate_210 | RATE.ROut, RATE.POut, RATE.YOut | 6.87144 | 9.5158 | 7.08461 |
| VB-01.alt_50m.BIN_pitch_response_candidate_214 | RATE.ROut, RATE.POut, RATE.YOut | 6.79602 | 9.88308 | 6.76842 |
| VB-01.alt_50m.BIN_pitch_response_candidate_215 | RATE.ROut, RATE.POut, RATE.YOut | 6.50912 | 9.36324 | 6.74776 |
| VB-01.alt_50m.BIN_pitch_response_candidate_217 | RATE.ROut, RATE.POut, RATE.YOut | 6.46693 | 9.16979 | 6.76564 |
| VB-01.alt_50m.BIN_pitch_response_candidate_220 | RATE.ROut, RATE.POut, RATE.YOut | 6.43488 | 8.91533 | 6.77355 |
| VB-01.alt_50m.BIN_pitch_response_candidate_221 | RATE.ROut, RATE.POut, RATE.YOut | 6.40458 | 8.85676 | 6.77747 |
| VB-01.alt_50m.BIN_pitch_response_candidate_222 | RATE.ROut, RATE.POut, RATE.YOut | 6.6111 | 9.23882 | 6.73006 |
| VB-01.alt_50m.BIN_pitch_response_candidate_224 | RATE.ROut, RATE.POut, RATE.YOut | 6.37294 | 8.84894 | 6.70716 |
| VB-01.alt_50m.BIN_pitch_response_candidate_226 | RATE.ROut, RATE.POut, RATE.YOut | 7.01453 | 9.3994 | 6.66615 |
| VB-01.alt_50m.BIN_pitch_response_candidate_227 | RATE.ROut, RATE.POut, RATE.YOut | 6.41853 | 8.9634 | 6.60425 |
| VB-01.alt_50m.BIN_pitch_response_candidate_228 | RATE.ROut, RATE.POut, RATE.YOut | 6.40745 | 9.14565 | 6.59406 |
| VB-01.alt_50m.BIN_pitch_response_candidate_230 | RATE.ROut, RATE.POut, RATE.YOut | 6.17018 | 8.88062 | 6.39604 |
| VB-01.alt_50m.BIN_pitch_response_candidate_231 | RATE.ROut, RATE.POut, RATE.YOut | 6.19428 | 8.88445 | 5.96283 |
| VB-01.alt_50m.BIN_pitch_response_candidate_232 | RATE.ROut, RATE.POut, RATE.YOut | 6.51575 | 9.12396 | 5.98629 |
| VB-01.alt_50m.BIN_pitch_response_candidate_234 | RATE.ROut, RATE.POut, RATE.YOut | 5.92249 | 8.55876 | 5.92555 |
| VB-01.alt_50m.BIN_pitch_response_candidate_236 | RATE.ROut, RATE.POut, RATE.YOut | 5.87953 | 8.5934 | 5.71211 |
| VB-01.alt_50m.BIN_pitch_response_candidate_237 | RATE.ROut, RATE.POut, RATE.YOut | 5.75361 | 7.96596 | 5.67618 |
| VB-01.alt_50m.BIN_pitch_response_candidate_238 | RATE.ROut, RATE.POut, RATE.YOut | 5.62204 | 7.9217 | 5.31099 |
| VB-01.alt_50m.BIN_pitch_response_candidate_241 | RATE.ROut, RATE.POut, RATE.YOut | 4.71483 | 6.67748 | 2.10448 |
| VB-01.alt_50m.BIN_pitch_response_candidate_243 | RATE.ROut, RATE.POut, RATE.YOut | 4.41023 | 6.03154 | 2.21085 |
| VB-01.alt_50m.BIN_pitch_response_candidate_244 | RATE.ROut, RATE.POut, RATE.YOut | 4.67062 | 5.60536 | 2.06542 |
| VB-01.alt_50m.BIN_pitch_response_candidate_245 | RATE.ROut, RATE.POut, RATE.YOut | 5.41079 | 6.92204 | 2.02671 |
| VB-01.alt_50m.BIN_pitch_response_candidate_246 | RATE.ROut, RATE.POut, RATE.YOut | 5.61869 | 6.97865 | 1.99235 |
| VB-01.alt_50m.BIN_pitch_response_candidate_247 | RATE.ROut, RATE.POut, RATE.YOut | 5.13135 | 6.65054 | 1.99384 |
| VB-01.alt_50m.BIN_pitch_response_candidate_248 | RATE.ROut, RATE.POut, RATE.YOut | 5.42664 | 7.00555 | 2.05028 |
| VB-01.alt_50m.BIN_pitch_response_candidate_249 | RATE.ROut, RATE.POut, RATE.YOut | 5.26206 | 6.71309 | 1.98591 |
| VB-01.alt_50m.BIN_pitch_response_candidate_252 | RATE.ROut, RATE.POut, RATE.YOut | 5.23324 | 6.67387 | 1.81677 |
| VB-01.alt_50m.BIN_pitch_response_candidate_253 | RATE.ROut, RATE.POut, RATE.YOut | 5.48218 | 7.2185 | 1.79411 |
| VB-01.alt_50m.BIN_pitch_response_candidate_258 | RATE.ROut, RATE.POut, RATE.YOut | 5.22949 | 6.2658 | 1.62293 |
| VB-01.alt_50m.BIN_pitch_response_candidate_260 | RATE.ROut, RATE.POut, RATE.YOut | 5.19694 | 6.3791 | 1.58292 |
| VB-01.alt_50m.BIN_pitch_response_candidate_261 | RATE.ROut, RATE.POut, RATE.YOut | 5.16739 | 6.38734 | 1.5859 |
| VB-01.alt_50m.BIN_pitch_response_candidate_262 | RATE.ROut, RATE.POut, RATE.YOut | 5.1842 | 6.37233 | 1.58175 |
| VB-01.alt_50m.BIN_pitch_response_candidate_265 | RATE.ROut, RATE.POut, RATE.YOut | 3.91497 | 5.95263 | 1.43116 |
| VB-01.alt_50m.BIN_pitch_response_candidate_266 | RATE.ROut, RATE.POut, RATE.YOut | 4.14755 | 6.20302 | 1.44757 |
| VB-01.alt_50m.BIN_pitch_response_candidate_268 | RATE.ROut, RATE.POut, RATE.YOut | 3.46854 | 5.35522 | 1.35235 |
| VB-01.alt_50m.BIN_pitch_response_candidate_270 | RATE.ROut, RATE.POut, RATE.YOut | 3.39652 | 5.01509 | 1.32458 |
| VB-01.alt_50m.BIN_pitch_response_candidate_271 | RATE.ROut, RATE.POut, RATE.YOut | 3.33903 | 4.27718 | 1.1048 |
| VB-01.alt_50m.BIN_pitch_response_candidate_272 | RATE.ROut, RATE.POut, RATE.YOut | 3.34281 | 4.06525 | 1.00129 |
| VB-01.alt_50m.BIN_pitch_response_candidate_274 | RATE.ROut, RATE.POut, RATE.YOut | 2.97907 | 3.74019 | 0.988001 |
| VB-01.alt_50m.BIN_pitch_response_candidate_275 | RATE.ROut, RATE.POut, RATE.YOut | 2.83805 | 3.54476 | 1.01775 |
| VB-01.alt_50m.BIN_pitch_response_candidate_276 | RATE.ROut, RATE.POut, RATE.YOut | 2.88833 | 3.34531 | 2.24554 |
| VB-01.alt_50m.BIN_pitch_response_candidate_277 | RATE.ROut, RATE.POut, RATE.YOut | 3.31868 | 3.91871 | 3.0589 |
| VB-01.alt_50m.BIN_pitch_response_candidate_278 | RATE.ROut, RATE.POut, RATE.YOut | 3.38596 | 3.95954 | 3.06023 |
| VB-01.alt_50m.BIN_pitch_response_candidate_279 | RATE.ROut, RATE.POut, RATE.YOut | 4.43754 | 4.97239 | 4.35785 |
| VB-01.alt_50m.BIN_pitch_response_candidate_280 | RATE.ROut, RATE.POut, RATE.YOut | 4.58715 | 5.03237 | 4.40135 |
| VB-01.alt_50m.BIN_pitch_response_candidate_282 | RATE.ROut, RATE.POut, RATE.YOut | 5.1285 | 5.52444 | 6.10565 |
| VB-01.alt_50m.BIN_pitch_response_candidate_283 | RATE.ROut, RATE.POut, RATE.YOut | 4.98615 | 5.5259 | 6.02065 |
| VB-01.alt_50m.BIN_pitch_response_candidate_284 | RATE.ROut, RATE.POut, RATE.YOut | 5.07272 | 5.57889 | 5.91672 |
| VB-01.alt_50m.BIN_pitch_response_candidate_285 | RATE.ROut, RATE.POut, RATE.YOut | 5.01977 | 5.76345 | 5.85274 |
| VB-01.alt_50m.BIN_pitch_response_candidate_287 | RATE.ROut, RATE.POut, RATE.YOut | 4.6144 | 4.69902 | 4.89579 |
| VB-01.alt_50m.BIN_pitch_response_candidate_289 | RATE.ROut, RATE.POut, RATE.YOut | 3.95763 | 3.94786 | 3.17315 |
| VB-01.alt_50m.BIN_pitch_response_candidate_290 | RATE.ROut, RATE.POut, RATE.YOut | 3.94855 | 4.04862 | 3.32534 |
| VB-01.alt_50m.BIN_pitch_response_candidate_292 | RATE.ROut, RATE.POut, RATE.YOut | 3.54041 | 4.18951 | 3.08301 |
| VB-01.alt_50m.BIN_pitch_response_candidate_296 | RATE.ROut, RATE.POut, RATE.YOut | 3.9177 | 3.80693 | 3.6125 |
| VB-01.alt_50m.BIN_pitch_response_candidate_297 | RATE.ROut, RATE.POut, RATE.YOut | 4.05008 | 3.97613 | 3.58995 |
| VB-01.alt_50m.BIN_pitch_response_candidate_304 | RATE.ROut, RATE.POut, RATE.YOut | 3.79549 | 4.27223 | 3.52693 |
| VB-01.alt_50m.BIN_pitch_response_candidate_306 | RATE.ROut, RATE.POut, RATE.YOut | 3.21536 | 5.7652 | 3.38592 |
| VB-01.alt_50m.BIN_pitch_response_candidate_307 | RATE.ROut, RATE.POut, RATE.YOut | 3.10841 | 7.18209 | 3.40144 |
| VB-01.alt_50m.BIN_pitch_response_candidate_310 | RATE.ROut, RATE.POut, RATE.YOut | 3.06251 | 8.08599 | 3.57631 |
| VB-01.alt_50m.BIN_pitch_response_candidate_312 | RATE.ROut, RATE.POut, RATE.YOut | 3.23662 | 7.63313 | 4.76966 |
| VB-01.alt_50m.BIN_pitch_response_candidate_313 | RATE.ROut, RATE.POut, RATE.YOut | 2.71166 | 6.09663 | 4.54912 |
| VB-01.alt_50m.BIN_pitch_response_candidate_315 | RATE.ROut, RATE.POut, RATE.YOut | 1.96012 | 4.50878 | 2.54128 |
| VB-01.alt_50m.BIN_pitch_response_candidate_316 | RATE.ROut, RATE.POut, RATE.YOut | 1.9497 | 4.48574 | 2.5478 |
| VB-01.alt_50m.BIN_pitch_response_candidate_317 | RATE.ROut, RATE.POut, RATE.YOut | 1.79359 | 4.53871 | 2.25919 |
| VB-01.alt_50m.BIN_pitch_response_candidate_320 | RATE.ROut, RATE.POut, RATE.YOut | 3.35703 | 8.82671 | 3.03143 |
| VB-01.alt_50m.BIN_pitch_response_candidate_321 | RATE.ROut, RATE.POut, RATE.YOut | 3.34433 | 8.75988 | 3.0094 |
| VB-01.alt_50m.BIN_pitch_response_candidate_323 | RATE.ROut, RATE.POut, RATE.YOut | 3.26906 | 8.40686 | 2.95071 |
| VB-01.alt_50m.BIN_pitch_response_candidate_324 | RATE.ROut, RATE.POut, RATE.YOut | 3.25257 | 8.07144 | 2.94394 |
| VB-01.alt_50m.BIN_pitch_response_candidate_326 | RATE.ROut, RATE.POut, RATE.YOut | 2.73938 | 3.78787 | 2.5437 |
| VB-01.alt_50m.BIN_pitch_response_candidate_327 | RATE.ROut, RATE.POut, RATE.YOut | 2.777 | 3.82219 | 2.64757 |
| VB-01.alt_50m.BIN_pitch_response_candidate_328 | RATE.ROut, RATE.POut, RATE.YOut | 2.71766 | 3.78486 | 2.70462 |
| VB-01.alt_50m.BIN_pitch_response_candidate_329 | RATE.ROut, RATE.POut, RATE.YOut | 2.30519 | 3.72999 | 2.23995 |
| VB-01.alt_50m.BIN_pitch_response_candidate_331 | RATE.ROut, RATE.POut, RATE.YOut | 2.90624 | 2.9554 | 1.82613 |
| VB-01.alt_50m.BIN_pitch_response_candidate_332 | RATE.ROut, RATE.POut, RATE.YOut | 2.79086 | 3.10454 | 1.62351 |
| VB-01.alt_50m.BIN_pitch_response_candidate_333 | RATE.ROut, RATE.POut, RATE.YOut | 3.01302 | 5.5136 | 1.6708 |
| VB-01.alt_50m.BIN_yaw_response_candidate_1 | RATE.ROut, RATE.POut, RATE.YOut | 8.82074 | 5.89491 | 2.46137 |
| VB-01.alt_50m.BIN_yaw_response_candidate_3 | RATE.ROut, RATE.POut, RATE.YOut | 7.69129 | 5.22753 | 2.68439 |
| VB-01.alt_50m.BIN_yaw_response_candidate_4 | RATE.ROut, RATE.POut, RATE.YOut | 6.41006 | 5.92948 | 3.25796 |
| VB-01.alt_50m.BIN_yaw_response_candidate_5 | RATE.ROut, RATE.POut, RATE.YOut | 6.96044 | 6.85428 | 3.81186 |
| VB-01.alt_50m.BIN_yaw_response_candidate_6 | RATE.ROut, RATE.POut, RATE.YOut | 7.46453 | 7.24832 | 3.93285 |
| VB-01.alt_50m.BIN_yaw_response_candidate_8 | RATE.ROut, RATE.POut, RATE.YOut | 4.18647 | 6.25577 | 3.78939 |
| VB-01.alt_50m.BIN_yaw_response_candidate_9 | RATE.ROut, RATE.POut, RATE.YOut | 4.30347 | 6.56802 | 3.66062 |
| VB-01.alt_50m.BIN_yaw_response_candidate_11 | RATE.ROut, RATE.POut, RATE.YOut | 4.43662 | 5.63703 | 2.61119 |
| VB-01.alt_50m.BIN_yaw_response_candidate_12 | RATE.ROut, RATE.POut, RATE.YOut | 4.73021 | 6.60062 | 3.3849 |
| VB-01.alt_50m.BIN_yaw_response_candidate_14 | RATE.ROut, RATE.POut, RATE.YOut | 5.44422 | 7.40981 | 3.37505 |
| VB-01.alt_50m.BIN_yaw_response_candidate_15 | RATE.ROut, RATE.POut, RATE.YOut | 4.83072 | 7.75028 | 3.05485 |
| VB-01.alt_50m.BIN_yaw_response_candidate_22 | RATE.ROut, RATE.POut, RATE.YOut | 4.59961 | 4.73615 | 4.91017 |
| VB-01.alt_50m.BIN_yaw_response_candidate_24 | RATE.ROut, RATE.POut, RATE.YOut | 3.7 | 4.04053 | 2.95425 |
| VB-01.alt_50m.BIN_yaw_response_candidate_26 | RATE.ROut, RATE.POut, RATE.YOut | 3.53512 | 4.23451 | 2.85296 |
| VB-01.alt_50m.BIN_yaw_response_candidate_28 | RATE.ROut, RATE.POut, RATE.YOut | 3.64604 | 4.27914 | 2.95205 |
| VB-01.alt_50m.BIN_yaw_response_candidate_29 | RATE.ROut, RATE.POut, RATE.YOut | 4.21182 | 4.2593 | 3.82999 |
| VB-01.alt_50m.BIN_yaw_response_candidate_30 | RATE.ROut, RATE.POut, RATE.YOut | 3.93193 | 3.97202 | 3.67772 |
| VB-01.alt_50m.BIN_yaw_response_candidate_33 | RATE.ROut, RATE.POut, RATE.YOut | 2.81633 | 3.1976 | 2.40523 |
| VB-01.alt_50m.BIN_yaw_response_candidate_34 | RATE.ROut, RATE.POut, RATE.YOut | 3.00301 | 2.78398 | 2.11024 |
| VB-01.alt_50m.BIN_yaw_response_candidate_36 | RATE.ROut, RATE.POut, RATE.YOut | 4.11171 | 4.82575 | 3.79341 |
| VB-01.alt_50m.BIN_yaw_response_candidate_38 | RATE.ROut, RATE.POut, RATE.YOut | 3.79455 | 4.30617 | 3.48959 |
| VB-01.alt_50m.BIN_yaw_response_candidate_40 | RATE.ROut, RATE.POut, RATE.YOut | 2.33295 | 2.30285 | 1.68677 |
| VB-01.alt_50m.BIN_yaw_response_candidate_42 | RATE.ROut, RATE.POut, RATE.YOut | 2.74632 | 6.38681 | 4.63875 |
| VB-01.alt_50m.BIN_yaw_response_candidate_43 | RATE.ROut, RATE.POut, RATE.YOut | 2.72473 | 6.28612 | 4.57402 |
| VB-01.alt_50m.BIN_yaw_response_candidate_44 | RATE.ROut, RATE.POut, RATE.YOut | 2.50104 | 4.27375 | 4.57864 |
| VB-01.alt_50m.BIN_yaw_response_candidate_45 | RATE.ROut, RATE.POut, RATE.YOut | 3.429 | 1.66764 | 1.84137 |
| VB-01.alt_50m.BIN_yaw_response_candidate_46 | RATE.ROut, RATE.POut, RATE.YOut | 1.53101 | 1.28345 | 3.03198 |
| VB-01.alt_50m.BIN_yaw_response_candidate_49 | RATE.ROut, RATE.POut, RATE.YOut | 3.06667 | 1.13976 | 1.16216 |
| VB-01.alt_50m.BIN_yaw_response_candidate_50 | RATE.ROut, RATE.POut, RATE.YOut | 3.45829 | 1.33355 | 1.32302 |
| VB-01.alt_50m.BIN_yaw_response_candidate_52 | RATE.ROut, RATE.POut, RATE.YOut | 2.58184 | 1.65068 | 1.87965 |
| VB-01.alt_50m.BIN_yaw_response_candidate_54 | RATE.ROut, RATE.POut, RATE.YOut | 2.90323 | 8.77268 | 3.14212 |
| VB-01.alt_50m.BIN_yaw_response_candidate_57 | RATE.ROut, RATE.POut, RATE.YOut | 1.90501 | 3.74024 | 2.53957 |
| VB-01.alt_50m.BIN_yaw_response_candidate_58 | RATE.ROut, RATE.POut, RATE.YOut | 2.82305 | 3.83705 | 2.83452 |
| VB-01.alt_50m.BIN_yaw_response_candidate_59 | RATE.ROut, RATE.POut, RATE.YOut | 3.02707 | 3.9712 | 3.0578 |
| VB-01.alt_50m.BIN_yaw_response_candidate_60 | RATE.ROut, RATE.POut, RATE.YOut | 3.42952 | 2.37917 | 2.81714 |
| VB-01.alt_50m.BIN_yaw_response_candidate_61 | RATE.ROut, RATE.POut, RATE.YOut | 2.33443 | 3.46023 | 2.11095 |
| VB-01.alt_50m.BIN_yaw_response_candidate_63 | RATE.ROut, RATE.POut, RATE.YOut | 2.91329 | 3.13628 | 1.85039 |
| VB-01.alt_50m.BIN_yaw_response_candidate_65 | RATE.ROut, RATE.POut, RATE.YOut | 9.73617 | 9.58719 | 5.59559 |
| VB-01.alt_50m.BIN_yaw_response_candidate_66 | RATE.ROut, RATE.POut, RATE.YOut | 10.0845 | 12.1481 | 5.41472 |
| VB-01.alt_50m.BIN_thrust_response_candidate_1 | RATE.ROut, RATE.POut, RATE.YOut | 4.18007 | 8.00909 | 2.37671 |
| VB-01.alt_50m.BIN_thrust_response_candidate_3 | RATE.ROut, RATE.POut, RATE.YOut | 2.75426 | 8.6227 | 2.79492 |
| full_fly_1.BIN_climb_candidate_1 | RATE.ROut, RATE.POut, RATE.YOut | 0.713666 | 1.38497 | 1.41386 |
| full_fly_1.BIN_climb_candidate_7 | RATE.ROut, RATE.POut, RATE.YOut | 1.20215 | 2.19051 | 4.09441 |
| full_fly_1.BIN_climb_candidate_9 | RATE.ROut, RATE.POut, RATE.YOut | 2.21531 | 6.92934 | 7.08298 |
| full_fly_1.BIN_climb_candidate_11 | RATE.ROut, RATE.POut, RATE.YOut | 1.22723 | 0.990023 | 2.03957 |
| full_fly_1.BIN_climb_candidate_12 | RATE.ROut, RATE.POut, RATE.YOut | 1.04181 | 4.22714 | 1.23578 |
| full_fly_1.BIN_climb_candidate_13 | RATE.ROut, RATE.POut, RATE.YOut | 1.50111 | 3.45889 | 3.82882 |
| full_fly_1.BIN_descent_candidate_3 | RATE.ROut, RATE.POut, RATE.YOut | 0.623537 | 1.44282 | 0.921622 |
| full_fly_1.BIN_descent_candidate_4 | RATE.ROut, RATE.POut, RATE.YOut | 0.380509 | 0.865406 | 0.982667 |
| full_fly_1.BIN_descent_candidate_5 | RATE.ROut, RATE.POut, RATE.YOut | 0.533209 | 0.918156 | 1.23402 |
| full_fly_1.BIN_descent_candidate_6 | RATE.ROut, RATE.POut, RATE.YOut | 1.71254 | 1.29681 | 2.42428 |
| full_fly_1.BIN_descent_candidate_7 | RATE.ROut, RATE.POut, RATE.YOut | 0.614617 | 0.998049 | 1.00008 |
| full_fly_1.BIN_descent_candidate_9 | RATE.ROut, RATE.POut, RATE.YOut | 0.425527 | 0.946661 | 1.03117 |
| full_fly_1.BIN_descent_candidate_11 | RATE.ROut, RATE.POut, RATE.YOut | 3.83289 | 3.29116 | 5.20789 |
| full_fly_1.BIN_descent_candidate_12 | RATE.ROut, RATE.POut, RATE.YOut | 2.70547 | 4.67792 | 3.69408 |
| full_fly_1.BIN_roll_response_candidate_1 | RATE.ROut, RATE.POut, RATE.YOut | 2.86289 | 3.1322 | 10.8479 |
| full_fly_1.BIN_roll_response_candidate_2 | RATE.ROut, RATE.POut, RATE.YOut | 1.24794 | 0.787849 | 2.20847 |
| full_fly_1.BIN_roll_response_candidate_3 | RATE.ROut, RATE.POut, RATE.YOut | 1.23922 | 0.809014 | 2.39849 |
| full_fly_1.BIN_roll_response_candidate_5 | RATE.ROut, RATE.POut, RATE.YOut | 1.43523 | 1.50998 | 3.17936 |
| full_fly_1.BIN_roll_response_candidate_6 | RATE.ROut, RATE.POut, RATE.YOut | 2.47362 | 1.8642 | 9.68829 |
| full_fly_1.BIN_roll_response_candidate_7 | RATE.ROut, RATE.POut, RATE.YOut | 5.60614 | 4.51311 | 10.4534 |
| full_fly_1.BIN_roll_response_candidate_8 | RATE.ROut, RATE.POut, RATE.YOut | 4.16173 | 3.76964 | 6.55401 |
| full_fly_1.BIN_roll_response_candidate_9 | RATE.ROut, RATE.POut, RATE.YOut | 3.77242 | 2.35902 | 4.33624 |
| full_fly_1.BIN_roll_response_candidate_12 | RATE.ROut, RATE.POut, RATE.YOut | 0.767605 | 1.16389 | 1.30385 |
| full_fly_1.BIN_roll_response_candidate_15 | RATE.ROut, RATE.POut, RATE.YOut | 0.860053 | 1.03064 | 1.63963 |
| full_fly_1.BIN_roll_response_candidate_16 | RATE.ROut, RATE.POut, RATE.YOut | 0.930952 | 1.0464 | 1.62885 |
| full_fly_1.BIN_roll_response_candidate_17 | RATE.ROut, RATE.POut, RATE.YOut | 0.993043 | 1.0213 | 1.64194 |
| full_fly_1.BIN_roll_response_candidate_18 | RATE.ROut, RATE.POut, RATE.YOut | 1.10434 | 1.01642 | 1.64167 |
| full_fly_1.BIN_roll_response_candidate_21 | RATE.ROut, RATE.POut, RATE.YOut | 1.64865 | 0.992184 | 1.63655 |
| full_fly_1.BIN_roll_response_candidate_25 | RATE.ROut, RATE.POut, RATE.YOut | 5.00812 | 22.6685 | 6.3782 |
| full_fly_1.BIN_roll_response_candidate_26 | RATE.ROut, RATE.POut, RATE.YOut | 4.70961 | 25.929 | 6.88679 |
| full_fly_1.BIN_roll_response_candidate_28 | RATE.ROut, RATE.POut, RATE.YOut | 4.71372 | 27.6199 | 7.21744 |
| full_fly_1.BIN_roll_response_candidate_29 | RATE.ROut, RATE.POut, RATE.YOut | 4.72624 | 29.3608 | 7.23429 |
| full_fly_1.BIN_roll_response_candidate_30 | RATE.ROut, RATE.POut, RATE.YOut | 4.71005 | 29.3249 | 7.22929 |
| full_fly_1.BIN_roll_response_candidate_32 | RATE.ROut, RATE.POut, RATE.YOut | 2.5713 | 16.3597 | 2.95403 |
| full_fly_1.BIN_pitch_response_candidate_1 | RATE.ROut, RATE.POut, RATE.YOut | 1.37881 | 1.54064 | 1.61347 |
| full_fly_1.BIN_pitch_response_candidate_3 | RATE.ROut, RATE.POut, RATE.YOut | 2.47288 | 3.09787 | 1.89258 |
| full_fly_1.BIN_pitch_response_candidate_4 | RATE.ROut, RATE.POut, RATE.YOut | 2.00312 | 1.69499 | 1.76019 |
| full_fly_1.BIN_pitch_response_candidate_5 | RATE.ROut, RATE.POut, RATE.YOut | 0.70332 | 1.62743 | 1.43075 |
| full_fly_1.BIN_pitch_response_candidate_6 | RATE.ROut, RATE.POut, RATE.YOut | 0.698844 | 2.38283 | 1.5077 |
| full_fly_1.BIN_pitch_response_candidate_7 | RATE.ROut, RATE.POut, RATE.YOut | 0.767634 | 3.16454 | 1.82685 |
| full_fly_1.BIN_pitch_response_candidate_8 | RATE.ROut, RATE.POut, RATE.YOut | 0.797497 | 3.13763 | 1.823 |
| full_fly_1.BIN_pitch_response_candidate_9 | RATE.ROut, RATE.POut, RATE.YOut | 0.789474 | 3.11455 | 1.8549 |
| full_fly_1.BIN_pitch_response_candidate_10 | RATE.ROut, RATE.POut, RATE.YOut | 0.794049 | 3.08861 | 1.86928 |
| full_fly_1.BIN_pitch_response_candidate_12 | RATE.ROut, RATE.POut, RATE.YOut | 0.774033 | 2.44212 | 1.84604 |
| full_fly_1.BIN_pitch_response_candidate_13 | RATE.ROut, RATE.POut, RATE.YOut | 0.734077 | 2.46444 | 1.77134 |
| full_fly_1.BIN_pitch_response_candidate_15 | RATE.ROut, RATE.POut, RATE.YOut | 0.755618 | 1.26777 | 0.835895 |
| full_fly_1.BIN_pitch_response_candidate_16 | RATE.ROut, RATE.POut, RATE.YOut | 2.53136 | 2.85144 | 9.10483 |
| full_fly_1.BIN_pitch_response_candidate_17 | RATE.ROut, RATE.POut, RATE.YOut | 0.479668 | 1.17909 | 0.785278 |
| full_fly_1.BIN_pitch_response_candidate_18 | RATE.ROut, RATE.POut, RATE.YOut | 0.528052 | 0.975306 | 1.1357 |
| full_fly_1.BIN_pitch_response_candidate_19 | RATE.ROut, RATE.POut, RATE.YOut | 1.13752 | 1.46021 | 1.29972 |
| full_fly_1.BIN_pitch_response_candidate_20 | RATE.ROut, RATE.POut, RATE.YOut | 1.13763 | 1.4486 | 1.28903 |
| full_fly_1.BIN_pitch_response_candidate_21 | RATE.ROut, RATE.POut, RATE.YOut | 1.04786 | 1.4916 | 1.23547 |
| full_fly_1.BIN_pitch_response_candidate_26 | RATE.ROut, RATE.POut, RATE.YOut | 1.20136 | 2.19046 | 4.09286 |
| full_fly_1.BIN_pitch_response_candidate_28 | RATE.ROut, RATE.POut, RATE.YOut | 4.78806 | 3.95176 | 9.90643 |
| full_fly_1.BIN_pitch_response_candidate_31 | RATE.ROut, RATE.POut, RATE.YOut | 0.958504 | 6.04503 | 2.15255 |
| full_fly_1.BIN_pitch_response_candidate_33 | RATE.ROut, RATE.POut, RATE.YOut | 0.930992 | 5.4013 | 3.0147 |
| full_fly_1.BIN_pitch_response_candidate_36 | RATE.ROut, RATE.POut, RATE.YOut | 1.67965 | 6.2101 | 2.23024 |
| full_fly_1.BIN_pitch_response_candidate_37 | RATE.ROut, RATE.POut, RATE.YOut | 2.57809 | 6.54133 | 8.57153 |
| full_fly_1.BIN_pitch_response_candidate_38 | RATE.ROut, RATE.POut, RATE.YOut | 1.43083 | 3.05459 | 6.078 |
| full_fly_1.BIN_pitch_response_candidate_41 | RATE.ROut, RATE.POut, RATE.YOut | 1.08817 | 5.42528 | 2.36957 |
| full_fly_1.BIN_pitch_response_candidate_42 | RATE.ROut, RATE.POut, RATE.YOut | 1.4781 | 3.57235 | 4.26047 |
| full_fly_1.BIN_pitch_response_candidate_45 | RATE.ROut, RATE.POut, RATE.YOut | 1.91263 | 3.56598 | 7.32043 |
| full_fly_1.BIN_pitch_response_candidate_47 | RATE.ROut, RATE.POut, RATE.YOut | 2.6454 | 2.69334 | 6.79175 |
| full_fly_1.BIN_pitch_response_candidate_48 | RATE.ROut, RATE.POut, RATE.YOut | 0.724775 | 1.38742 | 1.89844 |
| full_fly_1.BIN_pitch_response_candidate_49 | RATE.ROut, RATE.POut, RATE.YOut | 0.987646 | 1.59534 | 1.95877 |
| full_fly_1.BIN_pitch_response_candidate_50 | RATE.ROut, RATE.POut, RATE.YOut | 1.09667 | 1.74502 | 2.17208 |
| full_fly_1.BIN_pitch_response_candidate_51 | RATE.ROut, RATE.POut, RATE.YOut | 1.19421 | 1.67031 | 2.25741 |
| full_fly_1.BIN_pitch_response_candidate_54 | RATE.ROut, RATE.POut, RATE.YOut | 3.39904 | 1.59601 | 3.65837 |
| full_fly_1.BIN_pitch_response_candidate_56 | RATE.ROut, RATE.POut, RATE.YOut | 3.65944 | 3.75233 | 3.71794 |
| full_fly_1.BIN_pitch_response_candidate_57 | RATE.ROut, RATE.POut, RATE.YOut | 2.93263 | 3.30658 | 3.97954 |
| full_fly_1.BIN_pitch_response_candidate_59 | RATE.ROut, RATE.POut, RATE.YOut | 1.46712 | 3.25199 | 3.74502 |
| full_fly_1.BIN_pitch_response_candidate_61 | RATE.ROut, RATE.POut, RATE.YOut | 1.59451 | 3.05943 | 3.54161 |
| full_fly_1.BIN_pitch_response_candidate_63 | RATE.ROut, RATE.POut, RATE.YOut | 0.812798 | 6.33338 | 1.39676 |
| full_fly_1.BIN_pitch_response_candidate_64 | RATE.ROut, RATE.POut, RATE.YOut | 0.861505 | 6.63563 | 1.87304 |
| full_fly_1.BIN_pitch_response_candidate_65 | RATE.ROut, RATE.POut, RATE.YOut | 1.17491 | 6.5804 | 2.03636 |
| full_fly_1.BIN_pitch_response_candidate_68 | RATE.ROut, RATE.POut, RATE.YOut | 1.34816 | 6.37626 | 2.44028 |
| full_fly_1.BIN_pitch_response_candidate_69 | RATE.ROut, RATE.POut, RATE.YOut | 1.29934 | 6.36766 | 2.42592 |
| full_fly_1.BIN_pitch_response_candidate_72 | RATE.ROut, RATE.POut, RATE.YOut | 1.77216 | 3.75605 | 4.58982 |
| full_fly_1.BIN_pitch_response_candidate_73 | RATE.ROut, RATE.POut, RATE.YOut | 1.01156 | 1.89771 | 2.00878 |
| full_fly_1.BIN_pitch_response_candidate_75 | RATE.ROut, RATE.POut, RATE.YOut | 2.30396 | 2.21483 | 5.33575 |
| full_fly_1.BIN_pitch_response_candidate_76 | RATE.ROut, RATE.POut, RATE.YOut | 2.28781 | 2.23394 | 5.55296 |
| full_fly_1.BIN_pitch_response_candidate_77 | RATE.ROut, RATE.POut, RATE.YOut | 4.45003 | 19.0429 | 4.40798 |
| full_fly_1.BIN_pitch_response_candidate_78 | RATE.ROut, RATE.POut, RATE.YOut | 4.72086 | 27.6522 | 7.20444 |
| full_fly_1.BIN_pitch_response_candidate_80 | RATE.ROut, RATE.POut, RATE.YOut | 0.316198 | 0.371092 | 0.270145 |
| full_fly_1.BIN_yaw_response_candidate_2 | RATE.ROut, RATE.POut, RATE.YOut | 3.00764 | 3.23509 | 10.9992 |
| full_fly_1.BIN_yaw_response_candidate_4 | RATE.ROut, RATE.POut, RATE.YOut | 3.14924 | 3.29901 | 11.2686 |
| full_fly_1.BIN_yaw_response_candidate_9 | RATE.ROut, RATE.POut, RATE.YOut | 1.12335 | 1.99978 | 2.37086 |
| full_fly_1.BIN_yaw_response_candidate_11 | RATE.ROut, RATE.POut, RATE.YOut | 0.863597 | 0.931808 | 2.88621 |
| full_fly_1.BIN_yaw_response_candidate_12 | RATE.ROut, RATE.POut, RATE.YOut | 2.51168 | 2.49617 | 9.19431 |
| full_fly_1.BIN_yaw_response_candidate_14 | RATE.ROut, RATE.POut, RATE.YOut | 1.23924 | 2.2381 | 4.49767 |
| full_fly_1.BIN_yaw_response_candidate_16 | RATE.ROut, RATE.POut, RATE.YOut | 1.88575 | 2.71584 | 6.40083 |
| full_fly_1.BIN_yaw_response_candidate_17 | RATE.ROut, RATE.POut, RATE.YOut | 5.60893 | 4.46354 | 10.8032 |
| full_fly_1.BIN_yaw_response_candidate_18 | RATE.ROut, RATE.POut, RATE.YOut | 5.76402 | 4.68008 | 10.2312 |
| full_fly_1.BIN_yaw_response_candidate_19 | RATE.ROut, RATE.POut, RATE.YOut | 5.81427 | 4.67018 | 10.4766 |
| full_fly_1.BIN_yaw_response_candidate_20 | RATE.ROut, RATE.POut, RATE.YOut | 3.30306 | 3.78548 | 6.31882 |
| full_fly_1.BIN_yaw_response_candidate_22 | RATE.ROut, RATE.POut, RATE.YOut | 0.875077 | 5.91399 | 2.30378 |
| full_fly_1.BIN_yaw_response_candidate_23 | RATE.ROut, RATE.POut, RATE.YOut | 0.986381 | 5.83964 | 2.76478 |
| full_fly_1.BIN_yaw_response_candidate_26 | RATE.ROut, RATE.POut, RATE.YOut | 1.86633 | 4.02257 | 7.01044 |
| full_fly_1.BIN_yaw_response_candidate_27 | RATE.ROut, RATE.POut, RATE.YOut | 1.91748 | 3.64371 | 7.2876 |
| full_fly_1.BIN_yaw_response_candidate_29 | RATE.ROut, RATE.POut, RATE.YOut | 2.56967 | 3.01784 | 6.98288 |
| full_fly_1.BIN_yaw_response_candidate_32 | RATE.ROut, RATE.POut, RATE.YOut | 1.69893 | 0.992138 | 1.6384 |
| full_fly_1.BIN_yaw_response_candidate_36 | RATE.ROut, RATE.POut, RATE.YOut | 2.34883 | 3.16767 | 4.26841 |
| full_fly_1.BIN_yaw_response_candidate_37 | RATE.ROut, RATE.POut, RATE.YOut | 1.47371 | 3.57517 | 3.97238 |
| full_fly_1.BIN_yaw_response_candidate_38 | RATE.ROut, RATE.POut, RATE.YOut | 1.46915 | 5.81389 | 2.4776 |
| full_fly_1.BIN_yaw_response_candidate_39 | RATE.ROut, RATE.POut, RATE.YOut | 1.94344 | 3.52886 | 5.06652 |
| full_fly_1.BIN_yaw_response_candidate_41 | RATE.ROut, RATE.POut, RATE.YOut | 1.46851 | 2.24209 | 4.07745 |
| full_fly_1.BIN_yaw_response_candidate_43 | RATE.ROut, RATE.POut, RATE.YOut | 1.55021 | 1.80663 | 4.55812 |
| full_fly_1.BIN_yaw_response_candidate_44 | RATE.ROut, RATE.POut, RATE.YOut | 1.54871 | 1.78273 | 3.24224 |
| full_fly_1.BIN_yaw_response_candidate_45 | RATE.ROut, RATE.POut, RATE.YOut | 2.41996 | 1.82341 | 5.63992 |
| full_fly_1.BIN_yaw_response_candidate_46 | RATE.ROut, RATE.POut, RATE.YOut | 2.22046 | 1.79914 | 6.38241 |
| full_fly_1.BIN_yaw_response_candidate_48 | RATE.ROut, RATE.POut, RATE.YOut | 2.05434 | 1.90565 | 6.72116 |
| full_fly_1.BIN_yaw_response_candidate_51 | RATE.ROut, RATE.POut, RATE.YOut | 2.04761 | 1.8651 | 4.96021 |
| full_fly_1.BIN_yaw_response_candidate_52 | RATE.ROut, RATE.POut, RATE.YOut | 1.99139 | 1.91355 | 5.15074 |
| full_fly_1.BIN_yaw_response_candidate_53 | RATE.ROut, RATE.POut, RATE.YOut | 1.73738 | 1.84663 | 5.55198 |
| full_fly_1.BIN_yaw_response_candidate_55 | RATE.ROut, RATE.POut, RATE.YOut | 1.81585 | 1.9721 | 5.77032 |
| full_fly_1.BIN_yaw_response_candidate_56 | RATE.ROut, RATE.POut, RATE.YOut | 1.90753 | 1.97325 | 5.7823 |
| full_fly_1.BIN_yaw_response_candidate_57 | RATE.ROut, RATE.POut, RATE.YOut | 2.01223 | 2.03528 | 5.36774 |
| full_fly_1.BIN_yaw_response_candidate_61 | RATE.ROut, RATE.POut, RATE.YOut | 2.10316 | 1.69783 | 4.33345 |
| full_fly_1.BIN_yaw_response_candidate_62 | RATE.ROut, RATE.POut, RATE.YOut | 1.59234 | 1.42967 | 2.71366 |
| full_fly_1.BIN_yaw_response_candidate_63 | RATE.ROut, RATE.POut, RATE.YOut | 1.13947 | 1.24999 | 2.6352 |
| full_fly_1.BIN_yaw_response_candidate_64 | RATE.ROut, RATE.POut, RATE.YOut | 3.96649 | 12.5135 | 4.24114 |
| full_fly_1.BIN_yaw_response_candidate_65 | RATE.ROut, RATE.POut, RATE.YOut | 5.0138 | 27.5663 | 7.18807 |
| full_fly_1.BIN_yaw_response_candidate_66 | RATE.ROut, RATE.POut, RATE.YOut | 4.72437 | 25.9963 | 7.22282 |
| full_fly_1.BIN_yaw_response_candidate_67 | RATE.ROut, RATE.POut, RATE.YOut | 4.72624 | 29.3608 | 7.23429 |
| full_fly_1.BIN_thrust_response_candidate_1 | RATE.ROut, RATE.POut, RATE.YOut | 1.43685 | 3.04514 | 6.15355 |
| full_fly_2.BIN_hover_candidate_1 | RATE.ROut, RATE.POut, RATE.YOut | 0.509652 | 0.546878 | 0.848313 |
| full_fly_2.BIN_hover_candidate_4 | RATE.ROut, RATE.POut, RATE.YOut | 1.25643 | 0.974665 | 1.59679 |
| full_fly_2.BIN_climb_candidate_1 | RATE.ROut, RATE.POut, RATE.YOut | 1.42492 | 1.49011 | 1.53086 |
| full_fly_2.BIN_climb_candidate_2 | RATE.ROut, RATE.POut, RATE.YOut | 1.48432 | 1.93609 | 6.52137 |
| full_fly_2.BIN_climb_candidate_4 | RATE.ROut, RATE.POut, RATE.YOut | 3.62867 | 4.07276 | 11.4853 |
| full_fly_2.BIN_climb_candidate_5 | RATE.ROut, RATE.POut, RATE.YOut | 1.41394 | 1.0874 | 1.24484 |
| full_fly_2.BIN_descent_candidate_2 | RATE.ROut, RATE.POut, RATE.YOut | 0.906566 | 1.20847 | 1.06227 |
| full_fly_2.BIN_descent_candidate_3 | RATE.ROut, RATE.POut, RATE.YOut | 0.417284 | 0.879701 | 1.00069 |
| full_fly_2.BIN_descent_candidate_6 | RATE.ROut, RATE.POut, RATE.YOut | 1.41046 | 1.78565 | 1.47096 |
| full_fly_2.BIN_descent_candidate_7 | RATE.ROut, RATE.POut, RATE.YOut | 0.961618 | 1.14037 | 1.24795 |
| full_fly_2.BIN_descent_candidate_8 | RATE.ROut, RATE.POut, RATE.YOut | 1.32228 | 1.21905 | 0.998407 |
| full_fly_2.BIN_descent_candidate_10 | RATE.ROut, RATE.POut, RATE.YOut | 1.5854 | 1.8914 | 4.47524 |
| full_fly_2.BIN_descent_candidate_12 | RATE.ROut, RATE.POut, RATE.YOut | 6.59203 | 10.947 | 6.80442 |
| full_fly_2.BIN_roll_response_candidate_1 | RATE.ROut, RATE.POut, RATE.YOut | 1.20284 | 1.18812 | 1.93901 |
| full_fly_2.BIN_roll_response_candidate_2 | RATE.ROut, RATE.POut, RATE.YOut | 1.1679 | 1.34428 | 3.86733 |
| full_fly_2.BIN_roll_response_candidate_3 | RATE.ROut, RATE.POut, RATE.YOut | 1.88327 | 2.83838 | 8.71509 |
| full_fly_2.BIN_roll_response_candidate_4 | RATE.ROut, RATE.POut, RATE.YOut | 3.27855 | 3.58349 | 7.70944 |
| full_fly_2.BIN_roll_response_candidate_5 | RATE.ROut, RATE.POut, RATE.YOut | 3.94659 | 4.84455 | 10.7406 |
| full_fly_2.BIN_roll_response_candidate_7 | RATE.ROut, RATE.POut, RATE.YOut | 6.74918 | 15.7995 | 8.47756 |
| full_fly_2.BIN_pitch_response_candidate_1 | RATE.ROut, RATE.POut, RATE.YOut | 1.7644 | 2.80253 | 8.71541 |
| full_fly_2.BIN_pitch_response_candidate_4 | RATE.ROut, RATE.POut, RATE.YOut | 1.22347 | 1.57653 | 0.890534 |
| full_fly_2.BIN_pitch_response_candidate_8 | RATE.ROut, RATE.POut, RATE.YOut | 2.42557 | 1.82209 | 1.49765 |
| full_fly_2.BIN_pitch_response_candidate_10 | RATE.ROut, RATE.POut, RATE.YOut | 2.52202 | 1.96356 | 2.32299 |
| full_fly_2.BIN_pitch_response_candidate_13 | RATE.ROut, RATE.POut, RATE.YOut | 4.16556 | 5.02025 | 14.8639 |
| full_fly_2.BIN_pitch_response_candidate_14 | RATE.ROut, RATE.POut, RATE.YOut | 1.99418 | 2.63882 | 5.89527 |
| full_fly_2.BIN_pitch_response_candidate_18 | RATE.ROut, RATE.POut, RATE.YOut | 1.20885 | 2.84872 | 2.51332 |
| full_fly_2.BIN_pitch_response_candidate_21 | RATE.ROut, RATE.POut, RATE.YOut | 1.38704 | 3.4913 | 2.91115 |
| full_fly_2.BIN_pitch_response_candidate_22 | RATE.ROut, RATE.POut, RATE.YOut | 1.1329 | 2.48517 | 2.43052 |
| full_fly_2.BIN_pitch_response_candidate_23 | RATE.ROut, RATE.POut, RATE.YOut | 1.82372 | 2.11642 | 3.95816 |
| full_fly_2.BIN_pitch_response_candidate_25 | RATE.ROut, RATE.POut, RATE.YOut | 6.69642 | 15.7879 | 8.46737 |
| full_fly_2.BIN_pitch_response_candidate_27 | RATE.ROut, RATE.POut, RATE.YOut | 6.03424 | 13.2163 | 8.42053 |
| full_fly_2.BIN_pitch_response_candidate_28 | RATE.ROut, RATE.POut, RATE.YOut | 5.40295 | 11.7568 | 7.14027 |
| full_fly_2.BIN_yaw_response_candidate_2 | RATE.ROut, RATE.POut, RATE.YOut | 1.89606 | 2.86987 | 8.44816 |
| full_fly_2.BIN_yaw_response_candidate_4 | RATE.ROut, RATE.POut, RATE.YOut | 2.10864 | 2.6521 | 8.53223 |
| full_fly_2.BIN_yaw_response_candidate_5 | RATE.ROut, RATE.POut, RATE.YOut | 3.22879 | 3.64173 | 7.71249 |
| full_fly_2.BIN_yaw_response_candidate_6 | RATE.ROut, RATE.POut, RATE.YOut | 3.5045 | 4.89201 | 10.2963 |
| full_fly_2.BIN_yaw_response_candidate_7 | RATE.ROut, RATE.POut, RATE.YOut | 4.64254 | 5.71318 | 12.4986 |
| full_fly_2.BIN_yaw_response_candidate_8 | RATE.ROut, RATE.POut, RATE.YOut | 4.36168 | 5.52118 | 17.1574 |
| full_fly_2.BIN_yaw_response_candidate_9 | RATE.ROut, RATE.POut, RATE.YOut | 3.59047 | 5.0821 | 12.4104 |
| full_fly_2.BIN_yaw_response_candidate_12 | RATE.ROut, RATE.POut, RATE.YOut | 1.42095 | 4.08128 | 2.74001 |
| full_fly_2.BIN_yaw_response_candidate_15 | RATE.ROut, RATE.POut, RATE.YOut | 1.32687 | 1.42949 | 4.43238 |
| full_fly_2.BIN_yaw_response_candidate_17 | RATE.ROut, RATE.POut, RATE.YOut | 1.30334 | 1.51387 | 4.37007 |
| full_fly_2.BIN_yaw_response_candidate_18 | RATE.ROut, RATE.POut, RATE.YOut | 1.82051 | 2.13511 | 4.46129 |
| full_fly_2.BIN_yaw_response_candidate_20 | RATE.ROut, RATE.POut, RATE.YOut | 1.61653 | 2.14266 | 3.83257 |
| full_fly_2.BIN_yaw_response_candidate_21 | RATE.ROut, RATE.POut, RATE.YOut | 6.77945 | 11.1617 | 8.20497 |
| full_fly_2.BIN_yaw_response_candidate_22 | RATE.ROut, RATE.POut, RATE.YOut | 6.74258 | 15.8158 | 9.0299 |
| full_fly_2.BIN_yaw_response_candidate_25 | RATE.ROut, RATE.POut, RATE.YOut | 5.38631 | 11.7372 | 7.30431 |
| full_fly_2.BIN_thrust_response_candidate_1 | RATE.ROut, RATE.POut, RATE.YOut | 3.06709 | 3.49496 | 7.59322 |

## Показатели проверки на validation-участках

| segment_id | ось | RMSE, рад/с | MAE, рад/с | max, рад/с | соответствие, % |
|---|---|---:|---:|---:|---:|
| VB-01.alt_50m.BIN_climb_candidate_2 | RATE.R | 9.84602 | 5.47967 | 35.58 | -711.534 |
| VB-01.alt_50m.BIN_climb_candidate_2 | RATE.P | 0.241835 | 0.178312 | 1.42749 | -8.125 |
| VB-01.alt_50m.BIN_climb_candidate_2 | RATE.Y | 21559.4 | 8365.6 | 109429 | -17718978.487 |
| VB-01.alt_50m.BIN_climb_candidate_3 | RATE.R | 3.98536 | 3.34472 | 10.0832 | -177.840 |
| VB-01.alt_50m.BIN_climb_candidate_3 | RATE.P | 1.04335 | 0.735707 | 2.72086 | 4.553 |
| VB-01.alt_50m.BIN_climb_candidate_3 | RATE.Y | 13.8287 | 7.94667 | 47.5818 | -9039.161 |
| VB-01.alt_50m.BIN_climb_candidate_6 | RATE.R | 44093.4 | 16262.4 | 237368 | -12373319.508 |
| VB-01.alt_50m.BIN_climb_candidate_6 | RATE.P | 0.205766 | 0.165406 | 0.671308 | -51.952 |
| VB-01.alt_50m.BIN_climb_candidate_6 | RATE.Y | 1.63083e+12 | 4.13648e+11 | 1.26632e+13 | -1841360050042565.250 |
| VB-01.alt_50m.BIN_climb_candidate_7 | RATE.R | 9.12936e+06 | 3.07729e+06 | 5.37741e+07 | -4580440023.499 |
| VB-01.alt_50m.BIN_climb_candidate_7 | RATE.P | 0.837338 | 0.561243 | 4.15559 | 4.527 |
| VB-01.alt_50m.BIN_climb_candidate_7 | RATE.Y | 9.17028e+14 | 2.12579e+14 | 7.79116e+15 | -966964638834469248.000 |
| VB-01.alt_50m.BIN_climb_candidate_12 | RATE.R | 137.97 | 65.4395 | 577.738 | -11707.970 |
| VB-01.alt_50m.BIN_climb_candidate_12 | RATE.P | 0.139985 | 0.103656 | 0.403699 | -35.599 |
| VB-01.alt_50m.BIN_climb_candidate_12 | RATE.Y | 6.14017e+06 | 2.00298e+06 | 3.70717e+07 | -809717531.306 |
| VB-01.alt_50m.BIN_descent_candidate_3 | RATE.R | 8.51666e+10 | 2.22498e+10 | 6.47253e+11 | -19247558964239.238 |
| VB-01.alt_50m.BIN_descent_candidate_3 | RATE.P | 0.350567 | 0.298369 | 0.887109 | -100.068 |
| VB-01.alt_50m.BIN_descent_candidate_3 | RATE.Y | 3.59401e+25 | 6.45723e+24 | 3.93977e+26 | -14933172813612653528471306240.000 |
| VB-01.alt_50m.BIN_descent_candidate_4 | RATE.R | 50.313 | 31.9841 | 150.99 | -32781.736 |
| VB-01.alt_50m.BIN_descent_candidate_4 | RATE.P | 0.282188 | 0.215259 | 0.908364 | -49.062 |
| VB-01.alt_50m.BIN_descent_candidate_4 | RATE.Y | 495.085 | 226.626 | 2132.48 | -269920.194 |
| VB-01.alt_50m.BIN_descent_candidate_5 | RATE.R | 880.383 | 378.874 | 4054.93 | -473882.447 |
| VB-01.alt_50m.BIN_descent_candidate_5 | RATE.P | 0.379611 | 0.341721 | 0.667224 | -397.809 |
| VB-01.alt_50m.BIN_descent_candidate_5 | RATE.Y | 1.22611e+08 | 3.63475e+07 | 8.14591e+08 | -168733054306.829 |
| VB-01.alt_50m.BIN_descent_candidate_10 | RATE.R | 66.1822 | 35.759 | 242.168 | -80192.759 |
| VB-01.alt_50m.BIN_descent_candidate_10 | RATE.P | 2.12281 | 1.5039 | 5.07067 | 3.575 |
| VB-01.alt_50m.BIN_descent_candidate_10 | RATE.Y | 22474.7 | 8394.47 | 118509 | -13272256.404 |
| VB-01.alt_50m.BIN_descent_candidate_12 | RATE.R | 67395.4 | 25606.5 | 352173 | -10387836.254 |
| VB-01.alt_50m.BIN_descent_candidate_12 | RATE.P | 0.925041 | 0.446619 | 4.12384 | 4.118 |
| VB-01.alt_50m.BIN_descent_candidate_12 | RATE.Y | 3.9265e+11 | 1.02601e+11 | 2.9595e+12 | -218395857612071.719 |
| VB-01.alt_50m.BIN_descent_candidate_14 | RATE.R | 1.13376 | 0.930854 | 2.92558 | -141.192 |
| VB-01.alt_50m.BIN_descent_candidate_14 | RATE.P | 0.375931 | 0.300852 | 0.841087 | -35.014 |
| VB-01.alt_50m.BIN_descent_candidate_14 | RATE.Y | 177.767 | 99.9085 | 617.078 | -147686.706 |
| VB-01.alt_50m.BIN_roll_response_candidate_3 | RATE.R | 1.68855 | 1.22319 | 4.59254 | -415.279 |
| VB-01.alt_50m.BIN_roll_response_candidate_3 | RATE.P | 0.355434 | 0.292757 | 0.817745 | -18.090 |
| VB-01.alt_50m.BIN_roll_response_candidate_3 | RATE.Y | 48.8575 | 27.5289 | 169.379 | -68499.362 |
| VB-01.alt_50m.BIN_roll_response_candidate_4 | RATE.R | 0.788527 | 0.646573 | 1.90564 | -142.756 |
| VB-01.alt_50m.BIN_roll_response_candidate_4 | RATE.P | 0.334224 | 0.279702 | 0.711449 | -4.660 |
| VB-01.alt_50m.BIN_roll_response_candidate_4 | RATE.Y | 56.434 | 31.7856 | 196.194 | -82950.865 |
| VB-01.alt_50m.BIN_roll_response_candidate_11 | RATE.R | 3.40654 | 2.635 | 8.20553 | -1662.678 |
| VB-01.alt_50m.BIN_roll_response_candidate_11 | RATE.P | 0.189016 | 0.150833 | 0.557634 | -17.802 |
| VB-01.alt_50m.BIN_roll_response_candidate_11 | RATE.Y | 22.3181 | 12.4953 | 77.7151 | -53109.621 |
| VB-01.alt_50m.BIN_roll_response_candidate_12 | RATE.R | 1.18345 | 0.908494 | 3.44995 | -504.535 |
| VB-01.alt_50m.BIN_roll_response_candidate_12 | RATE.P | 0.186528 | 0.147033 | 0.557422 | -13.450 |
| VB-01.alt_50m.BIN_roll_response_candidate_12 | RATE.Y | 32.1495 | 18.0523 | 111.653 | -75091.992 |
| VB-01.alt_50m.BIN_roll_response_candidate_13 | RATE.R | 4.47152 | 3.47436 | 11.1613 | -2143.817 |
| VB-01.alt_50m.BIN_roll_response_candidate_13 | RATE.P | 0.196434 | 0.149838 | 0.572492 | -21.901 |
| VB-01.alt_50m.BIN_roll_response_candidate_13 | RATE.Y | 41.4411 | 23.2638 | 144.216 | -94495.717 |
| VB-01.alt_50m.BIN_roll_response_candidate_14 | RATE.R | 0.307147 | 0.228305 | 1.17323 | 8.920 |
| VB-01.alt_50m.BIN_roll_response_candidate_14 | RATE.P | 0.187062 | 0.140784 | 0.613547 | -13.482 |
| VB-01.alt_50m.BIN_roll_response_candidate_14 | RATE.Y | 27.2788 | 15.3074 | 94.7016 | -59779.907 |
| VB-01.alt_50m.BIN_roll_response_candidate_17 | RATE.R | 2.09015 | 1.59348 | 5.64937 | -229.542 |
| VB-01.alt_50m.BIN_roll_response_candidate_17 | RATE.P | 0.19433 | 0.145489 | 0.654695 | -13.517 |
| VB-01.alt_50m.BIN_roll_response_candidate_17 | RATE.Y | 45.88 | 25.9058 | 159.121 | -100903.134 |
| VB-01.alt_50m.BIN_roll_response_candidate_19 | RATE.R | 1.14746 | 0.691398 | 3.79099 | -32.579 |
| VB-01.alt_50m.BIN_roll_response_candidate_19 | RATE.P | 0.193002 | 0.144145 | 0.654684 | -13.398 |
| VB-01.alt_50m.BIN_roll_response_candidate_19 | RATE.Y | 37.0072 | 20.9107 | 128.257 | -83618.351 |
| VB-01.alt_50m.BIN_roll_response_candidate_22 | RATE.R | 6.5535 | 5.21311 | 17.1957 | -460.128 |
| VB-01.alt_50m.BIN_roll_response_candidate_22 | RATE.P | 0.240783 | 0.184921 | 0.731047 | -24.985 |
| VB-01.alt_50m.BIN_roll_response_candidate_22 | RATE.Y | 7.89339 | 4.50519 | 27.1441 | -6601.343 |
| VB-01.alt_50m.BIN_roll_response_candidate_23 | RATE.R | 2.90387 | 2.38213 | 6.22222 | -95.870 |
| VB-01.alt_50m.BIN_roll_response_candidate_23 | RATE.P | 0.220874 | 0.17332 | 0.657827 | -12.056 |
| VB-01.alt_50m.BIN_roll_response_candidate_23 | RATE.Y | 6.08274 | 3.53751 | 20.8322 | -4680.712 |
| VB-01.alt_50m.BIN_roll_response_candidate_24 | RATE.R | 5.04489 | 4.1016 | 12.9973 | -221.218 |
| VB-01.alt_50m.BIN_roll_response_candidate_24 | RATE.P | 0.234302 | 0.187833 | 0.616642 | -15.842 |
| VB-01.alt_50m.BIN_roll_response_candidate_24 | RATE.Y | 5.57414 | 3.26708 | 19.2698 | -3443.226 |
| VB-01.alt_50m.BIN_roll_response_candidate_25 | RATE.R | 3.03017 | 2.3109 | 8.53236 | -86.810 |
| VB-01.alt_50m.BIN_roll_response_candidate_25 | RATE.P | 0.240764 | 0.193652 | 0.610125 | -14.556 |
| VB-01.alt_50m.BIN_roll_response_candidate_25 | RATE.Y | 13.1116 | 7.30808 | 45.5805 | -7838.580 |
| VB-01.alt_50m.BIN_roll_response_candidate_27 | RATE.R | 11.3181 | 8.80808 | 26.9885 | -611.873 |
| VB-01.alt_50m.BIN_roll_response_candidate_27 | RATE.P | 0.718858 | 0.423694 | 2.46159 | -6.075 |
| VB-01.alt_50m.BIN_roll_response_candidate_27 | RATE.Y | 25.3896 | 14.2472 | 88.1056 | -13403.852 |
| VB-01.alt_50m.BIN_roll_response_candidate_28 | RATE.R | 11.6324 | 9.08375 | 27.5542 | -641.448 |
| VB-01.alt_50m.BIN_roll_response_candidate_28 | RATE.P | 0.754064 | 0.447403 | 2.4616 | -7.823 |
| VB-01.alt_50m.BIN_roll_response_candidate_28 | RATE.Y | 31.8538 | 17.9084 | 110.55 | -16843.370 |
| VB-01.alt_50m.BIN_roll_response_candidate_34 | RATE.R | 3.15743 | 2.28912 | 6.61105 | -120.977 |
| VB-01.alt_50m.BIN_roll_response_candidate_34 | RATE.P | 1.04673 | 0.736483 | 2.72017 | 4.197 |
| VB-01.alt_50m.BIN_roll_response_candidate_34 | RATE.Y | 4.19498 | 2.51901 | 14.1259 | -2653.740 |
| VB-01.alt_50m.BIN_roll_response_candidate_35 | RATE.R | 6.71345 | 4.99142 | 14.9687 | -370.451 |
| VB-01.alt_50m.BIN_roll_response_candidate_35 | RATE.P | 1.03602 | 0.730238 | 2.7222 | 5.199 |
| VB-01.alt_50m.BIN_roll_response_candidate_35 | RATE.Y | 1.61289 | 1.05854 | 5.08232 | -956.335 |
| VB-01.alt_50m.BIN_roll_response_candidate_36 | RATE.R | 10.9013 | 8.3761 | 24.9451 | -716.183 |
| VB-01.alt_50m.BIN_roll_response_candidate_36 | RATE.P | 1.01195 | 0.715715 | 2.72739 | 7.848 |
| VB-01.alt_50m.BIN_roll_response_candidate_36 | RATE.Y | 7.50644 | 4.06705 | 26.4956 | -4822.936 |
| VB-01.alt_50m.BIN_roll_response_candidate_39 | RATE.R | 2.80105 | 2.39035 | 6.10838 | -112.072 |
| VB-01.alt_50m.BIN_roll_response_candidate_39 | RATE.P | 0.857916 | 0.576705 | 2.9103 | -0.621 |
| VB-01.alt_50m.BIN_roll_response_candidate_39 | RATE.Y | 7.38403 | 4.01034 | 26.0297 | -5035.356 |
| VB-01.alt_50m.BIN_roll_response_candidate_41 | RATE.R | 4.04254 | 3.39371 | 9.42475 | -358.237 |
| VB-01.alt_50m.BIN_roll_response_candidate_41 | RATE.P | 0.43458 | 0.329276 | 1.20394 | 4.703 |
| VB-01.alt_50m.BIN_roll_response_candidate_41 | RATE.Y | 68.0128 | 38.1932 | 236.575 | -62555.527 |
| VB-01.alt_50m.BIN_roll_response_candidate_42 | RATE.R | 3.59056 | 2.77923 | 8.37245 | -312.874 |
| VB-01.alt_50m.BIN_roll_response_candidate_42 | RATE.P | 0.482541 | 0.36341 | 1.34742 | 7.383 |
| VB-01.alt_50m.BIN_roll_response_candidate_42 | RATE.Y | 65.3711 | 36.705 | 227.382 | -63341.892 |
| VB-01.alt_50m.BIN_roll_response_candidate_44 | RATE.R | 2.97108 | 2.1481 | 6.94192 | -385.065 |
| VB-01.alt_50m.BIN_roll_response_candidate_44 | RATE.P | 0.663595 | 0.526132 | 1.54537 | 5.377 |
| VB-01.alt_50m.BIN_roll_response_candidate_44 | RATE.Y | 37.3656 | 21.0196 | 129.962 | -61944.482 |
| VB-01.alt_50m.BIN_roll_response_candidate_46 | RATE.R | 0.583392 | 0.456618 | 1.35726 | 5.193 |
| VB-01.alt_50m.BIN_roll_response_candidate_46 | RATE.P | 0.534482 | 0.379398 | 1.56009 | 10.864 |
| VB-01.alt_50m.BIN_roll_response_candidate_46 | RATE.Y | 46.8036 | 26.4406 | 162.398 | -80443.343 |
| VB-01.alt_50m.BIN_roll_response_candidate_47 | RATE.R | 0.537546 | 0.421939 | 1.42754 | 12.776 |
| VB-01.alt_50m.BIN_roll_response_candidate_47 | RATE.P | 0.49594 | 0.340111 | 1.58512 | 13.969 |
| VB-01.alt_50m.BIN_roll_response_candidate_47 | RATE.Y | 44.0288 | 24.868 | 152.857 | -72266.993 |
| VB-01.alt_50m.BIN_roll_response_candidate_49 | RATE.R | 1.31034 | 1.05294 | 3.1386 | -597.416 |
| VB-01.alt_50m.BIN_roll_response_candidate_49 | RATE.P | 0.1645 | 0.137168 | 0.432831 | -17.369 |
| VB-01.alt_50m.BIN_roll_response_candidate_49 | RATE.Y | 49.5602 | 27.7898 | 172.422 | -129785.433 |
| VB-01.alt_50m.BIN_roll_response_candidate_52 | RATE.R | 2.44794 | 1.72545 | 6.35147 | -756.568 |
| VB-01.alt_50m.BIN_roll_response_candidate_52 | RATE.P | 0.158511 | 0.126908 | 0.442219 | -12.236 |
| VB-01.alt_50m.BIN_roll_response_candidate_52 | RATE.Y | 49.3856 | 27.8566 | 171.564 | -123382.032 |
| VB-01.alt_50m.BIN_roll_response_candidate_60 | RATE.R | 1.4812 | 0.98 | 4.50449 | -304.128 |
| VB-01.alt_50m.BIN_roll_response_candidate_60 | RATE.P | 0.244679 | 0.207931 | 0.545935 | -91.499 |
| VB-01.alt_50m.BIN_roll_response_candidate_60 | RATE.Y | 89.4908 | 49.5677 | 313.54 | -94216.204 |
| VB-01.alt_50m.BIN_roll_response_candidate_66 | RATE.R | 3.69495 | 2.6901 | 9.43993 | -611.171 |
| VB-01.alt_50m.BIN_roll_response_candidate_66 | RATE.P | 1.23197 | 1.07884 | 2.53797 | -171.733 |
| VB-01.alt_50m.BIN_roll_response_candidate_66 | RATE.Y | 169.725 | 95.7124 | 589.667 | -81852.772 |
| VB-01.alt_50m.BIN_roll_response_candidate_70 | RATE.R | 8.72443 | 6.53243 | 20.851 | -4903.458 |
| VB-01.alt_50m.BIN_roll_response_candidate_70 | RATE.P | 0.60108 | 0.466986 | 1.59138 | -86.919 |
| VB-01.alt_50m.BIN_roll_response_candidate_70 | RATE.Y | 326.545 | 184.114 | 1132.47 | -82010.095 |
| VB-01.alt_50m.BIN_roll_response_candidate_71 | RATE.R | 3.04323 | 2.36778 | 7.63879 | -1772.840 |
| VB-01.alt_50m.BIN_roll_response_candidate_71 | RATE.P | 0.187906 | 0.147598 | 0.514821 | -6.761 |
| VB-01.alt_50m.BIN_roll_response_candidate_71 | RATE.Y | 17.8451 | 10.2434 | 61.8476 | -30441.453 |
| VB-01.alt_50m.BIN_roll_response_candidate_74 | RATE.R | 0.467945 | 0.349591 | 1.26605 | 17.404 |
| VB-01.alt_50m.BIN_roll_response_candidate_74 | RATE.P | 0.365186 | 0.28387 | 1.11212 | 4.748 |
| VB-01.alt_50m.BIN_roll_response_candidate_74 | RATE.Y | 14.9504 | 8.33209 | 52.1228 | -11798.662 |
| VB-01.alt_50m.BIN_roll_response_candidate_77 | RATE.R | 3.86765 | 1.93944 | 15.5049 | -890.342 |
| VB-01.alt_50m.BIN_roll_response_candidate_77 | RATE.P | 0.878459 | 0.610248 | 2.9044 | -141.646 |
| VB-01.alt_50m.BIN_roll_response_candidate_77 | RATE.Y | 94.3902 | 53.1071 | 326.768 | -101823.153 |
| VB-01.alt_50m.BIN_roll_response_candidate_79 | RATE.R | 31.642 | 19.8957 | 83.2438 | -4352.456 |
| VB-01.alt_50m.BIN_roll_response_candidate_79 | RATE.P | 2.90427 | 1.93613 | 8.06944 | -262.797 |
| VB-01.alt_50m.BIN_roll_response_candidate_79 | RATE.Y | 95.6773 | 54.4045 | 331.98 | -8186.583 |
| VB-01.alt_50m.BIN_roll_response_candidate_81 | RATE.R | 81.2094 | 60.1634 | 195.337 | -11726.789 |
| VB-01.alt_50m.BIN_roll_response_candidate_81 | RATE.P | 4.39555 | 3.83423 | 8.06891 | -428.626 |
| VB-01.alt_50m.BIN_roll_response_candidate_81 | RATE.Y | 65.8098 | 36.9839 | 228.1 | -5588.508 |
| VB-01.alt_50m.BIN_roll_response_candidate_84 | RATE.R | 88.9621 | 67.1234 | 213.278 | -12767.546 |
| VB-01.alt_50m.BIN_roll_response_candidate_84 | RATE.P | 4.67848 | 4.23595 | 8.06604 | -460.223 |
| VB-01.alt_50m.BIN_roll_response_candidate_84 | RATE.Y | 108.207 | 61.0706 | 375.055 | -9283.844 |
| VB-01.alt_50m.BIN_roll_response_candidate_85 | RATE.R | 92.4626 | 70.3367 | 221.427 | -13230.970 |
| VB-01.alt_50m.BIN_roll_response_candidate_85 | RATE.P | 4.80118 | 4.4145 | 8.06275 | -472.333 |
| VB-01.alt_50m.BIN_roll_response_candidate_85 | RATE.Y | 116.835 | 65.9929 | 404.955 | -10027.199 |
| VB-01.alt_50m.BIN_pitch_response_candidate_2 | RATE.R | 6.02714 | 4.46272 | 14.8929 | -3972.447 |
| VB-01.alt_50m.BIN_pitch_response_candidate_2 | RATE.P | 0.497954 | 0.430433 | 1.06132 | -129.290 |
| VB-01.alt_50m.BIN_pitch_response_candidate_2 | RATE.Y | 10.1802 | 5.64284 | 35.67 | -17058.046 |
| VB-01.alt_50m.BIN_pitch_response_candidate_3 | RATE.R | 5.37184 | 3.97751 | 13.2506 | -3431.557 |
| VB-01.alt_50m.BIN_pitch_response_candidate_3 | RATE.P | 0.498951 | 0.433036 | 1.06123 | -122.386 |
| VB-01.alt_50m.BIN_pitch_response_candidate_3 | RATE.Y | 13.811 | 7.69041 | 48.227 | -22179.053 |
| VB-01.alt_50m.BIN_pitch_response_candidate_5 | RATE.R | 4.05027 | 3.01807 | 9.98772 | -1602.955 |
| VB-01.alt_50m.BIN_pitch_response_candidate_5 | RATE.P | 0.498864 | 0.435282 | 1.06077 | -102.239 |
| VB-01.alt_50m.BIN_pitch_response_candidate_5 | RATE.Y | 9.61643 | 5.2738 | 33.746 | -14409.735 |
| VB-01.alt_50m.BIN_pitch_response_candidate_6 | RATE.R | 5.61048 | 4.26016 | 12.9809 | -2221.336 |
| VB-01.alt_50m.BIN_pitch_response_candidate_6 | RATE.P | 0.484272 | 0.411828 | 1.05907 | -93.717 |
| VB-01.alt_50m.BIN_pitch_response_candidate_6 | RATE.Y | 15.9524 | 8.86697 | 55.5285 | -23664.689 |
| VB-01.alt_50m.BIN_pitch_response_candidate_7 | RATE.R | 3.00009 | 2.36573 | 7.11128 | -958.733 |
| VB-01.alt_50m.BIN_pitch_response_candidate_7 | RATE.P | 0.445329 | 0.36331 | 1.04054 | -68.493 |
| VB-01.alt_50m.BIN_pitch_response_candidate_7 | RATE.Y | 34.3587 | 19.2813 | 119.318 | -47630.247 |
| VB-01.alt_50m.BIN_pitch_response_candidate_8 | RATE.R | 0.535354 | 0.438348 | 1.42034 | -69.653 |
| VB-01.alt_50m.BIN_pitch_response_candidate_8 | RATE.P | 0.408518 | 0.331243 | 0.996653 | -41.814 |
| VB-01.alt_50m.BIN_pitch_response_candidate_8 | RATE.Y | 27.3763 | 15.3324 | 94.9805 | -37822.155 |
| VB-01.alt_50m.BIN_pitch_response_candidate_19 | RATE.R | 1.5098 | 1.02157 | 4.06483 | -563.161 |
| VB-01.alt_50m.BIN_pitch_response_candidate_19 | RATE.P | 0.248533 | 0.201784 | 0.613654 | -3.889 |
| VB-01.alt_50m.BIN_pitch_response_candidate_19 | RATE.Y | 3.43001 | 1.95397 | 11.9116 | -6471.760 |
| VB-01.alt_50m.BIN_pitch_response_candidate_21 | RATE.R | 2.37891 | 1.69398 | 6.01627 | -1067.607 |
| VB-01.alt_50m.BIN_pitch_response_candidate_21 | RATE.P | 0.203993 | 0.168362 | 0.57242 | -15.730 |
| VB-01.alt_50m.BIN_pitch_response_candidate_21 | RATE.Y | 1.23695 | 0.669378 | 4.47582 | -2390.680 |
| VB-01.alt_50m.BIN_pitch_response_candidate_26 | RATE.R | 1.53006 | 1.16911 | 3.49869 | -620.259 |
| VB-01.alt_50m.BIN_pitch_response_candidate_26 | RATE.P | 0.207877 | 0.163769 | 0.596723 | -16.255 |
| VB-01.alt_50m.BIN_pitch_response_candidate_26 | RATE.Y | 1.76476 | 0.95169 | 6.29269 | -4021.018 |
| VB-01.alt_50m.BIN_pitch_response_candidate_30 | RATE.R | 1.10516 | 0.843319 | 3.11461 | -101.429 |
| VB-01.alt_50m.BIN_pitch_response_candidate_30 | RATE.P | 0.200232 | 0.150679 | 0.654676 | -13.820 |
| VB-01.alt_50m.BIN_pitch_response_candidate_30 | RATE.Y | 27.5232 | 15.4329 | 95.729 | -59574.746 |
| VB-01.alt_50m.BIN_pitch_response_candidate_34 | RATE.R | 1.14746 | 0.691398 | 3.79099 | -32.579 |
| VB-01.alt_50m.BIN_pitch_response_candidate_34 | RATE.P | 0.193002 | 0.144145 | 0.654684 | -13.398 |
| VB-01.alt_50m.BIN_pitch_response_candidate_34 | RATE.Y | 37.0072 | 20.9107 | 128.257 | -83618.351 |
| VB-01.alt_50m.BIN_pitch_response_candidate_39 | RATE.R | 2.90387 | 2.38213 | 6.22222 | -95.870 |
| VB-01.alt_50m.BIN_pitch_response_candidate_39 | RATE.P | 0.220874 | 0.17332 | 0.657827 | -12.056 |
| VB-01.alt_50m.BIN_pitch_response_candidate_39 | RATE.Y | 6.08274 | 3.53751 | 20.8322 | -4680.712 |
| VB-01.alt_50m.BIN_pitch_response_candidate_41 | RATE.R | 3.07634 | 2.33978 | 8.53236 | -89.888 |
| VB-01.alt_50m.BIN_pitch_response_candidate_41 | RATE.P | 0.242346 | 0.194977 | 0.610125 | -13.716 |
| VB-01.alt_50m.BIN_pitch_response_candidate_41 | RATE.Y | 13.4931 | 7.50571 | 47.0311 | -8037.366 |
| VB-01.alt_50m.BIN_pitch_response_candidate_47 | RATE.R | 6.36644 | 5.16641 | 14.5599 | -367.875 |
| VB-01.alt_50m.BIN_pitch_response_candidate_47 | RATE.P | 0.963685 | 0.637519 | 2.71963 | 4.131 |
| VB-01.alt_50m.BIN_pitch_response_candidate_47 | RATE.Y | 36.1041 | 20.4183 | 125.335 | -25060.402 |
| VB-01.alt_50m.BIN_pitch_response_candidate_53 | RATE.R | 7.56834 | 6.20321 | 18.4007 | -425.422 |
| VB-01.alt_50m.BIN_pitch_response_candidate_53 | RATE.P | 1.05773 | 0.754844 | 2.7192 | 3.463 |
| VB-01.alt_50m.BIN_pitch_response_candidate_53 | RATE.Y | 4.47825 | 2.66012 | 15.0581 | -2859.327 |
| VB-01.alt_50m.BIN_pitch_response_candidate_56 | RATE.R | 1.42793 | 1.21625 | 3.07264 | -8.235 |
| VB-01.alt_50m.BIN_pitch_response_candidate_56 | RATE.P | 0.839363 | 0.552262 | 2.88014 | 10.311 |
| VB-01.alt_50m.BIN_pitch_response_candidate_56 | RATE.Y | 2.86845 | 1.52766 | 10.4499 | -1870.696 |
| VB-01.alt_50m.BIN_pitch_response_candidate_58 | RATE.R | 1.11835 | 0.91887 | 2.76122 | 15.330 |
| VB-01.alt_50m.BIN_pitch_response_candidate_58 | RATE.P | 0.861944 | 0.579706 | 2.91929 | 0.778 |
| VB-01.alt_50m.BIN_pitch_response_candidate_58 | RATE.Y | 3.16444 | 1.69883 | 11.3837 | -2089.883 |
| VB-01.alt_50m.BIN_pitch_response_candidate_65 | RATE.R | 11.9487 | 9.21458 | 28.5948 | -1491.617 |
| VB-01.alt_50m.BIN_pitch_response_candidate_65 | RATE.P | 0.561583 | 0.44056 | 1.34743 | 7.052 |
| VB-01.alt_50m.BIN_pitch_response_candidate_65 | RATE.Y | 57.1952 | 32.1804 | 198.489 | -57263.669 |
| VB-01.alt_50m.BIN_pitch_response_candidate_66 | RATE.R | 6.14026 | 4.78918 | 14.7348 | -1027.682 |
| VB-01.alt_50m.BIN_pitch_response_candidate_66 | RATE.P | 0.590371 | 0.479696 | 1.34737 | 5.920 |
| VB-01.alt_50m.BIN_pitch_response_candidate_66 | RATE.Y | 76.2801 | 42.9119 | 265.334 | -78586.955 |
| VB-01.alt_50m.BIN_pitch_response_candidate_67 | RATE.R | 6.11875 | 4.88343 | 14.5917 | -1873.649 |
| VB-01.alt_50m.BIN_pitch_response_candidate_67 | RATE.P | 0.667746 | 0.552537 | 1.53502 | 3.963 |
| VB-01.alt_50m.BIN_pitch_response_candidate_67 | RATE.Y | 61.4719 | 34.6382 | 213.337 | -71331.930 |
| VB-01.alt_50m.BIN_pitch_response_candidate_70 | RATE.R | 0.652576 | 0.458394 | 2.32573 | -46.073 |
| VB-01.alt_50m.BIN_pitch_response_candidate_70 | RATE.P | 0.715122 | 0.593493 | 1.5444 | 3.935 |
| VB-01.alt_50m.BIN_pitch_response_candidate_70 | RATE.Y | 39.3187 | 22.0826 | 136.642 | -74225.098 |
| VB-01.alt_50m.BIN_pitch_response_candidate_71 | RATE.R | 3.34324 | 2.49608 | 9.19195 | -538.312 |
| VB-01.alt_50m.BIN_pitch_response_candidate_71 | RATE.P | 0.714638 | 0.592182 | 1.54427 | 4.026 |
| VB-01.alt_50m.BIN_pitch_response_candidate_71 | RATE.Y | 29.6652 | 16.6776 | 102.861 | -55402.500 |
| VB-01.alt_50m.BIN_pitch_response_candidate_72 | RATE.R | 2.53424 | 1.82301 | 6.923 | -343.228 |
| VB-01.alt_50m.BIN_pitch_response_candidate_72 | RATE.P | 0.714344 | 0.576842 | 1.54379 | 3.958 |
| VB-01.alt_50m.BIN_pitch_response_candidate_72 | RATE.Y | 36.8763 | 20.7724 | 127.919 | -64846.337 |
| VB-01.alt_50m.BIN_pitch_response_candidate_75 | RATE.R | 2.02306 | 1.50321 | 4.81798 | -228.965 |
| VB-01.alt_50m.BIN_pitch_response_candidate_75 | RATE.P | 0.492634 | 0.33866 | 1.5882 | 13.113 |
| VB-01.alt_50m.BIN_pitch_response_candidate_75 | RATE.Y | 35.3825 | 19.9155 | 123.213 | -57930.714 |
| VB-01.alt_50m.BIN_pitch_response_candidate_76 | RATE.R | 2.58089 | 2.09206 | 6.29113 | -319.085 |
| VB-01.alt_50m.BIN_pitch_response_candidate_76 | RATE.P | 0.1599 | 0.129888 | 0.41834 | 7.526 |
| VB-01.alt_50m.BIN_pitch_response_candidate_76 | RATE.Y | 7.79465 | 4.2284 | 27.4295 | -12849.473 |
| VB-01.alt_50m.BIN_pitch_response_candidate_79 | RATE.R | 0.909854 | 0.665219 | 2.4178 | -428.014 |
| VB-01.alt_50m.BIN_pitch_response_candidate_79 | RATE.P | 0.169462 | 0.141133 | 0.422343 | -17.923 |
| VB-01.alt_50m.BIN_pitch_response_candidate_79 | RATE.Y | 57.3699 | 32.2419 | 199.661 | -151077.026 |
| VB-01.alt_50m.BIN_pitch_response_candidate_81 | RATE.R | 0.721546 | 0.526678 | 2.13217 | -216.694 |
| VB-01.alt_50m.BIN_pitch_response_candidate_81 | RATE.P | 0.169934 | 0.141346 | 0.445229 | -13.294 |
| VB-01.alt_50m.BIN_pitch_response_candidate_81 | RATE.Y | 46.148 | 25.9103 | 160.636 | -111118.982 |
| VB-01.alt_50m.BIN_pitch_response_candidate_82 | RATE.R | 2.59036 | 1.93034 | 6.8484 | -994.470 |
| VB-01.alt_50m.BIN_pitch_response_candidate_82 | RATE.P | 0.170947 | 0.140529 | 0.445239 | -14.963 |
| VB-01.alt_50m.BIN_pitch_response_candidate_82 | RATE.Y | 46.6886 | 26.2191 | 162.452 | -107887.904 |
| VB-01.alt_50m.BIN_pitch_response_candidate_83 | RATE.R | 4.17904 | 3.1505 | 10.9219 | -1633.849 |
| VB-01.alt_50m.BIN_pitch_response_candidate_83 | RATE.P | 0.173608 | 0.142222 | 0.445254 | -15.529 |
| VB-01.alt_50m.BIN_pitch_response_candidate_83 | RATE.Y | 40.8579 | 22.924 | 142.165 | -91637.210 |
| VB-01.alt_50m.BIN_pitch_response_candidate_87 | RATE.R | 2.59251 | 1.82559 | 7.15945 | -844.788 |
| VB-01.alt_50m.BIN_pitch_response_candidate_87 | RATE.P | 0.158295 | 0.12734 | 0.413707 | -10.531 |
| VB-01.alt_50m.BIN_pitch_response_candidate_87 | RATE.Y | 36.7514 | 20.7398 | 127.646 | -100992.366 |
| VB-01.alt_50m.BIN_pitch_response_candidate_89 | RATE.R | 6.62347 | 4.85615 | 16.491 | -2266.036 |
| VB-01.alt_50m.BIN_pitch_response_candidate_89 | RATE.P | 0.159401 | 0.126686 | 0.460482 | -11.345 |
| VB-01.alt_50m.BIN_pitch_response_candidate_89 | RATE.Y | 3.96783 | 2.21833 | 13.9599 | -7793.769 |
| VB-01.alt_50m.BIN_pitch_response_candidate_90 | RATE.R | 4.84028 | 3.5165 | 12.1901 | -1787.047 |
| VB-01.alt_50m.BIN_pitch_response_candidate_90 | RATE.P | 0.193942 | 0.155095 | 0.55795 | -35.044 |
| VB-01.alt_50m.BIN_pitch_response_candidate_90 | RATE.Y | 10.665 | 5.9889 | 36.5503 | -13866.900 |
| VB-01.alt_50m.BIN_pitch_response_candidate_92 | RATE.R | 2.34101 | 1.84004 | 5.16926 | -479.812 |
| VB-01.alt_50m.BIN_pitch_response_candidate_92 | RATE.P | 0.227383 | 0.191186 | 0.547741 | -69.187 |
| VB-01.alt_50m.BIN_pitch_response_candidate_92 | RATE.Y | 18.9121 | 11.1327 | 64.1808 | -24716.281 |
| VB-01.alt_50m.BIN_pitch_response_candidate_95 | RATE.R | 2.74882 | 2.07114 | 6.66873 | -1000.072 |
| VB-01.alt_50m.BIN_pitch_response_candidate_95 | RATE.P | 0.453748 | 0.348838 | 1.34231 | -0.645 |
| VB-01.alt_50m.BIN_pitch_response_candidate_95 | RATE.Y | 102.134 | 56.5876 | 356.55 | -50409.541 |
| VB-01.alt_50m.BIN_pitch_response_candidate_97 | RATE.R | 1.8306 | 1.37962 | 4.68112 | -774.287 |
| VB-01.alt_50m.BIN_pitch_response_candidate_97 | RATE.P | 0.663336 | 0.518384 | 1.67734 | -23.837 |
| VB-01.alt_50m.BIN_pitch_response_candidate_97 | RATE.Y | 316.965 | 178.097 | 1102.47 | -209361.067 |
| VB-01.alt_50m.BIN_pitch_response_candidate_100 | RATE.R | 2.3868 | 1.72575 | 5.95125 | -370.031 |
| VB-01.alt_50m.BIN_pitch_response_candidate_100 | RATE.P | 1.25626 | 1.13609 | 2.53974 | -175.581 |
| VB-01.alt_50m.BIN_pitch_response_candidate_100 | RATE.Y | 188.897 | 106.202 | 656.298 | -89954.112 |
| VB-01.alt_50m.BIN_pitch_response_candidate_103 | RATE.R | 2.55906 | 1.84925 | 6.78536 | -394.483 |
| VB-01.alt_50m.BIN_pitch_response_candidate_103 | RATE.P | 1.3213 | 1.2274 | 2.53968 | -203.495 |
| VB-01.alt_50m.BIN_pitch_response_candidate_103 | RATE.Y | 156.513 | 87.9939 | 543.67 | -73578.790 |
| VB-01.alt_50m.BIN_pitch_response_candidate_107 | RATE.R | 4.52116 | 3.34652 | 11.5464 | -768.454 |
| VB-01.alt_50m.BIN_pitch_response_candidate_107 | RATE.P | 1.26978 | 1.15298 | 2.53909 | -191.066 |
| VB-01.alt_50m.BIN_pitch_response_candidate_107 | RATE.Y | 158.768 | 89.6326 | 550.253 | -75561.073 |
| VB-01.alt_50m.BIN_pitch_response_candidate_108 | RATE.R | 5.25403 | 3.90965 | 13.4115 | -911.140 |
| VB-01.alt_50m.BIN_pitch_response_candidate_108 | RATE.P | 1.26463 | 1.14601 | 2.53903 | -188.283 |
| VB-01.alt_50m.BIN_pitch_response_candidate_108 | RATE.Y | 169.095 | 95.2698 | 587.493 | -80743.935 |
| VB-01.alt_50m.BIN_pitch_response_candidate_113 | RATE.R | 3.14782 | 2.25698 | 7.96971 | -504.077 |
| VB-01.alt_50m.BIN_pitch_response_candidate_113 | RATE.P | 1.20028 | 1.043 | 2.53468 | -161.262 |
| VB-01.alt_50m.BIN_pitch_response_candidate_113 | RATE.Y | 175.056 | 98.8532 | 608.005 | -84421.903 |
| VB-01.alt_50m.BIN_pitch_response_candidate_115 | RATE.R | 2.4744 | 1.71626 | 6.39552 | -381.098 |
| VB-01.alt_50m.BIN_pitch_response_candidate_115 | RATE.P | 1.17793 | 1.00594 | 2.5207 | -151.636 |
| VB-01.alt_50m.BIN_pitch_response_candidate_115 | RATE.Y | 153.249 | 86.6791 | 532.122 | -74485.303 |
| VB-01.alt_50m.BIN_pitch_response_candidate_116 | RATE.R | 1.17071 | 1.062 | 2.12404 | -139.322 |
| VB-01.alt_50m.BIN_pitch_response_candidate_116 | RATE.P | 1.17972 | 1.01653 | 2.51762 | -153.610 |
| VB-01.alt_50m.BIN_pitch_response_candidate_116 | RATE.Y | 89.3827 | 50.7195 | 309.416 | -44482.725 |
| VB-01.alt_50m.BIN_pitch_response_candidate_118 | RATE.R | 0.868386 | 0.64496 | 2.40881 | -125.788 |
| VB-01.alt_50m.BIN_pitch_response_candidate_118 | RATE.P | 1.11017 | 0.908632 | 2.42332 | -140.668 |
| VB-01.alt_50m.BIN_pitch_response_candidate_118 | RATE.Y | 30.5089 | 17.4099 | 105.556 | -16416.526 |
| VB-01.alt_50m.BIN_pitch_response_candidate_120 | RATE.R | 2.04271 | 1.43943 | 5.55086 | -457.045 |
| VB-01.alt_50m.BIN_pitch_response_candidate_120 | RATE.P | 1.07653 | 0.887099 | 2.29181 | -92.054 |
| VB-01.alt_50m.BIN_pitch_response_candidate_120 | RATE.Y | 13.3414 | 7.41672 | 46.7999 | -7601.390 |
| VB-01.alt_50m.BIN_pitch_response_candidate_124 | RATE.R | 6.57358 | 4.80554 | 16.2509 | -1714.214 |
| VB-01.alt_50m.BIN_pitch_response_candidate_124 | RATE.P | 1.19273 | 0.936272 | 4.15557 | 3.504 |
| VB-01.alt_50m.BIN_pitch_response_candidate_124 | RATE.Y | 66.5246 | 37.4162 | 231.712 | -40825.836 |
| VB-01.alt_50m.BIN_pitch_response_candidate_128 | RATE.R | 4.24553 | 3.11816 | 10.2084 | -3164.701 |
| VB-01.alt_50m.BIN_pitch_response_candidate_128 | RATE.P | 1.31907 | 0.873897 | 4.15632 | 7.833 |
| VB-01.alt_50m.BIN_pitch_response_candidate_128 | RATE.Y | 54.3271 | 30.5072 | 188.861 | -56809.213 |
| VB-01.alt_50m.BIN_pitch_response_candidate_131 | RATE.R | 4.4921 | 3.33612 | 11.0236 | -3370.505 |
| VB-01.alt_50m.BIN_pitch_response_candidate_131 | RATE.P | 1.30965 | 0.848723 | 4.15828 | 7.704 |
| VB-01.alt_50m.BIN_pitch_response_candidate_131 | RATE.Y | 58.1036 | 32.6613 | 202.041 | -53104.692 |
| VB-01.alt_50m.BIN_pitch_response_candidate_133 | RATE.R | 5.98866 | 4.52054 | 14.5794 | -4546.280 |
| VB-01.alt_50m.BIN_pitch_response_candidate_133 | RATE.P | 1.32358 | 0.88026 | 4.15797 | 5.718 |
| VB-01.alt_50m.BIN_pitch_response_candidate_133 | RATE.Y | 59.7037 | 33.6594 | 207.105 | -54025.446 |
| VB-01.alt_50m.BIN_pitch_response_candidate_135 | RATE.R | 4.27706 | 3.26115 | 10.4754 | -3410.444 |
| VB-01.alt_50m.BIN_pitch_response_candidate_135 | RATE.P | 1.36877 | 0.947163 | 4.17784 | -13.735 |
| VB-01.alt_50m.BIN_pitch_response_candidate_135 | RATE.Y | 63.7864 | 35.953 | 221.804 | -53163.502 |
| VB-01.alt_50m.BIN_pitch_response_candidate_136 | RATE.R | 2.79582 | 2.11383 | 6.82549 | -2194.831 |
| VB-01.alt_50m.BIN_pitch_response_candidate_136 | RATE.P | 1.38783 | 0.993617 | 4.18562 | -20.008 |
| VB-01.alt_50m.BIN_pitch_response_candidate_136 | RATE.Y | 54.8711 | 30.9224 | 190.859 | -45382.776 |
| VB-01.alt_50m.BIN_pitch_response_candidate_138 | RATE.R | 0.786687 | 0.559358 | 2.08528 | -517.824 |
| VB-01.alt_50m.BIN_pitch_response_candidate_138 | RATE.P | 0.851874 | 0.727999 | 2.45335 | 21.726 |
| VB-01.alt_50m.BIN_pitch_response_candidate_138 | RATE.Y | 20.6563 | 11.5686 | 72.0439 | -16487.501 |
| VB-01.alt_50m.BIN_pitch_response_candidate_141 | RATE.R | 0.482927 | 0.331553 | 1.45118 | -321.406 |
| VB-01.alt_50m.BIN_pitch_response_candidate_141 | RATE.P | 0.681823 | 0.615105 | 1.18106 | -57.990 |
| VB-01.alt_50m.BIN_pitch_response_candidate_141 | RATE.Y | 29.4308 | 16.5139 | 102.371 | -25683.441 |
| VB-01.alt_50m.BIN_pitch_response_candidate_144 | RATE.R | 0.218161 | 0.181064 | 0.573713 | -88.807 |
| VB-01.alt_50m.BIN_pitch_response_candidate_144 | RATE.P | 0.693504 | 0.635517 | 1.17748 | -96.550 |
| VB-01.alt_50m.BIN_pitch_response_candidate_144 | RATE.Y | 13.0201 | 7.50333 | 45.076 | -12110.937 |
| VB-01.alt_50m.BIN_pitch_response_candidate_146 | RATE.R | 1.40175 | 1.17868 | 3.18159 | -1097.182 |
| VB-01.alt_50m.BIN_pitch_response_candidate_146 | RATE.P | 0.692396 | 0.624362 | 1.18305 | -109.958 |
| VB-01.alt_50m.BIN_pitch_response_candidate_146 | RATE.Y | 41.8057 | 23.5121 | 145.376 | -40472.638 |
| VB-01.alt_50m.BIN_pitch_response_candidate_148 | RATE.R | 1.53361 | 1.09363 | 3.96069 | -1222.744 |
| VB-01.alt_50m.BIN_pitch_response_candidate_148 | RATE.P | 0.700795 | 0.645718 | 1.1814 | -112.611 |
| VB-01.alt_50m.BIN_pitch_response_candidate_148 | RATE.Y | 27.3125 | 15.3129 | 95.0784 | -26650.259 |
| VB-01.alt_50m.BIN_pitch_response_candidate_149 | RATE.R | 1.42245 | 1.2077 | 3.14486 | -1113.921 |
| VB-01.alt_50m.BIN_pitch_response_candidate_149 | RATE.P | 0.710193 | 0.653409 | 1.19532 | -115.414 |
| VB-01.alt_50m.BIN_pitch_response_candidate_149 | RATE.Y | 23.1373 | 12.9843 | 80.2757 | -22572.044 |
| VB-01.alt_50m.BIN_pitch_response_candidate_151 | RATE.R | 0.619277 | 0.431309 | 1.85719 | -429.775 |
| VB-01.alt_50m.BIN_pitch_response_candidate_151 | RATE.P | 0.706276 | 0.654422 | 1.18455 | -117.445 |
| VB-01.alt_50m.BIN_pitch_response_candidate_151 | RATE.Y | 18.2877 | 10.2117 | 63.7452 | -17920.823 |
| VB-01.alt_50m.BIN_pitch_response_candidate_154 | RATE.R | 3.26492 | 2.41417 | 8.30223 | -2682.500 |
| VB-01.alt_50m.BIN_pitch_response_candidate_154 | RATE.P | 0.663329 | 0.62191 | 1.13158 | -117.904 |
| VB-01.alt_50m.BIN_pitch_response_candidate_154 | RATE.Y | 47.2105 | 26.5584 | 164.252 | -50252.169 |
| VB-01.alt_50m.BIN_pitch_response_candidate_155 | RATE.R | 3.34447 | 2.45088 | 8.55777 | -2997.051 |
| VB-01.alt_50m.BIN_pitch_response_candidate_155 | RATE.P | 0.562356 | 0.511604 | 1.03399 | -99.914 |
| VB-01.alt_50m.BIN_pitch_response_candidate_155 | RATE.Y | 46.7902 | 26.3079 | 162.946 | -66969.278 |
| VB-01.alt_50m.BIN_pitch_response_candidate_156 | RATE.R | 3.70538 | 2.7315 | 9.38349 | -3344.094 |
| VB-01.alt_50m.BIN_pitch_response_candidate_156 | RATE.P | 0.559448 | 0.510436 | 1.02308 | -95.396 |
| VB-01.alt_50m.BIN_pitch_response_candidate_156 | RATE.Y | 50.6136 | 28.4699 | 176.22 | -76411.679 |
| VB-01.alt_50m.BIN_pitch_response_candidate_158 | RATE.R | 2.84049 | 2.03365 | 7.27865 | -2552.344 |
| VB-01.alt_50m.BIN_pitch_response_candidate_158 | RATE.P | 0.808876 | 0.616435 | 2.85654 | -4.683 |
| VB-01.alt_50m.BIN_pitch_response_candidate_158 | RATE.Y | 50.7807 | 28.5533 | 176.874 | -82953.314 |
| VB-01.alt_50m.BIN_pitch_response_candidate_159 | RATE.R | 3.00273 | 2.15048 | 7.67628 | -2798.539 |
| VB-01.alt_50m.BIN_pitch_response_candidate_159 | RATE.P | 1.00628 | 0.721165 | 2.85656 | 1.724 |
| VB-01.alt_50m.BIN_pitch_response_candidate_159 | RATE.Y | 44.1433 | 24.7965 | 153.595 | -69142.442 |
| VB-01.alt_50m.BIN_pitch_response_candidate_162 | RATE.R | 1.89076 | 1.3296 | 5.03657 | -1853.863 |
| VB-01.alt_50m.BIN_pitch_response_candidate_162 | RATE.P | 1.1747 | 0.789754 | 2.85807 | -1.050 |
| VB-01.alt_50m.BIN_pitch_response_candidate_162 | RATE.Y | 29.061 | 16.2798 | 100.974 | -29539.342 |
| VB-01.alt_50m.BIN_pitch_response_candidate_163 | RATE.R | 3.90785 | 2.84481 | 9.92896 | -3966.677 |
| VB-01.alt_50m.BIN_pitch_response_candidate_163 | RATE.P | 1.16928 | 0.767737 | 2.85949 | -0.847 |
| VB-01.alt_50m.BIN_pitch_response_candidate_163 | RATE.Y | 32.4051 | 18.1734 | 112.469 | -32835.604 |
| VB-01.alt_50m.BIN_pitch_response_candidate_165 | RATE.R | 4.44769 | 3.28623 | 10.8669 | -4757.953 |
| VB-01.alt_50m.BIN_pitch_response_candidate_165 | RATE.P | 1.16436 | 0.7439 | 2.86427 | -4.001 |
| VB-01.alt_50m.BIN_pitch_response_candidate_165 | RATE.Y | 49.0838 | 27.6505 | 170.535 | -44784.123 |
| VB-01.alt_50m.BIN_pitch_response_candidate_167 | RATE.R | 1.37573 | 0.962852 | 3.71209 | -690.430 |
| VB-01.alt_50m.BIN_pitch_response_candidate_167 | RATE.P | 0.295208 | 0.263573 | 0.563275 | -131.096 |
| VB-01.alt_50m.BIN_pitch_response_candidate_167 | RATE.Y | 2.27068 | 1.30718 | 7.89256 | -4879.315 |
| VB-01.alt_50m.BIN_pitch_response_candidate_169 | RATE.R | 5.13628 | 4.21331 | 11.7711 | -1395.557 |
| VB-01.alt_50m.BIN_pitch_response_candidate_169 | RATE.P | 0.367118 | 0.307838 | 0.89479 | -218.054 |
| VB-01.alt_50m.BIN_pitch_response_candidate_169 | RATE.Y | 72.0705 | 40.0405 | 251.046 | -63618.453 |
| VB-01.alt_50m.BIN_pitch_response_candidate_174 | RATE.R | 2.11489 | 1.44444 | 5.8759 | -783.490 |
| VB-01.alt_50m.BIN_pitch_response_candidate_174 | RATE.P | 0.857441 | 0.51391 | 2.89456 | -19.993 |
| VB-01.alt_50m.BIN_pitch_response_candidate_174 | RATE.Y | 30.1381 | 17.1802 | 103.615 | -18092.203 |
| VB-01.alt_50m.BIN_pitch_response_candidate_175 | RATE.R | 5.30897 | 3.85694 | 13.8532 | -2069.761 |
| VB-01.alt_50m.BIN_pitch_response_candidate_175 | RATE.P | 0.860571 | 0.523504 | 2.89638 | -20.016 |
| VB-01.alt_50m.BIN_pitch_response_candidate_175 | RATE.Y | 16.6202 | 9.58996 | 56.4734 | -9992.631 |
| VB-01.alt_50m.BIN_pitch_response_candidate_177 | RATE.R | 1.97514 | 1.23644 | 5.75133 | -640.058 |
| VB-01.alt_50m.BIN_pitch_response_candidate_177 | RATE.P | 0.435837 | 0.40476 | 0.802515 | -209.723 |
| VB-01.alt_50m.BIN_pitch_response_candidate_177 | RATE.Y | 169.795 | 95.2289 | 591.634 | -188064.850 |
| VB-01.alt_50m.BIN_pitch_response_candidate_179 | RATE.R | 6.43597 | 4.41771 | 17.0587 | -2083.424 |
| VB-01.alt_50m.BIN_pitch_response_candidate_179 | RATE.P | 0.433858 | 0.405102 | 0.801044 | -199.223 |
| VB-01.alt_50m.BIN_pitch_response_candidate_179 | RATE.Y | 136.687 | 76.3482 | 476.947 | -147197.057 |
| VB-01.alt_50m.BIN_pitch_response_candidate_180 | RATE.R | 11.9096 | 8.39936 | 31.1723 | -3668.321 |
| VB-01.alt_50m.BIN_pitch_response_candidate_180 | RATE.P | 0.408077 | 0.361374 | 1.10724 | -123.047 |
| VB-01.alt_50m.BIN_pitch_response_candidate_180 | RATE.Y | 181.687 | 101.5 | 633.478 | -153949.287 |
| VB-01.alt_50m.BIN_pitch_response_candidate_181 | RATE.R | 13.8755 | 9.72296 | 35.8599 | -4301.940 |
| VB-01.alt_50m.BIN_pitch_response_candidate_181 | RATE.P | 0.366444 | 0.314652 | 1.10593 | -84.459 |
| VB-01.alt_50m.BIN_pitch_response_candidate_181 | RATE.Y | 224.997 | 125.795 | 783.91 | -179490.265 |
| VB-01.alt_50m.BIN_pitch_response_candidate_184 | RATE.R | 20.5527 | 15.0779 | 50.6203 | -7210.609 |
| VB-01.alt_50m.BIN_pitch_response_candidate_184 | RATE.P | 0.47093 | 0.35822 | 1.27436 | 4.989 |
| VB-01.alt_50m.BIN_pitch_response_candidate_184 | RATE.Y | 309.891 | 173.887 | 1078.16 | -169238.700 |
| VB-01.alt_50m.BIN_pitch_response_candidate_187 | RATE.R | 12.4842 | 9.51651 | 29.5216 | -4055.023 |
| VB-01.alt_50m.BIN_pitch_response_candidate_187 | RATE.P | 0.56983 | 0.497731 | 1.28319 | -9.937 |
| VB-01.alt_50m.BIN_pitch_response_candidate_187 | RATE.Y | 308.023 | 172.973 | 1072.21 | -165535.011 |
| VB-01.alt_50m.BIN_pitch_response_candidate_188 | RATE.R | 10.1393 | 7.7952 | 23.6415 | -3288.309 |
| VB-01.alt_50m.BIN_pitch_response_candidate_188 | RATE.P | 0.583935 | 0.518322 | 1.28984 | -12.637 |
| VB-01.alt_50m.BIN_pitch_response_candidate_188 | RATE.Y | 282.431 | 158.489 | 983.451 | -151527.518 |
| VB-01.alt_50m.BIN_pitch_response_candidate_197 | RATE.R | 5.27292 | 3.67977 | 13.3455 | -3858.071 |
| VB-01.alt_50m.BIN_pitch_response_candidate_197 | RATE.P | 0.538204 | 0.484628 | 1.0708 | -201.806 |
| VB-01.alt_50m.BIN_pitch_response_candidate_197 | RATE.Y | 276.253 | 154.233 | 963.607 | -173407.927 |
| VB-01.alt_50m.BIN_pitch_response_candidate_198 | RATE.R | 7.49117 | 5.41067 | 19.0678 | -5369.532 |
| VB-01.alt_50m.BIN_pitch_response_candidate_198 | RATE.P | 0.635219 | 0.525254 | 1.75214 | -161.846 |
| VB-01.alt_50m.BIN_pitch_response_candidate_198 | RATE.Y | 322.686 | 180.103 | 1125.66 | -144069.651 |
| VB-01.alt_50m.BIN_pitch_response_candidate_203 | RATE.R | 7.06908 | 5.09036 | 18.411 | -4342.029 |
| VB-01.alt_50m.BIN_pitch_response_candidate_203 | RATE.P | 0.624952 | 0.514506 | 1.75112 | -152.285 |
| VB-01.alt_50m.BIN_pitch_response_candidate_203 | RATE.Y | 515.873 | 289.804 | 1790.74 | -181447.876 |
| VB-01.alt_50m.BIN_pitch_response_candidate_208 | RATE.R | 7.86011 | 5.65369 | 19.2441 | -4304.403 |
| VB-01.alt_50m.BIN_pitch_response_candidate_208 | RATE.P | 0.655012 | 0.51475 | 1.59122 | -105.258 |
| VB-01.alt_50m.BIN_pitch_response_candidate_208 | RATE.Y | 674.81 | 380.136 | 2346.26 | -151341.764 |
| VB-01.alt_50m.BIN_pitch_response_candidate_211 | RATE.R | 5.17687 | 3.8021 | 12.53 | -2870.803 |
| VB-01.alt_50m.BIN_pitch_response_candidate_211 | RATE.P | 0.609777 | 0.479443 | 1.59122 | -91.763 |
| VB-01.alt_50m.BIN_pitch_response_candidate_211 | RATE.Y | 382.892 | 215.455 | 1331.28 | -95049.663 |
| VB-01.alt_50m.BIN_pitch_response_candidate_212 | RATE.R | 6.79638 | 4.99272 | 16.4721 | -3814.704 |
| VB-01.alt_50m.BIN_pitch_response_candidate_212 | RATE.P | 0.605262 | 0.472514 | 1.59128 | -90.859 |
| VB-01.alt_50m.BIN_pitch_response_candidate_212 | RATE.Y | 356.342 | 200.451 | 1238.95 | -88549.910 |
| VB-01.alt_50m.BIN_pitch_response_candidate_213 | RATE.R | 9.68258 | 7.25069 | 23.2762 | -5427.415 |
| VB-01.alt_50m.BIN_pitch_response_candidate_213 | RATE.P | 0.598171 | 0.462248 | 1.59141 | -87.084 |
| VB-01.alt_50m.BIN_pitch_response_candidate_213 | RATE.Y | 354.729 | 199.58 | 1233.29 | -88785.738 |
| VB-01.alt_50m.BIN_pitch_response_candidate_216 | RATE.R | 9.93066 | 7.55612 | 23.9118 | -5580.830 |
| VB-01.alt_50m.BIN_pitch_response_candidate_216 | RATE.P | 0.572981 | 0.418898 | 1.59221 | -75.595 |
| VB-01.alt_50m.BIN_pitch_response_candidate_216 | RATE.Y | 303.82 | 171.345 | 1053.42 | -79118.023 |
| VB-01.alt_50m.BIN_pitch_response_candidate_218 | RATE.R | 12.1843 | 9.33522 | 29.4423 | -6965.298 |
| VB-01.alt_50m.BIN_pitch_response_candidate_218 | RATE.P | 0.565808 | 0.40533 | 1.59267 | -74.195 |
| VB-01.alt_50m.BIN_pitch_response_candidate_218 | RATE.Y | 304.344 | 171.269 | 1057.79 | -79614.872 |
| VB-01.alt_50m.BIN_pitch_response_candidate_219 | RATE.R | 10.5539 | 8.10178 | 25.1924 | -6021.925 |
| VB-01.alt_50m.BIN_pitch_response_candidate_219 | RATE.P | 0.565694 | 0.403341 | 1.59284 | -73.200 |
| VB-01.alt_50m.BIN_pitch_response_candidate_219 | RATE.Y | 297.655 | 167.927 | 1031.99 | -77687.036 |
| VB-01.alt_50m.BIN_pitch_response_candidate_223 | RATE.R | 8.00408 | 6.18208 | 19.0767 | -4612.019 |
| VB-01.alt_50m.BIN_pitch_response_candidate_223 | RATE.P | 0.561051 | 0.391546 | 1.59364 | -72.437 |
| VB-01.alt_50m.BIN_pitch_response_candidate_223 | RATE.Y | 248.223 | 139.681 | 862.524 | -65128.946 |
| VB-01.alt_50m.BIN_pitch_response_candidate_225 | RATE.R | 6.79016 | 5.2636 | 16.2044 | -3977.009 |
| VB-01.alt_50m.BIN_pitch_response_candidate_225 | RATE.P | 0.561173 | 0.392984 | 1.59388 | -72.631 |
| VB-01.alt_50m.BIN_pitch_response_candidate_225 | RATE.Y | 241.945 | 136.182 | 840.688 | -63552.817 |
| VB-01.alt_50m.BIN_pitch_response_candidate_229 | RATE.R | 5.63873 | 4.42861 | 13.5115 | -3504.899 |
| VB-01.alt_50m.BIN_pitch_response_candidate_229 | RATE.P | 0.563133 | 0.399107 | 1.59076 | -74.339 |
| VB-01.alt_50m.BIN_pitch_response_candidate_229 | RATE.Y | 187.449 | 105.504 | 651.087 | -49594.972 |
| VB-01.alt_50m.BIN_pitch_response_candidate_233 | RATE.R | 1.46257 | 1.1855 | 3.60581 | -845.321 |
| VB-01.alt_50m.BIN_pitch_response_candidate_233 | RATE.P | 0.570684 | 0.396917 | 1.61117 | -78.079 |
| VB-01.alt_50m.BIN_pitch_response_candidate_233 | RATE.Y | 129.479 | 72.8021 | 449.667 | -34524.233 |
| VB-01.alt_50m.BIN_pitch_response_candidate_235 | RATE.R | 0.77396 | 0.593231 | 1.89668 | -398.753 |
| VB-01.alt_50m.BIN_pitch_response_candidate_235 | RATE.P | 0.571958 | 0.398236 | 1.6127 | -77.974 |
| VB-01.alt_50m.BIN_pitch_response_candidate_235 | RATE.Y | 147.934 | 83.2755 | 513.626 | -39576.920 |
| VB-01.alt_50m.BIN_pitch_response_candidate_239 | RATE.R | 1.86302 | 1.42613 | 4.46482 | -1421.760 |
| VB-01.alt_50m.BIN_pitch_response_candidate_239 | RATE.P | 0.393691 | 0.280132 | 1.30206 | -32.887 |
| VB-01.alt_50m.BIN_pitch_response_candidate_239 | RATE.Y | 319.88 | 181.183 | 1108.27 | -104184.570 |
| VB-01.alt_50m.BIN_pitch_response_candidate_240 | RATE.R | 1.56844 | 1.23188 | 3.79778 | -1258.508 |
| VB-01.alt_50m.BIN_pitch_response_candidate_240 | RATE.P | 0.198353 | 0.155819 | 0.514531 | 3.903 |
| VB-01.alt_50m.BIN_pitch_response_candidate_240 | RATE.Y | 155.315 | 87.8789 | 539.434 | -158867.795 |
| VB-01.alt_50m.BIN_pitch_response_candidate_242 | RATE.R | 1.20324 | 0.948424 | 2.8998 | -948.979 |
| VB-01.alt_50m.BIN_pitch_response_candidate_242 | RATE.P | 0.191443 | 0.150097 | 0.514541 | 8.117 |
| VB-01.alt_50m.BIN_pitch_response_candidate_242 | RATE.Y | 104.662 | 59.2762 | 363.452 | -112508.611 |
| VB-01.alt_50m.BIN_pitch_response_candidate_250 | RATE.R | 1.07173 | 0.843265 | 2.61508 | -97.859 |
| VB-01.alt_50m.BIN_pitch_response_candidate_250 | RATE.P | 0.348688 | 0.263082 | 1.11121 | 6.416 |
| VB-01.alt_50m.BIN_pitch_response_candidate_250 | RATE.Y | 22.396 | 12.5541 | 77.9713 | -17682.000 |
| VB-01.alt_50m.BIN_pitch_response_candidate_251 | RATE.R | 1.65649 | 1.2428 | 3.96265 | -204.223 |
| VB-01.alt_50m.BIN_pitch_response_candidate_251 | RATE.P | 0.344731 | 0.258119 | 1.11199 | 8.085 |
| VB-01.alt_50m.BIN_pitch_response_candidate_251 | RATE.Y | 19.8774 | 11.13 | 69.1982 | -15627.359 |
| VB-01.alt_50m.BIN_pitch_response_candidate_254 | RATE.R | 0.73928 | 0.555013 | 1.97765 | -30.609 |
| VB-01.alt_50m.BIN_pitch_response_candidate_254 | RATE.P | 0.361971 | 0.280328 | 1.11289 | 5.431 |
| VB-01.alt_50m.BIN_pitch_response_candidate_254 | RATE.Y | 11.6464 | 6.46677 | 40.692 | -9150.282 |
| VB-01.alt_50m.BIN_pitch_response_candidate_255 | RATE.R | 0.747875 | 0.593117 | 1.50435 | -32.003 |
| VB-01.alt_50m.BIN_pitch_response_candidate_255 | RATE.P | 0.363726 | 0.283654 | 1.11466 | 5.123 |
| VB-01.alt_50m.BIN_pitch_response_candidate_255 | RATE.Y | 21.5031 | 12.0392 | 74.952 | -16999.329 |
| VB-01.alt_50m.BIN_pitch_response_candidate_256 | RATE.R | 0.83068 | 0.675916 | 1.64008 | -46.465 |
| VB-01.alt_50m.BIN_pitch_response_candidate_256 | RATE.P | 0.366569 | 0.287476 | 1.11657 | 4.032 |
| VB-01.alt_50m.BIN_pitch_response_candidate_256 | RATE.Y | 22.1666 | 12.4074 | 77.1789 | -17563.793 |
| VB-01.alt_50m.BIN_pitch_response_candidate_257 | RATE.R | 1.80284 | 1.43867 | 4.15422 | -217.940 |
| VB-01.alt_50m.BIN_pitch_response_candidate_257 | RATE.P | 0.378039 | 0.299105 | 1.13533 | 0.560 |
| VB-01.alt_50m.BIN_pitch_response_candidate_257 | RATE.Y | 20.1515 | 11.2583 | 70.203 | -16001.246 |
| VB-01.alt_50m.BIN_pitch_response_candidate_259 | RATE.R | 0.33634 | 0.250144 | 1.08363 | 40.639 |
| VB-01.alt_50m.BIN_pitch_response_candidate_259 | RATE.P | 0.368719 | 0.290774 | 1.12171 | 3.104 |
| VB-01.alt_50m.BIN_pitch_response_candidate_259 | RATE.Y | 20.8483 | 11.6482 | 72.6604 | -16581.399 |
| VB-01.alt_50m.BIN_pitch_response_candidate_263 | RATE.R | 0.496791 | 0.446119 | 1.03682 | 12.916 |
| VB-01.alt_50m.BIN_pitch_response_candidate_263 | RATE.P | 0.410254 | 0.329572 | 1.1552 | 6.022 |
| VB-01.alt_50m.BIN_pitch_response_candidate_263 | RATE.Y | 25.3536 | 14.1883 | 88.2615 | -20143.041 |
| VB-01.alt_50m.BIN_pitch_response_candidate_264 | RATE.R | 4.78583 | 3.67173 | 11.4541 | -1616.738 |
| VB-01.alt_50m.BIN_pitch_response_candidate_264 | RATE.P | 0.459055 | 0.376992 | 1.08714 | 5.255 |
| VB-01.alt_50m.BIN_pitch_response_candidate_264 | RATE.Y | 34.046 | 19.1459 | 118.31 | -40859.032 |
| VB-01.alt_50m.BIN_pitch_response_candidate_267 | RATE.R | 1.90662 | 1.50019 | 4.5147 | -717.935 |
| VB-01.alt_50m.BIN_pitch_response_candidate_267 | RATE.P | 0.460367 | 0.380434 | 1.08713 | 5.675 |
| VB-01.alt_50m.BIN_pitch_response_candidate_267 | RATE.Y | 26.3837 | 14.8402 | 91.7316 | -58458.788 |
| VB-01.alt_50m.BIN_pitch_response_candidate_269 | RATE.R | 1.40501 | 1.05758 | 3.49379 | -895.121 |
| VB-01.alt_50m.BIN_pitch_response_candidate_269 | RATE.P | 0.482112 | 0.40874 | 1.10581 | -1.028 |
| VB-01.alt_50m.BIN_pitch_response_candidate_269 | RATE.Y | 29.5059 | 16.6542 | 102.652 | -79248.887 |
| VB-01.alt_50m.BIN_pitch_response_candidate_273 | RATE.R | 0.496249 | 0.413468 | 1.1525 | -356.539 |
| VB-01.alt_50m.BIN_pitch_response_candidate_273 | RATE.P | 0.301969 | 0.26856 | 0.654341 | -80.469 |
| VB-01.alt_50m.BIN_pitch_response_candidate_273 | RATE.Y | 11.9056 | 6.62174 | 41.5515 | -43862.761 |
| VB-01.alt_50m.BIN_pitch_response_candidate_281 | RATE.R | 3.12785 | 2.35871 | 7.4966 | -1444.062 |
| VB-01.alt_50m.BIN_pitch_response_candidate_281 | RATE.P | 0.309621 | 0.253048 | 0.730349 | -43.230 |
| VB-01.alt_50m.BIN_pitch_response_candidate_281 | RATE.Y | 10.7567 | 5.96457 | 38.6592 | -3867.242 |
| VB-01.alt_50m.BIN_pitch_response_candidate_286 | RATE.R | 3.44599 | 2.78564 | 7.77804 | -1787.716 |
| VB-01.alt_50m.BIN_pitch_response_candidate_286 | RATE.P | 0.327909 | 0.278351 | 0.724185 | -54.486 |
| VB-01.alt_50m.BIN_pitch_response_candidate_286 | RATE.Y | 4.93731 | 2.69465 | 17.6938 | -1777.550 |
| VB-01.alt_50m.BIN_pitch_response_candidate_288 | RATE.R | 6.86409 | 5.08676 | 17.4354 | -3406.285 |
| VB-01.alt_50m.BIN_pitch_response_candidate_288 | RATE.P | 0.294149 | 0.258997 | 0.604279 | -87.344 |
| VB-01.alt_50m.BIN_pitch_response_candidate_288 | RATE.Y | 146.6 | 82.3354 | 509.71 | -64913.348 |
| VB-01.alt_50m.BIN_pitch_response_candidate_291 | RATE.R | 2.02954 | 1.55369 | 4.91454 | -1198.535 |
| VB-01.alt_50m.BIN_pitch_response_candidate_291 | RATE.P | 0.388315 | 0.349828 | 0.741343 | -169.423 |
| VB-01.alt_50m.BIN_pitch_response_candidate_291 | RATE.Y | 137.713 | 77.0972 | 479.719 | -112703.502 |
| VB-01.alt_50m.BIN_pitch_response_candidate_293 | RATE.R | 3.5582 | 2.72609 | 8.41344 | -2150.786 |
| VB-01.alt_50m.BIN_pitch_response_candidate_293 | RATE.P | 0.372468 | 0.338652 | 0.738725 | -161.720 |
| VB-01.alt_50m.BIN_pitch_response_candidate_293 | RATE.Y | 132.514 | 74.0784 | 461.391 | -100961.659 |
| VB-01.alt_50m.BIN_pitch_response_candidate_294 | RATE.R | 0.57878 | 0.403351 | 1.63904 | -271.710 |
| VB-01.alt_50m.BIN_pitch_response_candidate_294 | RATE.P | 0.377177 | 0.342923 | 0.736425 | -184.142 |
| VB-01.alt_50m.BIN_pitch_response_candidate_294 | RATE.Y | 162.615 | 91.0924 | 566.103 | -131785.376 |
| VB-01.alt_50m.BIN_pitch_response_candidate_295 | RATE.R | 1.02982 | 0.791025 | 2.10359 | -58.951 |
| VB-01.alt_50m.BIN_pitch_response_candidate_295 | RATE.P | 0.370187 | 0.315153 | 0.768299 | -94.054 |
| VB-01.alt_50m.BIN_pitch_response_candidate_295 | RATE.Y | 143.829 | 80.5746 | 501.656 | -93356.509 |
| VB-01.alt_50m.BIN_pitch_response_candidate_298 | RATE.R | 3.75426 | 3.04927 | 7.47774 | -406.212 |
| VB-01.alt_50m.BIN_pitch_response_candidate_298 | RATE.P | 0.406456 | 0.362563 | 0.741579 | -223.732 |
| VB-01.alt_50m.BIN_pitch_response_candidate_298 | RATE.Y | 255.646 | 142.471 | 892.778 | -137601.514 |
| VB-01.alt_50m.BIN_pitch_response_candidate_299 | RATE.R | 15.0347 | 11.03 | 36.6461 | -2642.000 |
| VB-01.alt_50m.BIN_pitch_response_candidate_299 | RATE.P | 0.463849 | 0.411921 | 0.880996 | -52.027 |
| VB-01.alt_50m.BIN_pitch_response_candidate_299 | RATE.Y | 919.504 | 516.072 | 3196.73 | -151015.031 |
| VB-01.alt_50m.BIN_pitch_response_candidate_300 | RATE.R | 15.1673 | 11.5198 | 37.0741 | -3697.341 |
| VB-01.alt_50m.BIN_pitch_response_candidate_300 | RATE.P | 0.33714 | 0.297821 | 0.663763 | -18.805 |
| VB-01.alt_50m.BIN_pitch_response_candidate_300 | RATE.Y | 1143.78 | 644.894 | 3975.67 | -243672.076 |
| VB-01.alt_50m.BIN_pitch_response_candidate_301 | RATE.R | 15.3921 | 11.5018 | 37.4194 | -11279.226 |
| VB-01.alt_50m.BIN_pitch_response_candidate_301 | RATE.P | 0.297951 | 0.21937 | 0.907722 | -51.054 |
| VB-01.alt_50m.BIN_pitch_response_candidate_301 | RATE.Y | 46.7162 | 26.1314 | 162.54 | -21798.771 |
| VB-01.alt_50m.BIN_pitch_response_candidate_302 | RATE.R | 15.5299 | 11.6911 | 37.8583 | -11562.393 |
| VB-01.alt_50m.BIN_pitch_response_candidate_302 | RATE.P | 0.296082 | 0.216333 | 0.907698 | -55.223 |
| VB-01.alt_50m.BIN_pitch_response_candidate_302 | RATE.Y | 7.93264 | 4.43437 | 27.6546 | -3642.342 |
| VB-01.alt_50m.BIN_pitch_response_candidate_303 | RATE.R | 14.465 | 10.8788 | 35.2418 | -10739.644 |
| VB-01.alt_50m.BIN_pitch_response_candidate_303 | RATE.P | 0.294984 | 0.214309 | 0.908938 | -55.260 |
| VB-01.alt_50m.BIN_pitch_response_candidate_303 | RATE.Y | 5.81485 | 3.31863 | 20.2653 | -2649.942 |
| VB-01.alt_50m.BIN_pitch_response_candidate_305 | RATE.R | 1.48942 | 1.08742 | 4.04298 | -526.232 |
| VB-01.alt_50m.BIN_pitch_response_candidate_305 | RATE.P | 2.74198 | 2.07097 | 5.03734 | -9.556 |
| VB-01.alt_50m.BIN_pitch_response_candidate_305 | RATE.Y | 5.58713 | 3.24565 | 19.4965 | -4847.492 |
| VB-01.alt_50m.BIN_pitch_response_candidate_308 | RATE.R | 0.59313 | 0.447307 | 1.4358 | -501.465 |
| VB-01.alt_50m.BIN_pitch_response_candidate_308 | RATE.P | 2.96168 | 2.46951 | 5.08297 | -15.149 |
| VB-01.alt_50m.BIN_pitch_response_candidate_308 | RATE.Y | 16.2971 | 9.2292 | 56.3524 | -14515.643 |
| VB-01.alt_50m.BIN_pitch_response_candidate_309 | RATE.R | 2.26305 | 1.6231 | 5.62824 | -2375.374 |
| VB-01.alt_50m.BIN_pitch_response_candidate_309 | RATE.P | 3.0007 | 2.55158 | 5.02768 | -8.757 |
| VB-01.alt_50m.BIN_pitch_response_candidate_309 | RATE.Y | 23.4342 | 13.2609 | 81.3164 | -21207.689 |
| VB-01.alt_50m.BIN_pitch_response_candidate_311 | RATE.R | 2.51599 | 1.9026 | 6.18236 | -2624.190 |
| VB-01.alt_50m.BIN_pitch_response_candidate_311 | RATE.P | 1.78405 | 1.60303 | 3.24321 | 24.030 |
| VB-01.alt_50m.BIN_pitch_response_candidate_311 | RATE.Y | 5.35692 | 3.15687 | 18.4491 | -2629.600 |
| VB-01.alt_50m.BIN_pitch_response_candidate_314 | RATE.R | 1.83696 | 1.37906 | 4.52852 | -2562.824 |
| VB-01.alt_50m.BIN_pitch_response_candidate_314 | RATE.P | 1.18998 | 0.879901 | 2.59978 | -4.951 |
| VB-01.alt_50m.BIN_pitch_response_candidate_314 | RATE.Y | 19.2395 | 10.8595 | 66.7531 | -8496.130 |
| VB-01.alt_50m.BIN_pitch_response_candidate_318 | RATE.R | 12.7812 | 9.88945 | 30.6184 | -3322.091 |
| VB-01.alt_50m.BIN_pitch_response_candidate_318 | RATE.P | 1.86753 | 1.43265 | 4.12383 | 3.042 |
| VB-01.alt_50m.BIN_pitch_response_candidate_318 | RATE.Y | 81.5372 | 47.2584 | 281.545 | -36434.472 |
| VB-01.alt_50m.BIN_pitch_response_candidate_319 | RATE.R | 1.62816 | 1.02697 | 4.2295 | -594.372 |
| VB-01.alt_50m.BIN_pitch_response_candidate_319 | RATE.P | 1.74265 | 1.3821 | 4.13377 | 13.943 |
| VB-01.alt_50m.BIN_pitch_response_candidate_319 | RATE.Y | 192.211 | 107.349 | 668.91 | -81416.633 |
| VB-01.alt_50m.BIN_pitch_response_candidate_322 | RATE.R | 3.09076 | 2.18154 | 7.5041 | -1216.207 |
| VB-01.alt_50m.BIN_pitch_response_candidate_322 | RATE.P | 1.64126 | 1.17074 | 4.14976 | -4.319 |
| VB-01.alt_50m.BIN_pitch_response_candidate_322 | RATE.Y | 459.933 | 259.208 | 1595.72 | -192795.744 |
| VB-01.alt_50m.BIN_pitch_response_candidate_325 | RATE.R | 3.56163 | 2.72847 | 8.8165 | -6220.250 |
| VB-01.alt_50m.BIN_pitch_response_candidate_325 | RATE.P | 0.450491 | 0.362862 | 1.22683 | 18.744 |
| VB-01.alt_50m.BIN_pitch_response_candidate_325 | RATE.Y | 177.935 | 99.7246 | 618.106 | -267072.282 |
| VB-01.alt_50m.BIN_pitch_response_candidate_330 | RATE.R | 6.44655 | 4.76409 | 15.7754 | -3552.460 |
| VB-01.alt_50m.BIN_pitch_response_candidate_330 | RATE.P | 0.646109 | 0.560057 | 1.28052 | -16.841 |
| VB-01.alt_50m.BIN_pitch_response_candidate_330 | RATE.Y | 402.802 | 226.275 | 1398.76 | -338262.950 |
| VB-01.alt_50m.BIN_pitch_response_candidate_334 | RATE.R | 4.57382 | 2.25462 | 18.1451 | -1010.205 |
| VB-01.alt_50m.BIN_pitch_response_candidate_334 | RATE.P | 0.942028 | 0.6347 | 2.99357 | -140.321 |
| VB-01.alt_50m.BIN_pitch_response_candidate_334 | RATE.Y | 95.9756 | 53.8887 | 333.062 | -102324.686 |
| VB-01.alt_50m.BIN_pitch_response_candidate_335 | RATE.R | 40.7016 | 26.8385 | 101.481 | -6032.348 |
| VB-01.alt_50m.BIN_pitch_response_candidate_335 | RATE.P | 3.31681 | 2.43449 | 8.06951 | -281.995 |
| VB-01.alt_50m.BIN_pitch_response_candidate_335 | RATE.Y | 114.665 | 65.0671 | 398.52 | -9823.352 |
| VB-01.alt_50m.BIN_pitch_response_candidate_336 | RATE.R | 60.2441 | 42.7377 | 146.196 | -8831.158 |
| VB-01.alt_50m.BIN_pitch_response_candidate_336 | RATE.P | 3.925 | 3.16158 | 8.06932 | -359.355 |
| VB-01.alt_50m.BIN_pitch_response_candidate_336 | RATE.Y | 71.8088 | 41.0219 | 248.801 | -6097.703 |
| VB-01.alt_50m.BIN_pitch_response_candidate_337 | RATE.R | 8.30181e+07 | 2.58463e+07 | 5.29431e+08 | -61915227582.823 |
| VB-01.alt_50m.BIN_pitch_response_candidate_337 | RATE.P | 5.64472 | 5.6211 | 7.56236 | -2090.460 |
| VB-01.alt_50m.BIN_pitch_response_candidate_337 | RATE.Y | 7.11927e+17 | 1.5243e+17 | 6.54875e+18 | -159428976276499955712.000 |
| VB-01.alt_50m.BIN_yaw_response_candidate_2 | RATE.R | 4.11021 | 2.58351 | 11.2012 | -1066.850 |
| VB-01.alt_50m.BIN_yaw_response_candidate_2 | RATE.P | 0.25804 | 0.219549 | 0.671304 | -101.587 |
| VB-01.alt_50m.BIN_yaw_response_candidate_2 | RATE.Y | 104.376 | 58.0164 | 364.539 | -108860.544 |
| VB-01.alt_50m.BIN_yaw_response_candidate_7 | RATE.R | 3.50788 | 2.95819 | 7.81442 | -1107.071 |
| VB-01.alt_50m.BIN_yaw_response_candidate_7 | RATE.P | 0.36761 | 0.308244 | 0.894774 | -218.624 |
| VB-01.alt_50m.BIN_yaw_response_candidate_7 | RATE.Y | 70.0425 | 38.9883 | 243.289 | -61756.481 |
| VB-01.alt_50m.BIN_yaw_response_candidate_10 | RATE.R | 8.81124 | 6.53064 | 21.1913 | -3542.950 |
| VB-01.alt_50m.BIN_yaw_response_candidate_10 | RATE.P | 0.382891 | 0.320702 | 0.944697 | -37.915 |
| VB-01.alt_50m.BIN_yaw_response_candidate_10 | RATE.Y | 45.8163 | 25.3052 | 159.846 | -38532.387 |
| VB-01.alt_50m.BIN_yaw_response_candidate_13 | RATE.R | 17.8733 | 13.02 | 44.0285 | -6244.599 |
| VB-01.alt_50m.BIN_yaw_response_candidate_13 | RATE.P | 0.482162 | 0.375098 | 1.27461 | 2.394 |
| VB-01.alt_50m.BIN_yaw_response_candidate_13 | RATE.Y | 298.319 | 167.755 | 1035.38 | -164196.798 |
| VB-01.alt_50m.BIN_yaw_response_candidate_16 | RATE.R | 7.52957 | 5.43569 | 18.8645 | -5397.780 |
| VB-01.alt_50m.BIN_yaw_response_candidate_16 | RATE.P | 0.632279 | 0.525814 | 1.75211 | -159.015 |
| VB-01.alt_50m.BIN_yaw_response_candidate_16 | RATE.Y | 373.846 | 208.773 | 1302.53 | -133059.039 |
| VB-01.alt_50m.BIN_yaw_response_candidate_17 | RATE.R | 6.34235 | 4.46926 | 15.6008 | -3436.843 |
| VB-01.alt_50m.BIN_yaw_response_candidate_17 | RATE.P | 0.675404 | 0.531795 | 1.59121 | -111.705 |
| VB-01.alt_50m.BIN_yaw_response_candidate_17 | RATE.Y | 632.218 | 356.813 | 2192.78 | -142112.129 |
| VB-01.alt_50m.BIN_yaw_response_candidate_18 | RATE.R | 8.05359 | 6.07021 | 19.1488 | -4516.417 |
| VB-01.alt_50m.BIN_yaw_response_candidate_18 | RATE.P | 0.591473 | 0.453076 | 1.59158 | -82.259 |
| VB-01.alt_50m.BIN_yaw_response_candidate_18 | RATE.Y | 330.805 | 186.597 | 1147.07 | -85062.064 |
| VB-01.alt_50m.BIN_yaw_response_candidate_19 | RATE.R | 10.2948 | 7.95002 | 24.6746 | -5900.711 |
| VB-01.alt_50m.BIN_yaw_response_candidate_19 | RATE.P | 0.561632 | 0.389579 | 1.59365 | -72.780 |
| VB-01.alt_50m.BIN_yaw_response_candidate_19 | RATE.Y | 278.82 | 157.318 | 966.5 | -72803.530 |
| VB-01.alt_50m.BIN_yaw_response_candidate_20 | RATE.R | 4.04039 | 3.11463 | 9.44177 | -1957.630 |
| VB-01.alt_50m.BIN_yaw_response_candidate_20 | RATE.P | 0.306067 | 0.248487 | 0.729979 | -42.988 |
| VB-01.alt_50m.BIN_yaw_response_candidate_20 | RATE.Y | 31.6867 | 18.1833 | 109.05 | -11133.811 |
| VB-01.alt_50m.BIN_yaw_response_candidate_21 | RATE.R | 0.320111 | 0.238081 | 1.03744 | -76.155 |
| VB-01.alt_50m.BIN_yaw_response_candidate_21 | RATE.P | 0.331273 | 0.281076 | 0.735802 | -55.705 |
| VB-01.alt_50m.BIN_yaw_response_candidate_21 | RATE.Y | 39.5457 | 22.9715 | 136.243 | -14882.401 |
| VB-01.alt_50m.BIN_yaw_response_candidate_23 | RATE.R | 7.07359 | 5.34748 | 17.3679 | -3910.056 |
| VB-01.alt_50m.BIN_yaw_response_candidate_23 | RATE.P | 0.369542 | 0.322079 | 0.718409 | -159.535 |
| VB-01.alt_50m.BIN_yaw_response_candidate_23 | RATE.Y | 70.2551 | 39.1926 | 245.334 | -49535.753 |
| VB-01.alt_50m.BIN_yaw_response_candidate_25 | RATE.R | 2.32105 | 1.7533 | 5.82052 | -1391.632 |
| VB-01.alt_50m.BIN_yaw_response_candidate_25 | RATE.P | 0.384127 | 0.353579 | 0.739144 | -188.013 |
| VB-01.alt_50m.BIN_yaw_response_candidate_25 | RATE.Y | 161.115 | 90.2435 | 560.804 | -125064.910 |
| VB-01.alt_50m.BIN_yaw_response_candidate_27 | RATE.R | 1.71327 | 1.18355 | 4.31887 | -454.129 |
| VB-01.alt_50m.BIN_yaw_response_candidate_27 | RATE.P | 0.34228 | 0.30958 | 0.61809 | -111.099 |
| VB-01.alt_50m.BIN_yaw_response_candidate_27 | RATE.Y | 184.429 | 103.528 | 641.598 | -165756.779 |
| VB-01.alt_50m.BIN_yaw_response_candidate_31 | RATE.R | 17.9865 | 11.3795 | 52.4811 | -3202.406 |
| VB-01.alt_50m.BIN_yaw_response_candidate_31 | RATE.P | 0.476407 | 0.442591 | 0.887099 | -153.034 |
| VB-01.alt_50m.BIN_yaw_response_candidate_31 | RATE.Y | 4560.77 | 2181.96 | 18739.2 | -873321.541 |
| VB-01.alt_50m.BIN_yaw_response_candidate_32 | RATE.R | 12.0506 | 9.12806 | 29.7481 | -2991.843 |
| VB-01.alt_50m.BIN_yaw_response_candidate_32 | RATE.P | 0.325518 | 0.286012 | 0.622035 | -14.784 |
| VB-01.alt_50m.BIN_yaw_response_candidate_32 | RATE.Y | 981.794 | 553.496 | 3413 | -246578.839 |
| VB-01.alt_50m.BIN_yaw_response_candidate_35 | RATE.R | 18.7303 | 13.7556 | 46.2672 | -12438.241 |
| VB-01.alt_50m.BIN_yaw_response_candidate_35 | RATE.P | 0.325513 | 0.254458 | 0.908356 | -52.287 |
| VB-01.alt_50m.BIN_yaw_response_candidate_35 | RATE.Y | 51.6244 | 28.8694 | 179.791 | -25482.832 |
| VB-01.alt_50m.BIN_yaw_response_candidate_37 | RATE.R | 16.053 | 12.0931 | 39.0226 | -11974.605 |
| VB-01.alt_50m.BIN_yaw_response_candidate_37 | RATE.P | 0.30386 | 0.22395 | 0.907089 | -58.961 |
| VB-01.alt_50m.BIN_yaw_response_candidate_37 | RATE.Y | 10.9456 | 6.05693 | 38.1387 | -5060.801 |
| VB-01.alt_50m.BIN_yaw_response_candidate_39 | RATE.R | 2.90358 | 2.10984 | 7.35982 | -1442.571 |
| VB-01.alt_50m.BIN_yaw_response_candidate_39 | RATE.P | 0.116127 | 0.0949314 | 0.270439 | -103.197 |
| VB-01.alt_50m.BIN_yaw_response_candidate_39 | RATE.Y | 70.5828 | 39.4232 | 244.63 | -50420.052 |
| VB-01.alt_50m.BIN_yaw_response_candidate_41 | RATE.R | 9.26193 | 6.96342 | 22.0905 | -15679.896 |
| VB-01.alt_50m.BIN_yaw_response_candidate_41 | RATE.P | 0.232396 | 0.205179 | 0.421872 | -212.217 |
| VB-01.alt_50m.BIN_yaw_response_candidate_41 | RATE.Y | 325.925 | 183.79 | 1129.86 | -566449.436 |
| VB-01.alt_50m.BIN_yaw_response_candidate_47 | RATE.R | 0.725653 | 0.457054 | 2.31235 | -45.345 |
| VB-01.alt_50m.BIN_yaw_response_candidate_47 | RATE.P | 0.050996 | 0.0430741 | 0.116511 | -4.609 |
| VB-01.alt_50m.BIN_yaw_response_candidate_47 | RATE.Y | 126.204 | 72.3121 | 434.78 | -15872.598 |
| VB-01.alt_50m.BIN_yaw_response_candidate_48 | RATE.R | 0.898243 | 0.657493 | 2.74585 | 32.942 |
| VB-01.alt_50m.BIN_yaw_response_candidate_48 | RATE.P | 0.0746598 | 0.0589647 | 0.211938 | -16.843 |
| VB-01.alt_50m.BIN_yaw_response_candidate_48 | RATE.Y | 310.112 | 174.924 | 1074.72 | -43432.196 |
| VB-01.alt_50m.BIN_yaw_response_candidate_51 | RATE.R | 4.19279 | 2.90692 | 11.7876 | -1387.660 |
| VB-01.alt_50m.BIN_yaw_response_candidate_51 | RATE.P | 0.0815574 | 0.0626949 | 0.300671 | -105.887 |
| VB-01.alt_50m.BIN_yaw_response_candidate_51 | RATE.Y | 96.928 | 54.1623 | 336.307 | -104818.121 |
| VB-01.alt_50m.BIN_yaw_response_candidate_53 | RATE.R | 20.0507 | 14.8905 | 49.3028 | -1557.247 |
| VB-01.alt_50m.BIN_yaw_response_candidate_53 | RATE.P | 0.326587 | 0.274939 | 0.592195 | -55.487 |
| VB-01.alt_50m.BIN_yaw_response_candidate_53 | RATE.Y | 282.18 | 157.356 | 982.082 | -108688.170 |
| VB-01.alt_50m.BIN_yaw_response_candidate_55 | RATE.R | 4.55219 | 3.37044 | 10.9872 | -1976.374 |
| VB-01.alt_50m.BIN_yaw_response_candidate_55 | RATE.P | 1.245 | 0.843689 | 3.17926 | 19.412 |
| VB-01.alt_50m.BIN_yaw_response_candidate_55 | RATE.Y | 298.117 | 167.315 | 1036.75 | -160967.042 |
| VB-01.alt_50m.BIN_yaw_response_candidate_56 | RATE.R | 5.69099 | 4.35885 | 13.848 | -10423.019 |
| VB-01.alt_50m.BIN_yaw_response_candidate_56 | RATE.P | 0.492151 | 0.394728 | 1.22802 | 10.558 |
| VB-01.alt_50m.BIN_yaw_response_candidate_56 | RATE.Y | 150.95 | 84.2477 | 526.035 | -233143.292 |
| VB-01.alt_50m.BIN_yaw_response_candidate_62 | RATE.R | 1.79278 | 1.39545 | 4.29298 | -707.781 |
| VB-01.alt_50m.BIN_yaw_response_candidate_62 | RATE.P | 0.377203 | 0.292019 | 0.962961 | -33.289 |
| VB-01.alt_50m.BIN_yaw_response_candidate_62 | RATE.Y | 300.086 | 168.67 | 1044.01 | -460920.688 |
| VB-01.alt_50m.BIN_yaw_response_candidate_64 | RATE.R | 4.88762 | 2.43484 | 19.0024 | -1084.619 |
| VB-01.alt_50m.BIN_yaw_response_candidate_64 | RATE.P | 0.940526 | 0.625483 | 2.99358 | -139.619 |
| VB-01.alt_50m.BIN_yaw_response_candidate_64 | RATE.Y | 93.3157 | 52.5137 | 323.013 | -99243.324 |
| VB-01.alt_50m.BIN_thrust_response_candidate_2 | RATE.R | 2.28796 | 1.82249 | 5.06527 | -55.421 |
| VB-01.alt_50m.BIN_thrust_response_candidate_2 | RATE.P | 0.170447 | 0.128837 | 0.403646 | -20.621 |
| VB-01.alt_50m.BIN_thrust_response_candidate_2 | RATE.Y | 121.914 | 68.2807 | 426.228 | -35438.450 |
| full_fly_1.BIN_hover_candidate_1 | RATE.R | 27.5466 | 17.0115 | 86.1174 | -17541.458 |
| full_fly_1.BIN_hover_candidate_1 | RATE.P | 0.345108 | 0.233643 | 1.06545 | -161.948 |
| full_fly_1.BIN_hover_candidate_1 | RATE.Y | 472.551 | 210.03 | 2093.7 | -907146.701 |
| full_fly_1.BIN_hover_candidate_2 | RATE.R | 13.8848 | 10.1262 | 34.775 | -10245.424 |
| full_fly_1.BIN_hover_candidate_2 | RATE.P | 1.14479 | 0.67003 | 3.03355 | -1.721 |
| full_fly_1.BIN_hover_candidate_2 | RATE.Y | 123.616 | 69.6211 | 429.679 | -95434.659 |
| full_fly_1.BIN_climb_candidate_2 | RATE.R | 4.23469e+07 | 1.33266e+07 | 2.67168e+08 | -18059470132.682 |
| full_fly_1.BIN_climb_candidate_2 | RATE.P | 0.575457 | 0.381208 | 3.32069 | -269.141 |
| full_fly_1.BIN_climb_candidate_2 | RATE.Y | 2.63093e+17 | 5.69401e+16 | 2.3942e+18 | -34208100261127270400.000 |
| full_fly_1.BIN_climb_candidate_3 | RATE.R | 16702.2 | 7208.52 | 76865.2 | -7513615.685 |
| full_fly_1.BIN_climb_candidate_3 | RATE.P | 0.267077 | 0.243396 | 0.638051 | -582.858 |
| full_fly_1.BIN_climb_candidate_3 | RATE.Y | 1.38815e+08 | 4.11792e+07 | 9.21619e+08 | -234467817585.986 |
| full_fly_1.BIN_climb_candidate_4 | RATE.R | 16.6042 | 11.9759 | 42.0514 | -59471.482 |
| full_fly_1.BIN_climb_candidate_4 | RATE.P | 0.405019 | 0.386935 | 0.628757 | -479.259 |
| full_fly_1.BIN_climb_candidate_4 | RATE.Y | 39.7476 | 22.3545 | 138.035 | -50113.086 |
| full_fly_1.BIN_climb_candidate_5 | RATE.R | 17.8861 | 12.9294 | 45.1803 | -139955.615 |
| full_fly_1.BIN_climb_candidate_5 | RATE.P | 0.370974 | 0.355562 | 0.534253 | -538.135 |
| full_fly_1.BIN_climb_candidate_5 | RATE.Y | 38.3682 | 21.5493 | 133.326 | -107097.647 |
| full_fly_1.BIN_climb_candidate_6 | RATE.R | 48537.3 | 20468.2 | 228517 | -16773157.000 |
| full_fly_1.BIN_climb_candidate_6 | RATE.P | 0.697818 | 0.517689 | 2.43844 | -444.578 |
| full_fly_1.BIN_climb_candidate_6 | RATE.Y | 1.02813e+09 | 2.98167e+08 | 6.98229e+09 | -118046600611.488 |
| full_fly_1.BIN_climb_candidate_8 | RATE.R | 1162.24 | 497.062 | 5389.92 | -305986.505 |
| full_fly_1.BIN_climb_candidate_8 | RATE.P | 1.69422 | 1.37021 | 4.51125 | -91.141 |
| full_fly_1.BIN_climb_candidate_8 | RATE.Y | 1.0145e+10 | 2.98721e+09 | 6.78577e+10 | -1071412650633.010 |
| full_fly_1.BIN_climb_candidate_10 | RATE.R | 0.782887 | 0.667048 | 1.72713 | -312.573 |
| full_fly_1.BIN_climb_candidate_10 | RATE.P | 2.98401 | 2.37191 | 5.25349 | -247.216 |
| full_fly_1.BIN_climb_candidate_10 | RATE.Y | 530.058 | 273.997 | 2016.62 | -82225.093 |
| full_fly_1.BIN_descent_candidate_1 | RATE.R | 9.62171 | 7.51593 | 21.8893 | -3759.976 |
| full_fly_1.BIN_descent_candidate_1 | RATE.P | 0.578724 | 0.502806 | 1.04812 | -6.092 |
| full_fly_1.BIN_descent_candidate_1 | RATE.Y | 40.5587 | 22.4902 | 141.561 | -47601.190 |
| full_fly_1.BIN_descent_candidate_2 | RATE.R | 18.8725 | 12.8455 | 51.9844 | -15965.306 |
| full_fly_1.BIN_descent_candidate_2 | RATE.P | 1.69744 | 1.66036 | 2.1446 | -969.316 |
| full_fly_1.BIN_descent_candidate_2 | RATE.Y | 331.611 | 172.248 | 1249.01 | -102519.996 |
| full_fly_1.BIN_descent_candidate_8 | RATE.R | 20.0871 | 14.6012 | 50.5949 | -192794.409 |
| full_fly_1.BIN_descent_candidate_8 | RATE.P | 0.352424 | 0.334946 | 0.525292 | -519.507 |
| full_fly_1.BIN_descent_candidate_8 | RATE.Y | 38.9008 | 21.8159 | 135.408 | -206198.035 |
| full_fly_1.BIN_descent_candidate_10 | RATE.R | 34.2048 | 25.6791 | 81.7564 | -5352.603 |
| full_fly_1.BIN_descent_candidate_10 | RATE.P | 1.88255 | 1.71073 | 4.44257 | -410.820 |
| full_fly_1.BIN_descent_candidate_10 | RATE.Y | 811.853 | 453.602 | 2826.87 | -50999.083 |
| full_fly_1.BIN_descent_candidate_13 | RATE.R | 1.21432e+09 | 3.45917e+08 | 8.46362e+09 | -279194960843.754 |
| full_fly_1.BIN_descent_candidate_13 | RATE.P | 4.82756 | 1.2396 | 35.7893 | -110.215 |
| full_fly_1.BIN_descent_candidate_13 | RATE.Y | 1.35881e+21 | 2.66199e+20 | 1.36605e+22 | -230866444193308822470656.000 |
| full_fly_1.BIN_roll_response_candidate_4 | RATE.R | 564.608 | 347.237 | 1780.91 | -866550.378 |
| full_fly_1.BIN_roll_response_candidate_4 | RATE.P | 0.287644 | 0.253035 | 0.805279 | -541.739 |
| full_fly_1.BIN_roll_response_candidate_4 | RATE.Y | 18634.1 | 8119.62 | 84203.1 | -17563830.857 |
| full_fly_1.BIN_roll_response_candidate_10 | RATE.R | 45.9518 | 32.8587 | 117.363 | -89277.847 |
| full_fly_1.BIN_roll_response_candidate_10 | RATE.P | 0.266906 | 0.253042 | 0.398669 | -643.137 |
| full_fly_1.BIN_roll_response_candidate_10 | RATE.Y | 5.05581 | 3.19249 | 16.6375 | -8628.350 |
| full_fly_1.BIN_roll_response_candidate_11 | RATE.R | 48.491 | 34.6961 | 123.593 | -101997.066 |
| full_fly_1.BIN_roll_response_candidate_11 | RATE.P | 0.281453 | 0.267828 | 0.398649 | -700.439 |
| full_fly_1.BIN_roll_response_candidate_11 | RATE.Y | 28.1151 | 15.517 | 98.3482 | -47646.765 |
| full_fly_1.BIN_roll_response_candidate_13 | RATE.R | 55.9766 | 40.27 | 142.025 | -91290.660 |
| full_fly_1.BIN_roll_response_candidate_13 | RATE.P | 0.295838 | 0.284563 | 0.398199 | -738.267 |
| full_fly_1.BIN_roll_response_candidate_13 | RATE.Y | 90.8422 | 50.8208 | 316.482 | -138648.780 |
| full_fly_1.BIN_roll_response_candidate_14 | RATE.R | 57.0349 | 41.156 | 144.311 | -46086.824 |
| full_fly_1.BIN_roll_response_candidate_14 | RATE.P | 0.290165 | 0.277427 | 0.397374 | -700.408 |
| full_fly_1.BIN_roll_response_candidate_14 | RATE.Y | 99.1655 | 55.6415 | 344.706 | -146174.154 |
| full_fly_1.BIN_roll_response_candidate_19 | RATE.R | 61.1676 | 44.1472 | 153.971 | -16218.071 |
| full_fly_1.BIN_roll_response_candidate_19 | RATE.P | 0.245567 | 0.233669 | 0.374287 | -477.791 |
| full_fly_1.BIN_roll_response_candidate_19 | RATE.Y | 141.54 | 79.6074 | 490.932 | -110250.026 |
| full_fly_1.BIN_roll_response_candidate_20 | RATE.R | 61.8542 | 44.6107 | 155.688 | -16388.579 |
| full_fly_1.BIN_roll_response_candidate_20 | RATE.P | 0.238162 | 0.226067 | 0.369982 | -438.706 |
| full_fly_1.BIN_roll_response_candidate_20 | RATE.Y | 151.072 | 84.835 | 525.158 | -92886.985 |
| full_fly_1.BIN_roll_response_candidate_22 | RATE.R | 31.8839 | 22.917 | 79.1573 | -6105.441 |
| full_fly_1.BIN_roll_response_candidate_22 | RATE.P | 1.25757 | 1.14415 | 2.01347 | -278.604 |
| full_fly_1.BIN_roll_response_candidate_22 | RATE.Y | 213.139 | 117.806 | 743.589 | -30170.356 |
| full_fly_1.BIN_roll_response_candidate_23 | RATE.R | 2.49356 | 1.78646 | 6.9283 | -170.894 |
| full_fly_1.BIN_roll_response_candidate_23 | RATE.P | 14.2865 | 9.57537 | 35.7879 | -159.682 |
| full_fly_1.BIN_roll_response_candidate_23 | RATE.Y | 240.984 | 135.453 | 834.796 | -17212.015 |
| full_fly_1.BIN_roll_response_candidate_24 | RATE.R | 2.35351 | 1.67526 | 6.66301 | -155.565 |
| full_fly_1.BIN_roll_response_candidate_24 | RATE.P | 14.332 | 9.70469 | 35.7878 | -158.685 |
| full_fly_1.BIN_roll_response_candidate_24 | RATE.Y | 271.865 | 153.401 | 940.784 | -19317.661 |
| full_fly_1.BIN_roll_response_candidate_27 | RATE.R | 5.36638 | 3.42415 | 16.9937 | -489.255 |
| full_fly_1.BIN_roll_response_candidate_27 | RATE.P | 14.5165 | 10.6065 | 35.7784 | -161.421 |
| full_fly_1.BIN_roll_response_candidate_27 | RATE.Y | 532.539 | 301.811 | 1845.29 | -38053.687 |
| full_fly_1.BIN_roll_response_candidate_31 | RATE.R | 22.5491 | 14.9793 | 61.3132 | -2389.804 |
| full_fly_1.BIN_roll_response_candidate_31 | RATE.P | 14.5227 | 12.0099 | 32.7131 | -156.679 |
| full_fly_1.BIN_roll_response_candidate_31 | RATE.Y | 82.6631 | 47.673 | 286.276 | -6142.999 |
| full_fly_1.BIN_roll_response_candidate_33 | RATE.R | 294.171 | 188.225 | 884.042 | -5112924.243 |
| full_fly_1.BIN_roll_response_candidate_33 | RATE.P | 10.0077 | 9.71485 | 10.9096 | -10188.650 |
| full_fly_1.BIN_roll_response_candidate_33 | RATE.Y | 593.465 | 273.011 | 2539.97 | -3125748.677 |
| full_fly_1.BIN_pitch_response_candidate_2 | RATE.R | 7.87776 | 5.56034 | 19.1539 | -3330.638 |
| full_fly_1.BIN_pitch_response_candidate_2 | RATE.P | 0.467561 | 0.351948 | 1.06515 | -52.337 |
| full_fly_1.BIN_pitch_response_candidate_2 | RATE.Y | 5.66389 | 3.3755 | 19.1477 | -7935.099 |
| full_fly_1.BIN_pitch_response_candidate_11 | RATE.R | 5.04252 | 3.76554 | 12.7038 | -11041.044 |
| full_fly_1.BIN_pitch_response_candidate_11 | RATE.P | 0.752562 | 0.626261 | 1.28012 | -197.017 |
| full_fly_1.BIN_pitch_response_candidate_11 | RATE.Y | 151.85 | 85.2894 | 528.15 | -225340.629 |
| full_fly_1.BIN_pitch_response_candidate_14 | RATE.R | 2.37879 | 1.52231 | 6.63443 | -6880.698 |
| full_fly_1.BIN_pitch_response_candidate_14 | RATE.P | 0.817839 | 0.764598 | 1.27189 | -258.128 |
| full_fly_1.BIN_pitch_response_candidate_14 | RATE.Y | 122.582 | 69.1858 | 424.938 | -209225.142 |
| full_fly_1.BIN_pitch_response_candidate_22 | RATE.R | 42.1011 | 30.8295 | 104.267 | -39094.281 |
| full_fly_1.BIN_pitch_response_candidate_22 | RATE.P | 0.918963 | 0.881801 | 1.22446 | -855.131 |
| full_fly_1.BIN_pitch_response_candidate_22 | RATE.Y | 49.4453 | 27.7375 | 171.627 | -144472.462 |
| full_fly_1.BIN_pitch_response_candidate_23 | RATE.R | 41.8314 | 30.9574 | 102.902 | -48289.576 |
| full_fly_1.BIN_pitch_response_candidate_23 | RATE.P | 0.877671 | 0.834613 | 1.20087 | -803.271 |
| full_fly_1.BIN_pitch_response_candidate_23 | RATE.Y | 62.0941 | 34.9381 | 215.387 | -227334.869 |
| full_fly_1.BIN_pitch_response_candidate_24 | RATE.R | 41.637 | 30.819 | 102.54 | -46110.901 |
| full_fly_1.BIN_pitch_response_candidate_24 | RATE.P | 0.861378 | 0.81631 | 1.18806 | -790.202 |
| full_fly_1.BIN_pitch_response_candidate_24 | RATE.Y | 70.762 | 39.7643 | 245.997 | -282983.536 |
| full_fly_1.BIN_pitch_response_candidate_25 | RATE.R | 62.518 | 47.5999 | 152.449 | -17964.909 |
| full_fly_1.BIN_pitch_response_candidate_25 | RATE.P | 1.20749 | 1.08704 | 2.42868 | -197.420 |
| full_fly_1.BIN_pitch_response_candidate_25 | RATE.Y | 1331.71 | 750.048 | 4616.65 | -67545.884 |
| full_fly_1.BIN_pitch_response_candidate_27 | RATE.R | 19.7537 | 13.5479 | 51.3704 | -13663.514 |
| full_fly_1.BIN_pitch_response_candidate_27 | RATE.P | 1.14705 | 1.09124 | 1.85307 | -803.082 |
| full_fly_1.BIN_pitch_response_candidate_27 | RATE.Y | 194.704 | 107.938 | 685.845 | -23252.021 |
| full_fly_1.BIN_pitch_response_candidate_29 | RATE.R | 14.7486 | 10.4576 | 37.5622 | -3451.342 |
| full_fly_1.BIN_pitch_response_candidate_29 | RATE.P | 1.58415 | 1.52354 | 2.71116 | -95.567 |
| full_fly_1.BIN_pitch_response_candidate_29 | RATE.Y | 62.5358 | 36.4591 | 216.552 | -19959.979 |
| full_fly_1.BIN_pitch_response_candidate_30 | RATE.R | 21.9861 | 16.2521 | 54.3618 | -6883.778 |
| full_fly_1.BIN_pitch_response_candidate_30 | RATE.P | 1.42291 | 1.29827 | 2.70276 | -73.312 |
| full_fly_1.BIN_pitch_response_candidate_30 | RATE.Y | 340.605 | 192.46 | 1179.06 | -205061.276 |
| full_fly_1.BIN_pitch_response_candidate_32 | RATE.R | 12.6781 | 9.34831 | 31.7102 | -5533.505 |
| full_fly_1.BIN_pitch_response_candidate_32 | RATE.P | 0.970486 | 0.807803 | 1.93127 | 13.245 |
| full_fly_1.BIN_pitch_response_candidate_32 | RATE.Y | 38.7209 | 21.6476 | 134.141 | -16734.258 |
| full_fly_1.BIN_pitch_response_candidate_34 | RATE.R | 10.0753 | 7.28858 | 25.4119 | -4209.606 |
| full_fly_1.BIN_pitch_response_candidate_34 | RATE.P | 1.52595 | 1.30632 | 3.10079 | -51.919 |
| full_fly_1.BIN_pitch_response_candidate_34 | RATE.Y | 63.9269 | 36.6198 | 220.996 | -29327.493 |
| full_fly_1.BIN_pitch_response_candidate_35 | RATE.R | 10.347 | 7.54328 | 25.6141 | -7708.006 |
| full_fly_1.BIN_pitch_response_candidate_35 | RATE.P | 1.55769 | 1.35298 | 3.09813 | -68.009 |
| full_fly_1.BIN_pitch_response_candidate_35 | RATE.Y | 78.7577 | 44.3772 | 272.455 | -40795.494 |
| full_fly_1.BIN_pitch_response_candidate_39 | RATE.R | 0.73038 | 0.567018 | 1.65744 | -316.431 |
| full_fly_1.BIN_pitch_response_candidate_39 | RATE.P | 1.60644 | 1.18491 | 3.1061 | -93.018 |
| full_fly_1.BIN_pitch_response_candidate_39 | RATE.Y | 100.054 | 56.8377 | 347.565 | -20574.512 |
| full_fly_1.BIN_pitch_response_candidate_40 | RATE.R | 4.27189 | 3.09592 | 10.5575 | -2525.648 |
| full_fly_1.BIN_pitch_response_candidate_40 | RATE.P | 1.5107 | 1.10497 | 2.99198 | -79.307 |
| full_fly_1.BIN_pitch_response_candidate_40 | RATE.Y | 15.1181 | 8.68689 | 52.5337 | -3046.605 |
| full_fly_1.BIN_pitch_response_candidate_43 | RATE.R | 1.97442 | 1.35872 | 4.77863 | -2186.719 |
| full_fly_1.BIN_pitch_response_candidate_43 | RATE.P | 1.37355 | 0.987272 | 3.42445 | 9.165 |
| full_fly_1.BIN_pitch_response_candidate_43 | RATE.Y | 5.805 | 3.26033 | 20.3037 | -1490.884 |
| full_fly_1.BIN_pitch_response_candidate_44 | RATE.R | 3.41699 | 2.5279 | 8.61834 | -3387.067 |
| full_fly_1.BIN_pitch_response_candidate_44 | RATE.P | 1.37952 | 0.992125 | 3.44443 | 9.046 |
| full_fly_1.BIN_pitch_response_candidate_44 | RATE.Y | 14.9916 | 8.39653 | 52.4726 | -3174.808 |
| full_fly_1.BIN_pitch_response_candidate_46 | RATE.R | 4.98491 | 3.80455 | 12.4225 | -2229.044 |
| full_fly_1.BIN_pitch_response_candidate_46 | RATE.P | 1.29449 | 0.938445 | 3.28674 | 15.265 |
| full_fly_1.BIN_pitch_response_candidate_46 | RATE.Y | 22.8116 | 12.8488 | 79.728 | -4562.802 |
| full_fly_1.BIN_pitch_response_candidate_52 | RATE.R | 8.62376 | 6.70116 | 19.2321 | -1539.407 |
| full_fly_1.BIN_pitch_response_candidate_52 | RATE.P | 1.31622 | 1.12531 | 3.0298 | -30.402 |
| full_fly_1.BIN_pitch_response_candidate_52 | RATE.Y | 42.6741 | 24.0478 | 147.574 | -16920.064 |
| full_fly_1.BIN_pitch_response_candidate_53 | RATE.R | 5.06518 | 4.24918 | 9.25458 | -928.038 |
| full_fly_1.BIN_pitch_response_candidate_53 | RATE.P | 0.83688 | 0.794242 | 1.31367 | -5.519 |
| full_fly_1.BIN_pitch_response_candidate_53 | RATE.Y | 29.5056 | 16.7839 | 101.372 | -11851.114 |
| full_fly_1.BIN_pitch_response_candidate_55 | RATE.R | 12.9824 | 8.59076 | 35.792 | -4028.834 |
| full_fly_1.BIN_pitch_response_candidate_55 | RATE.P | 0.901235 | 0.8023 | 2.01485 | -168.365 |
| full_fly_1.BIN_pitch_response_candidate_55 | RATE.Y | 68.4011 | 39.407 | 234.231 | -17902.858 |
| full_fly_1.BIN_pitch_response_candidate_58 | RATE.R | 37.1019 | 27.7203 | 91.3872 | -8209.334 |
| full_fly_1.BIN_pitch_response_candidate_58 | RATE.P | 1.5142 | 1.44611 | 2.11682 | -432.266 |
| full_fly_1.BIN_pitch_response_candidate_58 | RATE.Y | 583.857 | 325.876 | 2035.6 | -76056.021 |
| full_fly_1.BIN_pitch_response_candidate_60 | RATE.R | 15.7245 | 11.6887 | 38.3527 | -5558.406 |
| full_fly_1.BIN_pitch_response_candidate_60 | RATE.P | 1.00822 | 0.887443 | 1.83051 | -343.021 |
| full_fly_1.BIN_pitch_response_candidate_60 | RATE.Y | 732.004 | 411.338 | 2543.92 | -109177.441 |
| full_fly_1.BIN_pitch_response_candidate_62 | RATE.R | 2.42233 | 1.66657 | 6.27421 | -3784.847 |
| full_fly_1.BIN_pitch_response_candidate_62 | RATE.P | 0.432058 | 0.365995 | 1.24491 | 14.232 |
| full_fly_1.BIN_pitch_response_candidate_62 | RATE.Y | 14.33 | 8.1222 | 49.3799 | -24624.338 |
| full_fly_1.BIN_pitch_response_candidate_66 | RATE.R | 4.33219 | 3.21744 | 10.1089 | -3096.653 |
| full_fly_1.BIN_pitch_response_candidate_66 | RATE.P | 0.881798 | 0.71393 | 1.92271 | -109.036 |
| full_fly_1.BIN_pitch_response_candidate_66 | RATE.Y | 0.342731 | 0.20317 | 1.42194 | -176.555 |
| full_fly_1.BIN_pitch_response_candidate_67 | RATE.R | 4.06752 | 3.14975 | 9.56892 | -3106.017 |
| full_fly_1.BIN_pitch_response_candidate_67 | RATE.P | 0.978748 | 0.870876 | 1.92351 | -111.962 |
| full_fly_1.BIN_pitch_response_candidate_67 | RATE.Y | 6.18642 | 3.5731 | 21.0355 | -4751.423 |
| full_fly_1.BIN_pitch_response_candidate_70 | RATE.R | 0.498778 | 0.2779 | 1.24741 | -472.148 |
| full_fly_1.BIN_pitch_response_candidate_70 | RATE.P | 1.367 | 0.864577 | 3.19142 | -162.557 |
| full_fly_1.BIN_pitch_response_candidate_70 | RATE.Y | 14.4761 | 7.98717 | 50.5687 | -14341.834 |
| full_fly_1.BIN_pitch_response_candidate_71 | RATE.R | 0.266227 | 0.241817 | 0.435501 | -123.135 |
| full_fly_1.BIN_pitch_response_candidate_71 | RATE.P | 1.43322 | 0.963729 | 3.19129 | -228.726 |
| full_fly_1.BIN_pitch_response_candidate_71 | RATE.Y | 10.5677 | 5.76297 | 36.4084 | -7918.625 |
| full_fly_1.BIN_pitch_response_candidate_74 | RATE.R | 14.1067 | 10.4382 | 34.6999 | -5551.895 |
| full_fly_1.BIN_pitch_response_candidate_74 | RATE.P | 0.332431 | 0.257215 | 0.853986 | -40.424 |
| full_fly_1.BIN_pitch_response_candidate_74 | RATE.Y | 134.869 | 75.6664 | 470.656 | -24796.555 |
| full_fly_1.BIN_pitch_response_candidate_79 | RATE.R | 6.9581 | 4.47347 | 21.42 | -666.015 |
| full_fly_1.BIN_pitch_response_candidate_79 | RATE.P | 14.592 | 11.0059 | 35.7589 | -162.638 |
| full_fly_1.BIN_pitch_response_candidate_79 | RATE.Y | 618.257 | 349.861 | 2147.77 | -44626.860 |
| full_fly_1.BIN_yaw_response_candidate_1 | RATE.R | 3.05711 | 2.79585 | 5.71017 | -1113.931 |
| full_fly_1.BIN_yaw_response_candidate_1 | RATE.P | 0.507894 | 0.442356 | 0.88861 | 7.786 |
| full_fly_1.BIN_yaw_response_candidate_1 | RATE.Y | 68.5216 | 38.1513 | 238.84 | -89341.142 |
| full_fly_1.BIN_yaw_response_candidate_3 | RATE.R | 75.8869 | 57.5208 | 184.796 | -17837.957 |
| full_fly_1.BIN_yaw_response_candidate_3 | RATE.P | 1.90319 | 1.73516 | 3.31005 | -340.938 |
| full_fly_1.BIN_yaw_response_candidate_3 | RATE.Y | 1164.18 | 653.124 | 4046.28 | -52615.693 |
| full_fly_1.BIN_yaw_response_candidate_5 | RATE.R | 20.3473 | 15.4142 | 50.5103 | -5730.260 |
| full_fly_1.BIN_yaw_response_candidate_5 | RATE.P | 1.90123 | 1.87352 | 2.555 | -429.088 |
| full_fly_1.BIN_yaw_response_candidate_5 | RATE.Y | 2527.94 | 1431.17 | 8762.87 | -116041.293 |
| full_fly_1.BIN_yaw_response_candidate_6 | RATE.R | 7.23796 | 4.94004 | 19.398 | -4639.225 |
| full_fly_1.BIN_yaw_response_candidate_6 | RATE.P | 1.71997 | 1.67371 | 2.20646 | -1039.873 |
| full_fly_1.BIN_yaw_response_candidate_6 | RATE.Y | 292.441 | 164.706 | 1016.04 | -53676.816 |
| full_fly_1.BIN_yaw_response_candidate_7 | RATE.R | 11.5155 | 8.1407 | 29.9401 | -9230.818 |
| full_fly_1.BIN_yaw_response_candidate_7 | RATE.P | 1.70634 | 1.66602 | 2.14096 | -1024.700 |
| full_fly_1.BIN_yaw_response_candidate_7 | RATE.Y | 126.183 | 70.1556 | 441.081 | -36711.580 |
| full_fly_1.BIN_yaw_response_candidate_8 | RATE.R | 18.6411 | 13.0427 | 48.7029 | -22618.670 |
| full_fly_1.BIN_yaw_response_candidate_8 | RATE.P | 1.4532 | 1.42389 | 1.77412 | -961.188 |
| full_fly_1.BIN_yaw_response_candidate_8 | RATE.Y | 312.752 | 175.203 | 1087.1 | -225230.439 |
| full_fly_1.BIN_yaw_response_candidate_10 | RATE.R | 1569 | 886.055 | 5460.39 | -1273159.415 |
| full_fly_1.BIN_yaw_response_candidate_10 | RATE.P | 0.29052 | 0.257498 | 0.805279 | -412.221 |
| full_fly_1.BIN_yaw_response_candidate_10 | RATE.Y | 160692 | 63165.6 | 805102 | -147643898.150 |
| full_fly_1.BIN_yaw_response_candidate_13 | RATE.R | 66.8398 | 50.7155 | 162.761 | -19264.877 |
| full_fly_1.BIN_yaw_response_candidate_13 | RATE.P | 1.18837 | 1.04855 | 2.43354 | -191.618 |
| full_fly_1.BIN_yaw_response_candidate_13 | RATE.Y | 1074.14 | 603.647 | 3724.06 | -54536.935 |
| full_fly_1.BIN_yaw_response_candidate_15 | RATE.R | 20.3962 | 13.9807 | 52.8869 | -10822.839 |
| full_fly_1.BIN_yaw_response_candidate_15 | RATE.P | 1.16434 | 1.10842 | 1.85306 | -805.286 |
| full_fly_1.BIN_yaw_response_candidate_15 | RATE.Y | 182.749 | 100.657 | 645.577 | -21976.154 |
| full_fly_1.BIN_yaw_response_candidate_21 | RATE.R | 14.6483 | 10.3648 | 37.2645 | -3529.242 |
| full_fly_1.BIN_yaw_response_candidate_21 | RATE.P | 1.55551 | 1.49134 | 2.71083 | -84.793 |
| full_fly_1.BIN_yaw_response_candidate_21 | RATE.Y | 46.7129 | 27.5425 | 161.757 | -15955.726 |
| full_fly_1.BIN_yaw_response_candidate_24 | RATE.R | 8.40248 | 5.96967 | 21.237 | -3487.410 |
| full_fly_1.BIN_yaw_response_candidate_24 | RATE.P | 1.59875 | 1.43236 | 3.10095 | -42.578 |
| full_fly_1.BIN_yaw_response_candidate_24 | RATE.Y | 17.2606 | 9.42447 | 59.7816 | -8202.603 |
| full_fly_1.BIN_yaw_response_candidate_25 | RATE.R | 0.650506 | 0.467348 | 1.51826 | -238.006 |
| full_fly_1.BIN_yaw_response_candidate_25 | RATE.P | 3.05212 | 2.35144 | 5.14675 | -216.748 |
| full_fly_1.BIN_yaw_response_candidate_25 | RATE.Y | 25.9006 | 14.3439 | 91.3392 | -3697.169 |
| full_fly_1.BIN_yaw_response_candidate_28 | RATE.R | 4.72382 | 3.6009 | 11.9362 | -622.611 |
| full_fly_1.BIN_yaw_response_candidate_28 | RATE.P | 0.669655 | 0.552091 | 1.64719 | 47.739 |
| full_fly_1.BIN_yaw_response_candidate_28 | RATE.Y | 34.3388 | 19.3048 | 120.021 | -5778.296 |
| full_fly_1.BIN_yaw_response_candidate_30 | RATE.R | 0.92727 | 0.507862 | 3.74561 | 3.251 |
| full_fly_1.BIN_yaw_response_candidate_30 | RATE.P | 0.470228 | 0.38357 | 1.05143 | 3.489 |
| full_fly_1.BIN_yaw_response_candidate_30 | RATE.Y | 75.5854 | 42.6262 | 262.258 | -13004.463 |
| full_fly_1.BIN_yaw_response_candidate_31 | RATE.R | 4.01615 | 2.16679 | 12.9619 | -104.459 |
| full_fly_1.BIN_yaw_response_candidate_31 | RATE.P | 0.297222 | 0.241121 | 0.775706 | -67.209 |
| full_fly_1.BIN_yaw_response_candidate_31 | RATE.Y | 137.84 | 78.0009 | 478.458 | -25861.799 |
| full_fly_1.BIN_yaw_response_candidate_33 | RATE.R | 24.0887 | 18.1735 | 57.4955 | -45453.309 |
| full_fly_1.BIN_yaw_response_candidate_33 | RATE.P | 0.377007 | 0.330093 | 0.696091 | -399.290 |
| full_fly_1.BIN_yaw_response_candidate_33 | RATE.Y | 19.5134 | 11.5074 | 65.5574 | -4880.317 |
| full_fly_1.BIN_yaw_response_candidate_34 | RATE.R | 15.7021 | 10.3809 | 42.3796 | -4094.313 |
| full_fly_1.BIN_yaw_response_candidate_34 | RATE.P | 1.05213 | 0.934373 | 2.01483 | -265.583 |
| full_fly_1.BIN_yaw_response_candidate_34 | RATE.Y | 65.9637 | 36.1197 | 234.945 | -16747.066 |
| full_fly_1.BIN_yaw_response_candidate_35 | RATE.R | 22.051 | 15.0946 | 56.4465 | -4667.991 |
| full_fly_1.BIN_yaw_response_candidate_35 | RATE.P | 1.16489 | 1.04263 | 2.01471 | -271.248 |
| full_fly_1.BIN_yaw_response_candidate_35 | RATE.Y | 128.284 | 70.3483 | 453.064 | -32175.465 |
| full_fly_1.BIN_yaw_response_candidate_40 | RATE.R | 6.51364 | 4.94564 | 15.9534 | -2639.916 |
| full_fly_1.BIN_yaw_response_candidate_40 | RATE.P | 2.12092 | 1.92505 | 4.05874 | -413.625 |
| full_fly_1.BIN_yaw_response_candidate_40 | RATE.Y | 204.823 | 115.247 | 710.517 | -28345.132 |
| full_fly_1.BIN_yaw_response_candidate_42 | RATE.R | 2.76421 | 1.85247 | 7.54487 | -612.447 |
| full_fly_1.BIN_yaw_response_candidate_42 | RATE.P | 0.301064 | 0.24483 | 0.718072 | -31.497 |
| full_fly_1.BIN_yaw_response_candidate_42 | RATE.Y | 29.1158 | 16.0392 | 102.878 | -12274.836 |
| full_fly_1.BIN_yaw_response_candidate_47 | RATE.R | 15.3398 | 11.1363 | 38.4708 | -5816.118 |
| full_fly_1.BIN_yaw_response_candidate_47 | RATE.P | 0.325783 | 0.241246 | 0.853693 | -108.846 |
| full_fly_1.BIN_yaw_response_candidate_47 | RATE.Y | 139.245 | 78.3815 | 482.577 | -30398.370 |
| full_fly_1.BIN_yaw_response_candidate_49 | RATE.R | 13.707 | 10.0184 | 33.7902 | -5230.455 |
| full_fly_1.BIN_yaw_response_candidate_49 | RATE.P | 0.326705 | 0.24439 | 0.853739 | -40.745 |
| full_fly_1.BIN_yaw_response_candidate_49 | RATE.Y | 8.54688 | 4.95482 | 30.8938 | -1553.154 |
| full_fly_1.BIN_yaw_response_candidate_50 | RATE.R | 14.7704 | 11.043 | 36.2785 | -5792.813 |
| full_fly_1.BIN_yaw_response_candidate_50 | RATE.P | 0.343431 | 0.27034 | 0.853398 | -42.054 |
| full_fly_1.BIN_yaw_response_candidate_50 | RATE.Y | 82.3871 | 46.0475 | 287.632 | -14498.294 |
| full_fly_1.BIN_yaw_response_candidate_54 | RATE.R | 8.27416 | 5.8076 | 21.4323 | -2181.938 |
| full_fly_1.BIN_yaw_response_candidate_54 | RATE.P | 0.176755 | 0.146298 | 0.43197 | -24.288 |
| full_fly_1.BIN_yaw_response_candidate_54 | RATE.Y | 182.001 | 102.76 | 629.649 | -59907.907 |
| full_fly_1.BIN_yaw_response_candidate_58 | RATE.R | 8.56299 | 6.40141 | 21.8972 | -3663.574 |
| full_fly_1.BIN_yaw_response_candidate_58 | RATE.P | 0.21916 | 0.1784 | 0.608604 | 36.383 |
| full_fly_1.BIN_yaw_response_candidate_58 | RATE.Y | 150.505 | 84.9597 | 522.985 | -34161.487 |
| full_fly_1.BIN_yaw_response_candidate_59 | RATE.R | 6.05716 | 4.34829 | 15.5258 | -2581.792 |
| full_fly_1.BIN_yaw_response_candidate_59 | RATE.P | 0.274628 | 0.22692 | 0.6389 | 29.791 |
| full_fly_1.BIN_yaw_response_candidate_59 | RATE.Y | 107.028 | 61.1678 | 371.194 | -27262.644 |
| full_fly_1.BIN_yaw_response_candidate_60 | RATE.R | 3.10056 | 2.00663 | 7.98483 | -1573.469 |
| full_fly_1.BIN_yaw_response_candidate_60 | RATE.P | 0.276645 | 0.229356 | 0.638927 | 28.672 |
| full_fly_1.BIN_yaw_response_candidate_60 | RATE.Y | 160.26 | 90.3638 | 553.785 | -44023.206 |
| full_fly_1.BIN_thrust_response_candidate_2 | RATE.R | 1.92509 | 1.29848 | 4.94459 | -2193.031 |
| full_fly_1.BIN_thrust_response_candidate_2 | RATE.P | 1.36984 | 0.974917 | 3.42319 | 9.581 |
| full_fly_1.BIN_thrust_response_candidate_2 | RATE.Y | 4.53538 | 2.60026 | 16.6225 | -1487.713 |
| full_fly_1.BIN_thrust_response_candidate_3 | RATE.R | 4.59654 | 3.48247 | 11.3567 | -4474.788 |
| full_fly_1.BIN_thrust_response_candidate_3 | RATE.P | 1.41114 | 1.01003 | 3.49724 | 7.046 |
| full_fly_1.BIN_thrust_response_candidate_3 | RATE.Y | 16.6975 | 9.41093 | 57.5856 | -3510.732 |
| full_fly_1.BIN_thrust_response_candidate_4 | RATE.R | 5.38995 | 4.11202 | 12.7559 | -3873.431 |
| full_fly_1.BIN_thrust_response_candidate_4 | RATE.P | 0.911252 | 0.767408 | 1.92232 | -117.111 |
| full_fly_1.BIN_thrust_response_candidate_4 | RATE.Y | 0.769856 | 0.478899 | 2.19069 | -519.458 |
| full_fly_2.BIN_hover_candidate_2 | RATE.R | 11.587 | 8.43996 | 29.0474 | -5378.415 |
| full_fly_2.BIN_hover_candidate_2 | RATE.P | 0.213595 | 0.1868 | 0.492548 | -11.555 |
| full_fly_2.BIN_hover_candidate_2 | RATE.Y | 107.237 | 60.4179 | 371.99 | -64329.070 |
| full_fly_2.BIN_hover_candidate_3 | RATE.R | 9.47386 | 6.90692 | 23.6403 | -3102.383 |
| full_fly_2.BIN_hover_candidate_3 | RATE.P | 0.124249 | 0.0918296 | 0.292403 | 30.508 |
| full_fly_2.BIN_hover_candidate_3 | RATE.Y | 98.9766 | 55.9082 | 343.153 | -140179.434 |
| full_fly_2.BIN_hover_candidate_5 | RATE.R | 17.7967 | 12.329 | 50.2778 | -5221.998 |
| full_fly_2.BIN_hover_candidate_5 | RATE.P | 3.65878 | 1.79122 | 13.6646 | -172.993 |
| full_fly_2.BIN_hover_candidate_5 | RATE.Y | 20.0983 | 10.7754 | 74.4009 | -3261.974 |
| full_fly_2.BIN_climb_candidate_3 | RATE.R | 24.3374 | 17.6013 | 61.5851 | -267807.762 |
| full_fly_2.BIN_climb_candidate_3 | RATE.P | 0.482902 | 0.468752 | 0.652325 | -501.230 |
| full_fly_2.BIN_climb_candidate_3 | RATE.Y | 21.9649 | 12.2391 | 76.6348 | -73083.914 |
| full_fly_2.BIN_climb_candidate_6 | RATE.R | 31.1277 | 19.1273 | 97.8284 | -25558.380 |
| full_fly_2.BIN_climb_candidate_6 | RATE.P | 1.82309 | 1.53896 | 4.19092 | -249.412 |
| full_fly_2.BIN_climb_candidate_6 | RATE.Y | 4118.85 | 1808.03 | 18474.5 | -1689567.534 |
| full_fly_2.BIN_descent_candidate_1 | RATE.R | 50.4655 | 37.9585 | 125.079 | -19271.318 |
| full_fly_2.BIN_descent_candidate_1 | RATE.P | 1.39691 | 1.32242 | 1.95907 | -341.309 |
| full_fly_2.BIN_descent_candidate_1 | RATE.Y | 1478.9 | 831.605 | 5142.46 | -118138.201 |
| full_fly_2.BIN_descent_candidate_4 | RATE.R | 23.969 | 17.354 | 60.6057 | -262075.728 |
| full_fly_2.BIN_descent_candidate_4 | RATE.P | 0.456704 | 0.443456 | 0.559106 | -2091.694 |
| full_fly_2.BIN_descent_candidate_4 | RATE.Y | 43.2618 | 24.2732 | 150.568 | -108296.270 |
| full_fly_2.BIN_descent_candidate_5 | RATE.R | 24.3939 | 17.7019 | 61.2818 | -55736.480 |
| full_fly_2.BIN_descent_candidate_5 | RATE.P | 0.486492 | 0.466659 | 0.861764 | -356.304 |
| full_fly_2.BIN_descent_candidate_5 | RATE.Y | 51.5443 | 29.0332 | 178.722 | -135044.660 |
| full_fly_2.BIN_descent_candidate_9 | RATE.R | 0.745131 | 0.648773 | 1.18424 | -796.760 |
| full_fly_2.BIN_descent_candidate_9 | RATE.P | 0.315623 | 0.279703 | 0.640403 | -48.503 |
| full_fly_2.BIN_descent_candidate_9 | RATE.Y | 28.2512 | 15.866 | 98.1105 | -87591.635 |
| full_fly_2.BIN_descent_candidate_11 | RATE.R | 9.56302 | 6.86326 | 24.5684 | -2604.390 |
| full_fly_2.BIN_descent_candidate_11 | RATE.P | 0.222339 | 0.171872 | 0.445665 | 16.959 |
| full_fly_2.BIN_descent_candidate_11 | RATE.Y | 33.8926 | 19.1733 | 117.721 | -46144.453 |
| full_fly_2.BIN_roll_response_candidate_6 | RATE.R | 20.3764 | 13.8779 | 51.1602 | -5345.868 |
| full_fly_2.BIN_roll_response_candidate_6 | RATE.P | 5.59859 | 3.24702 | 17.0655 | -176.812 |
| full_fly_2.BIN_roll_response_candidate_6 | RATE.Y | 115.852 | 65.1818 | 401.855 | -10811.080 |
| full_fly_2.BIN_roll_response_candidate_8 | RATE.R | 28.9332 | 20.9514 | 70.4445 | -7541.013 |
| full_fly_2.BIN_roll_response_candidate_8 | RATE.P | 5.61535 | 3.24926 | 17.0664 | -180.946 |
| full_fly_2.BIN_roll_response_candidate_8 | RATE.Y | 136.249 | 77.1656 | 472.1 | -12668.711 |
| full_fly_2.BIN_roll_response_candidate_9 | RATE.R | 30.4996 | 22.2493 | 74.1474 | -7949.731 |
| full_fly_2.BIN_roll_response_candidate_9 | RATE.P | 5.61515 | 3.25276 | 17.0662 | -181.233 |
| full_fly_2.BIN_roll_response_candidate_9 | RATE.Y | 127.05 | 71.9739 | 440.214 | -11805.639 |
| full_fly_2.BIN_pitch_response_candidate_2 | RATE.R | 592.09 | 340.518 | 2025.3 | -199829.061 |
| full_fly_2.BIN_pitch_response_candidate_2 | RATE.P | 1.88459 | 1.80195 | 2.86507 | -708.387 |
| full_fly_2.BIN_pitch_response_candidate_2 | RATE.Y | 676631 | 270545 | 3.33281e+06 | -52578372.168 |
| full_fly_2.BIN_pitch_response_candidate_3 | RATE.R | 25.5281 | 19.4337 | 61.4618 | -6072.618 |
| full_fly_2.BIN_pitch_response_candidate_3 | RATE.P | 1.47751 | 1.25995 | 2.7321 | -303.559 |
| full_fly_2.BIN_pitch_response_candidate_3 | RATE.Y | 1828.93 | 1031.34 | 6355.03 | -141455.375 |
| full_fly_2.BIN_pitch_response_candidate_5 | RATE.R | 23.7937 | 17.2137 | 60.2043 | -238304.716 |
| full_fly_2.BIN_pitch_response_candidate_5 | RATE.P | 0.499184 | 0.481117 | 0.645923 | -825.903 |
| full_fly_2.BIN_pitch_response_candidate_5 | RATE.Y | 34.2179 | 19.2128 | 119.113 | -106530.613 |
| full_fly_2.BIN_pitch_response_candidate_6 | RATE.R | 21.2009 | 15.9564 | 46.9889 | -5556.752 |
| full_fly_2.BIN_pitch_response_candidate_6 | RATE.P | 0.574871 | 0.54442 | 0.86146 | -331.498 |
| full_fly_2.BIN_pitch_response_candidate_6 | RATE.Y | 39.0782 | 21.8808 | 136.925 | -33827.201 |
| full_fly_2.BIN_pitch_response_candidate_7 | RATE.R | 19.9157 | 15.2332 | 42.0971 | -5091.324 |
| full_fly_2.BIN_pitch_response_candidate_7 | RATE.P | 0.580023 | 0.549096 | 0.861224 | -336.645 |
| full_fly_2.BIN_pitch_response_candidate_7 | RATE.Y | 46.9922 | 26.2284 | 165.251 | -40874.007 |
| full_fly_2.BIN_pitch_response_candidate_9 | RATE.R | 17.6586 | 13.9032 | 34.3303 | -4387.900 |
| full_fly_2.BIN_pitch_response_candidate_9 | RATE.P | 0.582633 | 0.553476 | 0.860716 | -338.378 |
| full_fly_2.BIN_pitch_response_candidate_9 | RATE.Y | 40.5514 | 22.4569 | 143.47 | -34774.567 |
| full_fly_2.BIN_pitch_response_candidate_11 | RATE.R | 6.31121 | 5.38465 | 13.2617 | -1506.013 |
| full_fly_2.BIN_pitch_response_candidate_11 | RATE.P | 0.885746 | 0.716863 | 2.67835 | -377.782 |
| full_fly_2.BIN_pitch_response_candidate_11 | RATE.Y | 52.4716 | 28.0838 | 192.203 | -6374.603 |
| full_fly_2.BIN_pitch_response_candidate_12 | RATE.R | 58.1062 | 38.8602 | 151.98 | -23598.475 |
| full_fly_2.BIN_pitch_response_candidate_12 | RATE.P | 1.47295 | 1.22342 | 2.67775 | -348.425 |
| full_fly_2.BIN_pitch_response_candidate_12 | RATE.Y | 183.556 | 99.441 | 642.844 | -15194.177 |
| full_fly_2.BIN_pitch_response_candidate_15 | RATE.R | 1.82703 | 1.20856 | 5.18569 | -932.782 |
| full_fly_2.BIN_pitch_response_candidate_15 | RATE.P | 0.774984 | 0.695943 | 1.37382 | -171.962 |
| full_fly_2.BIN_pitch_response_candidate_15 | RATE.Y | 92.0727 | 51.7875 | 320.351 | -41692.139 |
| full_fly_2.BIN_pitch_response_candidate_16 | RATE.R | 5.50285 | 3.98161 | 13.9237 | -4839.623 |
| full_fly_2.BIN_pitch_response_candidate_16 | RATE.P | 0.985008 | 0.72245 | 3.11075 | -295.385 |
| full_fly_2.BIN_pitch_response_candidate_16 | RATE.Y | 5.60057 | 2.92136 | 20.9189 | -3820.651 |
| full_fly_2.BIN_pitch_response_candidate_17 | RATE.R | 5.1338 | 3.67517 | 12.9481 | -4665.379 |
| full_fly_2.BIN_pitch_response_candidate_17 | RATE.P | 1.55239 | 1.04611 | 4.09556 | -483.596 |
| full_fly_2.BIN_pitch_response_candidate_17 | RATE.Y | 32.0473 | 17.6737 | 112.576 | -14402.661 |
| full_fly_2.BIN_pitch_response_candidate_19 | RATE.R | 5.99307 | 4.37681 | 14.8555 | -4032.780 |
| full_fly_2.BIN_pitch_response_candidate_19 | RATE.P | 1.96141 | 1.43639 | 4.19104 | -280.992 |
| full_fly_2.BIN_pitch_response_candidate_19 | RATE.Y | 41.6679 | 23.0865 | 144.965 | -14860.949 |
| full_fly_2.BIN_pitch_response_candidate_20 | RATE.R | 6.47066 | 4.7577 | 16.0425 | -4226.705 |
| full_fly_2.BIN_pitch_response_candidate_20 | RATE.P | 1.96968 | 1.46872 | 4.19102 | -238.078 |
| full_fly_2.BIN_pitch_response_candidate_20 | RATE.Y | 45.3665 | 25.1163 | 157.941 | -16019.056 |
| full_fly_2.BIN_pitch_response_candidate_24 | RATE.R | 24.2671 | 17.0812 | 59.5748 | -6327.201 |
| full_fly_2.BIN_pitch_response_candidate_24 | RATE.P | 5.61487 | 3.27016 | 17.0658 | -179.213 |
| full_fly_2.BIN_pitch_response_candidate_24 | RATE.Y | 134.106 | 75.843 | 464.661 | -12480.386 |
| full_fly_2.BIN_pitch_response_candidate_26 | RATE.R | 37.4848 | 28.1604 | 90.647 | -9902.778 |
| full_fly_2.BIN_pitch_response_candidate_26 | RATE.P | 5.62837 | 3.22382 | 17.0731 | -184.546 |
| full_fly_2.BIN_pitch_response_candidate_26 | RATE.Y | 133.959 | 76.0222 | 464.152 | -12476.784 |
| full_fly_2.BIN_pitch_response_candidate_29 | RATE.R | 42.0337 | 32.4082 | 101.618 | -11749.637 |
| full_fly_2.BIN_pitch_response_candidate_29 | RATE.P | 5.2598 | 2.72295 | 16.8453 | -166.968 |
| full_fly_2.BIN_pitch_response_candidate_29 | RATE.Y | 90.8074 | 51.5529 | 315.374 | -8465.020 |
| full_fly_2.BIN_yaw_response_candidate_1 | RATE.R | 69.4694 | 49.8134 | 174.776 | -31638.593 |
| full_fly_2.BIN_yaw_response_candidate_1 | RATE.P | 0.873227 | 0.61422 | 1.8039 | -552.463 |
| full_fly_2.BIN_yaw_response_candidate_1 | RATE.Y | 344.135 | 188.121 | 1217.48 | -37057.018 |
| full_fly_2.BIN_yaw_response_candidate_3 | RATE.R | 71.3996 | 47.7512 | 200.924 | -41217.539 |
| full_fly_2.BIN_yaw_response_candidate_3 | RATE.P | 2.05432 | 1.97481 | 2.86506 | -1638.853 |
| full_fly_2.BIN_yaw_response_candidate_3 | RATE.Y | 3424.34 | 1686.74 | 13645.8 | -352854.895 |
| full_fly_2.BIN_yaw_response_candidate_10 | RATE.R | 12.3636 | 9.90083 | 29.3199 | -2155.216 |
| full_fly_2.BIN_yaw_response_candidate_10 | RATE.P | 2.48159 | 2.18695 | 4.23966 | -641.039 |
| full_fly_2.BIN_yaw_response_candidate_10 | RATE.Y | 788.944 | 445.63 | 2733.92 | -33781.984 |
| full_fly_2.BIN_yaw_response_candidate_11 | RATE.R | 5.54033 | 4.03055 | 14.0206 | -3616.501 |
| full_fly_2.BIN_yaw_response_candidate_11 | RATE.P | 2.11002 | 1.67986 | 4.19073 | -255.939 |
| full_fly_2.BIN_yaw_response_candidate_11 | RATE.Y | 65.6522 | 36.5595 | 228.74 | -21788.129 |
| full_fly_2.BIN_yaw_response_candidate_13 | RATE.R | 6.46392 | 4.69808 | 16.6972 | -4407.639 |
| full_fly_2.BIN_yaw_response_candidate_13 | RATE.P | 2.09496 | 1.85809 | 4.08933 | -241.863 |
| full_fly_2.BIN_yaw_response_candidate_13 | RATE.Y | 235.713 | 132.993 | 819.253 | -78174.052 |
| full_fly_2.BIN_yaw_response_candidate_14 | RATE.R | 0.884237 | 0.505763 | 2.91782 | -1954.737 |
| full_fly_2.BIN_yaw_response_candidate_14 | RATE.P | 0.0874657 | 0.071435 | 0.220872 | -9.465 |
| full_fly_2.BIN_yaw_response_candidate_14 | RATE.Y | 24.0002 | 13.4466 | 82.2026 | -7573.201 |
| full_fly_2.BIN_yaw_response_candidate_16 | RATE.R | 5.14846 | 3.50484 | 13.3795 | -8577.998 |
| full_fly_2.BIN_yaw_response_candidate_16 | RATE.P | 0.167111 | 0.116537 | 0.497148 | -10.331 |
| full_fly_2.BIN_yaw_response_candidate_16 | RATE.Y | 101.684 | 58.1346 | 352.217 | -30243.901 |
| full_fly_2.BIN_yaw_response_candidate_19 | RATE.R | 5.30384 | 3.50558 | 14.0038 | -4258.424 |
| full_fly_2.BIN_yaw_response_candidate_19 | RATE.P | 0.202842 | 0.169064 | 0.44142 | -37.438 |
| full_fly_2.BIN_yaw_response_candidate_19 | RATE.Y | 491.66 | 277.845 | 1704.57 | -141046.607 |
| full_fly_2.BIN_yaw_response_candidate_23 | RATE.R | 33.4831 | 24.7442 | 81.19 | -8715.512 |
| full_fly_2.BIN_yaw_response_candidate_23 | RATE.P | 5.61668 | 3.24138 | 17.0673 | -181.802 |
| full_fly_2.BIN_yaw_response_candidate_23 | RATE.Y | 133.22 | 75.5257 | 461.592 | -12391.849 |
| full_fly_2.BIN_yaw_response_candidate_24 | RATE.R | 41.1239 | 31.1655 | 99.3764 | -10940.453 |
| full_fly_2.BIN_yaw_response_candidate_24 | RATE.P | 5.62934 | 3.22795 | 17.0735 | -185.548 |
| full_fly_2.BIN_yaw_response_candidate_24 | RATE.Y | 116.775 | 66.312 | 404.594 | -10870.236 |

### Предварительное заключение

- RATE.R: средний показатель соответствия -58892994886.517 %, критерий 70.000 %. RATE.R: предварительный критерий не выполнен.
- RATE.P: средний показатель соответствия -186.669 %, критерий 70.000 %. RATE.P: предварительный критерий не выполнен.
- RATE.Y: средний показатель соответствия -44845056680669517499596800.000 %, критерий 60.000 %. RATE.Y: предварительный критерий не выполнен.

## Ограничения применимости

- ModelRate не является полной моделью движения изделия.
- Model6DOF будет настраиваться позже.
- Реальные записи ESC не обнаружены, что ограничивает будущую модель винтомоторной группы и аккумулятора.
- Графики и расчетные выходы хранятся локально в `result/rate_identification/` и не добавляются в Git.
