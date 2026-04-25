function domega = pravayaChastUglovykhSkorostei(~, omega, u, parametry)
% Правая часть уравнений модели угловых скоростей.

omega = double(omega(:));
u = double(u(:));
domega = parametry.A * omega + parametry.B * u + parametry.c(:);
end
