% Демонстрационный расчет Model6DOF на синтетическом примере.

projectRoot = fileparts(fileparts(mfilename('fullpath')));
run(fullfile(projectRoot, 'matlab', 'startup.m'));
config = copter.config.loadConfig(fullfile(projectRoot, 'config', 'vehicle_qc_ardupilot_v0.json'));
model = copter.models.Model6DOF(config);

state0 = zeros(16, 1);
thrustPerMotor = model.mass_kg * model.g_m_s2 / 4;
state0(13:16) = thrustPerMotor;
hoverInput = sqrt(thrustPerMotor / model.kT) * ones(4, 1);

rhs = @(time, state) copter.models.rhs6DOF(time, state, hoverInput, model);
[time, state] = ode45(rhs, [0 2], state0);

outputPath = fullfile(projectRoot, 'result', 'model6dof_demo.mat');
save(outputPath, 'time', 'state', 'model');
fprintf('Демонстрационный расчет Model6DOF сохранен: %s\n', outputPath);
fprintf('Этот расчет не претендует на физическую точность реального изделия.\n');
