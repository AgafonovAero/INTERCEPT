classdef TestMetrics < matlab.unittest.TestCase
    % Проверка расчета показателей расхождения.

    methods (Test)
        function testMetrics(testCase)
            reference = [1; 2; 3; 4];
            calculated = [1; 2; 2; 4];
            metrics = copter.validation.computeMetrics(reference, calculated);

            testCase.verifyEqual(metrics.rmse, 0.5, 'AbsTol', 1e-12);
            testCase.verifyEqual(metrics.mae, 0.25, 'AbsTol', 1e-12);
            testCase.verifyEqual(metrics.max_abs, 1, 'AbsTol', 1e-12);
            testCase.verifyTrue(isfield(metrics.russian_names, 'fit_percent'));
        end
    end
end
