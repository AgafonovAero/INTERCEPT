function T = chitatMatDannye(putKFailu)
% Читает MAT с таблицей MATLAB или timetable MATLAB.

soderzhimoe = load(putKFailu);
imena = fieldnames(soderzhimoe);
T = [];

for k = 1:numel(imena)
    znachenie = soderzhimoe.(imena{k});
    if istimetable(znachenie) || istable(znachenie)
        T = znachenie;
        return;
    end
end

error('В MAT не найдены table или timetable MATLAB.');
end
