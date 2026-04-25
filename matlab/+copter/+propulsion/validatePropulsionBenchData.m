function report = validatePropulsionBenchData(benchData)
% Проверяет качество и физическую правдоподобность стендовых данных ВМГ.

warnings = strings(0, 1);
if isempty(benchData)
    report = makeReport(false, "not_available", "Стендовые данные отсутствуют.");
    return;
end

if hasVariable(benchData, "thrust_n")
    thrust = double(benchData.thrust_n);
    if any(thrust(isfinite(thrust)) < -0.1)
        warnings(end + 1, 1) = "Обнаружена отрицательная тяга.";
    end
else
    warnings(end + 1, 1) = "Поле thrust_n отсутствует.";
end

if hasVariable(benchData, "voltage_v")
    voltage = double(benchData.voltage_v);
    validVoltage = voltage(isfinite(voltage));
    if any(validVoltage <= 0) || any(validVoltage > 30)
        warnings(end + 1, 1) = "Напряжение выходит за ожидаемый диапазон 6S.";
    end
else
    warnings(end + 1, 1) = "Поле voltage_v отсутствует.";
end

if hasVariable(benchData, "current_a")
    current = double(benchData.current_a);
    validCurrent = current(isfinite(current));
    if any(validCurrent < -0.1) || any(validCurrent > 150)
        warnings(end + 1, 1) = "Ток выходит за ожидаемый диапазон.";
    end
else
    warnings(end + 1, 1) = "Поле current_a отсутствует.";
end

if hasVariable(benchData, "normalized_input") && hasVariable(benchData, "thrust_n")
    [uSorted, order] = sort(double(benchData.normalized_input));
    thrustSorted = double(benchData.thrust_n(order));
    valid = isfinite(uSorted) & isfinite(thrustSorted);
    if nnz(valid) >= 3 && any(diff(thrustSorted(valid)) < -0.5)
        warnings(end + 1, 1) = "Тяга не является монотонной по normalized_input.";
    end
end

if hasVariable(benchData, "propeller_type")
    propellers = string(benchData.propeller_type);
    hasKnownPropeller = any(contains(propellers, "Gemfan 8060")) || any(contains(propellers, "APC 7x11E"));
    if ~hasKnownPropeller
        warnings(end + 1, 1) = "Тип винта не совпадает с Gemfan 8060 или APC 7x11E.";
    end
else
    warnings(end + 1, 1) = "Поле propeller_type отсутствует.";
end

isValid = ~any(contains(warnings, "отсутствует")) && ~any(contains(warnings, "отрицательная"));
report = struct();
report.is_valid = isValid;
report.status = "checked";
report.row_count = height(benchData);
report.warnings = unique(warnings, 'stable');
end

function result = hasVariable(tableIn, name)
result = any(string(tableIn.Properties.VariableNames) == string(name));
end

function report = makeReport(isValid, status, warning)
report = struct();
report.is_valid = isValid;
report.status = string(status);
report.row_count = 0;
report.warnings = string(warning);
end
