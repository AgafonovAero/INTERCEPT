% Запуск проверок программного обеспечения компьютерного моделирования.

startup;

import matlab.unittest.TestSuite
import matlab.unittest.TestRunner
import matlab.unittest.plugins.DiagnosticsRecordingPlugin

projectRoot = fileparts(fileparts(mfilename('fullpath')));
testFolder = fullfile(projectRoot, 'tests');
suite = TestSuite.fromFolder(testFolder, 'IncludingSubfolders', false);

runner = TestRunner.withTextOutput('OutputDetail', 3);
runner.addPlugin(DiagnosticsRecordingPlugin);
result = runner.run(suite);

disp(result);
assertSuccess(result);
