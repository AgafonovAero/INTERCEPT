function u = normalizatsiyaShIM(shim, minimumMks, maksimumMks)
% Нормирует значения ШИМ в диапазон от 0 до 1.

if nargin < 2 || isempty(minimumMks)
    minimumMks = 1000;
end
if nargin < 3 || isempty(maksimumMks)
    maksimumMks = 2000;
end

u = (double(shim) - minimumMks) ./ (maksimumMks - minimumMks);
u = max(0, min(1, u));
end
