function report = validatePhysicalConfigurationCheck(physicalCheck)
% Проверяет полноту результатов физической проверки конфигурации изделия.

missingFields = strings(0, 1);
warnings = strings(0, 1);

if isempty(physicalCheck) || ~isstruct(physicalCheck) ...
        || isfield(physicalCheck, 'status') && string(physicalCheck.status) == "not_available"
    report = makeReport(false, "not_available", "physical_check", "Физическая проверка отсутствует.");
    return;
end

requiredTopFields = [
    "vehicle_id"
    "check_date"
    "performed_by"
    "vehicle_nose_direction"
    "installed_propeller_type"
    "motors"
    ];

for index = 1:numel(requiredTopFields)
    fieldName = requiredTopFields(index);
    if ~isfield(physicalCheck, char(fieldName)) || isEmptyValue(physicalCheck.(char(fieldName)))
        missingFields(end + 1, 1) = fieldName;
    end
end

motors = readMotors(physicalCheck);
if numel(motors) < 4
    missingFields(end + 1, 1) = "motors.motor_1...motor_4";
else
    for index = 1:4
        motorMissing = validateMotor(motors(index), index);
        missingFields = [missingFields; motorMissing];
    end
end

if ~isfield(physicalCheck, 'approved_by') || isEmptyValue(physicalCheck.approved_by)
    warnings(end + 1, 1) = "Поле approved_by не заполнено; подтверждение требует ответственного согласования.";
end

isValid = isempty(missingFields);
status = "physically_confirmed";
if ~isValid
    status = "incomplete";
end

report = struct();
report.is_valid = isValid;
report.status = status;
report.missing_fields = unique(missingFields, 'stable');
report.warnings = unique(warnings, 'stable');
end

function missingFields = validateMotor(motor, motorIndex)
missingFields = strings(0, 1);
required = [
    "motor_id"
    "physical_position"
    "rcou_channel"
    "spin_direction"
    "spin_sign"
    "propeller_type"
    "propeller_installation_direction"
    ];

for index = 1:numel(required)
    fieldName = required(index);
    if ~isfield(motor, char(fieldName)) || isEmptyValue(motor.(char(fieldName)))
        missingFields(end + 1, 1) = "motor_" + string(motorIndex) + "." + fieldName;
    end
end
end

function motors = readMotors(physicalCheck)
if isfield(physicalCheck, 'motors')
    motors = physicalCheck.motors;
else
    motors = struct([]);
end
end

function result = isEmptyValue(value)
if isstring(value) || ischar(value)
    result = strlength(string(value)) == 0;
elseif isnumeric(value)
    result = isempty(value) || any(~isfinite(double(value(:))));
elseif islogical(value)
    result = isempty(value);
else
    result = isempty(value);
end
end

function report = makeReport(isValid, status, missingField, warningText)
report = struct();
report.is_valid = isValid;
report.status = string(status);
report.missing_fields = string(missingField);
report.warnings = string(warningText);
end
