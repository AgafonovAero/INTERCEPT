classdef TestNoAbsoluteLocalPathsInDocs < matlab.unittest.TestCase
    % Проверка отсутствия абсолютных локальных путей в документации.

    methods (Test)
        function testNoAbsolutePaths(testCase)
            projectRoot = fileparts(fileparts(mfilename('fullpath')));
            docFiles = dir(fullfile(projectRoot, 'docs', '**', '*.md'));
            pattern = '([A-Za-z]:\\|/home/|/Users/)';

            for index = 1:numel(docFiles)
                filePath = fullfile(docFiles(index).folder, docFiles(index).name);
                text = fileread(filePath);
                match = regexp(text, pattern, 'once');
                testCase.verifyEmpty(match, ...
                    sprintf('В документации найден абсолютный локальный путь: %s', filePath));
            end
        end
    end
end
