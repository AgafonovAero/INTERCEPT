function comparison = compareBenchThrustWithLogHover(thrustModel, hoverData, vehicleConfig)
% Сопоставляет стендовую тягу с оценкой тяги на участках висения журнала.

if nargin < 3 || isempty(vehicleConfig)
    vehicleConfig = copter.config.defaultVehicleConfig();
end

warnings = strings(0, 1);
comparison = struct();
comparison.status = "not_available";
comparison.hover_input = NaN;
comparison.required_total_thrust_n = vehicleConfig.model6dof.mass_kg * vehicleConfig.model6dof.g_m_s2;
comparison.estimated_total_thrust_n = NaN;
comparison.difference_percent = NaN;

if isempty(hoverData)
    warnings(end + 1, 1) = "Hover-участки отсутствуют.";
    comparison.warnings = warnings;
    return;
end

u = readHoverInput(hoverData);
if all(~isfinite(u))
    warnings(end + 1, 1) = "Не удалось оценить команду висения по RCOU или u_motor.";
    comparison.warnings = warnings;
    return;
end

hoverInput = mean(u, 'omitnan');
singleThrust = estimateThrust(thrustModel, hoverInput);
if ~isfinite(singleThrust)
    warnings(end + 1, 1) = "Стендовая модель тяги отсутствует.";
    comparison.warnings = warnings;
    return;
end

comparison.status = "compared";
comparison.hover_input = hoverInput;
comparison.estimated_total_thrust_n = 4 * singleThrust;
comparison.difference_percent = 100 * (comparison.estimated_total_thrust_n ...
    - comparison.required_total_thrust_n) / comparison.required_total_thrust_n;
comparison.warnings = warnings;
end

function u = readHoverInput(data)
if istimetable(data)
    data = timetable2table(data, 'ConvertRowTimes', false);
end
values = [];
for index = 1:4
    name = "u_motor_" + string(index);
    if any(string(data.Properties.VariableNames) == name)
        values = [values, double(data.(name))];
    end
end
if isempty(values)
    u = NaN;
else
    u = mean(values, 2, 'omitnan');
end
end

function thrust = estimateThrust(model, u)
thrust = NaN;
if ~isstruct(model) || ~isfield(model, 'type')
    return;
end
if model.type == "quadratic_input"
    thrust = model.a0 + model.a1 * u + model.a2 * u .^ 2;
end
end
