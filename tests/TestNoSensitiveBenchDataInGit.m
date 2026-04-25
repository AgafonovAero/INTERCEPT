classdef TestNoSensitiveBenchDataInGit < matlab.unittest.TestCase
    % Проверяет, что реальные физические и стендовые данные не отслеживаются Git.

    methods (Test)
        function testOnlyTemplatesAreTracked(testCase)
            projectRoot = fileparts(fileparts(mfilename('fullpath')));
            tracked = gitFiles(projectRoot);
            sensitivePrefixes = [
                "data/raw/physical_checks/"
                "data/raw/bench/propulsion/"
                ];
            allowed = allowedFiles();

            for index = 1:numel(tracked)
                path = strrep(tracked(index), "\", "/");
                if any(startsWith(path, sensitivePrefixes))
                    testCase.verifyTrue(any(path == allowed), ...
                        sprintf('Чувствительный файл не должен отслеживаться Git: %s', path));
                end
            end
        end
    end
end

function files = gitFiles(projectRoot)
command = "git -C " + quotedPath(projectRoot) + " ls-files --full-name";
[status, output] = system(command);
assert(status == 0, 'Не удалось получить перечень файлов Git.');
files = string(splitlines(strtrim(output)));
end

function files = allowedFiles()
files = [
    "data/raw/physical_checks/.gitkeep"
    "data/raw/physical_checks/README.md"
    "data/raw/physical_checks/physical_configuration_check_template.json"
    "data/raw/physical_checks/motor_spin_check_template.csv"
    "data/raw/physical_checks/motor_order_check_template.csv"
    "data/raw/physical_checks/propeller_installation_check_template.csv"
    "data/raw/bench/propulsion/.gitkeep"
    "data/raw/bench/propulsion/README.md"
    "data/raw/bench/propulsion/propulsion_static_test_template.csv"
    "data/raw/bench/propulsion/battery_discharge_test_template.csv"
    "data/raw/bench/propulsion/esc_current_voltage_template.csv"
    ];
end

function text = quotedPath(pathValue)
text = """" + string(pathValue) + """";
end
