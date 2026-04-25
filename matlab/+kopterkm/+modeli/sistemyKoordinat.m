function rezultat = sistemyKoordinat(ugly, deystvie)
% Возвращает матрицы преобразования для расчетной связанной системы координат.

if nargin < 2
    deystvie = 'matrica_telo_v_inertsialnuyu';
end

ugly = double(ugly(:));
phi = ugly(1);
theta = ugly(2);
psi = ugly(3);

Rz = [cos(psi), -sin(psi), 0; sin(psi), cos(psi), 0; 0, 0, 1];
Ry = [cos(theta), 0, sin(theta); 0, 1, 0; -sin(theta), 0, cos(theta)];
Rx = [1, 0, 0; 0, cos(phi), -sin(phi); 0, sin(phi), cos(phi)];
R = Rz * Ry * Rx;

switch char(deystvie)
    case 'matrica_telo_v_inertsialnuyu'
        rezultat = R;
    case 'matrica_inertsialnaya_v_telo'
        rezultat = R.';
    otherwise
        error('Неизвестное действие преобразования координат.');
end
end
