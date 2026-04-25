function puti = sformirovatGrafiki(dannye, raschet, papkaRezultatov)
% Формирует графики сопоставления расчетных и зарегистрированных величин.

if nargin < 3 || isempty(papkaRezultatov)
    papkaRezultatov = fullfile(pwd, 'results');
end
if ~isfolder(papkaRezultatov)
    mkdir(papkaRezultatov);
end

T = dannye;
if istimetable(T)
    T = timetable2table(T, 'ConvertRowTimes', false);
end

puti = strings(0, 1);
kanaly = ["R", "P", "Y"];
for k = 1:3
    imya = "RATE." + kanaly(k) + "_rad_s";
    if any(string(T.Properties.VariableNames) == imya)
        yRef = rad2deg(double(T.(imya)));
    elseif any(string(T.Properties.VariableNames) == "RATE." + kanaly(k))
        yRef = double(T.("RATE." + kanaly(k)));
    else
        continue;
    end
    yCalc = raschet.("RATE_" + kanaly(k) + "_calc_deg_s");
    n = min(numel(yRef), numel(yCalc));
    f = figure('Visible', 'off');
    plot(T.t_s(1:n), yRef(1:n), 'LineWidth', 1.1);
    hold on;
    plot(raschet.t_s(1:n), yCalc(1:n), '--', 'LineWidth', 1.1);
    grid on;
    xlabel('время, с');
    ylabel('угловая скорость, град/с');
    legend('зарегистрировано', 'расчет компьютерной модели', 'Location', 'best');
    title("Сопоставление RATE." + kanaly(k));
    put = fullfile(papkaRezultatov, "sopostavlenie_RATE_" + kanaly(k) + ".png");
    saveas(f, put);
    close(f);
    puti(end + 1, 1) = string(put);
end
end
