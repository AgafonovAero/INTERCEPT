function [model, fitReport] = fitCurrentModel(benchData)
% Подбирает первичную модель тока винтомоторной группы.

warnings = strings(0, 1);
model = struct();
model.type = "not_fitted";
model.b0 = NaN;
model.b1 = NaN;
model.b2 = NaN;
model.coefficients = [NaN; NaN; NaN];

if isempty(benchData) || ~hasVariable(benchData, "current_a")
    warnings(end + 1, 1) = "Стендовые данные тока отсутствуют.";
    fitReport = makeReport("bench_data_not_available", warnings, NaN);
    return;
end

u = readInput(benchData);
current = double(benchData.current_a);
valid = isfinite(u) & isfinite(current);
if nnz(valid) < 3
    warnings(end + 1, 1) = "Недостаточно точек для подбора модели тока.";
    fitReport = makeReport("insufficient_data", warnings, NaN);
    return;
end

design = [ones(nnz(valid), 1), u(valid), u(valid) .^ 2];
coefficients = design \ current(valid);
model.type = "quadratic_input";
model.b0 = coefficients(1);
model.b1 = coefficients(2);
model.b2 = coefficients(3);
model.coefficients = coefficients(:);
fitReport = makeReport("fitted_from_bench", warnings, sqrt(mean((current(valid) - design * coefficients) .^ 2)));
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

function result = hasVariable(tableIn, name)
result = any(string(tableIn.Properties.VariableNames) == string(name));
end

function fitReport = makeReport(status, warnings, rmseValue)
fitReport = struct();
fitReport.status = string(status);
fitReport.rmse = rmseValue;
fitReport.warnings = unique(warnings, 'stable');
end
