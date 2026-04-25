classdef TestModel6DofComparisonMetrics < matlab.unittest.TestCase
    % Проверка метрик сопоставления Model6DOF с защитой FIT.

    methods (Test)
        function testComparisonMetrics(testCase)
            timeSeconds = transpose(0:0.1:2);
            logTable = table();
            logTable.t_s = timeSeconds;
            logTable.("ATT.Roll_rad") = zeros(size(timeSeconds));
            simTable = table();
            simTable.t_s = timeSeconds;
            simTable.roll_rad = zeros(size(timeSeconds));
            logData = table2timetable(logTable, 'RowTimes', seconds(timeSeconds));
            simData = table2timetable(simTable, 'RowTimes', seconds(timeSeconds));
            replayWindow = table("w1", "synthetic", "В-01", "hover_candidate", 0, 2, 2, "validation", ...
                'VariableNames', {'window_id', 'log_file', 'candidate_validation_case_id', ...
                'window_type', 't_start_s', 't_end_s', 'duration_s', 'split_role'});

            [metrics, warnings] = copter.validation.compareModel6DofToLog(simData, logData, replayWindow);

            row = metrics(metrics.signal == "ATT.Roll", :);
            testCase.verifyEqual(height(row), 1);
            testCase.verifyTrue(isnan(row.fit_percent));
            testCase.verifyFalse(row.valid_metric_flag);
            testCase.verifyNotEmpty(row.metric_warning);
            testCase.verifyClass(warnings, 'string');
        end
    end
end
