% Командный запуск выделения участков ВБ и идентификации ModelRate.

projectRootForScenario = fileparts(fileparts(mfilename('fullpath')));
scenarioPath = fullfile(projectRootForScenario, 'scripts', '08_extract_segments_and_fit_rate_model.m');
eval(fileread(scenarioPath));
clear projectRootForScenario scenarioPath
