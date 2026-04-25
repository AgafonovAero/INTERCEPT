classdef TestModel6DofReplaySynthetic < matlab.unittest.TestCase
    % Дымовая проверка replay-расчета Model6DOF на синтетическом окне.

    methods (Test)
        function testReplay(testCase)
            config = copter.config.defaultVehicleConfig();
            processedData = makeProcessedData(config);
            replayWindow = makeWindow();

            [simData, simReport] = copter.validation.simulateModel6DofOnLogWindow( ...
                processedData, replayWindow, struct(), config);

            testCase.verifyTrue(istimetable(simData));
            testCase.verifyGreaterThan(height(simData), 10);
            testCase.verifyTrue(all(isfinite(simData.altitude_m)));
            testCase.verifyClass(simReport.warnings, 'string');
        end
    end
end

function replayWindow = makeWindow()
replayWindow = table("w1", "synthetic", "В-01", "hover_candidate", 0, 2, 2, "validation", ...
    'VariableNames', {'window_id', 'log_file', 'candidate_validation_case_id', ...
    'window_type', 't_start_s', 't_end_s', 'duration_s', 'split_role'});
end

function processedData = makeProcessedData(config)
timeSeconds = transpose(0:0.02:2);
hoverInput = sqrt(config.model6dof.mass_kg * config.model6dof.g_m_s2 / (4 * config.model6dof.kT));
dataTable = table();
dataTable.t_s = timeSeconds;
dataTable.("ATT.Roll") = zeros(size(timeSeconds));
dataTable.("ATT.Pitch") = zeros(size(timeSeconds));
dataTable.("ATT.Yaw") = zeros(size(timeSeconds));
dataTable.("ATT.Roll_rad") = zeros(size(timeSeconds));
dataTable.("ATT.Pitch_rad") = zeros(size(timeSeconds));
dataTable.("ATT.Yaw_rad") = zeros(size(timeSeconds));
dataTable.("RATE.R") = zeros(size(timeSeconds));
dataTable.("RATE.P") = zeros(size(timeSeconds));
dataTable.("RATE.Y") = zeros(size(timeSeconds));
dataTable.("RATE.R_rad_s") = zeros(size(timeSeconds));
dataTable.("RATE.P_rad_s") = zeros(size(timeSeconds));
dataTable.("RATE.Y_rad_s") = zeros(size(timeSeconds));
dataTable.altitude_m = 5 * ones(size(timeSeconds));
dataTable.vertical_speed_mps = zeros(size(timeSeconds));
dataTable.horizontal_speed_mps = zeros(size(timeSeconds));
for index = 1:4
    dataTable.("u_motor_" + string(index)) = hoverInput * ones(size(timeSeconds));
end
processedData = table2timetable(dataTable, 'RowTimes', seconds(timeSeconds));
end
