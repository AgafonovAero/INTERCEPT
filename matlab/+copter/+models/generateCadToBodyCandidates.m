function candidates = generateCadToBodyCandidates(frameSettings)
% Формирует кандидатные преобразования CAD -> body для диагностики систем координат.

if nargin < 1 || isempty(frameSettings)
    frameSettings = struct();
end

allowed = [
    "identity"
    "swap_x_z"
    "swap_y_z"
    "sign_flip_x"
    "sign_flip_y"
    "sign_flip_z"
    "candidate_from_motor_geometry"
    ];

if isfield(frameSettings, 'allowed_cad_to_body_transforms')
    allowed = string(frameSettings.allowed_cad_to_body_transforms(:));
end

rows = struct([]);
for index = 1:numel(allowed)
    name = allowed(index);
    transform = makeTransform(name);
    rows = appendCandidate(rows, name, transform, describeTransform(name));
end

candidates = struct2table(rows);
end

function transform = makeTransform(name)
transform = eye(3);
switch string(name)
    case "identity"
        transform = eye(3);
    case "swap_x_z"
        transform = [0 0 1; 0 1 0; 1 0 0];
    case "swap_y_z"
        transform = [1 0 0; 0 0 1; 0 1 0];
    case "sign_flip_x"
        transform = diag([-1 1 1]);
    case "sign_flip_y"
        transform = diag([1 -1 1]);
    case "sign_flip_z"
        transform = diag([1 1 -1]);
    case "candidate_from_motor_geometry"
        transform = [0 0 -1; 1 0 0; 0 -1 0];
end
end

function rows = appendCandidate(rows, id, transform, description)
row = struct();
row.candidate_id = string(id);
row.transform_matrix = {double(transform)};
row.description = string(description);
row.source = "coordinate_frame_calibration_v0";
rows = [rows; row];
end

function description = describeTransform(name)
switch string(name)
    case "identity"
        description = "Без преобразования осей CAD.";
    case "swap_x_z"
        description = "Перестановка осей X и Z.";
    case "swap_y_z"
        description = "Перестановка осей Y и Z.";
    case "sign_flip_x"
        description = "Смена знака оси X.";
    case "sign_flip_y"
        description = "Смена знака оси Y.";
    case "sign_flip_z"
        description = "Смена знака оси Z.";
    otherwise
        description = "Кандидат по геометрии моторов.";
end
end
