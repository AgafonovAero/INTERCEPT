classdef TestFormirovanieOtcheta < matlab.unittest.TestCase
    % Проверка формирования отчета и предупреждений исходных данных.

    methods (Test)
        function testOtchet(testCase)
            konfiguratsiya = kopterkm.konfiguratsiya.sozdatKonfiguratsiyuPoUmolchaniyu();
            [~, preduprezhdeniya] = kopterkm.konfiguratsiya.proveritKonfiguratsiyu(konfiguratsiya);
            testCase.verifyTrue(any(contains(preduprezhdeniya, "Gemfan 8060")));
            testCase.verifyTrue(any(contains(preduprezhdeniya, "APC 7x11E")));

            pokazateli = struct();
            pokazateli.srednekvadraticheskoe_otklonenie = [0.1, 0.2, 0.3];
            pokazateli.srednee_absolyutnoe_otklonenie = [0.08, 0.15, 0.22];
            pokazateli.maksimalnoe_absolyutnoe_otklonenie = [0.3, 0.4, 0.5];
            pokazateli.normirovannoe_srednekvadraticheskoe_otklonenie = [0.05, 0.06, 0.07];
            pokazateli.pokazatel_sootvetstviya_proc = [80, 75, 65];

            validatsiya = struct();
            validatsiya.pokazateli = pokazateli;
            validatsiya.matritsa_validatsii = kopterkm.validatsiya.sformirovatMatritsuValidatsii(pokazateli, [2, 4], konfiguratsiya);

            identifikatsiya = struct();
            identifikatsiya.A = diag([-1, -1, -1]);
            identifikatsiya.B = eye(3);
            identifikatsiya.c = zeros(3, 1);

            kachestvo = struct();
            kachestvo.ispolzovannye_kanaly = ["RATE.R"; "RATE.P"; "RATE.Y"];
            kachestvo.preduprezhdeniya = preduprezhdeniya;

            dannyeOtcheta = struct();
            dannyeOtcheta.konfiguratsiya = konfiguratsiya;
            dannyeOtcheta.kachestvo_dannykh = kachestvo;
            dannyeOtcheta.identifikatsiya = identifikatsiya;
            dannyeOtcheta.validatsiya = validatsiya;
            dannyeOtcheta.uchastki = struct('identifikatsiya', [0, 2], 'proverka', [2, 4]);

            put = fullfile(tempdir, 'otchet_otsenki_adekvatnosti_test.md');
            tekst = kopterkm.otchety.sformirovatOtchetMarkdown(put, dannyeOtcheta);

            testCase.verifyTrue(isfile(put));
            testCase.verifyTrue(contains(tekst, "Данная проверка выполнена по данным бортового журнала"));
            testCase.verifyTrue(contains(tekst, "Gemfan 8060"));
            testCase.verifyTrue(contains(tekst, "APC 7x11E"));
            testCase.verifyTrue(contains(tekst, "Матрица валидации"));
        end
    end
end
