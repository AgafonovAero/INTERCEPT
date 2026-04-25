classdef TestLogManifest < matlab.unittest.TestCase
    % Проверка реестра локальных бортовых журналов для PR №2.

    methods (Test)
        function testLogManifest(testCase)
            projectRoot = fileparts(fileparts(mfilename('fullpath')));
            manifestPath = fullfile(projectRoot, 'config', 'log_manifest_v0.json');
            testCase.verifyTrue(isfile(manifestPath));

            manifest = jsondecode(fileread(manifestPath));
            fileNames = string({manifest.logs.file_name});
            testCase.verifyTrue(any(fileNames == "VB-01.alt_50m.BIN"));
            testCase.verifyTrue(any(fileNames == "full_fly_1.BIN"));
            testCase.verifyTrue(any(fileNames == "full_fly_2.BIN"));

            validationLog = manifest.logs(fileNames == "VB-01.alt_50m.BIN");
            testCase.verifyEqual(string(validationLog.candidate_validation_case_id), "В-01");
            note = string(validationLog.note);
            testCase.verifyTrue(contains(note, "alt_50m"));
            testCase.verifyTrue(contains(note, "В-01"));
            testCase.verifyTrue(contains(note, "30 м"));
        end
    end
end
