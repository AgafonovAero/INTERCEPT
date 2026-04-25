classdef TestMetricRobustness < matlab.unittest.TestCase
    % Проверка устойчивости показателей расхождения.

    methods (Test)
        function testNormalFit(testCase)
            reference = transpose(sin(0:0.1:4));
            calculated = reference + 0.01;
            metrics = copter.validation.computeMetrics(reference, calculated);

            testCase.verifyGreaterThan(metrics.fit_percent, 90);
            testCase.verifyTrue(metrics.valid_metric_flag);
            testCase.verifyTrue(strlength(metrics.metric_warning) == 0);
        end

        function testAlmostConstantReference(testCase)
            reference = ones(100, 1);
            calculated = reference + transpose(linspace(0, 1, 100));
            options = struct();
            options.fit_epsilon_denominator = 1.0e-6;
            metrics = copter.validation.computeMetrics(reference, calculated, options);

            testCase.verifyTrue(isnan(metrics.fit_percent));
            testCase.verifyFalse(metrics.valid_metric_flag);
            testCase.verifyTrue(contains(metrics.metric_warning, "Показатель соответствия не применим"));
        end
    end
end
