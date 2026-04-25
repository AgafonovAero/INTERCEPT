% Создание каталогов и исходных файлов управления конфигурацией.

projectRoot = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(projectRoot, 'matlab'));

folders = [
    "matlab"
    "scripts"
    "config"
    "docs"
    fullfile("docs", "validation_basis")
    "tests"
    "result"
    fullfile("data", "raw")
    fullfile("data", "raw", "ardupilot", "bin")
    fullfile("data", "processed")
    ];

for index = 1:numel(folders)
    folderPath = fullfile(projectRoot, folders(index));
    if ~isfolder(folderPath)
        mkdir(folderPath);
    end
end

configPath = fullfile(projectRoot, 'config', 'vehicle_qc_ardupilot_v0.json');
if ~isfile(configPath)
    config = copter.config.defaultVehicleConfig();
    copter.config.saveConfig(config, configPath);
end

validationBasisPath = fullfile(projectRoot, 'config', 'validation_basis_v0.json');
if ~isfile(validationBasisPath)
    validationBasis = copter.config.defaultValidationBasis();
    copter.utils.writeJson(validationBasisPath, validationBasis);
end

fprintf('Проект компьютерного моделирования подготовлен.\n');
fprintf('Конфигурация изделия: %s\n', configPath);
fprintf('Реестр валидационного базиса: %s\n', validationBasisPath);
fprintf('Журналы BIN разместите в: %s\n', fullfile(projectRoot, 'data', 'raw', 'ardupilot', 'bin'));
fprintf('PDF ВБ разместите в: %s\n', fullfile(projectRoot, 'docs', 'validation_basis', 'ValidationBasis_v0.pdf'));
