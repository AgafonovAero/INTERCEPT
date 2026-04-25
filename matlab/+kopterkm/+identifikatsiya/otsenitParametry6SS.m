function rezultat = otsenitParametry6SS(~, konfiguratsiya)
% Заготовка идентификации параметров модели движения с шестью степенями свободы.

if nargin < 2 || isempty(konfiguratsiya)
    konfiguratsiya = kopterkm.konfiguratsiya.sozdatKonfiguratsiyuPoUmolchaniyu();
end

rezultat = struct();
rezultat.model = kopterkm.modeli.ModelDvizheniya6SS(konfiguratsiya);
rezultat.primechanie = "На первом этапе параметры модели движения с шестью степенями свободы берутся из конфигурации изделия.";
end
