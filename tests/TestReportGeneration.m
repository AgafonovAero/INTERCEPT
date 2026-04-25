classdef TestReportGeneration < matlab.unittest.TestCase
    % Проверка формирования отчета и предупреждений исходных данных.

    methods (Test)
        function testReport(testCase)
            config = copter.config.defaultVehicleConfig();
            [~, warnings] = copter.config.validateConfig(config);
            testCase.verifyTrue(any(contains(warnings, "Gemfan 8060")));
            testCase.verifyTrue(any(contains(warnings, "APC 7x11E")));

            metrics = struct();
            metrics.rmse = [0.1, 0.2, 0.3];
            metrics.mae = [0.08, 0.15, 0.22];
            metrics.max_abs = [0.3, 0.4, 0.5];
            metrics.nrmse = [0.05, 0.06, 0.07];
            metrics.fit_percent = [80, 75, 65];

            validation = struct();
            validation.metrics = metrics;
            validation.validation_matrix = copter.validation.buildValidationMatrix(metrics, [2, 4], config);

            identification = struct();
            identification.A = diag([-1, -1, -1]);
            identification.B = eye(3);
            identification.c = zeros(3, 1);

            quality = struct();
            quality.available_channels = ["RATE.R"; "RATE.P"; "RATE.Y"];
            quality.warnings = warnings;

            reportData = struct();
            reportData.config = config;
            reportData.data_quality = quality;
            reportData.identification = identification;
            reportData.validation = validation;
            reportData.segments = struct('identification', [0, 2], 'validation', [2, 4]);

            reportPath = fullfile(tempdir, 'validation_report_test.md');
            text = copter.reports.writeMarkdownReport(reportPath, reportData);

            testCase.verifyTrue(isfile(reportPath));
            testCase.verifyTrue(contains(text, "Данная проверка выполнена по данным бортового журнала"));
            testCase.verifyTrue(contains(text, "Gemfan 8060"));
            testCase.verifyTrue(contains(text, "APC 7x11E"));
            testCase.verifyTrue(contains(text, "Матрица валидации"));
        end
    end
end
