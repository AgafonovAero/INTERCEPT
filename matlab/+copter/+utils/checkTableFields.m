function [presentFields, missingFields] = checkTableFields(dataTable, fieldList)
% Проверяет наличие столбцов таблицы.

tableFields = string(dataTable.Properties.VariableNames);
fieldList = string(fieldList);
presentFields = fieldList(ismember(fieldList, tableFields));
missingFields = fieldList(~ismember(fieldList, tableFields));
end
