classdef TestModel6DOFClosedLoopDemo < matlab.unittest.TestCase
    % Проверка короткого замкнутого расчета Model6DOF.

    methods (Test)
        function testShortHover(testCase)
            config = makeDemoConfig();
            trajectory = makeHoverTrajectory(2, 4, 0.05);
            simulation = copter.control.simulatePrimitiveClosedLoop(trajectory, config);
            dataTable = timetable2table(simulation, 'ConvertRowTimes', false);

            testCase.verifyTrue(istimetable(simulation));
            testCase.verifyFalse(any(any(ismissing(dataTable))));
            testCase.verifyTrue(all(isfinite(dataTable.z_m)));
            testCase.verifyTrue(all(dataTable.u_motor_1 >= 0 & dataTable.u_motor_1 <= 1));
            testCase.verifyTrue(all(dataTable.u_motor_2 >= 0 & dataTable.u_motor_2 <= 1));
            testCase.verifyTrue(all(dataTable.u_motor_3 >= 0 & dataTable.u_motor_3 <= 1));
            testCase.verifyTrue(all(dataTable.u_motor_4 >= 0 & dataTable.u_motor_4 <= 1));
            testCase.verifyLessThan(abs(dataTable.z_m(end) - 2), 1.5);
        end
    end
end

function config = makeDemoConfig()
config = copter.config.defaultVehicleConfig();
config.geometry.cad_cg_mm = [0; 0; 0];
armMm = 260;
config.geometry.motor_1_raw_cad_mm = [-armMm; -armMm; 0];
config.geometry.motor_2_raw_cad_mm = [armMm; -armMm; 0];
config.geometry.motor_3_raw_cad_mm = [armMm; armMm; 0];
config.geometry.motor_4_raw_cad_mm = [-armMm; armMm; 0];
config.geometry.spin_sign = [1; -1; 1; -1];
config.model6dof.kT = 40;
config.model6dof.linear_drag = [0.18; 0.18; 0.25];
end

function trajectory = makeHoverTrajectory(heightM, durationS, dtS)
time = transpose(0:dtS:durationS);
dataTable = table();
dataTable.t_s = time;
dataTable.x_m = zeros(numel(time), 1);
dataTable.y_m = zeros(numel(time), 1);
dataTable.z_m = heightM * ones(numel(time), 1);
dataTable.vx_mps = zeros(numel(time), 1);
dataTable.vy_mps = zeros(numel(time), 1);
dataTable.vz_mps = zeros(numel(time), 1);
dataTable.yaw_rad = zeros(numel(time), 1);
dataTable.phase = repmat("висение", numel(time), 1);
trajectory = table2timetable(dataTable, 'RowTimes', seconds(time));
end
