function [luchshayaZaderzhka, oshibki] = otsenitZaderzhkuVkhoda(y, dy, u, maksimalnayaZaderzhka)
% Подбирает целочисленную задержку входного воздействия.

if nargin < 4 || isempty(maksimalnayaZaderzhka)
    maksimalnayaZaderzhka = 5;
end

y = double(y(:));
dy = double(dy(:));
u = double(u(:));
oshibki = inf(maksimalnayaZaderzhka + 1, 1);

for zaderzhka = 0:maksimalnayaZaderzhka
    indeks = (1 + zaderzhka):numel(y);
    if numel(indeks) < 4
        continue;
    end
    yy = y(indeks);
    ddy = dy(indeks);
    uu = u(indeks - zaderzhka);
    X = [yy, uu, ones(numel(yy), 1)];
    theta = X \ ddy;
    ostatok = ddy - X * theta;
    oshibki(zaderzhka + 1) = sqrt(mean(ostatok .^ 2, 'omitnan'));
end

[~, nomer] = min(oshibki);
luchshayaZaderzhka = nomer - 1;
end
