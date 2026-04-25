function [confirmedVehicleConfig, report] = buildConfirmedVehicleConfig(vehicleConfig, physicalCheck, selectedCandidate)
% Формирует конфигурацию изделия со статусами подтверждения.

if nargin < 1 || isempty(vehicleConfig)
    vehicleConfig = copter.config.defaultVehicleConfig();
end

if nargin < 2
    physicalCheck = struct();
end

if nargin < 3 || isempty(selectedCandidate)
    selectedCandidate = table("pr7_perm_7", {[2; 1; 3; 4]}, {[1; -1; 1; -1]}, ...
        'VariableNames', {'candidate_id', 'motor_order', 'spin_sign'});
end

confirmedVehicleConfig = vehicleConfig;
validationReport = copter.physical.validatePhysicalConfigurationCheck(physicalCheck);
comparison = copter.physical.comparePhysicalCheckWithCandidate( ...
    physicalCheck, selectedCandidate, [], vehicleConfig);

if validationReport.is_valid
    confirmedVehicleConfig.geometry.motor_order = comparison.physical_motor_order;
    confirmedVehicleConfig.geometry.spin_sign = comparison.physical_spin_sign;
    status = "physically_confirmed";
else
    status = "hypothesis_from_log";
    confirmedVehicleConfig.geometry.motor_order = readOrder(selectedCandidate);
    confirmedVehicleConfig.geometry.spin_sign = readSpin(selectedCandidate);
end

confirmedVehicleConfig.configuration_status = makeStatusStruct(status, validationReport.is_valid);
confirmedVehicleConfig.model6dof.configuration_status = confirmedVehicleConfig.configuration_status;

report = struct();
report.status = status;
report.validation = validationReport;
report.comparison = comparison;
report.warnings = unique([validationReport.warnings(:); string(comparison.differences(:))], 'stable');
end

function statusStruct = makeStatusStruct(status, isPhysical)
statusStruct = struct();
if isPhysical
    statusStruct.motor_map_status = "physically_confirmed";
    statusStruct.spin_sign_status = "physically_confirmed";
    statusStruct.cad_to_body_status = "physically_confirmed";
    statusStruct.propeller_configuration_status = "physically_confirmed";
else
    statusStruct.motor_map_status = "hypothesis_from_log";
    statusStruct.spin_sign_status = "hypothesis_from_log";
    statusStruct.cad_to_body_status = "hypothesis_from_log";
    statusStruct.propeller_configuration_status = "inconsistent_sources";
end
statusStruct.propulsion_model_status = "demonstration";
statusStruct.note = "Статусы конфигурации используются для разграничения гипотез и подтвержденных данных.";
end

function order = readOrder(candidate)
if istable(candidate) && iscell(candidate.motor_order(1))
    order = double(candidate.motor_order{1}(:));
elseif istable(candidate)
    order = double(candidate.motor_order(:));
else
    order = [1; 2; 3; 4];
end
end

function spin = readSpin(candidate)
if istable(candidate) && iscell(candidate.spin_sign(1))
    spin = double(candidate.spin_sign{1}(:));
elseif istable(candidate)
    spin = double(candidate.spin_sign(:));
else
    spin = [1; -1; 1; -1];
end
end
