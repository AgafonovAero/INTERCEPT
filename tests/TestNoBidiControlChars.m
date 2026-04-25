classdef TestNoBidiControlChars < matlab.unittest.TestCase
    % Проверяет отсутствие управляющих символов двунаправленного текста.

    methods (Test)
        function testNoBidiCharactersInTrackedText(testCase)
            projectRoot = fileparts(fileparts(mfilename('fullpath')));
            files = listTrackedTextFiles(projectRoot);
            forbidden = [8234, 8235, 8236, 8237, 8238, 8294, 8295, 8296, 8297];

            for fileIndex = 1:numel(files)
                text = fileread(files(fileIndex));
                codePoints = double(char(text));
                for forbiddenIndex = 1:numel(forbidden)
                    hasForbidden = any(codePoints == forbidden(forbiddenIndex));
                    message = sprintf('%s содержит Unicode bidi control character U+%04X.', ...
                        files(fileIndex), forbidden(forbiddenIndex));
                    testCase.verifyFalse(hasForbidden, message);
                end
            end
        end
    end
end

function files = listTrackedTextFiles(projectRoot)
command = "git -C " + quotedPath(projectRoot) + " ls-files --full-name";
[status, output] = system(command);
assert(status == 0, 'Не удалось получить перечень файлов Git.');
allFiles = string(splitlines(strtrim(output)));
files = strings(0, 1);
extensions = [".m", ".md", ".json", ".gitignore"];

for index = 1:numel(allFiles)
    relativePath = allFiles(index);
    if strlength(relativePath) == 0
        continue;
    end

    [~, fileName, extension] = fileparts(relativePath);
    fullName = fileName + extension;
    if any(extension == extensions) || any(fullName == extensions)
        normalizedPath = strrep(relativePath, '/', filesep);
        files(end + 1, 1) = string(fullfile(projectRoot, normalizedPath));
    end
end
end

function text = quotedPath(pathValue)
text = """" + string(pathValue) + """";
end
