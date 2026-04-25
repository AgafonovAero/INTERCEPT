classdef TestModel6DofParameterFitSynthetic < matlab.unittest.TestCase
    % Проверка первичной оценки масштаба тяги Model6DOF на синтетическом висении.

    methods (Test)
        function testParameterFit(testCase)
            config = copter.config.defaultVehicleConfig();
            knownScale = 1.2;
            processedData = makeHoverData(config, knownScale);
            windows = table("w1", "synthetic", "В-01", "hover_candidate", 0, 3, 3, "identification", ...
                'VariableNames', {'window_id', 'log_file', 'candidate_validation_case_id', ...
                'window_type', 't_start_s', 't_end_s', 'duration_s', 'split_role'});
            settings = struct();
            settings.max_iterations = 0;

            [params, diagnostics, warnings] = copter.identification.fitModel6DofParametersFromWindows( ...
                processedData, windows, config, settings);

            testCase.verifyEqual(params.thrust_scale, knownScale, 'RelTol', 0.05);
            testCase.verifyEqual(params.motor_tau_s, config.model6dof.tau_motor_s, 'AbsTol', 1e-12);
            testCase.verifyTrue(isstruct(diagnostics));
            testCase.verifyClass(warnings, 'string');
        end
    end
end

function processedData = makeHoverData(config, scale)
timeSeconds = transpose(0:0.02:3);
hoverInput = sqrt(config.model6dof.mass_kg * config.model6dof.g_m_s2 / (4 * config.model6dof.kT * scale));
dataTable = table();
dataTable.t_s = timeSeconds;
dataTable.("ATT.Roll_rad") = zeros(size(timeSeconds));
dataTable.("ATT.Pitch_rad") = zeros(size(timeSeconds));
dataTable.("ATT.Yaw_rad") = zeros(size(timeSeconds));
dataTable.("RATE.R_rad_s") = zeros(size(timeSeconds));
dataTable.("RATE.P_rad_s") = zeros(size(timeSeconds));
dataTable.("RATE.Y_rad_s") = zeros(size(timeSeconds));
dataTable.altitude_m = 10 * ones(size(timeSeconds));
dataTable.vertical_speed_mps = zeros(size(timeSeconds));
dataTable.horizontal_speed_mps = zeros(size(timeSeconds));
for index = 1:4
    dataTable.("u_motor_" + string(index)) = hoverInput * ones(size(timeSeconds));
end
processedData = table2timetable(dataTable, 'RowTimes', seconds(timeSeconds));
end
