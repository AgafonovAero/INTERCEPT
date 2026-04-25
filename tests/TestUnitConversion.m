classdef TestUnitConversion < matlab.unittest.TestCase
    % Проверки пересчета единиц измерения и нормирования ШИМ.

    methods (Test)
        function testAngleAndRateConversion(testCase)
            dataTable = table();
            dataTable.TimeUS = [0; 10000];
            dataTable.("ATT.Roll") = [0; 90];
            dataTable.("ATT.Pitch") = [0; -45];
            dataTable.("ATT.Yaw") = [350; 370];
            dataTable.("RATE.R") = [0; 180];

            converted = copter.data.convertUnits(dataTable);
            roll = converted.("ATT.Roll_rad");
            pitch = converted.("ATT.Pitch_rad");
            rate = converted.("RATE.R_rad_s");

            testCase.verifyEqual(roll(2), pi / 2, 'AbsTol', 1e-12);
            testCase.verifyEqual(pitch(2), -pi / 4, 'AbsTol', 1e-12);
            testCase.verifyEqual(rate(2), pi, 'AbsTol', 1e-12);
        end

        function testPwmNormalization(testCase)
            value = copter.utils.normalizePwm([900; 1000; 1500; 2000; 2100], 1000, 2000);
            testCase.verifyEqual(value, [0; 0; 0.5; 1; 1], 'AbsTol', 1e-12);
        end
    end
end
