function model = ModelRate(A, B, c)
% Создает структуру модели угловых скоростей.

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
model.type = "Модель угловых скоростей";
model.state_description = "omega = [p; q; r], рад/с";
model.input_description = "u = [u_roll; u_pitch; u_yaw]";
model.equation = "domega/dt = A * omega + B * u + c";
model.A = double(A);
model.B = double(B);
model.c = double(c(:));
end
