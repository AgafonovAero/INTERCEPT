classdef TestSignalUnitDiagnostics < matlab.unittest.TestCase
    % Проверка диагностики единиц измерения сигналов.

    methods (Test)
        function testDegreeRateDiagnostics(testCase)
            dataTable = makeBaseTable();
            dataTable.("RATE.R") = 30 * sin(dataTable.t_s);
            dataTable.("RATE.P") = 20 * cos(dataTable.t_s);
            dataTable.("RATE.Y") = 40 * sin(0.5 * dataTable.t_s);
            dataTable.("RATE.R_rad_s") = deg2rad(dataTable.("RATE.R"));
            dataTable.("RATE.P_rad_s") = deg2rad(dataTable.("RATE.P"));
            dataTable.("RATE.Y_rad_s") = deg2rad(dataTable.("RATE.Y"));

            diagnostics = copter.data.diagnoseSignalUnits(dataTable);
            testCase.verifyEqual(diagnostics.rate_unit_guess(1), "град/с");
            testCase.verifyTrue(all(diagnostics.internal_rate_rad_s_available));
        end

        function testRadianRateDiagnostics(testCase)
            dataTable = makeBaseTable();
            dataTable.("RATE.R") = 2 * sin(dataTable.t_s);
            dataTable.("RATE.P") = 1.5 * cos(dataTable.t_s);
            dataTable.("RATE.Y") = 1.2 * sin(0.5 * dataTable.t_s);
            dataTable.("RATE.R_rad_s") = dataTable.("RATE.R");
            dataTable.("RATE.P_rad_s") = dataTable.("RATE.P");
            dataTable.("RATE.Y_rad_s") = dataTable.("RATE.Y");

            diagnostics = copter.data.diagnoseSignalUnits(dataTable);
            testCase.verifyEqual(diagnostics.rate_unit_guess(1), "рад/с");
        end

        function testAmbiguousDiagnostics(testCase)
            dataTable = makeBaseTable();
            dataTable.("RATE.R") = 0.05 * sin(dataTable.t_s);
            dataTable.("RATE.P") = 0.05 * sin(dataTable.t_s);
            dataTable.("RATE.Y") = 0.05 * sin(dataTable.t_s);

            diagnostics = copter.data.diagnoseSignalUnits(dataTable);
            testCase.verifyTrue(any(diagnostics.rate_unit_guess == "неоднозначно"));
            testCase.verifyFalse(isempty(diagnostics.warnings));
        end
    end
end

function dataTable = makeBaseTable()
t = transpose(0:0.01:2);
dataTable = table();
dataTable.t_s = t;
dataTable.("ATT.Roll") = 5 * sin(t);
dataTable.("ATT.Pitch") = 4 * cos(t);
dataTable.("ATT.Yaw") = 20 * sin(0.2 * t);
end
