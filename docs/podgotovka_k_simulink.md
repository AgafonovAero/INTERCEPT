# Подготовка расчетного ядра к Simulink

## Общий подход

Расчетное ядро отделено от чтения данных, формирования графиков и отчетов. Это позволяет использовать его как основу для будущих функциональных блоков MATLAB в Simulink без переписывания основной логики.

## Функции, пригодные для переноса

Будущей основой для блоков Simulink являются:

- `kopterkm.modeli.pravayaChastUglovykhSkorostei`;
- `kopterkm.modeli.pravayaChast6SS`;
- `kopterkm.modeli.sistemyKoordinat`;
- `kopterkm.modeli.ModelVintomotornoyGruppy` как источник параметров;
- `kopterkm.modeli.ModelAkkumulyatora` как справочная заготовка.

## Входы и выходы будущих блоков

### Блок модели угловых скоростей

Входы:

- `omega = [p; q; r]`, рад/с;
- `u = [u_roll; u_pitch; u_yaw]`;
- параметры `A`, `B`, `c`.

Выход:

- `domega/dt`, рад/с².

### Блок модели движения с шестью степенями свободы

Входы:

- состояние `[положение; скорость; ориентация; угловые скорости; тяга двигателей]`;
- нормированные команды двигателей `u_i`;
- масса;
- матрица инерции;
- координаты двигателей;
- параметры винтомоторной группы;
- параметры сопротивления воздуха.

Выход:

- производная состояния.

## Функции, которые не следует переносить в Simulink

К чтению данных, отчетам или графикам относятся:

- `kopterkm.dannye.chitatTablichnyiZhurnal`;
- `kopterkm.dannye.chitatMatDannye`;
- `kopterkm.dannye.chitatBinZagotovka`;
- `kopterkm.dannye.prosmotrZhurnala`;
- `kopterkm.otchety.sformirovatOtchetMarkdown`;
- `kopterkm.otchety.sformirovatGrafiki`;
- сценарии из папки `scripts`.

Эти функции относятся к препроцессору и постпроцессору, а не к решателю компьютерной модели.
