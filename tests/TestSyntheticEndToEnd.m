classdef TestSyntheticEndToEnd < matlab.unittest.TestCase
    % Сквозная проверка синтетической последовательности обработки.

    methods (Test)
        function testEndToEnd(testCase)
            config = copter.config.defaultVehicleConfig();
            dataTable = createSyntheticLogTable();
            [processedData, quality] = copter.data.preprocessLogData(dataTable, config, 100);
            segments = copter.data.selectSegments(processedData, 3);
            identification = copter.identification.fitRateModel(processedData, config, segments.identification);
            validation = copter.validation.validateByLog(processedData, identification.model, segments.validation, config);

            reportData = struct();
            reportData.config = config;
            reportData.data_quality = quality;
            reportData.identification = identification;
            reportData.validation = validation;
            reportData.segments = segments;
            reportPath = fullfile(tempdir, 'synthetic_end_to_end_report.md');
            reportText = copter.reports.writeMarkdownReport(reportPath, reportData);

            testCase.verifyTrue(istimetable(processedData));
            testCase.verifySize(identification.A, [3, 3]);
            testCase.verifySize(identification.B, [3, 3]);
            testCase.verifySize(identification.c, [3, 1]);
            testCase.verifyEqual(height(validation.validation_matrix), 3);
            testCase.verifyTrue(isfile(reportPath));
            testCase.verifyTrue(contains(reportText, "Данная проверка выполнена по данным бортового журнала и не является полной независимой валидацией реального изделия по внешним средствам измерений."));
            testCase.verifyTrue(contains(reportText, "В исходном описании указаны винты Gemfan 8060, а в CAD-выгрузке присутствуют винты APC 7x11E"));
        end
    end
end

function dataTable = createSyntheticLogTable()
timeStep = 0.01;
timeSeconds = transpose(0:timeStep:9);
A = diag([-0.9, -0.7, -0.5]);
B = diag([1.8, 1.3, 0.9]);
c = [0.05; -0.03; 0.01];
input = [
    0.4 * sin(0.8 * timeSeconds), ...
    0.3 * cos(0.6 * timeSeconds), ...
    0.25 * sin(0.4 * timeSeconds + 0.3)
    ];
state = zeros(numel(timeSeconds), 3);

for index = 1:(numel(timeSeconds) - 1)
    rhs = A * transpose(state(index, :)) + B * transpose(input(index, :)) + c;
    state(index + 1, :) = state(index, :) + transpose(timeStep * rhs);
end

dataTable = table();
dataTable.TimeUS = uint64(timeSeconds * 1e6);
dataTable.("RATE.R") = rad2deg(state(:, 1));
dataTable.("RATE.P") = rad2deg(state(:, 2));
dataTable.("RATE.Y") = rad2deg(state(:, 3));
dataTable.("RATE.ROut") = input(:, 1);
dataTable.("RATE.POut") = input(:, 2);
dataTable.("RATE.YOut") = input(:, 3);
dataTable.("ATT.Roll") = 2 * sin(0.2 * timeSeconds);
dataTable.("ATT.Pitch") = 1.5 * cos(0.2 * timeSeconds);
dataTable.("ATT.Yaw") = 10 + 0.5 * timeSeconds;
dataTable.("RCOU.C1") = 1500 + 50 * sin(0.3 * timeSeconds);
dataTable.("RCOU.C2") = 1500 + 50 * cos(0.3 * timeSeconds);
dataTable.("RCOU.C3") = 1500 - 40 * sin(0.25 * timeSeconds);
dataTable.("RCOU.C4") = 1500 - 40 * cos(0.25 * timeSeconds);
end
