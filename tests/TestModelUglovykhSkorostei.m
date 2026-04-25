classdef TestModelUglovykhSkorostei < matlab.unittest.TestCase
    % Проверка синтетической идентификации модели угловых скоростей.

    methods (Test)
        function testSinteticheskayaIdentifikatsiya(testCase)
            dt = 0.005;
            t = (0:dt:15).';
            A = diag([-1.1, -0.8, -0.6]);
            B = diag([2.0, 1.5, 1.0]);
            c = [0.1; -0.05; 0.02];
            U = [sin(0.8 * t), cos(0.5 * t), sin(0.3 * t + 0.2)];
            X = zeros(numel(t), 3);
            for k = 1:(numel(t) - 1)
                h = dt;
                x = X(k, :).';
                u1 = U(k, :).';
                u2 = U(k + 1, :).';
                us = 0.5 * (u1 + u2);
                f = @(xx, uu) A * xx + B * uu + c;
                k1 = f(x, u1);
                k2 = f(x + h * k1 / 2, us);
                k3 = f(x + h * k2 / 2, us);
                k4 = f(x + h * k3, u2);
                X(k + 1, :) = (x + h * (k1 + 2 * k2 + 2 * k3 + k4) / 6).';
            end

            T = table();
            T.t_s = t;
            T.("RATE.R_rad_s") = X(:, 1);
            T.("RATE.P_rad_s") = X(:, 2);
            T.("RATE.Y_rad_s") = X(:, 3);
            T.("RATE.ROut") = U(:, 1);
            T.("RATE.POut") = U(:, 2);
            T.("RATE.YOut") = U(:, 3);

            konfiguratsiya = kopterkm.konfiguratsiya.sozdatKonfiguratsiyuPoUmolchaniyu();
            konfiguratsiya.model_uglovykh_skorostei.maksimalnaya_zaderzhka_shagov = 1;
            rezultat = kopterkm.identifikatsiya.otsenitParametryUglovykhSkorostei(T, konfiguratsiya, [0.1, 14.9]);

            testCase.verifyEqual(diag(rezultat.A), diag(A), 'AbsTol', 0.03);
            testCase.verifyEqual(diag(rezultat.B), diag(B), 'AbsTol', 0.03);
            testCase.verifyEqual(rezultat.c, c, 'AbsTol', 0.03);
        end
    end
end
