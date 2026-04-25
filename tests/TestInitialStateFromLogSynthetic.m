classdef TestInitialStateFromLogSynthetic < matlab.unittest.TestCase
    % Проверка построения начального состояния Model6DOF по синтетическому журналу.

    methods (Test)
        function testInitialState(testCase)
            config = copter.config.defaultVehicleConfig();
            processedData = makeProcessedData(config);

            [x0, warnings] = copter.data.buildInitialStateFromLog(processedData, 0.5, config);

            testCase.verifySize(x0, [16, 1]);
            testCase.verifyTrue(all(isfinite(x0)));
            testCase.verifyClass(warnings, 'string');
        end
    end
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
for index = 1:4
    dataTable.("RCOU.C" + string(index)) = 1000 + 1000 * hoverInput * ones(size(timeSeconds));
    dataTable.("u_motor_" + string(index)) = hoverInput * ones(size(timeSeconds));
end
processedData = table2timetable(dataTable, 'RowTimes', seconds(timeSeconds));
end
