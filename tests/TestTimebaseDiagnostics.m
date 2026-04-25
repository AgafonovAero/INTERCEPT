classdef TestTimebaseDiagnostics < matlab.unittest.TestCase
    % Проверка диагностики временной базы.

    methods (Test)
        function testUniformTimebase(testCase)
            dataTable = table();
            dataTable.t_s = transpose(0:0.01:2);
            diagnostics = copter.data.diagnoseTimebase(dataTable, 100);

            testCase.verifyTrue(diagnostics.is_uniform);
            testCase.verifyEqual(diagnostics.duplicate_time_count, 0);
            testCase.verifyLessThan(diagnostics.missing_sample_percent, 1);
        end

        function testDuplicateTime(testCase)
            dataTable = table();
            dataTable.t_s = [0; 0.01; 0.01; 0.02; 0.03];
            diagnostics = copter.data.diagnoseTimebase(dataTable, 100);

            testCase.verifyGreaterThan(diagnostics.duplicate_time_count, 0);
            testCase.verifyTrue(any(contains(diagnostics.warnings, "дубли")));
        end

        function testMissingSamples(testCase)
            dataTable = table();
            dataTable.t_s = [0; 0.01; 0.02; 0.20; 0.21];
            diagnostics = copter.data.diagnoseTimebase(dataTable, 100);

            testCase.verifyGreaterThan(diagnostics.missing_sample_percent, 0);
            testCase.verifyTrue(any(contains(diagnostics.warnings, "пропуски")));
        end
    end
end
