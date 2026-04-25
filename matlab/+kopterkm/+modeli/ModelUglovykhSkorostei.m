function model = ModelUglovykhSkorostei(A, B, c)
% Создает параметры модели угловых скоростей.

if nargin < 1 || isempty(A)
    A = diag([-1, -1, -1]);
end
if nargin < 2 || isempty(B)
    B = eye(3);
end
if nargin < 3 || isempty(c)
    c = zeros(3, 1);
end

model = struct();
model.tip = "Модель угловых скоростей";
model.sostoyanie = "omega = [p; q; r], рад/с";
model.vkhod = "u = [u_roll; u_pitch; u_yaw]";
model.A = double(A);
model.B = double(B);
model.c = double(c(:));
end
