function allocation = buildQuadXAllocationMatrix(motorPositionsBodyM, spinSign, kQOverKT)
% Формирует матрицу распределения тяги QUAD/X для связанной системы координат.

if nargin < 3 || isempty(kQOverKT)
    kQOverKT = 0.02;
end

positions = double(motorPositionsBodyM);
if size(positions, 1) ~= 3 && size(positions, 2) == 3
    positions = transpose(positions);
end

assert(size(positions, 1) == 3, 'Координаты моторов должны иметь размер 3xN.');
motorCount = size(positions, 2);
spinSign = double(spinSign(:));
assert(numel(spinSign) == motorCount, 'Число знаков вращения должно совпадать с числом моторов.');

allocation = zeros(4, motorCount);
allocation(1, :) = 1;
for index = 1:motorCount
    radius = positions(:, index);
    forceDirection = [0; 0; 1];
    momentArm = cross(radius, forceDirection);
    allocation(2, index) = momentArm(1);
    allocation(3, index) = momentArm(2);
    allocation(4, index) = spinSign(index) * double(kQOverKT);
end
end
