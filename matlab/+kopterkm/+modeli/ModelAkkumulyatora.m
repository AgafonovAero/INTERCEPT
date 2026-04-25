function model = ModelAkkumulyatora(napryazhenieNomV, emkostMach)
% Создает параметры аккумуляторной батареи первого уровня.

if nargin < 1 || isempty(napryazhenieNomV)
    napryazhenieNomV = 22.8;
end
if nargin < 2 || isempty(emkostMach)
    emkostMach = 7000;
end

model = struct();
model.napryazhenie_nominalnoe_v = napryazhenieNomV;
model.emkost_mach = emkostMach;
model.primechanie = "На первом этапе модель аккумуляторной батареи используется как справочная часть конфигурации.";
end
