classdef TestConfirmedVehicleConfigStatus < matlab.unittest.TestCase
    % Проверяет статусы подтвержденной и гипотетической конфигурации.

    methods (Test)
        function testHypothesisStatusWhenNoPhysicalCheck(testCase)
            vehicleConfig = copter.config.defaultVehicleConfig();
            [confirmedConfig, report] = copter.physical.buildConfirmedVehicleConfig(vehicleConfig, struct(), []);

            testCase.verifyEqual(confirmedConfig.configuration_status.motor_map_status, "hypothesis_from_log");
            testCase.verifyEqual(report.status, "hypothesis_from_log");
        end

        function testPhysicalStatusWhenCheckIsValid(testCase)
            vehicleConfig = copter.config.defaultVehicleConfig();
            physicalCheck = makePhysicalCheck();

            [confirmedConfig, report] = copter.physical.buildConfirmedVehicleConfig(vehicleConfig, physicalCheck, []);

            testCase.verifyEqual(confirmedConfig.configuration_status.motor_map_status, "physically_confirmed");
            testCase.verifyEqual(report.status, "physically_confirmed");
        end
    end
end

function physicalCheck = makePhysicalCheck()
physicalCheck = struct();
physicalCheck.vehicle_id = "qc_ardupilot_v0";
physicalCheck.status = "physically_confirmed";
physicalCheck.check_date = "2026-04-25";
physicalCheck.performed_by = "test";
physicalCheck.approved_by = "test";
physicalCheck.vehicle_nose_direction = "x forward";
physicalCheck.installed_propeller_type = "Gemfan 8060, 3 лопасти";
for index = 1:4
    physicalCheck.motors(index).motor_id = index;
    physicalCheck.motors(index).physical_position = "position_" + string(index);
    physicalCheck.motors(index).rcou_channel = index;
    physicalCheck.motors(index).spin_direction = "cw";
    physicalCheck.motors(index).spin_sign = (-1) ^ (index + 1);
    physicalCheck.motors(index).propeller_type = "Gemfan 8060, 3 лопасти";
    physicalCheck.motors(index).propeller_installation_direction = "confirmed";
end
end
