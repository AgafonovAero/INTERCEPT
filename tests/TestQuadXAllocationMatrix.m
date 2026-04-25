classdef TestQuadXAllocationMatrix < matlab.unittest.TestCase
    % Проверяет матрицу распределения QUAD/X.

    methods (Test)
        function testSymmetricHoverHasZeroMoments(testCase)
            positions = [
                1, 1, -1, -1
                1, -1, -1, 1
                0, 0, 0, 0
                ];
            spin = [1; -1; 1; -1];

            allocation = copter.models.buildQuadXAllocationMatrix(positions, spin, 0.02);
            result = allocation * ones(4, 1);

            testCase.verifyEqual(result(1), 4, 'AbsTol', 1e-12);
            testCase.verifyEqual(result(2:4), zeros(3, 1), 'AbsTol', 1e-12);
        end

        function testMomentSigns(testCase)
            positions = [
                1, 1, -1, -1
                1, -1, -1, 1
                0, 0, 0, 0
                ];
            spin = [1; -1; 1; -1];
            allocation = copter.models.buildQuadXAllocationMatrix(positions, spin, 0.02);

            rollCommand = [1; 0; 0; 1];
            pitchCommand = [1; 1; 0; 0];
            yawCommand = [1; 0; 1; 0];

            testCase.verifyGreaterThan(allocation(2, :) * rollCommand, 0);
            testCase.verifyLessThan(allocation(3, :) * pitchCommand, 0);
            testCase.verifyGreaterThan(allocation(4, :) * yawCommand, 0);
        end
    end
end
