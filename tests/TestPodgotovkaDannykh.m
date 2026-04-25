classdef TestPodgotovkaDannykh < matlab.unittest.TestCase
    % Проверка подготовки данных без реального бортового журнала.

    methods (Test)
        function testPodgotovka(testCase)
            T = table();
            T.TimeUS = [30000; 0; 10000; 10000; 20000];
            T.("ATT.Roll") = [3; 0; 1; 1; 2];
            T.("ATT.Pitch") = [0; 0; 0; 0; 0];
            T.("RATE.R") = [30; 0; 10; 10; 20];
            T.("RATE.P") = [0; 0; 0; 0; 0];
            T.("RATE.Y") = [0; 0; 0; 0; 0];
            T.("RCOU.C1") = [1500; 1500; 1500; 1500; 1500];
            T.("RCOU.C2") = [1500; 1500; 1500; 1500; 1500];
            T.("RCOU.C3") = [1500; 1500; 1500; 1500; 1500];
            T.("RCOU.C4") = [1500; 1500; 1500; 1500; 1500];

            konfiguratsiya = kopterkm.konfiguratsiya.sozdatKonfiguratsiyuPoUmolchaniyu();
            [TT, kachestvo] = kopterkm.dannye.podgotovitDannye(T, konfiguratsiya, 100);

            testCase.verifyTrue(istimetable(TT));
            testCase.verifyTrue(any(string(TT.Properties.VariableNames) == "ATT.Roll_rad"));
            testCase.verifyTrue(any(string(TT.Properties.VariableNames) == "RCOU.C1_norm"));
            testCase.verifyGreaterThanOrEqual(height(TT), 4);
            testCase.verifyEqual(kachestvo.vremya.chislo_dubley, 1);
        end
    end
end
