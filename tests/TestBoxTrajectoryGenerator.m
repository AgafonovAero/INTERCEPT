classdef TestBoxTrajectoryGenerator < matlab.unittest.TestCase
    % Проверка генератора траектории прямоугольного маршрута.

    methods (Test)
        function testBoxTrajectory(testCase)
            trajectory = copter.control.generateBoxTrajectory(struct( ...
                'height_m', 2, 'side_m', 4, 'speed_mps', 1, 'dt_s', 0.1));
            dataTable = timetable2table(trajectory, 'ConvertRowTimes', false);

            testCase.verifyGreaterThan(height(dataTable), 10);
            testCase.verifyFalse(any(any(ismissing(dataTable))));
            testCase.verifyEqual(dataTable.z_m(1), 0, 'AbsTol', 1.0e-12);
            testCase.verifyEqual(dataTable.z_m(end), 0, 'AbsTol', 1.0e-12);
            testCase.verifyGreaterThan(max(dataTable.x_m), 3.5);
            testCase.verifyGreaterThan(max(dataTable.y_m), 3.5);
            testCase.verifyTrue(any(dataTable.phase == "сторона 1"));
            testCase.verifyTrue(any(dataTable.phase == "посадка"));
        end
    end
end
