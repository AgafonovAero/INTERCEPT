classdef TestPwmNormalizationFromParams < matlab.unittest.TestCase
    % Проверяет построение нормирования RCOU по параметрам ArduPilot.

    methods (Test)
        function testUsesMotPwmParams(testCase)
            vehicleConfig = copter.config.defaultVehicleConfig();
            params = struct();
            params.MOT_PWM_MIN = 1100;
            params.MOT_PWM_MAX = 1900;
            params.SERVO1_MIN = 1005;
            params.SERVO1_MAX = 1995;
            params.SERVO1_TRIM = 1500;

            [normalization, warnings] = copter.data.buildPwmNormalizationFromParams(params, vehicleConfig);

            testCase.verifyEqual(normalization.pwm_min, 1100);
            testCase.verifyEqual(normalization.pwm_max, 1900);
            testCase.verifyEqual(normalization.servo_min(1), 1005);
            testCase.verifyEmpty(warnings);
        end

        function testFallbackUsesVehicleConfig(testCase)
            vehicleConfig = copter.config.defaultVehicleConfig();
            params = struct();

            [normalization, warnings] = copter.data.buildPwmNormalizationFromParams(params, vehicleConfig);

            testCase.verifyEqual(normalization.pwm_min, vehicleConfig.normalization.pwm_min);
            testCase.verifyEqual(normalization.pwm_max, vehicleConfig.normalization.pwm_max);
            testCase.verifyGreaterThanOrEqual(numel(warnings), 2);
        end
    end
end
