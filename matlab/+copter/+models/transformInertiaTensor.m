function [inertiaBody, report] = transformInertiaTensor(inertiaSource, cadToBodyMatrix, options)
% Преобразует тензор инерции CAD в связанную систему координат изделия.

if nargin < 2 || isempty(cadToBodyMatrix)
    cadToBodyMatrix = eye(3);
end

if nargin < 3 || isempty(options)
    options = struct();
end

useProducts = false;
if isfield(options, 'use_products_of_inertia')
    useProducts = logical(options.use_products_of_inertia);
end

raw = readRawInertia(inertiaSource);
if useProducts
    inertiaCad = [
        raw.Ixx, -raw.Ixy, -raw.Ixz
        -raw.Ixy, raw.Iyy, -raw.Iyz
        -raw.Ixz, -raw.Iyz, raw.Izz
        ];
else
    inertiaCad = diag([raw.Ixx, raw.Iyy, raw.Izz]);
end

transform = double(cadToBodyMatrix);
inertiaBody = transform * inertiaCad * transpose(transform);
if ~useProducts
    inertiaBody = diag(diag(inertiaBody));
end

report = struct();
report.use_products_of_inertia = useProducts;
report.transform_matrix = transform;
report.inertia_cad = inertiaCad;
report.inertia_body = inertiaBody;
report.warnings = strings(0, 1);
if ~useProducts
    report.warnings(end + 1, 1) = "Произведения инерции CAD сохранены, но не применены по умолчанию.";
end
end

function raw = readRawInertia(source)
if isstruct(source) && isfield(source, 'inertia')
    source = source.inertia;
end

raw = struct();
raw.Ixx = readField(source, "Ixx_cad_raw", 0.058);
raw.Iyy = readField(source, "Iyy_cad_raw", 0.030);
raw.Izz = readField(source, "Izz_cad_raw", 0.044);
raw.Ixy = readField(source, "Ixy_cad_raw", 0);
raw.Ixz = readField(source, "Ixz_cad_raw", 0);
raw.Iyz = readField(source, "Iyz_cad_raw", 0);
end

function value = readField(source, fieldName, defaultValue)
if isstruct(source) && isfield(source, char(fieldName))
    value = double(source.(char(fieldName)));
else
    value = defaultValue;
end
end
