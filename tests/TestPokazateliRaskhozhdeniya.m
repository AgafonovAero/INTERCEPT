classdef TestPokazateliRaskhozhdeniya < matlab.unittest.TestCase
    % Проверка расчета показателей расхождения.

    methods (Test)
        function testPokazateli(testCase)
            yRef = [1; 2; 3; 4];
            yCalc = [1; 2; 2; 4];
            p = kopterkm.validatsiya.raschitatPokazateliRaskhozhdeniya(yRef, yCalc);

            testCase.verifyEqual(p.srednekvadraticheskoe_otklonenie, 0.5, 'AbsTol', 1e-12);
            testCase.verifyEqual(p.srednee_absolyutnoe_otklonenie, 0.25, 'AbsTol', 1e-12);
            testCase.verifyEqual(p.maksimalnoe_absolyutnoe_otklonenie, 1, 'AbsTol', 1e-12);
            testCase.verifyTrue(isfield(p.russkie_nazvaniya, 'pokazatel_sootvetstviya_proc'));
        end
    end
end
