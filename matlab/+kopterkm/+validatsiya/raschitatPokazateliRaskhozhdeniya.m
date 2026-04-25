function pokazateli = raschitatPokazateliRaskhozhdeniya(yRef, yCalc)
% Рассчитывает показатели расхождения расчетных и зарегистрированных величин.

yRef = double(yRef);
yCalc = double(yCalc);
assert(isequal(size(yRef), size(yCalc)), 'Размеры сравниваемых данных должны совпадать.');

e = yRef - yCalc;
pokazateli = struct();
pokazateli.srednekvadraticheskoe_otklonenie = sqrt(mean(e .^ 2, 1, 'omitnan'));
pokazateli.srednee_absolyutnoe_otklonenie = mean(abs(e), 1, 'omitnan');
pokazateli.maksimalnoe_absolyutnoe_otklonenie = max(abs(e), [], 1, 'omitnan');

razmak = max(yRef, [], 1, 'omitnan') - min(yRef, [], 1, 'omitnan');
razmak(razmak < eps) = NaN;
pokazateli.normirovannoe_srednekvadraticheskoe_otklonenie = ...
    pokazateli.srednekvadraticheskoe_otklonenie ./ razmak;

pokazatel = zeros(1, size(yRef, 2));
for k = 1:size(yRef, 2)
    znam = norm(yRef(:, k) - mean(yRef(:, k), 'omitnan'));
    if znam < eps
        pokazatel(k) = NaN;
    else
        pokazatel(k) = 100 * (1 - norm(e(:, k)) / znam);
    end
end
pokazateli.pokazatel_sootvetstviya_proc = pokazatel;

pokazateli.russkie_nazvaniya = struct( ...
    'srednekvadraticheskoe_otklonenie', "среднеквадратическое отклонение", ...
    'srednee_absolyutnoe_otklonenie', "среднее абсолютное отклонение", ...
    'maksimalnoe_absolyutnoe_otklonenie', "максимальное абсолютное отклонение", ...
    'normirovannoe_srednekvadraticheskoe_otklonenie', "нормированное среднеквадратическое отклонение", ...
    'pokazatel_sootvetstviya_proc', "показатель соответствия");
end
