classdef TestPrimitiveControllerHover < matlab.unittest.TestCase
    % Проверка примитивных регуляторов для режима висения.

    methods (Test)
        function testZeroErrors(testCase)
            [uRoll, uPitch, uYaw] = copter.control.PrimitiveAttitudeController( ...
                zeros(3, 1), zeros(3, 1), zeros(3, 1), zeros(3, 1), struct());
            [collectiveThrust, normalizedCollective] = copter.control.PrimitiveAltitudeController( ...
                10, 0, 10, 0, 3.269, struct('kT', 40));

            testCase.verifyEqual([uRoll; uPitch; uYaw], zeros(3, 1), 'AbsTol', 1.0e-12);
            testCase.verifyGreaterThan(collectiveThrust, 0);
            testCase.verifyGreaterThan(normalizedCollective, 0);
            testCase.verifyLessThanOrEqual(normalizedCollective, 1);
        end

        function testCommandLimits(testCase)
            gains = struct();
            gains.command_limit = [0.05; 0.06; 0.07];
            [uRoll, uPitch, uYaw] = copter.control.PrimitiveAttitudeController( ...
                [10; -10; 10], zeros(3, 1), zeros(3, 1), zeros(3, 1), gains);

            testCase.verifyLessThanOrEqual(abs(uRoll), gains.command_limit(1));
            testCase.verifyLessThanOrEqual(abs(uPitch), gains.command_limit(2));
            testCase.verifyLessThanOrEqual(abs(uYaw), gains.command_limit(3));
        end
    end
end
