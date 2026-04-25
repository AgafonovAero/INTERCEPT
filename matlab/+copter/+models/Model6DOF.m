function model = Model6DOF(config)
% Создает структуру модели движения с шестью степенями свободы.

if nargin < 1 || isempty(config)
    config = copter.config.defaultVehicleConfig();
end

model = struct();
model.type = "Модель движения с шестью степенями свободы";
model.mass_kg = double(config.model6dof.mass_kg);
model.g_m_s2 = double(config.model6dof.g_m_s2);
model.kT = double(config.model6dof.kT);
model.tau_motor_s = double(config.model6dof.tau_motor_s);
model.kQ_over_kT_m = double(config.model6dof.kQ_over_kT_m);
model.linear_drag = double(config.model6dof.linear_drag(:));
model.inertia_kg_m2 = getInertiaMatrix(config);
model.motor_positions_m = getMotorPositions(config);
model.spin_sign = double(config.geometry.spin_sign(:));
model.configuration_status = getConfigurationStatus(config);
model.motor_map_status = model.configuration_status.motor_map_status;
model.spin_sign_status = model.configuration_status.spin_sign_status;
model.cad_to_body_status = model.configuration_status.cad_to_body_status;
model.propulsion_model_status = model.configuration_status.propulsion_model_status;
model.propeller_configuration_status = model.configuration_status.propeller_configuration_status;
model.warnings = string(config.warnings(:));
model.warnings(end + 1, 1) = "Параметры тяги в PR №5 заданы демонстрационно и подлежат идентификации по стендовым или летным данным.";
model.warnings(end + 1, 1) = "До физического подтверждения выбранная конфигурация Model6DOF должна рассматриваться как расчетная гипотеза.";
model.limitations = [
    "Model6DOF в демонстрационном режиме не является полной независимой валидацией."
    "Аэродинамика, ESC telemetry и модель винтомоторной группы подлежат дальнейшей идентификации."
    ];
end

function inertia = getInertiaMatrix(config)
if isfield(config.inertia, 'use_products_of_inertia')
    useProducts = config.inertia.use_products_of_inertia;
else
    useProducts = false;
end

if useProducts
    inertia = [
        config.inertia.Ixx_cad_raw, -config.inertia.Ixy_cad_raw, -config.inertia.Ixz_cad_raw
        -config.inertia.Ixy_cad_raw, config.inertia.Iyy_cad_raw, -config.inertia.Iyz_cad_raw
        -config.inertia.Ixz_cad_raw, -config.inertia.Iyz_cad_raw, config.inertia.Izz_cad_raw
        ];
else
    inertia = double(config.inertia.default_inertia_kg_m2);
end
end

function positions = getMotorPositions(config)
centerOfMass = double(config.geometry.cad_cg_mm(:));
transform = double(config.geometry.cad_to_body_matrix);
motor1 = double(config.geometry.motor_1_raw_cad_mm(:));
motor2 = double(config.geometry.motor_2_raw_cad_mm(:));
motor3 = double(config.geometry.motor_3_raw_cad_mm(:));
motor4 = double(config.geometry.motor_4_raw_cad_mm(:));
positionsCad = [
    motor1 - centerOfMass, ...
    motor2 - centerOfMass, ...
    motor3 - centerOfMass, ...
    motor4 - centerOfMass
    ] ./ 1000;
positions = transform * positionsCad;
end

function status = getConfigurationStatus(config)
if isfield(config, 'configuration_status')
    status = config.configuration_status;
elseif isfield(config.model6dof, 'configuration_status')
    status = config.model6dof.configuration_status;
else
    status = struct();
end

status = ensureStatusField(status, "motor_map_status", "unknown");
status = ensureStatusField(status, "spin_sign_status", "unknown");
status = ensureStatusField(status, "cad_to_body_status", "unknown");
status = ensureStatusField(status, "propulsion_model_status", "unknown");
status = ensureStatusField(status, "propeller_configuration_status", "inconsistent_sources");
end

function status = ensureStatusField(status, fieldName, defaultValue)
if ~isfield(status, char(fieldName)) || strlength(string(status.(char(fieldName)))) == 0
    status.(char(fieldName)) = string(defaultValue);
end
end
