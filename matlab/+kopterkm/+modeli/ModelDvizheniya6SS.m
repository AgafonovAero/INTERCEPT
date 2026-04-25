function model = ModelDvizheniya6SS(konfiguratsiya)
% Создает параметры модели движения с шестью степенями свободы.

if nargin < 1 || isempty(konfiguratsiya)
    konfiguratsiya = kopterkm.konfiguratsiya.sozdatKonfiguratsiyuPoUmolchaniyu();
end

model = struct();
model.tip = "Модель движения с шестью степенями свободы";
model.massa_kg = double(konfiguratsiya.model_6ss.massa_kg);
model.g_m_s2 = double(konfiguratsiya.model_6ss.g_m_s2);
model.kT = double(konfiguratsiya.model_6ss.kT);
model.tau_motor_s = double(konfiguratsiya.model_6ss.tau_motor_s);
model.kQ_over_kT_m = double(konfiguratsiya.model_6ss.kQ_over_kT_m);
model.lineynoe_soprotivlenie = double(konfiguratsiya.model_6ss.lineynoe_soprotivlenie(:));
model.inertsiya_kg_m2 = poluchitMatrichuInertsii(konfiguratsiya);
model.polozheniya_dvigateley_m = polozheniyaDvigateley(konfiguratsiya);
model.znak_vrashcheniya = double(konfiguratsiya.geometriya.znak_vrashcheniya(:));
model.preduprezhdenie_inertsii = string(konfiguratsiya.inertsiya.preduprezhdenie);
end

function I = poluchitMatrichuInertsii(konfiguratsiya)
if isfield(konfiguratsiya.inertsiya, 'use_products_of_inertia') && konfiguratsiya.inertsiya.use_products_of_inertia
    I = [konfiguratsiya.inertsiya.Ixx_cad_raw, -konfiguratsiya.inertsiya.Ixy_cad_raw, -konfiguratsiya.inertsiya.Ixz_cad_raw; ...
        -konfiguratsiya.inertsiya.Ixy_cad_raw, konfiguratsiya.inertsiya.Iyy_cad_raw, -konfiguratsiya.inertsiya.Iyz_cad_raw; ...
        -konfiguratsiya.inertsiya.Ixz_cad_raw, -konfiguratsiya.inertsiya.Iyz_cad_raw, konfiguratsiya.inertsiya.Izz_cad_raw];
else
    I = double(konfiguratsiya.inertsiya.matrica_po_umolchaniyu_kg_m2);
end
end

function r = polozheniyaDvigateley(konfiguratsiya)
cm = double(konfiguratsiya.geometriya.tsentr_mass_cad_mm(:));
R = double(konfiguratsiya.geometriya.preobrazovanie_cad_v_ssi);
motor1 = double(konfiguratsiya.geometriya.motor_1_raw_cad_mm(:));
motor2 = double(konfiguratsiya.geometriya.motor_2_raw_cad_mm(:));
motor3 = double(konfiguratsiya.geometriya.motor_3_raw_cad_mm(:));
motor4 = double(konfiguratsiya.geometriya.motor_4_raw_cad_mm(:));
rCad = [motor1 - cm, motor2 - cm, motor3 - cm, motor4 - cm] ./ 1000;
r = R * rCad;
end
