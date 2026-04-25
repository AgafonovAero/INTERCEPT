% Настройка путей программного обеспечения компьютерного моделирования.

projectRoot = fileparts(fileparts(mfilename('fullpath')));

addpath(fullfile(projectRoot, 'matlab'));
addpath(fullfile(projectRoot, 'scripts'));
addpath(fullfile(projectRoot, 'tests'));

configPath = fullfile(projectRoot, 'config', 'vehicle_qc_ardupilot_v0.json');
if ~isfile(configPath)
    vehicleConfig = copter.config.defaultVehicleConfig();
    copter.config.saveConfig(vehicleConfig, configPath);
    fprintf('Создана конфигурация изделия: %s\n', configPath);
end

validationBasisPath = fullfile(projectRoot, 'config', 'validation_basis_v0.json');
if ~isfile(validationBasisPath)
    validationBasis = copter.config.defaultValidationBasis();
    copter.utils.writeJson(validationBasisPath, validationBasis);
    fprintf('Создан реестр валидационного базиса: %s\n', validationBasisPath);
end

fprintf('Пути проекта компьютерного моделирования настроены.\n');
