function T = privestiEdinitsyIzmereniya(T, konfiguratsiya)
% Приводит углы и угловые скорости к радианам для расчета.

if nargin < 2
    konfiguratsiya = kopterkm.konfiguratsiya.sozdatKonfiguratsiyuPoUmolchaniyu();
end

uglyGrad = ["ATT.Roll", "ATT.Pitch", "ATT.Yaw", ...
    "ATT.DesRoll", "ATT.DesPitch", "ATT.DesYaw"];
for k = 1:numel(uglyGrad)
    imya = uglyGrad(k);
    if estStolbets(T, imya)
        novoeImya = imya + "_rad";
        T.(novoeImya) = deg2rad(double(T.(imya)));
        if imya == "ATT.Yaw" || imya == "ATT.DesYaw"
            T.(novoeImya) = unwrap(T.(novoeImya));
        end
    end
end

skorostiGradS = ["RATE.R", "RATE.P", "RATE.Y", ...
    "RATE.RDes", "RATE.PDes", "RATE.YDes"];
for k = 1:numel(skorostiGradS)
    imya = skorostiGradS(k);
    if estStolbets(T, imya)
        T.(imya + "_rad_s") = deg2rad(double(T.(imya)));
    end
end

for k = 1:4
    imya = "RCOU.C" + k;
    if estStolbets(T, imya)
        T.(imya + "_norm") = kopterkm.sluzhebnye.normalizatsiyaShIM( ...
            T.(imya), ...
            konfiguratsiya.normalizatsiya.rcou_min_mks, ...
            konfiguratsiya.normalizatsiya.rcou_max_mks);
    end
end
end

function tf = estStolbets(T, imya)
tf = any(string(T.Properties.VariableNames) == string(imya));
end
