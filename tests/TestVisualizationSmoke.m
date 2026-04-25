classdef TestVisualizationSmoke < matlab.unittest.TestCase
    % Дымовая проверка функций визуализации.

    methods (Test)
        function testOverviewAndPath(testCase)
            dataSet = makeSyntheticTimetable();
            outputFolder = fullfile(tempdir, "intercept_visual_test_" + string(java.util.UUID.randomUUID));
            mkdir(outputFolder);
            cleanup = onCleanup(@() localRemoveFolder(outputFolder));

            [createdFiles, warnings] = copter.visualization.plotLogOverview(dataSet, outputFolder);
            pathFile = fullfile(outputFolder, 'path.png');
            [figureHandle, pathReport] = copter.visualization.plotFlightPath3D(dataSet, pathFile);
            close(figureHandle);

            testCase.verifyGreaterThan(numel(createdFiles), 0);
            testCase.verifyTrue(isfile(pathFile));
            testCase.verifyClass(warnings, 'string');
            testCase.verifyClass(pathReport.warnings, 'string');
        end
    end
end

function dataSet = makeSyntheticTimetable()
t = transpose(0:0.05:5);
dataTable = table();
dataTable.t_s = t;
dataTable.("ATT.Roll") = 5 * sin(t);
dataTable.("ATT.Pitch") = 3 * cos(t);
dataTable.("ATT.Yaw") = 20 * sin(0.3 * t);
dataTable.("RATE.R") = 10 * cos(t);
dataTable.("RATE.P") = -3 * sin(t);
dataTable.("RATE.Y") = 4 * cos(0.3 * t);
dataTable.("RATE.ROut") = 0.1 * sin(t);
dataTable.("RATE.POut") = 0.1 * cos(t);
dataTable.("RATE.YOut") = 0.05 * sin(0.5 * t);
dataTable.("RCOU.C1") = 1500 + 100 * sin(t);
dataTable.("RCOU.C2") = 1500 + 100 * cos(t);
dataTable.("RCOU.C3") = 1500 - 100 * sin(t);
dataTable.("RCOU.C4") = 1500 - 100 * cos(t);
dataTable.u_motor_1 = 0.5 + 0.1 * sin(t);
dataTable.u_motor_2 = 0.5 + 0.1 * cos(t);
dataTable.u_motor_3 = 0.5 - 0.1 * sin(t);
dataTable.u_motor_4 = 0.5 - 0.1 * cos(t);
dataTable.altitude_m = 10 + sin(t);
dataTable.vertical_speed_mps = gradient(dataTable.altitude_m, t);
dataTable.horizontal_speed_mps = 2 * ones(numel(t), 1);
dataTable.x_m = t;
dataTable.y_m = sin(t);
dataTable.z_m = dataTable.altitude_m;
dataSet = table2timetable(dataTable, 'RowTimes', seconds(t));
end

function localRemoveFolder(folder)
if isfolder(folder)
    rmdir(folder, 's');
end
end
