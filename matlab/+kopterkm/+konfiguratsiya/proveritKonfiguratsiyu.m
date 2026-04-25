function [uspeshno, preduprezhdeniya] = proveritKonfiguratsiyu(konfiguratsiya)
% Проверяет полноту конфигурации объекта моделирования.

preduprezhdeniya = strings(0, 1);
uspeshno = true;

obyazatelnyePolya = ["identifikator_izdeliya", "izdeliye", "geometriya", "inertsiya", "normalizatsiya"];
for k = 1:numel(obyazatelnyePolya)
    if ~isfield(konfiguratsiya, obyazatelnyePolya(k))
        preduprezhdeniya(end + 1, 1) = "В конфигурации отсутствует поле: " + obyazatelnyePolya(k);
        uspeshno = false;
    end
end

if ~isfield(konfiguratsiya, 'izdeliye')
    return;
end

if isfield(konfiguratsiya.izdeliye, 'vinty_po_opisaniyu') && isfield(konfiguratsiya.izdeliye, 'vinty_po_cad')
    if ~strcmp(string(konfiguratsiya.izdeliye.vinty_po_opisaniyu), string(konfiguratsiya.izdeliye.vinty_po_cad))
        preduprezhdeniya(end + 1, 1) = ...
            "Зафиксировано противоречие исходных данных: Gemfan 8060 по описанию и APC 7x11E по CAD.";
    end
end

if isfield(konfiguratsiya, 'inertsiya') && isfield(konfiguratsiya.inertsiya, 'use_products_of_inertia')
    if ~konfiguratsiya.inertsiya.use_products_of_inertia
        preduprezhdeniya(end + 1, 1) = ...
            "Произведения инерции сохранены в конфигурации, но не используются в расчете компьютерной модели.";
    end
end
end
