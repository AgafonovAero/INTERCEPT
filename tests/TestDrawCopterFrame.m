classdef TestDrawCopterFrame < matlab.unittest.TestCase
    % Проверка построения простой 3D-рамы квадрокоптера.

    methods (Test)
        function testDrawFrame(testCase)
            figureHandle = figure('Visible', 'off');
            cleanup = onCleanup(@() close(figureHandle));
            axesHandle = axes(figureHandle);
            handles = copter.visualization.drawCopterFrame( ...
                axesHandle, [0; 0; 0], [0; 0; 0], struct());

            testCase.verifyGreaterThan(numel(handles), 0);
            testCase.verifyTrue(all(isgraphics(handles)));
        end
    end
end
