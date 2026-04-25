function candidates = generateMotorMapCandidates(vehicleConfig, calibrationSettings)
% Формирует набор кандидатных соответствий RCOU физическим моторам модели.

if nargin < 1 || isempty(vehicleConfig)
    vehicleConfig = copter.config.defaultVehicleConfig();
end

if nargin < 2 || isempty(calibrationSettings)
    calibrationSettings = defaultSettings();
end

maxCandidates = readSetting(calibrationSettings, "max_candidates", 48);
rows = struct([]);

if readSetting(calibrationSettings, "use_vehicle_config_candidate", true)
    rows = appendCandidate(rows, "vehicle_config", getVehicleOrder(vehicleConfig), ...
        getVehicleSpin(vehicleConfig), "Порядок из конфигурации изделия.");
end

if readSetting(calibrationSettings, "use_ardupilot_default_quad_x_candidate", true)
    rows = appendCandidate(rows, "ardupilot_quad_x", [1; 2; 4; 3], [1; -1; 1; -1], ...
        "Типовой кандидат ArduPilot QUAD/X для первой диагностики.");
end

if readSetting(calibrationSettings, "allow_motor_permutations", true)
    permutations = perms(1:4);
    for index = 1:size(permutations, 1)
        rows = appendCandidate(rows, "perm_" + string(index), transpose(permutations(index, :)), ...
            getVehicleSpin(vehicleConfig), "Перестановка каналов RCOU.");
        if numel(rows) >= maxCandidates
            break;
        end
    end
end

if readSetting(calibrationSettings, "allow_yaw_spin_sign_variants", true) && numel(rows) < maxCandidates
    baseRows = rows;
    variantSigns = [
        1, -1, 1, -1
        -1, 1, -1, 1
        1, 1, -1, -1
        -1, -1, 1, 1
        ];
    for rowIndex = 1:numel(baseRows)
        for signIndex = 1:size(variantSigns, 1)
            rows = appendCandidate(rows, baseRows(rowIndex).candidate_id + "_spin_" + string(signIndex), ...
                baseRows(rowIndex).motor_order, transpose(variantSigns(signIndex, :)), ...
                "Вариант знаков момента рыскания.");
            if numel(rows) >= maxCandidates
                break;
            end
        end
        if numel(rows) >= maxCandidates
            break;
        end
    end
end

candidates = uniqueCandidates(struct2table(rows));
if height(candidates) > maxCandidates
    candidates = candidates(1:maxCandidates, :);
end
end

function settings = defaultSettings()
settings = struct();
settings.max_candidates = 48;
settings.use_vehicle_config_candidate = true;
settings.use_ardupilot_default_quad_x_candidate = true;
settings.allow_motor_permutations = true;
settings.allow_yaw_spin_sign_variants = true;
end

function value = readSetting(settings, fieldName, defaultValue)
if isstruct(settings) && isfield(settings, char(fieldName))
    value = settings.(char(fieldName));
else
    value = defaultValue;
end
end

function order = getVehicleOrder(vehicleConfig)
if isfield(vehicleConfig, 'geometry') && isfield(vehicleConfig.geometry, 'motor_order')
    order = double(vehicleConfig.geometry.motor_order(:));
else
    order = transpose(1:4);
end
end

function spin = getVehicleSpin(vehicleConfig)
if isfield(vehicleConfig, 'geometry') && isfield(vehicleConfig.geometry, 'spin_sign')
    spin = double(vehicleConfig.geometry.spin_sign(:));
else
    spin = [1; -1; 1; -1];
end
end

function rows = appendCandidate(rows, id, order, spin, notes)
if iscell(order)
    order = order{1};
end
if iscell(spin)
    spin = spin{1};
end

row = struct();
row.candidate_id = string(id);
row.motor_order = {double(order(:))};
row.spin_sign = {double(spin(:))};
row.source = string(id);
row.notes = string(notes);
rows = [rows; row];
end

function candidates = uniqueCandidates(candidates)
keys = strings(height(candidates), 1);
for index = 1:height(candidates)
    order = candidates.motor_order{index};
    spin = candidates.spin_sign{index};
    keys(index) = join(string([order(:); 99; spin(:)]), "_");
end
[~, uniqueIndex] = unique(keys, 'stable');
candidates = candidates(uniqueIndex, :);
end
