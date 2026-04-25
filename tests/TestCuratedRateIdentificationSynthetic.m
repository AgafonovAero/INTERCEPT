classdef TestCuratedRateIdentificationSynthetic < matlab.unittest.TestCase
    % Проверка полного синтетического цикла curated-идентификации ModelRate.

    methods (Test)
        function testCuratedIdentification(testCase)
            processedData = makeRateData();
            segmentRegistry = makeSyntheticRegistry();
            curationSettings = makeCurationSettings();
            vehicleConfig = copter.config.defaultVehicleConfig();

            [curatedSegments, excludedSegments] = copter.validation.curateValidationSegments( ...
                segmentRegistry, processedData, curationSettings);
            [curatedSegments, ~] = copter.validation.removeOverlappingSegments(curatedSegments, curationSettings);
            [splitSegments, ~] = copter.validation.splitCuratedSegments(curatedSegments, curationSettings);
            identificationSegments = splitSegments(splitSegments.split_role == "identification", :);
            validationSegments = splitSegments(splitSegments.split_role == "validation", :);

            [continuousModel, discreteModel, fitDiagnostics, selectedDelay, warnings] = ...
                copter.identification.fitCuratedRateModels( ...
                processedData, identificationSegments, vehicleConfig, curationSettings);
            comparison = copter.validation.compareRateModelVariants( ...
                continuousModel, discreteModel, processedData, validationSegments, vehicleConfig);

            testCase.verifyGreaterThanOrEqual(height(curatedSegments), 2);
            testCase.verifyGreaterThan(height(excludedSegments), 0);
            testCase.verifySize(continuousModel.A, [3, 3]);
            testCase.verifySize(discreteModel.Ad, [3, 3]);
            testCase.verifyTrue(isfinite(selectedDelay));
            testCase.verifyGreaterThanOrEqual(fitDiagnostics.identification_segment_count, 1);
            testCase.verifyClass(warnings, 'string');
            testCase.verifyTrue(all(comparison.pass_preliminary_criterion(comparison.model_variant == "discrete ModelRateDiscrete")));
        end
    end
end

function processedData = makeRateData()
sampleRateHz = 100;
t = transpose(0:1 / sampleRateHz:40);
A = diag([-1.1, -0.9, -0.7]);
B = diag([1.8, 1.5, 1.2]);
c = [0.005; -0.004; 0.003];
model = copter.models.ModelRate(A, B, c);
u = [
    0.25 * sin(0.7 * t), ...
    0.22 * cos(0.6 * t), ...
    0.18 * sin(0.8 * t)
    ];
omega = zeros(numel(t), 3);
for index = 1:numel(t) - 1
    step = t(index + 1) - t(index);
    state = transpose(omega(index, :));
    input = transpose(u(index, :));
    omega(index + 1, :) = transpose(state + step * copter.models.rhsRateModel(t(index), state, input, model));
end

dataTable = table();
dataTable.t_s = t;
dataTable.log_file = repmat("synthetic.BIN", numel(t), 1);
dataTable.("RATE.R_rad_s") = omega(:, 1);
dataTable.("RATE.P_rad_s") = omega(:, 2);
dataTable.("RATE.Y_rad_s") = omega(:, 3);
dataTable.("RATE.R") = rad2deg(omega(:, 1));
dataTable.("RATE.P") = rad2deg(omega(:, 2));
dataTable.("RATE.Y") = rad2deg(omega(:, 3));
dataTable.("RATE.ROut") = u(:, 1);
dataTable.("RATE.POut") = u(:, 2);
dataTable.("RATE.YOut") = u(:, 3);
dataTable.u_motor_1 = 0.5 + zeros(numel(t), 1);
dataTable.u_motor_2 = 0.5 + zeros(numel(t), 1);
dataTable.u_motor_3 = 0.5 + zeros(numel(t), 1);
dataTable.u_motor_4 = 0.5 + zeros(numel(t), 1);
dataTable.motor_saturation_flag = false(numel(t), 1);
processedData = table2timetable(dataTable, 'RowTimes', seconds(t));
end

function registry = makeSyntheticRegistry()
registry = table( ...
    ["fit_a"; "fit_b"; "bad_climb"], ...
    repmat("synthetic.BIN", 3, 1), ...
    ["В-10"; "В-09"; "В-06"], ...
    ["roll_response_candidate"; "pitch_response_candidate"; "climb_candidate"], ...
    [2; 22; 5], ...
    [18; 38; 8], ...
    [16; 16; 3], ...
    [30; 30; 30], ...
    [0; 0; 2], ...
    [0; 0; 0], ...
    [5; 5; 0], ...
    [4; 4; 0], ...
    [3; 3; 0], ...
    [0; 0; 0], ...
    repmat("синтетика", 3, 1), ...
    [1; 1; 0.1], ...
    repmat("синтетика", 3, 1), ...
    'VariableNames', registryNames());
end

function names = registryNames()
names = { ...
    'segment_id', ...
    'log_file', ...
    'candidate_validation_case_id', ...
    'segment_type', ...
    't_start_s', ...
    't_end_s', ...
    'duration_s', ...
    'mean_altitude_m', ...
    'mean_vertical_speed_mps', ...
    'mean_horizontal_speed_mps', ...
    'roll_rms_deg', ...
    'pitch_rms_deg', ...
    'yaw_rate_rms_deg_s', ...
    'motor_saturation_percent', ...
    'data_quality_flags', ...
    'score', ...
    'notes'};
end

function settings = makeCurationSettings()
settings = struct();
settings.min_duration_s = 2;
settings.max_duration_s = 20;
settings.min_input_std = 0.01;
settings.min_rate_std_deg_s = 0.5;
settings.max_nan_percent = 5;
settings.max_motor_saturation_percent = 5;
settings.min_time_gap_between_segments_s = 1;
settings.max_condition_number = 1.0e10;
settings.input_delay_search_samples = 0;
settings.train_validation_split = 0.5;
settings.random_seed = 11;
settings.prefer_distinct_logs_for_validation = false;
settings.candidate_types_for_rate_identification = [
    "roll_response_candidate"
    "pitch_response_candidate"
    "yaw_response_candidate"
    "hover_candidate"
    ];
settings.exclude_candidate_types_for_rate_identification = [
    "climb_candidate"
    "descent_candidate"
    "thrust_response_candidate"
    ];
end
