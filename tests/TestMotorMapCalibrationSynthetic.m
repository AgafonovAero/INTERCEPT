classdef TestMotorMapCalibrationSynthetic < matlab.unittest.TestCase
    % Проверяет синтетическую калибровку мотор-маппинга.

    methods (Test)
        function testKnownMapIsRankedInTopThree(testCase)
            vehicleConfig = copter.config.defaultVehicleConfig();
            knownOrder = [2; 1; 3; 4];
            data = makeSyntheticData(vehicleConfig, knownOrder);
            windows = table("w1", "synthetic", 0, 8, "identification", ...
                'VariableNames', {'window_id', 'log_file', 't_start_s', 't_end_s', 'split_role'});
            settings = struct();
            settings.max_candidates = 48;
            settings.allow_motor_permutations = true;
            settings.allow_yaw_spin_sign_variants = false;
            settings.use_vehicle_config_candidate = true;
            settings.use_ardupilot_default_quad_x_candidate = true;

            result = copter.identification.calibrateMotorMapAndFrame( ...
                data, windows, windows, vehicleConfig, settings, struct());

            topCount = min(3, height(result.motorMetrics));
            topIds = string(result.motorMetrics.candidate_id(1:topCount));
            knownCandidates = findKnownCandidateIds(result.motorCandidates, knownOrder);
            testCase.verifyTrue(any(ismember(topIds, knownCandidates)));
        end
    end
end

function data = makeSyntheticData(vehicleConfig, knownOrder)
time = transpose(0:0.02:10);
uControl = [
    0.5 + 0.08 * sin(time), ...
    0.5 + 0.07 * cos(0.7 * time), ...
    0.5 + 0.06 * sin(1.3 * time), ...
    0.5 + 0.05 * cos(1.7 * time)
    ];
pwm = 1000 + 1000 * uControl;

candidate = table("known", {knownOrder}, {[1; -1; 1; -1]}, "synthetic", "known", ...
    'VariableNames', {'candidate_id', 'motor_order', 'spin_sign', 'source', 'notes'});
[mapped, ~] = copter.models.applyMotorMap(array2table(pwm, ...
    'VariableNames', {'RCOU.C1', 'RCOU.C2', 'RCOU.C3', 'RCOU.C4'}), candidate, vehicleConfig);
[positions, ~] = copter.models.transformMotorPositions(vehicleConfig, eye(3));
allocation = copter.models.buildQuadXAllocationMatrix(positions, [1; -1; 1; -1], 0.02);
u = [mapped.u_motor_1, mapped.u_motor_2, mapped.u_motor_3, mapped.u_motor_4];
moments = transpose(allocation(2:4, :) * transpose(u .^ 2 - mean(u .^ 2, 2)));

data = table();
data.t_s = time;
data.("RCOU.C1") = pwm(:, 1);
data.("RCOU.C2") = pwm(:, 2);
data.("RCOU.C3") = pwm(:, 3);
data.("RCOU.C4") = pwm(:, 4);
data.RATE_R_rad_s = moments(:, 1);
data.RATE_P_rad_s = moments(:, 2);
data.RATE_Y_rad_s = moments(:, 3);
end

function ids = findKnownCandidateIds(candidates, knownOrder)
ids = strings(0, 1);
for index = 1:height(candidates)
    if isequal(candidates.motor_order{index}, knownOrder)
        ids(end + 1, 1) = string(candidates.candidate_id(index));
    end
end
end
