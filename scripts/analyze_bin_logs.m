% Командный запуск анализа журналов DataFlash для MATLAB.

projectRoot = fileparts(fileparts(mfilename('fullpath')));
scenarioPath = fullfile(projectRoot, 'scripts', '07_analyze_bin_logs.m');
eval(fileread(scenarioPath));
