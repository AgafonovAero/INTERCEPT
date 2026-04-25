function model = ModelRateDiscrete(Ad, Bd, cd, delaySamples, sampleTime)
% Создает диагностическую дискретную модель угловых скоростей.

if nargin < 1 || isempty(Ad)
    Ad = eye(3);
end

if nargin < 2 || isempty(Bd)
    Bd = zeros(3);
end

if nargin < 3 || isempty(cd)
    cd = zeros(3, 1);
end

if nargin < 4 || isempty(delaySamples)
    delaySamples = 0;
end

if nargin < 5 || isempty(sampleTime)
    sampleTime = NaN;
end

model = struct();
model.type = "Диагностическая дискретная модель угловых скоростей";
model.state_description = "omega = [p; q; r], рад/с";
model.input_description = "u = [u_roll; u_pitch; u_yaw]";
model.equation = "omega[k+1] = Ad * omega[k] + Bd * u[k-delay] + cd";
model.Ad = double(Ad);
model.Bd = double(Bd);
model.cd = double(cd(:));
model.delay_samples = double(delaySamples);
model.sample_time_s = double(sampleTime);
end
