classdef TestRateDiscreteModelSynthetic < matlab.unittest.TestCase
    % Проверка синтетической дискретной идентификации ModelRateDiscrete.

    methods (Test)
        function testDiscreteIdentification(testCase)
            [processedData, trueModel] = makeDiscreteData();
            segments = makeSegments();
            settings = struct();
            settings.input_delay_search_samples = 0;
            settings.max_condition_number = 1.0e12;
            settings.ridge_lambda = 1.0e-8;

            [model, fitReport, warnings] = copter.identification.fitRateModelDiscreteFromSegments( ...
                processedData, segments, settings);

            testCase.verifyLessThan(norm(model.Ad - trueModel.Ad), 1.0e-8);
            testCase.verifyLessThan(norm(model.Bd - trueModel.Bd), 1.0e-8);
            testCase.verifyLessThan(norm(model.cd - trueModel.cd), 1.0e-8);
            testCase.verifyFalse(isempty(fitReport));
            testCase.verifyClass(warnings, 'string');
        end
    end
end

function [processedData, model] = makeDiscreteData()
t = transpose(0:0.01:20);
Ad = diag([0.985, 0.982, 0.98]);
Bd = diag([0.020, 0.018, 0.015]);
cd = [0.001; -0.001; 0.0005];
model = copter.models.ModelRateDiscrete(Ad, Bd, cd, 0, 0.01);
u = [
    0.3 * sin(0.7 * t), ...
    0.2 * cos(0.5 * t), ...
    0.15 * sin(0.9 * t)
    ];
omega = zeros(numel(t), 3);
for index = 1:(numel(t) - 1)
    omega(index + 1, :) = transpose(Ad * transpose(omega(index, :)) + Bd * transpose(u(index, :)) + cd);
end

dataTable = table();
dataTable.t_s = t;
dataTable.log_file = repmat("synthetic.BIN", numel(t), 1);
dataTable.("RATE.R_rad_s") = omega(:, 1);
dataTable.("RATE.P_rad_s") = omega(:, 2);
dataTable.("RATE.Y_rad_s") = omega(:, 3);
dataTable.("RATE.R") = rad2deg(omega(:, 1));
dataTable.("RATE.P") = rad2deg(omega(:, 2));
dataTable.("RATE.Y") = rad2deg(omega(:, 3));
dataTable.("RATE.ROut") = u(:, 1);
dataTable.("RATE.POut") = u(:, 2);
dataTable.("RATE.YOut") = u(:, 3);
processedData = table2timetable(dataTable, 'RowTimes', seconds(t));
end

function segments = makeSegments()
segments = table( ...
    "synthetic_discrete", ...
    "synthetic.BIN", ...
    "В-10", ...
    "roll_response_candidate", ...
    2, ...
    18, ...
    16, ...
    "identification", ...
    'VariableNames', { ...
    'segment_id', ...
    'log_file', ...
    'candidate_validation_case_id', ...
    'segment_type', ...
    't_start_s', ...
    't_end_s', ...
    'duration_s', ...
    'split_role'});
end
