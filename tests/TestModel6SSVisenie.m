classdef TestModel6SSVisenie < matlab.unittest.TestCase
    % Проверка висения модели движения с шестью степенями свободы.

    methods (Test)
        function testVisenie(testCase)
            konfiguratsiya = kopterkm.konfiguratsiya.sozdatKonfiguratsiyuPoUmolchaniyu();
            konfiguratsiya.geometriya.tsentr_mass_cad_mm = [0; 0; 0];
            konfiguratsiya.geometriya.motor_1_raw_cad_mm = [-100; -100; 0];
            konfiguratsiya.geometriya.motor_2_raw_cad_mm = [100; -100; 0];
            konfiguratsiya.geometriya.motor_3_raw_cad_mm = [100; 100; 0];
            konfiguratsiya.geometriya.motor_4_raw_cad_mm = [-100; 100; 0];
            konfiguratsiya.geometriya.znak_vrashcheniya = [1; -1; 1; -1];

            model = kopterkm.modeli.ModelDvizheniya6SS(konfiguratsiya);
            x = zeros(16, 1);
            tyaga = model.massa_kg * model.g_m_s2 / 4;
            x(13:16) = tyaga;
            u = sqrt(tyaga / model.kT) * ones(4, 1);

            dx = kopterkm.modeli.pravayaChast6SS(0, x, u, model);
            testCase.verifyEqual(dx(4:6), zeros(3, 1), 'AbsTol', 1e-10);
            testCase.verifyEqual(dx(10:12), zeros(3, 1), 'AbsTol', 1e-10);
            testCase.verifyEqual(dx(13:16), zeros(4, 1), 'AbsTol', 1e-10);
        end
    end
end
