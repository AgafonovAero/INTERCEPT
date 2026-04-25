% Запускает визуальный демонстратор PR №5 с допустимым для MATLAB именем.

projectRootForScenario = fileparts(fileparts(mfilename('fullpath')));
run(fullfile(projectRootForScenario, 'scripts', 'visualDemoAndModel6dofFlightImpl.m'));
