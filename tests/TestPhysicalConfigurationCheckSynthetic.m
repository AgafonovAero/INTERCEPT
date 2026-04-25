classdef TestPhysicalConfigurationCheckSynthetic < matlab.unittest.TestCase
    % Проверяет загрузку и верификацию синтетической физической проверки.

    methods (Test)
        function testLoadAndValidate(testCase)
            physicalCheck = makePhysicalCheck();
            tempFolder = tempname;
            mkdir(tempFolder);
            cleanup = onCleanup(@() rmdir(tempFolder, 's'));
            filePath = fullfile(tempFolder, 'physical_configuration_check.json');
            writeJson(filePath, physicalCheck);

            [loadedCheck, loadReport] = copter.physical.loadPhysicalConfigurationCheck(filePath);
            validation = copter.physical.validatePhysicalConfigurationCheck(loadedCheck);

            testCase.verifyEqual(loadReport.status, "physically_confirmed");
            testCase.verifyTrue(validation.is_valid);
            testCase.verifyEqual(validation.status, "physically_confirmed");
        end

        function testMissingFileReturnsNotAvailable(testCase)
            [physicalCheck, report] = copter.physical.loadPhysicalConfigurationCheck("missing_physical_check.json");

            testCase.verifyEqual(string(physicalCheck.status), "not_available");
            testCase.verifyEqual(report.status, "not_available");
            testCase.verifyGreaterThan(numel(report.warnings), 0);
        end
    end
end

function physicalCheck = makePhysicalCheck()
physicalCheck = struct();
physicalCheck.vehicle_id = "qc_ardupilot_v0";
physicalCheck.status = "physically_confirmed";
physicalCheck.check_date = "2026-04-25";
physicalCheck.performed_by = "test";
physicalCheck.approved_by = "test";
physicalCheck.vehicle_nose_direction = "x forward";
physicalCheck.installed_propeller_type = "Gemfan 8060, 3 лопасти";
physicalCheck.motors = makeMotors();
end

function motors = makeMotors()
for index = 1:4
    motors(index).motor_id = index;
    motors(index).physical_position = "position_" + string(index);
    motors(index).rcou_channel = index;
    motors(index).spin_direction = "cw";
    motors(index).spin_sign = (-1) ^ (index + 1);
    motors(index).propeller_type = "Gemfan 8060, 3 лопасти";
    motors(index).propeller_installation_direction = "confirmed";
end
end

function writeJson(filePath, value)
fileId = fopen(filePath, 'w', 'n', 'UTF-8');
cleanup = onCleanup(@() fclose(fileId));
fprintf(fileId, '%s', jsonencode(value));
end
