function svedeniya = prosmotrZhurnala(istochnik, konfiguratsiya)
% Формирует краткие сведения о бортовом журнале.

if nargin < 2 || isempty(konfiguratsiya)
    konfiguratsiya = kopterkm.konfiguratsiya.sozdatKonfiguratsiyuPoUmolchaniyu();
end

T = kopterkm.dannye.chitatTablichnyiZhurnal(istochnik);
[T, ~, vremya] = kopterkm.dannye.privestiVremya(T);
kachestvo = kopterkm.dannye.otsenitKachestvoDannykh(T, konfiguratsiya);

svedeniya = struct();
svedeniya.stolbtsy = string(T.Properties.VariableNames).';
svedeniya.vremya = vremya;
svedeniya.kachestvo = kachestvo;

fprintf('Столбцов: %d\n', numel(svedeniya.stolbtsy));
fprintf('Строк: %d\n', kachestvo.chislo_strok);
fprintf('Длительность, с: %.3f\n', kachestvo.dlitelnost_s);
if ~isempty(kachestvo.preduprezhdeniya)
    fprintf('Предупреждения качества данных:\n');
    for k = 1:numel(kachestvo.preduprezhdeniya)
        fprintf('  - %s\n', kachestvo.preduprezhdeniya(k));
    end
end
end
