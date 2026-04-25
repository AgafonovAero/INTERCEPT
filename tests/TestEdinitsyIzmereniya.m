classdef TestEdinitsyIzmereniya < matlab.unittest.TestCase
    % Проверки пересчета единиц измерения и нормирования ШИМ.

    methods (Test)
        function testPereschetUglov(testCase)
            T = table();
            T.TimeUS = [0; 10000];
            T.("ATT.Roll") = [0; 90];
            T.("ATT.Pitch") = [0; -45];
            T.("ATT.Yaw") = [350; 370];
            T.("RATE.R") = [0; 180];

            T2 = kopterkm.dannye.privestiEdinitsyIzmereniya(T);
            roll = T2.("ATT.Roll_rad");
            pitch = T2.("ATT.Pitch_rad");
            rateR = T2.("RATE.R_rad_s");

            testCase.verifyEqual(roll(2), pi / 2, 'AbsTol', 1e-12);
            testCase.verifyEqual(pitch(2), -pi / 4, 'AbsTol', 1e-12);
            testCase.verifyEqual(rateR(2), pi, 'AbsTol', 1e-12);
        end

        function testNormalizatsiyaRcou(testCase)
            u = kopterkm.sluzhebnye.normalizatsiyaShIM([900; 1000; 1500; 2000; 2100], 1000, 2000);
            testCase.verifyEqual(u, [0; 0; 0.5; 1; 1], 'AbsTol', 1e-12);
        end
    end
end
