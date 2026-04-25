classdef TestMotorInputsFromLogSynthetic < matlab.unittest.TestCase
    % Проверка формирования входов двигателей по RCOU.

    methods (Test)
        function testMotorInputs(testCase)
            config = copter.config.defaultVehicleConfig();
            timeSeconds = transpose(0:0.1:2);
            dataTable = table();
            dataTable.t_s = timeSeconds;
            for index = 1:4
                dataTable.("RCOU.C" + string(index)) = 1500 * ones(size(timeSeconds));
            end
            processedData = table2timetable(dataTable, 'RowTimes', seconds(timeSeconds));
            replayWindow = table("w1", "synthetic", "В-01", "hover_candidate", 0, 2, 2, "validation", ...
                'VariableNames', {'window_id', 'log_file', 'candidate_validation_case_id', ...
                'window_type', 't_start_s', 't_end_s', 'duration_s', 'split_role'});

            [motorInputs, inputReport] = copter.data.buildMotorInputsFromLog(processedData, replayWindow, config);

            testCase.verifyTrue(istimetable(motorInputs));
            testCase.verifyEqual(motorInputs.u_motor_1(1), 0.5, 'AbsTol', 1e-12);
            testCase.verifyTrue(all(motorInputs.u_motor_1 >= 0 & motorInputs.u_motor_1 <= 1));
            testCase.verifyEqual(inputReport.saturation_percent, 0, 'AbsTol', 1e-12);
        end
    end
end
