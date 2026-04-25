function T = chitatTablichnyiZhurnal(istochnik)
% Читает табличный бортовой журнал ArduPilot из CSV, MAT, table или timetable.

if istimetable(istochnik) || istable(istochnik)
    T = istochnik;
    return;
end

putKFailu = char(string(istochnik));
assert(isfile(putKFailu), 'Набор данных не найден: %s', putKFailu);
[~, ~, rasshirenie] = fileparts(putKFailu);
rasshirenie = lower(rasshirenie);

switch rasshirenie
    case '.csv'
        opts = detectImportOptions(putKFailu, 'VariableNamingRule', 'preserve');
        T = readtable(putKFailu, opts);
    case '.mat'
        T = kopterkm.dannye.chitatMatDannye(putKFailu);
    otherwise
        error('Поддерживаются только CSV и MAT. Для .BIN используйте предварительное приведение к таблице.');
end
end
