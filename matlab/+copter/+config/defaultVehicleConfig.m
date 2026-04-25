function config = defaultVehicleConfig()
% Создает конфигурацию объекта моделирования по умолчанию.

config = struct();
config.version = 1;
config.vehicle_id = "qc_ardupilot_v0";
config.vehicle_name = "Квадрокоптер qc_ardupilot_v0";
config.model_version = "0.1.0";
config.current_level = "Оценка адекватности компьютерной модели по данным бортовой системы регистрации";

config.vehicle = struct();
config.vehicle.vehicle_id = "qc_ardupilot_v0";
config.vehicle.frame = "QUAD/X";
config.vehicle.firmware = "ArduCopter V4.7.0-dev";
config.vehicle.firmware_hash = "8f118800";
config.vehicle.flight_controller = "MatekSYS H743-SLIM V3";
config.vehicle.sensors = ["MPU6000", "ICM20602", "DPS310"];
config.vehicle.motors = "BrotherHobby Avenger 2816-1050KV";
config.vehicle.props_declared = "Gemfan 8060, 3 лопасти";
config.vehicle.props_from_cad = "APC 7x11E";
config.vehicle.esc = "SpeedyBee F405 V4 60A 3-6S 4in1 8-bit";
config.vehicle.battery = "GNB Gaoneng LiPo 7000mAh 6S1P 22.8V 70C";
config.vehicle.mass_kg_from_doc = 3.2;
config.vehicle.mass_kg_from_cad = 3.269;

config.frame = config.vehicle.frame;
config.firmware = config.vehicle.firmware;
config.firmware_hash = config.vehicle.firmware_hash;
config.flight_controller = config.vehicle.flight_controller;
config.sensors = config.vehicle.sensors;
config.motors = config.vehicle.motors;
config.props_declared = config.vehicle.props_declared;
config.props_from_cad = config.vehicle.props_from_cad;
config.esc = config.vehicle.esc;
config.battery = config.vehicle.battery;
config.mass_kg_from_doc = config.vehicle.mass_kg_from_doc;
config.mass_kg_from_cad = config.vehicle.mass_kg_from_cad;

config.geometry = struct();
config.geometry.cad_cg_mm = [-0.147; -20.467; -2.319];
config.geometry.cad_to_body_matrix = eye(3);
config.geometry.motor_4_raw_cad_mm = [-108.834; -20.437; 181.558];
config.geometry.motor_3_raw_cad_mm = [108.659; -20.437; 181.661];
config.geometry.motor_1_raw_cad_mm = [-108.659; -20.437; -181.661];
config.geometry.motor_2_raw_cad_mm = [108.659; -20.437; -181.663];
config.geometry.motor_order = [1; 2; 3; 4];
config.geometry.spin_sign = [1; -1; 1; -1];

config.cad_cg_mm = config.geometry.cad_cg_mm;
config.motor_4_raw_cad_mm = config.geometry.motor_4_raw_cad_mm;
config.motor_3_raw_cad_mm = config.geometry.motor_3_raw_cad_mm;
config.motor_1_raw_cad_mm = config.geometry.motor_1_raw_cad_mm;
config.motor_2_raw_cad_mm = config.geometry.motor_2_raw_cad_mm;

config.inertia = struct();
config.inertia.Ixx_cad_raw = 0.058;
config.inertia.Iyy_cad_raw = 0.030;
config.inertia.Izz_cad_raw = 0.044;
config.inertia.Ixy_cad_raw = 7.575e-005;
config.inertia.Ixz_cad_raw = 2.651e-005;
config.inertia.Iyz_cad_raw = -5.014e-004;
config.inertia.use_products_of_inertia = false;
config.inertia.use_diagonal_inertia_only = true;
config.inertia.default_inertia_kg_m2 = diag([0.058, 0.030, 0.044]);

config.Ixx_cad_raw = config.inertia.Ixx_cad_raw;
config.Iyy_cad_raw = config.inertia.Iyy_cad_raw;
config.Izz_cad_raw = config.inertia.Izz_cad_raw;
config.Ixy_cad_raw = config.inertia.Ixy_cad_raw;
config.Ixz_cad_raw = config.inertia.Ixz_cad_raw;
config.Iyz_cad_raw = config.inertia.Iyz_cad_raw;
config.use_products_of_inertia = config.inertia.use_products_of_inertia;
config.use_diagonal_inertia_only = config.inertia.use_diagonal_inertia_only;

config.normalization = struct();
config.normalization.pwm_min = 1000;
config.normalization.pwm_max = 2000;
config.normalization.sample_rate_hz = 100;

config.pwm_min = config.normalization.pwm_min;
config.pwm_max = config.normalization.pwm_max;

config.rate_model = struct();
config.rate_model.full_matrix_A = false;
config.rate_model.max_input_delay_steps = 5;

config.model6dof = struct();
config.model6dof.mass_kg = config.vehicle.mass_kg_from_cad;
config.model6dof.g_m_s2 = 9.80665;
config.model6dof.kT = 40;
config.model6dof.tau_motor_s = 0.05;
config.model6dof.kQ_over_kT_m = 0.02;
config.model6dof.linear_drag = [0.05; 0.05; 0.08];

config.criteria = struct();
config.criteria.rate_roll_pitch_fit_min_percent = 70;
config.criteria.rate_yaw_fit_min_percent = 60;
config.criteria.angle_roll_pitch_rmse_max_deg = 3;
config.criteria.angle_yaw_rmse_max_deg = 5;
config.criteria.note = "Критерии являются предварительными и подлежат уточнению после накопления валидационного базиса.";

config.warnings = [
    "Оси CAD не считаются автоматически совпадающими со связанной системой координат изделия."
    "По умолчанию используется диагональная матрица инерции."
    "Произведения инерции CAD сохраняются, но по умолчанию не применяются."
    "В исходном описании указаны винты Gemfan 8060, а в CAD-выгрузке присутствуют винты APC 7x11E."
    ];

config.applicability_limits = [
    "Проверка выполняется по данным бортового журнала."
    "Файл BIN на первом этапе не разбирается полноценно."
    "Не заявляется полная независимая валидация реального изделия по внешним средствам измерений."
    "Соответствие осей CAD и связанной системы координат изделия требует отдельного подтверждения."
    ];
end
