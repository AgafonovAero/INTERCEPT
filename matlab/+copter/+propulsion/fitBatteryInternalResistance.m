function [batteryModel, fitReport] = fitBatteryInternalResistance(batteryData)
% Оценивает внутреннее сопротивление аккумуляторной батареи по стендовым данным.

warnings = strings(0, 1);
batteryModel = struct();
batteryModel.status = "not_fitted";
batteryModel.open_circuit_voltage_v = NaN;
batteryModel.internal_resistance_ohm = NaN;
batteryModel.capacity_mah = NaN;

if isempty(batteryData) || ~hasVariable(batteryData, "current_a") || ~hasVariable(batteryData, "voltage_v")
    warnings(end + 1, 1) = "Данные разряда аккумулятора отсутствуют или неполны.";
    fitReport = makeReport("bench_data_not_available", warnings, NaN);
    return;
end

current = double(batteryData.current_a);
voltage = double(batteryData.voltage_v);
valid = isfinite(current) & isfinite(voltage);
if nnz(valid) < 2
    warnings(end + 1, 1) = "Недостаточно точек для оценки внутреннего сопротивления.";
    fitReport = makeReport("insufficient_data", warnings, NaN);
    return;
end

design = [ones(nnz(valid), 1), -current(valid)];
coefficients = design \ voltage(valid);
batteryModel.status = "fitted_from_bench";
batteryModel.open_circuit_voltage_v = coefficients(1);
batteryModel.internal_resistance_ohm = coefficients(2);
if hasVariable(batteryData, "capacity_mah")
    batteryModel.capacity_mah = max(double(batteryData.capacity_mah), [], 'omitnan');
end
estimate = design * coefficients;
fitReport = makeReport("fitted_from_bench", warnings, sqrt(mean((voltage(valid) - estimate) .^ 2)));
end

function result = hasVariable(tableIn, name)
result = any(string(tableIn.Properties.VariableNames) == string(name));
end

function fitReport = makeReport(status, warnings, rmseValue)
fitReport = struct();
fitReport.status = string(status);
fitReport.rmse = rmseValue;
fitReport.warnings = unique(warnings, 'stable');
end
