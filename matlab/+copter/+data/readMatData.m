function dataTable = readMatData(filePath)
% Читает MAT с table MATLAB или timetable MATLAB.

content = load(filePath);
names = fieldnames(content);

for index = 1:numel(names)
    value = content.(names{index});
    if istimetable(value) || istable(value)
        dataTable = value;
        return;
    end
end

error('В MAT не найдены table MATLAB или timetable MATLAB.');
end
