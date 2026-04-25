classdef TestCodeFormat < matlab.unittest.TestCase
    % Статическая проверка формата MATLAB-кода и технических имен.

    methods (Test)
        function testMatlabFilesFormat(testCase)
            projectRoot = fileparts(fileparts(mfilename('fullpath')));
            folders = [
                string(fullfile(projectRoot, 'matlab'))
                string(fullfile(projectRoot, 'scripts'))
                string(fullfile(projectRoot, 'tests'))
                ];
            files = listMatlabFiles(folders);
            forbiddenNames = buildForbiddenNames();

            for fileIndex = 1:numel(files)
                filePath = files(fileIndex);
                lines = readlines(filePath);
                checkPath(testCase, filePath, forbiddenNames);
                for lineIndex = 1:numel(lines)
                    lineText = lines(lineIndex);
                    checkFunctionComment(testCase, filePath, lineIndex, lineText);
                    checkFunctionName(testCase, filePath, lineIndex, lineText, forbiddenNames);
                    checkStringLiteral(testCase, filePath, lineIndex, lineText);
                end
            end
        end
    end
end

function files = listMatlabFiles(folders)
files = strings(0, 1);
for folderIndex = 1:numel(folders)
    folderFiles = dir(fullfile(folders(folderIndex), '**', '*.m'));
    for index = 1:numel(folderFiles)
        files(end + 1, 1) = string(fullfile(folderFiles(index).folder, folderFiles(index).name));
    end
end
end

function forbiddenNames = buildForbiddenNames()
forbiddenNames = [
    "kop" + "terkm"
    "konfigur" + "atsiya"
    "dan" + "nye"
    "mode" + "li"
    "identifik" + "atsiya"
    "valid" + "atsiya"
    "ot" + "chety"
    "sluzh" + "ebnye"
    "ots" + "enit"
    "sform" + "irovat"
    "podg" + "otovit"
    "priv" + "esti"
    "chi" + "tat"
    "kh" + "esh"
    "normaliz" + "atsiya"
    ];
end

function checkPath(testCase, filePath, forbiddenNames)
for index = 1:numel(forbiddenNames)
    testCase.verifyFalse(contains(filePath, forbiddenNames(index)), ...
        sprintf('Запрещенное имя в пути: %s', filePath));
end
end

function checkFunctionComment(testCase, filePath, lineIndex, lineText)
trimmed = strtrim(lineText);
if ~startsWith(trimmed, "function")
    return;
end

commentPosition = strfind(lineText, '%');
if isempty(commentPosition)
    return;
end

commentText = extractAfter(lineText, commentPosition(1));
badPattern = "(^|\s)(if|for|while|switch|end|model\s*=|T\s*=|omega\s*=|dx\s*=|domega\s*=)";
hasBadText = ~isempty(regexp(commentText, badPattern, 'once'));
message = sprintf('%s:%d содержит исполняемый код после комментария function.', filePath, lineIndex);
testCase.verifyFalse(hasBadText, message);
end

function checkFunctionName(testCase, filePath, lineIndex, lineText, forbiddenNames)
trimmed = strtrim(lineText);
if ~startsWith(trimmed, "function")
    return;
end

for index = 1:numel(forbiddenNames)
    hasForbiddenName = contains(trimmed, forbiddenNames(index));
    message = sprintf('%s:%d содержит старое техническое имя.', filePath, lineIndex);
    testCase.verifyFalse(hasForbiddenName, message);
end
end

function checkStringLiteral(testCase, filePath, lineIndex, lineText)
codePart = char(lineText);
singleQuoteCount = sum(double(codePart) == 39);
doubleQuoteCount = sum(double(codePart) == 34);
hasOddDoubleQuotes = mod(doubleQuoteCount, 2) ~= 0;
hasOddSingleQuotes = mod(singleQuoteCount, 2) ~= 0;
message = sprintf('%s:%d содержит подозрительный строковый литерал.', filePath, lineIndex);
testCase.verifyFalse(hasOddDoubleQuotes || hasOddSingleQuotes, message);
end

function codePart = eraseComment(lineText)
commentPosition = strfind(lineText, '%');
if isempty(commentPosition)
    codePart = lineText;
else
    codePart = extractBefore(lineText, commentPosition(1));
end
end
