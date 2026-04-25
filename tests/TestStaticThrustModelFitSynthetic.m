classdef TestStaticThrustModelFitSynthetic < matlab.unittest.TestCase
    % Проверяет подбор квадратичной модели тяги по синтетическим данным.

    methods (Test)
        function testQuadraticFit(testCase)
            u = transpose(linspace(0, 1, 20));
            benchData = table();
            benchData.normalized_input = u;
            benchData.thrust_n = 0.2 + 3.0 * u + 12.0 * u .^ 2;

            [model, report] = copter.propulsion.fitStaticThrustModel(benchData);

            testCase.verifyEqual(report.status, "fitted_from_bench");
            testCase.verifyEqual([model.a0; model.a1; model.a2], [0.2; 3.0; 12.0], 'AbsTol', 1e-10);
        end
    end
end
