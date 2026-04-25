classdef TestPreprocessLogData < matlab.unittest.TestCase
    % Проверка препроцессора без реального бортового журнала.

    methods (Test)
        function testPreprocess(testCase)
            dataTable = table();
            dataTable.TimeUS = [30000; 0; 10000; 10000; 20000];
            dataTable.("ATT.Roll") = [3; 0; 1; 1; 2];
            dataTable.("ATT.Pitch") = [0; 0; 0; 0; 0];
            dataTable.("RATE.R") = [30; 0; 10; 10; 20];
            dataTable.("RATE.P") = [0; 0; 0; 0; 0];
            dataTable.("RATE.Y") = [0; 0; 0; 0; 0];
            dataTable.("RCOU.C1") = [1500; 1500; 1500; 1500; 1500];
            dataTable.("RCOU.C2") = [1500; 1500; 1500; 1500; 1500];
            dataTable.("RCOU.C3") = [1500; 1500; 1500; 1500; 1500];
            dataTable.("RCOU.C4") = [1500; 1500; 1500; 1500; 1500];

            config = copter.config.defaultVehicleConfig();
            [processedData, quality] = copter.data.preprocessLogData(dataTable, config, 100);

            testCase.verifyTrue(istimetable(processedData));
            testCase.verifyTrue(any(string(processedData.Properties.VariableNames) == "ATT.Roll_rad"));
            testCase.verifyTrue(any(string(processedData.Properties.VariableNames) == "RCOU.C1_norm"));
            testCase.verifyGreaterThanOrEqual(height(processedData), 4);
            testCase.verifyEqual(quality.time.duplicate_count, 1);
        end
    end
end
