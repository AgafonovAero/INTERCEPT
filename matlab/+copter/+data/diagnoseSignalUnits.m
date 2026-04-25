function diagnostics = diagnoseSignalUnits(dataSet)
% Диагностирует единицы измерения сигналов для ModelRate.

dataTable = localTable(dataSet);
diagnostics = struct();
diagnostics.warnings = strings(0, 1);
diagnostics.rate_unit_guess = strings(3, 1);
diagnostics.attitude_unit_guess = strings(3, 1);
diagnostics.internal_rate_rad_s_available = false(3, 1);

rateNames = ["RATE.R", "RATE.P", "RATE.Y"];
rateRadNames = ["RATE.R_rad_s", "RATE.P_rad_s", "RATE.Y_rad_s"];
for index = 1:numel(rateNames)
    diagnostics.internal_rate_rad_s_available(index) = hasVariable(dataTable, rateRadNames(index));
    if hasVariable(dataTable, rateNames(index))
        values = double(dataTable.(rateNames(index)));
        diagnostics.rate_unit_guess(index) = guessRateUnit(values);
    elseif diagnostics.internal_rate_rad_s_available(index)
        diagnostics.rate_unit_guess(index) = "рад/с";
    else
        diagnostics.rate_unit_guess(index) = "канал отсутствует";
        diagnostics.warnings(end + 1, 1) = "Отсутствует канал " + rateNames(index) + ".";
    end

    if ~diagnostics.internal_rate_rad_s_available(index)
        diagnostics.warnings(end + 1, 1) = "Для " + rateNames(index) + " нет внутреннего канала в рад/с.";
    end
end

attitudeNames = ["ATT.Roll", "ATT.Pitch", "ATT.Yaw"];
for index = 1:numel(attitudeNames)
    if hasVariable(dataTable, attitudeNames(index))
        diagnostics.attitude_unit_guess(index) = guessAngleUnit(double(dataTable.(attitudeNames(index))));
    else
        diagnostics.attitude_unit_guess(index) = "канал отсутствует";
        diagnostics.warnings(end + 1, 1) = "Отсутствует канал " + attitudeNames(index) + ".";
    end
end

if any(diagnostics.rate_unit_guess == "неоднозначно")
    diagnostics.warnings(end + 1, 1) = "Диапазон RATE.R/P/Y неоднозначен для уверенного выбора единиц измерения.";
end

if any(diagnostics.attitude_unit_guess == "неоднозначно")
    diagnostics.warnings(end + 1, 1) = "Диапазон ATT.Roll/Pitch/Yaw неоднозначен для уверенного выбора единиц измерения.";
end

diagnostics.note = "Внутреннее представление ModelRate должно использовать рад/с.";
end

function guess = guessRateUnit(values)
finiteValues = abs(values(isfinite(values)));
if isempty(finiteValues)
    guess = "неоднозначно";
    return;
end

percentileValue = prctile(finiteValues, 95);
if percentileValue > 25
    guess = "град/с";
elseif percentileValue < 0.5
    guess = "неоднозначно";
elseif percentileValue < 12
    guess = "рад/с";
else
    guess = "град/с";
end
end

function guess = guessAngleUnit(values)
finiteValues = abs(values(isfinite(values)));
if isempty(finiteValues)
    guess = "неоднозначно";
    return;
end

percentileValue = prctile(finiteValues, 95);
if percentileValue > 2 * pi
    guess = "град";
elseif percentileValue < 0.2
    guess = "неоднозначно";
else
    guess = "рад";
end
end

function dataTable = localTable(dataSet)
if istimetable(dataSet)
    dataTable = timetable2table(dataSet, 'ConvertRowTimes', false);
else
    dataTable = dataSet;
end
end

function result = hasVariable(dataTable, variableName)
result = any(string(dataTable.Properties.VariableNames) == string(variableName));
end
