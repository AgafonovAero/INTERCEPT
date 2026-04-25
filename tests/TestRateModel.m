classdef TestRateModel < matlab.unittest.TestCase
    % Проверка синтетической идентификации модели угловых скоростей.

    methods (Test)
        function testSyntheticIdentification(testCase)
            [dataTable, expectedA, expectedB, expectedC] = createSyntheticRateTable();
            config = copter.config.defaultVehicleConfig();
            config.rate_model.max_input_delay_steps = 1;
            result = copter.identification.fitRateModel(dataTable, config, [0.1, 14.9]);

            testCase.verifyEqual(diag(result.A), diag(expectedA), 'AbsTol', 0.03);
            testCase.verifyEqual(diag(result.B), diag(expectedB), 'AbsTol', 0.03);
            testCase.verifyEqual(result.c, expectedC, 'AbsTol', 0.03);
        end
    end
end

function [dataTable, A, B, c] = createSyntheticRateTable()
timeStep = 0.005;
timeSeconds = transpose(0:timeStep:15);
A = diag([-1.1, -0.8, -0.6]);
B = diag([2.0, 1.5, 1.0]);
c = [0.1; -0.05; 0.02];
input = [
    sin(0.8 * timeSeconds), ...
    cos(0.5 * timeSeconds), ...
    sin(0.3 * timeSeconds + 0.2)
    ];
state = zeros(numel(timeSeconds), 3);

for index = 1:(numel(timeSeconds) - 1)
    step = timeStep;
    currentState = transpose(state(index, :));
    inputStart = transpose(input(index, :));
    inputEnd = transpose(input(index + 1, :));
    inputMiddle = 0.5 * (inputStart + inputEnd);
    rhs = @(x, u) A * x + B * u + c;
    k1 = rhs(currentState, inputStart);
    k2 = rhs(currentState + step * k1 / 2, inputMiddle);
    k3 = rhs(currentState + step * k2 / 2, inputMiddle);
    k4 = rhs(currentState + step * k3, inputEnd);
    state(index + 1, :) = transpose(currentState + step * (k1 + 2 * k2 + 2 * k3 + k4) / 6);
end

dataTable = table();
dataTable.t_s = timeSeconds;
dataTable.("RATE.R_rad_s") = state(:, 1);
dataTable.("RATE.P_rad_s") = state(:, 2);
dataTable.("RATE.Y_rad_s") = state(:, 3);
dataTable.("RATE.ROut") = input(:, 1);
dataTable.("RATE.POut") = input(:, 2);
dataTable.("RATE.YOut") = input(:, 3);
end
