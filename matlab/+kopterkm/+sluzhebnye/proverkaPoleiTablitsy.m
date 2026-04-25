function [estPolya, netPolei] = proverkaPoleiTablitsy(T, spisokPolei)
% Проверяет наличие столбцов таблицы.

imena = string(T.Properties.VariableNames);
spisokPolei = string(spisokPolei);
estPolya = spisokPolei(ismember(spisokPolei, imena));
netPolei = spisokPolei(~ismember(spisokPolei, imena));
end
