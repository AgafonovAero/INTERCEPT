classdef TestComparePhysicalCheckWithCandidate < matlab.unittest.TestCase
    % Проверяет сравнение физической проверки с кандидатами PR №7.

    methods (Test)
        function testMatchingCandidate(testCase)
            vehicleConfig = copter.config.defaultVehicleConfig();
            physicalCheck = makePhysicalCheck([2; 1; 3; 4], [1; -1; 1; -1]);
            candidate = table("perm_7", {[2; 1; 3; 4]}, {[1; -1; 1; -1]}, ...
                'VariableNames', {'candidate_id', 'motor_order', 'spin_sign'});

            comparison = copter.physical.comparePhysicalCheckWithCandidate( ...
                physicalCheck, candidate, [], vehicleConfig);

            testCase.verifyTrue(comparison.matches_pr7_candidate);
            testCase.verifyFalse(any(contains(comparison.differences, "PR №7")));
        end

        function testMismatchCreatesDifference(testCase)
            vehicleConfig = copter.config.defaultVehicleConfig();
            physicalCheck = makePhysicalCheck([1; 2; 3; 4], [1; -1; 1; -1]);
            candidate = table("perm_7", {[2; 1; 3; 4]}, {[1; -1; 1; -1]}, ...
                'VariableNames', {'candidate_id', 'motor_order', 'spin_sign'});

            comparison = copter.physical.comparePhysicalCheckWithCandidate( ...
                physicalCheck, candidate, [], vehicleConfig);

            testCase.verifyFalse(comparison.matches_pr7_candidate);
            testCase.verifyGreaterThan(numel(comparison.differences), 0);
        end
    end
end

function physicalCheck = makePhysicalCheck(order, spin)
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
    physicalCheck.motors(index).rcou_channel = order(index);
    physicalCheck.motors(index).spin_direction = "cw";
    physicalCheck.motors(index).spin_sign = spin(index);
    physicalCheck.motors(index).propeller_type = "Gemfan 8060, 3 лопасти";
    physicalCheck.motors(index).propeller_installation_direction = "confirmed";
end
end
