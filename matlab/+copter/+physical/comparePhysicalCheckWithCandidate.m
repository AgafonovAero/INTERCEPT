function comparison = comparePhysicalCheckWithCandidate(physicalCheck, selectedCandidate, ardupilotCandidate, vehicleConfig)
% Сравнивает физическую проверку с кандидатами мотор-маппинга.

if nargin < 4 || isempty(vehicleConfig)
    vehicleConfig = copter.config.defaultVehicleConfig();
end

if nargin < 3 || isempty(ardupilotCandidate)
    ardupilotCandidate = makeCandidate("ardupilot_quad_x", [1; 2; 4; 3], [1; -1; 1; -1]);
end

if nargin < 2 || isempty(selectedCandidate)
    selectedCandidate = makeCandidate("pr7_perm_7", [2; 1; 3; 4], [1; -1; 1; -1]);
end

[physicalOrder, physicalSpin, status] = readPhysicalMap(physicalCheck, vehicleConfig);
selectedOrder = readOrder(selectedCandidate);
selectedSpin = readSpin(selectedCandidate);
ardupilotOrder = readOrder(ardupilotCandidate);
vehicleOrder = double(vehicleConfig.geometry.motor_order(:));

differences = strings(0, 1);
if ~isequal(physicalOrder, selectedOrder)
    differences(end + 1, 1) = "Физический motor map не совпадает с выбранным кандидатом PR №7.";
end
if ~isequal(physicalSpin, selectedSpin)
    differences(end + 1, 1) = "Физические знаки вращения не совпадают с выбранным кандидатом PR №7.";
end
if ~isequal(physicalOrder, ardupilotOrder)
    differences(end + 1, 1) = "Физический motor map отличается от типового ArduPilot QUAD/X.";
end
if ~isequal(physicalOrder, vehicleOrder)
    differences(end + 1, 1) = "Физический motor map отличается от текущей конфигурации изделия.";
end

comparison = struct();
comparison.status = status;
comparison.physical_motor_order = physicalOrder;
comparison.physical_spin_sign = physicalSpin;
comparison.selected_candidate_order = selectedOrder;
comparison.selected_candidate_spin_sign = selectedSpin;
comparison.matches_pr7_candidate = isequal(physicalOrder, selectedOrder) ...
    && isequal(physicalSpin, selectedSpin) && status == "physically_confirmed";
comparison.matches_ardupilot_default = isequal(physicalOrder, ardupilotOrder);
comparison.matches_vehicle_config = isequal(physicalOrder, vehicleOrder);
comparison.differences = unique(differences, 'stable');
comparison.recommendation = makeRecommendation(comparison);
end

function candidate = makeCandidate(id, order, spin)
candidate = table(string(id), {double(order(:))}, {double(spin(:))}, ...
    'VariableNames', {'candidate_id', 'motor_order', 'spin_sign'});
end

function [order, spin, status] = readPhysicalMap(physicalCheck, vehicleConfig)
order = double(vehicleConfig.geometry.motor_order(:));
spin = double(vehicleConfig.geometry.spin_sign(:));
status = "hypothesis_only";
if isempty(physicalCheck) || ~isstruct(physicalCheck) || ~isfield(physicalCheck, 'motors')
    return;
end

motors = physicalCheck.motors;
if numel(motors) < 4
    return;
end

order = NaN(4, 1);
spin = NaN(4, 1);
for index = 1:4
    motorId = double(motors(index).motor_id);
    order(motorId) = double(motors(index).rcou_channel);
    spin(motorId) = double(motors(index).spin_sign);
end
status = "physically_confirmed";
end

function order = readOrder(candidate)
if istable(candidate)
    value = candidate.motor_order(1);
    if iscell(value)
        order = double(value{1}(:));
    else
        order = double(value(:));
    end
elseif isstruct(candidate) && isfield(candidate, 'motor_order')
    order = double(candidate.motor_order(:));
else
    order = [1; 2; 3; 4];
end
end

function spin = readSpin(candidate)
if istable(candidate)
    value = candidate.spin_sign(1);
    if iscell(value)
        spin = double(value{1}(:));
    else
        spin = double(value(:));
    end
elseif isstruct(candidate) && isfield(candidate, 'spin_sign')
    spin = double(candidate.spin_sign(:));
else
    spin = [1; -1; 1; -1];
end
end

function text = makeRecommendation(comparison)
if comparison.status ~= "physically_confirmed"
    text = "Физическая проверка отсутствует; конфигурация остается расчетной гипотезой.";
elseif comparison.matches_pr7_candidate
    text = "Физическая проверка согласуется с выбранным кандидатом PR №7.";
else
    text = "Необходимо обновить конфигурацию изделия по физической проверке и повторить replay.";
end
end
