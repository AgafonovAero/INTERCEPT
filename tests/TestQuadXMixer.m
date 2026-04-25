classdef TestQuadXMixer < matlab.unittest.TestCase
    % Проверка смесителя QUAD/X.

    methods (Test)
        function testCollectiveDistribution(testCase)
            [motorCommand, saturationFlags] = copter.control.quadXMixer(0.5, 0, 0, 0, []);

            testCase.verifyEqual(motorCommand, 0.5 * ones(4, 1), 'AbsTol', 1.0e-12);
            testCase.verifyFalse(any(saturationFlags));
        end

        function testAxisCommands(testCase)
            [rollCommand, ~] = copter.control.quadXMixer(0.5, 0.1, 0, 0, []);
            [pitchCommand, ~] = copter.control.quadXMixer(0.5, 0, 0.1, 0, []);
            [yawCommand, ~] = copter.control.quadXMixer(0.5, 0, 0, 0.1, []);

            testCase.verifyNotEqual(rollCommand(1), rollCommand(3));
            testCase.verifyNotEqual(pitchCommand(1), pitchCommand(2));
            testCase.verifyNotEqual(yawCommand(1), yawCommand(2));
        end

        function testSaturation(testCase)
            [motorCommand, saturationFlags] = copter.control.quadXMixer(1.2, 1, 1, 1, []);

            testCase.verifyTrue(all(motorCommand >= 0 & motorCommand <= 1));
            testCase.verifyTrue(any(saturationFlags));
        end
    end
end
