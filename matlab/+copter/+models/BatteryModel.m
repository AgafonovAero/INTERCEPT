function model = BatteryModel(nominalVoltageV, capacityMah)
% Создает параметры аккумуляторной батареи начального уровня.

if nargin < 1 || isempty(nominalVoltageV)
    nominalVoltageV = 22.8;
end

if nargin < 2 || isempty(capacityMah)
    capacityMah = 7000;
end

model = struct();
model.nominal_voltage_v = nominalVoltageV;
model.capacity_mah = capacityMah;
model.note = "На первом этапе модель аккумулятора используется как справочная часть конфигурации.";
end
