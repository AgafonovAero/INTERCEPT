function konfiguratsiya = sozdatKonfiguratsiyuPoUmolchaniyu()
% Создает исходную конфигурацию объекта моделирования.

konfiguratsiya = struct();
konfiguratsiya.versiya_formatta = 1;
konfiguratsiya.identifikator_izdeliya = "qc_ardupilot_v0";
konfiguratsiya.naimenovanie_izdeliya = "Квадрокоптер qc_ardupilot_v0";
konfiguratsiya.versiya_modeli = "0.1.0";
konfiguratsiya.tekushchiy_uroven = "Оценка адекватности компьютерной модели по данным бортовой системы регистрации";

konfiguratsiya.izdeliye = struct();
konfiguratsiya.izdeliye.skhema = "QUAD/X";
konfiguratsiya.izdeliye.proshivka = "ArduCopter V4.7.0-dev";
konfiguratsiya.izdeliye.khesh_proshivki = "8f118800";
konfiguratsiya.izdeliye.poletnyy_kontroller = "MatekSYS H743-SLIM V3";
konfiguratsiya.izdeliye.datchiki = ["MPU6000", "ICM20602", "DPS310"];
konfiguratsiya.izdeliye.dvigiteli = "BrotherHobby Avenger 2816-1050KV";
konfiguratsiya.izdeliye.vinty_po_opisaniyu = "Gemfan 8060, 3 лопасти";
konfiguratsiya.izdeliye.vinty_po_cad = "APC 7x11E";
konfiguratsiya.izdeliye.regulyator_dvigateley = "SpeedyBee F405 V4 60A 3-6S 4in1 8-bit";
konfiguratsiya.izdeliye.akkumulyator = "GNB Gaoneng LiPo 7000mAh 6S1P 22.8V 70C";
konfiguratsiya.izdeliye.massa_po_opisaniyu_kg = 3.2;
konfiguratsiya.izdeliye.massa_po_cad_kg = 3.269;

konfiguratsiya.geometriya = struct();
konfiguratsiya.geometriya.tsentr_mass_cad_mm = [-0.147; -20.467; -2.319];
konfiguratsiya.geometriya.preobrazovanie_cad_v_ssi = eye(3);
konfiguratsiya.geometriya.opisanie_preobrazovaniya = ...
    "Первый вариант хранит явный слой преобразования CAD -> связанная система координат изделия. Матрица должна быть подтверждена пользователем.";
konfiguratsiya.geometriya.motor_4_raw_cad_mm = [-108.834; -20.437; 181.558];
konfiguratsiya.geometriya.motor_3_raw_cad_mm = [108.659; -20.437; 181.661];
konfiguratsiya.geometriya.motor_1_raw_cad_mm = [-108.659; -20.437; -181.661];
konfiguratsiya.geometriya.motor_2_raw_cad_mm = [108.659; -20.437; -181.663];
konfiguratsiya.geometriya.poryadok_dvigateley = [1; 2; 3; 4];
konfiguratsiya.geometriya.znak_vrashcheniya = [1; -1; 1; -1];

konfiguratsiya.inertsiya = struct();
konfiguratsiya.inertsiya.Ixx_cad_raw = 0.058;
konfiguratsiya.inertsiya.Iyy_cad_raw = 0.030;
konfiguratsiya.inertsiya.Izz_cad_raw = 0.044;
konfiguratsiya.inertsiya.Ixy_cad_raw = 7.575e-005;
konfiguratsiya.inertsiya.Ixz_cad_raw = 2.651e-005;
konfiguratsiya.inertsiya.Iyz_cad_raw = -5.014e-004;
konfiguratsiya.inertsiya.use_products_of_inertia = false;
konfiguratsiya.inertsiya.matrica_po_umolchaniyu_kg_m2 = diag([0.058, 0.030, 0.044]);
konfiguratsiya.inertsiya.preduprezhdenie = ...
    "По умолчанию используется диагональная матрица инерции. Произведения инерции сохранены, но не применяются до подтверждения соответствия систем координат.";

konfiguratsiya.normalizatsiya = struct();
konfiguratsiya.normalizatsiya.rcou_min_mks = 1000;
konfiguratsiya.normalizatsiya.rcou_max_mks = 2000;
konfiguratsiya.normalizatsiya.chastota_setki_gts = 100;

konfiguratsiya.model_uglovykh_skorostei = struct();
konfiguratsiya.model_uglovykh_skorostei.polnaya_matrica_A = false;
konfiguratsiya.model_uglovykh_skorostei.maksimalnaya_zaderzhka_shagov = 5;

konfiguratsiya.model_6ss = struct();
konfiguratsiya.model_6ss.massa_kg = konfiguratsiya.izdeliye.massa_po_cad_kg;
konfiguratsiya.model_6ss.g_m_s2 = 9.80665;
konfiguratsiya.model_6ss.kT = 40;
konfiguratsiya.model_6ss.tau_motor_s = 0.05;
konfiguratsiya.model_6ss.kQ_over_kT_m = 0.02;
konfiguratsiya.model_6ss.lineynoe_soprotivlenie = [0.05; 0.05; 0.08];

konfiguratsiya.kriterii = struct();
konfiguratsiya.kriterii.sootvetstvie_roll_pitch_min_proc = 70;
konfiguratsiya.kriterii.sootvetstvie_yaw_min_proc = 60;
konfiguratsiya.kriterii.sko_roll_pitch_max_grad = 3;
konfiguratsiya.kriterii.sko_yaw_max_grad = 5;
konfiguratsiya.kriterii.primechanie = ...
    "Критерии являются предварительными и подлежат уточнению после накопления валидационного базиса.";

konfiguratsiya.ogranicheniya = [
    "Проверка выполняется по данным бортового журнала."
    "Файл .BIN на первом этапе должен быть предварительно приведен к табличному виду штатными средствами пользователя."
    "Не заявляется полная независимая валидация реального изделия по внешним средствам измерений."
    "Соответствие осей CAD и связанной системы координат изделия требует отдельного подтверждения."
    ];

konfiguratsiya.preduprezhdeniya = [
    "В исходном описании указаны винты Gemfan 8060, а в CAD-выгрузке присутствуют винты APC 7x11E. Противоречие не устранено автоматически."
    konfiguratsiya.inertsiya.preduprezhdenie
    ];
end
