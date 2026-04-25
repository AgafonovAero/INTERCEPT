classdef TestBinToProcessedTimetable < matlab.unittest.TestCase
    % Проверка формирования обработанного timetable из синтетического BIN.

    methods (Test)
        function testBuildProcessedTimetable(testCase)
            temporaryFolder = tempname;
            mkdir(temporaryFolder);
            cleanup = onCleanup(@() rmdir(temporaryFolder, 's'));
            filePath = fullfile(temporaryFolder, 'synthetic.BIN');
            writeSyntheticBin(filePath);

            config = copter.config.defaultVehicleConfig();
            settings = struct();
            settings.sample_rate_hz = 50;
            settings.hover_max_horizontal_speed_mps = 2;
            settings.hover_max_vertical_speed_mps = 1;
            settings.hover_max_roll_pitch_deg = 10;
            settings.climb_vertical_speed_threshold_mps = 1;
            settings.descent_vertical_speed_threshold_mps = 1;

            [processedData, qualityReport] = copter.data.buildProcessedTimetableFromBin(filePath, config, settings);

            testCase.verifyTrue(istimetable(processedData));
            names = string(processedData.Properties.VariableNames);
            testCase.verifyTrue(any(names == "RATE.R"));
            testCase.verifyTrue(any(names == "RATE.P"));
            testCase.verifyTrue(any(names == "RATE.Y"));
            testCase.verifyTrue(any(names == "ATT.Roll"));
            testCase.verifyTrue(any(names == "ATT.Pitch"));
            testCase.verifyGreaterThan(qualityReport.row_count, 0);
            testCase.verifyTrue(isfield(qualityReport, 'warnings'));
        end
    end
end

function writeSyntheticBin(filePath)
fileId = fopen(filePath, 'w');
assert(fileId > 0, 'Не удалось создать синтетический BIN.');
cleanup = onCleanup(@() fclose(fileId));

writeFmtPacket(fileId, 1, "ATT", "Qfff", "TimeUS,Roll,Pitch,Yaw");
writeFmtPacket(fileId, 2, "RATE", "Qfff", "TimeUS,R,P,Y");
writeFmtPacket(fileId, 3, "RCOU", "QHHHH", "TimeUS,C1,C2,C3,C4");

for index = 1:20
    timeUs = uint64((index - 1) * 20000);
    writeDataPacket(fileId, 1, [typecast(timeUs, 'uint8'), typecast(single([1, 2, 3]), 'uint8')]);
    writeDataPacket(fileId, 2, [typecast(timeUs, 'uint8'), typecast(single([4, 5, 6]), 'uint8')]);
    pwm = uint16([1500, 1510, 1490, 1505]);
    writeDataPacket(fileId, 3, [typecast(timeUs, 'uint8'), typecast(pwm, 'uint8')]);
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
