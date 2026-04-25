classdef TestRepositoryFiles < matlab.unittest.TestCase
    % Проверка обязательной структуры репозитория для PR №1.

    methods (Test)
        function testRequiredProjectStructure(testCase)
            projectRoot = fileparts(fileparts(mfilename('fullpath')));
            requiredPaths = [
                "matlab/+copter"
                "matlab/+copter/+config"
                "matlab/+copter/+data"
                "matlab/+copter/+models"
                "matlab/+copter/+identification"
                "matlab/+copter/+validation"
                "matlab/+copter/+reports"
                "matlab/+copter/+utils"
                "config/vehicle_qc_ardupilot_v0.json"
                "config/validation_basis_v0.json"
                "docs/model_description.md"
                "docs/validation_by_log_method.md"
                "docs/data_contract.md"
                "docs/simulink_preparation.md"
                "data/raw/ardupilot/bin/README.md"
                "data/raw/ardupilot/bin/manifest_template.json"
                "docs/validation_basis/README.md"
                "result/README.md"
                "matlab/+copter/+models/ModelRate.m"
                "matlab/+copter/+models/Model6DOF.m"
                "matlab/+copter/+validation/validateByLog.m"
                "matlab/+copter/+validation/buildValidationMatrix.m"
                "matlab/+copter/+reports/writeMarkdownReport.m"
                "matlab/+copter/+reports/writeBinAnalysisSummary.m"
                "matlab/+copter/+reports/writeMissingBinLogsReport.m"
                "matlab/+copter/+data/preprocessLogData.m"
                "matlab/+copter/+data/inspectBinLog.m"
                "matlab/+copter/+data/readBinLog.m"
                "matlab/+copter/+data/parseDataFlashFmt.m"
                "matlab/+copter/+data/decodeDataFlashMessage.m"
                "matlab/+copter/+data/dataFlashFormatMap.m"
                "matlab/+copter/+data/buildLogChannelInventory.m"
                "config/log_manifest_v0.json"
                "scripts/analyze_bin_logs.m"
                "scripts/07_analyze_bin_logs.m"
                "tests/TestDataFlashParserSynthetic.m"
                "tests/TestLogManifest.m"
                ];

            for index = 1:numel(requiredPaths)
                pathToCheck = fullfile(projectRoot, requiredPaths(index));
                message = sprintf('Отсутствует обязательный путь: %s', pathToCheck);
                testCase.verifyTrue(isfolder(pathToCheck) || isfile(pathToCheck), message);
            end
        end
    end
end
