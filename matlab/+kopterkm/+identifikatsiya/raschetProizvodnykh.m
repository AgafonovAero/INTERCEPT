function dy = raschetProizvodnykh(t, y)
% Рассчитывает производные устойчивой центральной разностью.

t = double(t(:));
y = double(y(:));
assert(numel(t) == numel(y), 'Размеры времени и измерения должны совпадать.');
assert(numel(t) >= 3, 'Для расчета производной требуется не менее трех точек.');

dy = zeros(size(y));
dy(2:end-1) = (y(3:end) - y(1:end-2)) ./ (t(3:end) - t(1:end-2));
dy(1) = (y(2) - y(1)) ./ (t(2) - t(1));
dy(end) = (y(end) - y(end-1)) ./ (t(end) - t(end-1));

dy = ochistitVybrosy(dy);
end

function dy = ochistitVybrosy(dy)
med = median(dy, 'omitnan');
otkl = median(abs(dy - med), 'omitnan');
if otkl <= eps || isnan(otkl)
    return;
end
porog = 12 * 1.4826 * otkl;
ind = abs(dy - med) > porog;
if any(ind)
    dy(ind) = med;
end
end
