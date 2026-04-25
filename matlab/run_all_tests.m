% Запуск проверок программного обеспечения компьютерного моделирования.

startup;

import matlab.unittest.TestSuite
import matlab.unittest.TestRunner
import matlab.unittest.plugins.DiagnosticsRecordingPlugin

kornevoyKatalog = fileparts(fileparts(mfilename('fullpath')));
naborProverok = TestSuite.fromFolder(fullfile(kornevoyKatalog, 'tests'), ...
    'IncludingSubfolders', false);

ispolnitel = TestRunner.withTextOutput('OutputDetail', 3);
ispolnitel.addPlugin(DiagnosticsRecordingPlugin);
rezultat = ispolnitel.run(naborProverok);

disp(rezultat);
assertSuccess(rezultat);
