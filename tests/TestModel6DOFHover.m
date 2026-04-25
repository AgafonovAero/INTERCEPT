classdef TestModel6DOFHover < matlab.unittest.TestCase
    % Проверка висения модели движения с шестью степенями свободы.

    methods (Test)
        function testHover(testCase)
            config = copter.config.defaultVehicleConfig();
            config.geometry.cad_cg_mm = [0; 0; 0];
            config.geometry.motor_1_raw_cad_mm = [-100; -100; 0];
            config.geometry.motor_2_raw_cad_mm = [100; -100; 0];
            config.geometry.motor_3_raw_cad_mm = [100; 100; 0];
            config.geometry.motor_4_raw_cad_mm = [-100; 100; 0];
            config.geometry.spin_sign = [1; -1; 1; -1];

            model = copter.models.Model6DOF(config);
            state = zeros(16, 1);
            thrustPerMotor = model.mass_kg * model.g_m_s2 / 4;
            state(13:16) = thrustPerMotor;
            input = sqrt(thrustPerMotor / model.kT) * ones(4, 1);

            derivative = copter.models.rhs6DOF(0, state, input, model);
            testCase.verifyEqual(derivative(4:6), zeros(3, 1), 'AbsTol', 1e-10);
            testCase.verifyEqual(derivative(10:12), zeros(3, 1), 'AbsTol', 1e-10);
            testCase.verifyEqual(derivative(13:16), zeros(4, 1), 'AbsTol', 1e-10);
        end
    end
end
