classdef TestValidationSegmentDetectionSynthetic < matlab.unittest.TestCase
    % Проверка выделения участков ВБ на синтетических данных.

    methods (Test)
        function testSegmentDetection(testCase)
            processedData = makeSyntheticProcessedData();
            settings = makeSettings();
            validationBasis = copter.utils.readJson(fullfile(projectRoot(), 'config', 'validation_basis_v0.json'));
            segments = copter.validation.detectValidationSegments(processedData, validationBasis, settings, "synthetic.BIN");
            segmentTypes = string(segments.segment_type);

            testCase.verifyTrue(any(segmentTypes == "hover_candidate"));
            testCase.verifyTrue(any(segmentTypes == "climb_candidate"));
            testCase.verifyTrue(any(segmentTypes == "descent_candidate"));
            hasResponse = any(endsWith(segmentTypes, "response_candidate"));
            testCase.verifyTrue(hasResponse);
        end
    end
end

function processedData = makeSyntheticProcessedData()
t = transpose(0:0.01:35);
dataTable = table();
dataTable.t_s = t;
dataTable.("ATT.Roll") = 2 * sin(0.2 * t);
dataTable.("ATT.Pitch") = 2 * cos(0.2 * t);
dataTable.("ATT.Yaw") = zeros(size(t));
dataTable.("RATE.R") = zeros(size(t));
dataTable.("RATE.P") = zeros(size(t));
dataTable.("RATE.Y") = zeros(size(t));
dataTable.horizontal_speed_mps = 0.2 * ones(size(t));
dataTable.vertical_speed_mps = zeros(size(t));
dataTable.vertical_speed_mps(t >= 10 & t <= 15) = 2.0;
dataTable.vertical_speed_mps(t >= 18 & t <= 23) = -2.0;
dataTable.altitude_m = 30 + cumtrapz(t, dataTable.vertical_speed_mps);
dataTable.control_roll_amplitude = zeros(size(t));
dataTable.control_pitch_amplitude = zeros(size(t));
dataTable.control_yaw_amplitude = zeros(size(t));
dataTable.control_thrust_amplitude = zeros(size(t));
dataTable.control_roll_amplitude(t >= 26 & t <= 29) = 0.25;
dataTable.motor_saturation_flag = false(size(t));
dataTable.is_hover = abs(dataTable.vertical_speed_mps) < 0.5 & dataTable.horizontal_speed_mps < 1.5;
dataTable.is_climb = dataTable.vertical_speed_mps > 1.0;
dataTable.is_descent = dataTable.vertical_speed_mps < -1.0;
processedData = table2timetable(dataTable, 'RowTimes', seconds(dataTable.t_s));
end

function settings = makeSettings()
settings = struct();
settings.sample_rate_hz = 100;
settings.min_segment_duration_s = 2;
settings.max_segment_duration_s = 20;
settings.hover_max_horizontal_speed_mps = 1.5;
settings.hover_max_vertical_speed_mps = 0.5;
settings.hover_max_roll_pitch_deg = 8;
settings.climb_vertical_speed_threshold_mps = 1;
settings.descent_vertical_speed_threshold_mps = 1;
settings.response_min_control_amplitude = 0.15;
settings.max_motor_saturation_percent = 5;
settings.allowed_nan_percent = 10;
end

function root = projectRoot()
root = fileparts(fileparts(mfilename('fullpath')));
end
