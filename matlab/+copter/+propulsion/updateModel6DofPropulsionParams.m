function [updatedConfig, report] = updateModel6DofPropulsionParams(vehicleConfig, thrustModel, currentModel, batteryModel)
% Обновляет параметры Model6DOF по стендовой модели ВМГ, если данные доступны.

updatedConfig = vehicleConfig;
warnings = strings(0, 1);
status = "bench_data_not_available";

if nargin >= 2 && isstruct(thrustModel) && isfield(thrustModel, 'type') ...
        && thrustModel.type ~= "not_fitted"
    if isfield(thrustModel, 'a2') && isfinite(thrustModel.a2)
        updatedConfig.model6dof.kT = max(1, 4 * thrustModel.a2);
        status = "fitted_from_bench";
    elseif isfield(thrustModel, 'kT_rpm') && isfinite(thrustModel.kT_rpm)
        updatedConfig.model6dof.kT_rpm = thrustModel.kT_rpm;
        status = "fitted_from_bench";
    end
else
    warnings(end + 1, 1) = "Стендовая модель тяги отсутствует; параметры Model6DOF не изменены.";
end

updatedConfig.configuration_status = ensureStatus(updatedConfig, status);
updatedConfig.model6dof.configuration_status = updatedConfig.configuration_status;
if nargin >= 3 && isstruct(currentModel)
    updatedConfig.model6dof.current_model = currentModel;
end
if nargin >= 4 && isstruct(batteryModel)
    updatedConfig.model6dof.battery_model = batteryModel;
end

report = struct();
report.status = status;
report.warnings = unique(warnings, 'stable');
end

function statusStruct = ensureStatus(config, propulsionStatus)
if isfield(config, 'configuration_status')
    statusStruct = config.configuration_status;
else
    statusStruct = struct();
end
statusStruct.propulsion_model_status = string(propulsionStatus);
if ~isfield(statusStruct, 'motor_map_status')
    statusStruct.motor_map_status = "hypothesis_from_log";
end
if ~isfield(statusStruct, 'spin_sign_status')
    statusStruct.spin_sign_status = "hypothesis_from_log";
end
if ~isfield(statusStruct, 'cad_to_body_status')
    statusStruct.cad_to_body_status = "hypothesis_from_log";
end
if ~isfield(statusStruct, 'propeller_configuration_status')
    statusStruct.propeller_configuration_status = "inconsistent_sources";
end
end
