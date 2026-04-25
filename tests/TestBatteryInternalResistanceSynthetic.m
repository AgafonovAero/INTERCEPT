classdef TestBatteryInternalResistanceSynthetic < matlab.unittest.TestCase
    % Проверяет оценку внутреннего сопротивления аккумулятора.

    methods (Test)
        function testResistanceFit(testCase)
            current = transpose(linspace(0, 40, 20));
            resistance = 0.035;
            voltage = 24.5 - current * resistance;
            batteryData = table();
            batteryData.current_a = current;
            batteryData.voltage_v = voltage;
            batteryData.capacity_mah = repmat(7000, numel(current), 1);

            [model, report] = copter.propulsion.fitBatteryInternalResistance(batteryData);

            testCase.verifyEqual(report.status, "fitted_from_bench");
            testCase.verifyEqual(model.internal_resistance_ohm, resistance, 'AbsTol', 1e-10);
            testCase.verifyEqual(model.capacity_mah, 7000);
        end
    end
end
