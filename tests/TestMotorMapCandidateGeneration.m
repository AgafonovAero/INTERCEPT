classdef TestMotorMapCandidateGeneration < matlab.unittest.TestCase
    % Проверяет генерацию кандидатных мотор-маппингов.

    methods (Test)
        function testCandidatesIncludeDefaultsAndAreLimited(testCase)
            vehicleConfig = copter.config.defaultVehicleConfig();
            settings = struct();
            settings.max_candidates = 12;
            settings.use_vehicle_config_candidate = true;
            settings.use_ardupilot_default_quad_x_candidate = true;
            settings.allow_motor_permutations = true;
            settings.allow_yaw_spin_sign_variants = true;

            candidates = copter.models.generateMotorMapCandidates(vehicleConfig, settings);

            testCase.verifyLessThanOrEqual(height(candidates), settings.max_candidates);
            testCase.verifyTrue(any(string(candidates.candidate_id) == "vehicle_config"));
            testCase.verifyTrue(any(string(candidates.candidate_id) == "ardupilot_quad_x"));
            keys = makeKeys(candidates);
            testCase.verifyEqual(numel(unique(keys)), height(candidates));
        end
    end
end

function keys = makeKeys(candidates)
keys = strings(height(candidates), 1);
for index = 1:height(candidates)
    keys(index) = join(string([candidates.motor_order{index}; 99; candidates.spin_sign{index}]), "_");
end
end
