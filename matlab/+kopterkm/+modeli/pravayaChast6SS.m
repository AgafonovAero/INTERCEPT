function dx = pravayaChast6SS(~, x, u, parametry)
% Правая часть уравнений движения с шестью степенями свободы.

x = double(x(:));
u = max(0, min(1, double(u(:))));

polozhenie = x(1:3);
skorost = x(4:6);
ugly = x(7:9);
omega = x(10:12);
tyaga = x(13:16);

R = kopterkm.modeli.sistemyKoordinat(ugly, 'matrica_telo_v_inertsialnuyu');
summaTyagi = sum(tyaga);
silaTyagi = R * [0; 0; summaTyagi];
silaTyazhesti = [0; 0; -parametry.massa_kg * parametry.g_m_s2];
silaSoprotivleniya = -parametry.lineynoe_soprotivlenie(:) .* skorost;
uskorenie = (silaTyagi + silaTyazhesti + silaSoprotivleniya) ./ parametry.massa_kg;

moment = zeros(3, 1);
for k = 1:4
    silaTelo = [0; 0; tyaga(k)];
    moment = moment + cross(parametry.polozheniya_dvigateley_m(:, k), silaTelo);
    moment = moment + [0; 0; parametry.znak_vrashcheniya(k) * parametry.kQ_over_kT_m * tyaga(k)];
end

I = parametry.inertsiya_kg_m2;
uglovoeUskorenie = I \ (moment - cross(omega, I * omega));

E = matricaSkorosteyEilera(ugly);
proizvodnyeUglov = E * omega;

tyagaKomanda = parametry.kT .* (u .^ 2);
proizvodnyeTyagi = (tyagaKomanda - tyaga) ./ parametry.tau_motor_s;

dx = zeros(16, 1);
dx(1:3) = skorost;
dx(4:6) = uskorenie;
dx(7:9) = proizvodnyeUglov;
dx(10:12) = uglovoeUskorenie;
dx(13:16) = proizvodnyeTyagi;

if ~isempty(polozhenie)
    dx(1:3) = skorost;
end
end

function E = matricaSkorosteyEilera(ugly)
phi = ugly(1);
theta = ugly(2);
ct = cos(theta);
if abs(ct) < 1e-6
    ct = sign(ct + eps) * 1e-6;
end
E = [1, sin(phi) * tan(theta), cos(phi) * tan(theta); ...
     0, cos(phi), -sin(phi); ...
     0, sin(phi) / ct, cos(phi) / ct];
end
