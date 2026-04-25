classdef TestDataFlashParserSynthetic < matlab.unittest.TestCase
    % Проверка синтетического бортового журнала DataFlash BIN.

    methods (Test)
        function testSyntheticDataFlashParser(testCase)
            temporaryFolder = tempname;
            mkdir(temporaryFolder);
            cleanup = onCleanup(@() rmdir(temporaryFolder, 's'));
            filePath = fullfile(temporaryFolder, 'synthetic.BIN');
            writeSyntheticBin(filePath);

            summary = copter.data.inspectBinLog(filePath);
            messageNames = string(summary.messages.message_name);
            testCase.verifyTrue(any(messageNames == "ATT"));
            testCase.verifyTrue(any(messageNames == "RATE"));

            attRow = summary.messages(messageNames == "ATT", :);
            rateRow = summary.messages(messageNames == "RATE", :);
            testCase.verifyTrue(attRow.has_TimeUS);
            testCase.verifyTrue(rateRow.has_TimeUS);
            testCase.verifyGreaterThan(attRow.estimated_rate_hz, 0);
            testCase.verifyGreaterThan(rateRow.estimated_rate_hz, 0);

            config = copter.config.defaultVehicleConfig();
            logData = copter.data.readBinLog(filePath, config);
            testCase.verifyTrue(isfield(logData.messages, 'ATT'));
            testCase.verifyTrue(isfield(logData.messages, 'RATE'));
            testCase.verifyTrue(ismember('TimeUS', logData.messages.ATT.Properties.VariableNames));
            testCase.verifyTrue(ismember('TimeUS', logData.messages.RATE.Properties.VariableNames));
            testCase.verifyEqual(height(logData.messages.ATT), 3);
            testCase.verifyEqual(height(logData.messages.RATE), 3);
        end
    end
end

function writeSyntheticBin(filePath)
fileId = fopen(filePath, 'w');
assert(fileId > 0, 'Не удалось создать синтетический BIN.');
cleanup = onCleanup(@() fclose(fileId));

writeFmtPacket(fileId, 1, "ATT", "Qfff", "TimeUS,Roll,Pitch,Yaw");
writeFmtPacket(fileId, 2, "RATE", "Qfff", "TimeUS,R,P,Y");

for index = 1:3
    timeUs = uint64((index - 1) * 10000);
    writeDataPacket(fileId, 1, [typecast(timeUs, 'uint8'), typecast(single([0.1, 0.2, 0.3] * index), 'uint8')]);
    writeDataPacket(fileId, 2, [typecast(timeUs, 'uint8'), typecast(single([1.0, 2.0, 3.0] * index), 'uint8')]);
end
end

function writeFmtPacket(fileId, typeId, name, formatText, columnsText)
payload = zeros(1, 86, 'uint8');
payload(1) = uint8(typeId);
payload(2) = uint8(3 + payloadLength(formatText));
payload(3:6) = paddedBytes(name, 4);
payload(7:22) = paddedBytes(formatText, 16);
payload(23:86) = paddedBytes(columnsText, 64);
writeDataPacket(fileId, 128, payload);
end

function writeDataPacket(fileId, typeId, payload)
header = uint8([hex2dec('A3'), hex2dec('95'), typeId]);
fwrite(fileId, header, 'uint8');
fwrite(fileId, uint8(payload), 'uint8');
end

function bytes = paddedBytes(text, width)
bytes = zeros(1, width, 'uint8');
raw = uint8(char(text));
copyCount = min(numel(raw), width);
bytes(1:copyCount) = raw(1:copyCount);
end

function lengthBytes = payloadLength(formatText)
formatMap = copter.data.dataFlashFormatMap();
chars = char(formatText);
lengthBytes = 0;
for index = 1:numel(chars)
    entry = formatMap(chars(index));
    lengthBytes = lengthBytes + entry.size_bytes;
end
end
