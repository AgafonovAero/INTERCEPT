function [model, fitReport] = fitStaticThrustModel(benchData)
% Подбирает первичную статическую модель тяги винтомоторной группы.

warnings = strings(0, 1);
model = defaultModel();
if isempty(benchData) || ~hasVariable(benchData, "thrust_n")
    warnings(end + 1, 1) = "Стендовые данные тяги отсутствуют.";
    fitReport = makeReport("bench_data_not_available", warnings, NaN);
    return;
end

if hasVariable(benchData, "rpm") && any(isfinite(double(benchData.rpm)))
    rpm = double(benchData.rpm);
    thrust = double(benchData.thrust_n);
    valid = isfinite(rpm) & isfinite(thrust) & rpm > 0;
    if nnz(valid) >= 2
        coefficient = rpm(valid) .^ 2 \ thrust(valid);
        model.type = "rpm_squared";
        model.kT_rpm = coefficient;
        model.coefficients = [0; 0; coefficient];
        fitReport = makeReport("fitted_from_bench", warnings, rmse(thrust(valid), coefficient * rpm(valid) .^ 2));
        return;
    end
end

u = readInput(benchData);
thrust = double(benchData.thrust_n);
valid = isfinite(u) & isfinite(thrust);
if nnz(valid) < 3
    warnings(end + 1, 1) = "Недостаточно точек для подбора модели тяги.";
    fitReport = makeReport("insufficient_data", warnings, NaN);
    return;
end

design = [ones(nnz(valid), 1), u(valid), u(valid) .^ 2];
coefficients = design \ thrust(valid);
model.type = "quadratic_input";
model.a0 = coefficients(1);
model.a1 = coefficients(2);
model.a2 = coefficients(3);
model.coefficients = coefficients(:);
fitReport = makeReport("fitted_from_bench", warnings, rmse(thrust(valid), design * coefficients));
end

function model = defaultModel()
model = struct();
model.type = "not_fitted";
model.a0 = NaN;
model.a1 = NaN;
model.a2 = NaN;
model.kT_rpm = NaN;
model.coefficients = [NaN; NaN; NaN];
model.note = "Точность модели не заявляется без стендовой неопределенности.";
end

function u = readInput(benchData)
if hasVariable(benchData, "normalized_input")
    u = double(benchData.normalized_input);
elseif hasVariable(benchData, "input_command")
    u = double(benchData.input_command);
elseif hasVariable(benchData, "pwm_us")
    u = (double(benchData.pwm_us) - 1000) ./ 1000;
else
    u = NaN(height(benchData), 1);
end
end

function value = rmse(reference, estimate)
value = sqrt(mean((reference - estimate) .^ 2, 'omitnan'));
end

function result = hasVariable(tableIn, name)
result = any(string(tableIn.Properties.VariableNames) == string(name));
end

function fitReport = makeReport(status, warnings, rmseValue)
fitReport = struct();
fitReport.status = string(status);
fitReport.rmse = rmseValue;
fitReport.warnings = unique(warnings, 'stable');
fitReport.note = "Модель тяги является первичной и должна уточняться по стендовым данным с неопределенностью.";
end
