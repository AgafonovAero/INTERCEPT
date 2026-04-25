classdef TestTextFileLineEndings < matlab.unittest.TestCase
    % Проверка окончаний строк и чрезмерно длинных строк текстовых файлов.

    methods (Test)
        function testLineEndings(testCase)
            projectRoot = fileparts(fileparts(mfilename('fullpath')));
            files = listTrackedTextFiles(projectRoot);

            for index = 1:numel(files)
                filePath = files(index);
                bytes = readFileBytes(filePath);
                testCase.verifyFalse(hasCrOnly(bytes), ...
                    sprintf('%s содержит CR-only окончание строки.', filePath));

                [lines, lineBreakCount] = splitLines(bytes);
                [~, ~, extension] = fileparts(filePath);
                if extension == ".m"
                    testCase.verifyGreaterThan(lineBreakCount, 0, ...
                        sprintf('%s является одной строкой без LF/CRLF.', filePath));
                    checkMatlabLineLengths(testCase, filePath, lines);
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
extensions = [".m", ".md", ".json", ".gitignore"];
files = strings(0, 1);

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

function text = quotedPath(pathValue)
text = """" + string(pathValue) + """";
end
end

function bytes = readFileBytes(filePath)
fileId = fopen(filePath, 'r');
assert(fileId > 0, 'Не удалось открыть файл для проверки окончаний строк: %s', filePath);
cleanup = onCleanup(@() fclose(fileId));
bytes = fread(fileId, Inf, '*uint8');
end

function result = hasCrOnly(bytes)
crIndex = find(bytes == 13);
result = false;
for index = 1:numel(crIndex)
    position = crIndex(index);
    if position == numel(bytes) || bytes(position + 1) ~= 10
        result = true;
        return;
    end
end
end

function [lines, lineBreakCount] = splitLines(bytes)
text = native2unicode(transpose(bytes), 'UTF-8');
text = replace(string(text), sprintf('\r\n'), newline);
lineBreakCount = count(text, newline);
lines = splitlines(text);
end

function checkMatlabLineLengths(testCase, filePath, lines)
for lineIndex = 1:numel(lines)
    lineText = lines(lineIndex);
    if strlength(lineText) <= 220 || isAllowedLongLine(filePath, lineText)
        continue;
    end

    message = sprintf('%s:%d содержит строку длиннее 220 символов.', filePath, lineIndex);
    testCase.verifyLessThanOrEqual(strlength(lineText), 220, message);
end
end

function result = isAllowedLongLine(filePath, lineText)
allowedMarkers = [
    "http://"
    "https://"
    "Данная проверка выполнена по данным бортового журнала"
    ];
result = any(contains(lineText, allowedMarkers)) || contains(filePath, "defaultValidationBasis.m");
end
