function model = ModelVintomotornoyGruppy(kT, tauMotorS, kQoverKT)
% Создает параметры винтомоторной группы.

if nargin < 1 || isempty(kT)
    kT = 40;
end
if nargin < 2 || isempty(tauMotorS)
    tauMotorS = 0.05;
end
if nargin < 3 || isempty(kQoverKT)
    kQoverKT = 0.02;
end

model = struct();
model.kT = kT;
model.tau_motor_s = tauMotorS;
model.kQ_over_kT_m = kQoverKT;
end
