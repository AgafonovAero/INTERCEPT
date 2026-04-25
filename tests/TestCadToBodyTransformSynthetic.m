classdef TestCadToBodyTransformSynthetic < matlab.unittest.TestCase
    % Проверяет преобразование CAD -> body для координат моторов и инерции.

    methods (Test)
        function testMotorPositionTransform(testCase)
            positionsCad = [
                1, 0, -1, 0
                0, 1, 0, -1
                0, 0, 0, 0
                ];
            transform = diag([1 -1 1]);

            [positionsBody, report] = copter.models.transformMotorPositions(positionsCad, transform);

            testCase.verifyEqual(positionsBody(2, 2), -1, 'AbsTol', 1e-12);
            testCase.verifyEqual(report.transform_matrix, transform);
        end

        function testDiagonalInertiaIgnoresProducts(testCase)
            source = struct();
            source.Ixx_cad_raw = 1;
            source.Iyy_cad_raw = 2;
            source.Izz_cad_raw = 3;
            source.Ixy_cad_raw = 0.5;
            source.Ixz_cad_raw = 0.6;
            source.Iyz_cad_raw = 0.7;
            options = struct();
            options.use_products_of_inertia = false;

            [inertiaBody, report] = copter.models.transformInertiaTensor(source, eye(3), options);

            testCase.verifyEqual(inertiaBody, diag([1 2 3]), 'AbsTol', 1e-12);
            testCase.verifyFalse(report.use_products_of_inertia);
        end
    end
end
