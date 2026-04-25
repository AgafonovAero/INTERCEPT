classdef TestPropulsionBenchDataSynthetic < matlab.unittest.TestCase
    % Проверяет чтение и контроль синтетических стендовых данных ВМГ.

    methods (Test)
        function testReadAndValidateBenchCsv(testCase)
            tempFolder = tempname;
            mkdir(tempFolder);
            cleanup = onCleanup(@() rmdir(tempFolder, 's'));
            filePath = fullfile(tempFolder, 'propulsion_static_test.csv');
            benchData = makeBenchData();
            writetable(benchData, filePath);

            [readData, readReport] = copter.propulsion.readPropulsionBenchData(filePath);
            quality = copter.propulsion.validatePropulsionBenchData(readData);

            testCase.verifyEqual(readReport.status, "loaded");
            testCase.verifyEqual(height(readData), height(benchData));
            testCase.verifyTrue(quality.is_valid);
        end
    end
end

function benchData = makeBenchData()
u = transpose(linspace(0, 1, 8));
benchData = table();
benchData.point_id = transpose(1:numel(u));
benchData.sample_time_s = u;
benchData.input_command = u;
benchData.pwm_us = 1000 + 1000 * u;
benchData.normalized_input = u;
benchData.voltage_v = 22.8 - 0.2 * u;
benchData.current_a = 2 + 20 * u .^ 2;
benchData.thrust_n = 0.1 + 5 * u + 20 * u .^ 2;
benchData.rpm = 1000 + 9000 * u;
benchData.temperature_c = 25 + 5 * u;
benchData.motor_type = repmat("BrotherHobby Avenger 2816-1050KV", numel(u), 1);
benchData.propeller_type = repmat("Gemfan 8060, 3 лопасти", numel(u), 1);
benchData.esc_type = repmat("SpeedyBee F405 V4 60A 3-6S 4in1 8-bit", numel(u), 1);
benchData.battery_or_power_source = repmat("bench supply", numel(u), 1);
end
