classdef TestArduPilotParamExtractionSynthetic < matlab.unittest.TestCase
    % Проверяет извлечение параметров ArduPilot из синтетического PARM.

    methods (Test)
        function testExtractsFrameMotServoParams(testCase)
            parmTable = table( ...
                ["FRAME_CLASS"; "FRAME_TYPE"; "MOT_PWM_MIN"; "MOT_PWM_MAX"; "SERVO1_FUNCTION"], ...
                [1; 1; 1100; 1900; 33], ...
                'VariableNames', {'Name', 'Value'});
            logData = struct();
            logData.messages = struct();
            logData.messages.PARM = parmTable;

            [params, report] = copter.data.extractArduPilotParams(logData);

            testCase.verifyEqual(params.FRAME_CLASS, 1);
            testCase.verifyEqual(params.FRAME_TYPE, 1);
            testCase.verifyEqual(params.MOT_PWM_MIN, 1100);
            testCase.verifyEqual(params.MOT_PWM_MAX, 1900);
            testCase.verifyEqual(params.SERVO1_FUNCTION, 33);
            testCase.verifyEqual(report.parameter_count, 5);
        end

        function testMissingParmCreatesWarning(testCase)
            logData = struct();
            logData.messages = struct();

            [params, report] = copter.data.extractArduPilotParams(logData);

            testCase.verifyTrue(isnan(params.FRAME_CLASS));
            testCase.verifyGreaterThan(numel(report.warnings), 0);
        end
    end
end
