function [physicalCheck, report] = loadPhysicalConfigurationCheck(filePath)
% Загружает структурированный файл физической проверки конфигурации изделия.

warnings = strings(0, 1);
if nargin < 1 || isempty(filePath)
    filePath = fullfile("data", "raw", "physical_checks", "physical_configuration_check.json");
end

physicalCheck = struct();
physicalCheck.status = "not_available";
physicalCheck.file_path = string(filePath);

if ~isfile(filePath)
    warnings(end + 1, 1) = "Файл физической проверки отсутствует: " + string(filePath) + ".";
    report = makeReport(physicalCheck, warnings);
    return;
end

try
    physicalCheck = jsondecode(fileread(filePath));
    physicalCheck.file_path = string(filePath);
    if ~isfield(physicalCheck, 'status') || strlength(string(physicalCheck.status)) == 0
        physicalCheck.status = "loaded";
    end
catch exception
    physicalCheck.status = "not_available";
    warnings(end + 1, 1) = "Не удалось прочитать JSON физической проверки: " + string(exception.message);
end

report = makeReport(physicalCheck, warnings);
end

function report = makeReport(physicalCheck, warnings)
report = struct();
report.status = string(physicalCheck.status);
report.file_path = string(physicalCheck.file_path);
report.warnings = unique(warnings, 'stable');
end
