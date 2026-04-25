function [continuousModel, discreteModel, fitDiagnostics, selectedDelay, warnings] = fitCuratedRateModels( ...
    processedData, curatedIdentificationSegments, vehicleConfig, curationSettings)
% Идентифицирует непрерывную и дискретную модели ModelRate по отфильтрованным участкам.

if nargin < 3 || isempty(vehicleConfig)
    vehicleConfig = copter.config.defaultVehicleConfig();
end

if nargin < 4 || isempty(curationSettings)
    curationSettings = struct();
end

[continuousModel, continuousFitReport, continuousWarnings] = copter.identification.fitRateModelFromSegments( ...
    processedData, curatedIdentificationSegments, vehicleConfig);
[discreteModel, discreteFitReport, discreteWarnings] = copter.identification.fitRateModelDiscreteFromSegments( ...
    processedData, curatedIdentificationSegments, curationSettings);

selectedDelay = discreteModel.delay_samples;
warnings = unique([continuousWarnings; discreteWarnings], 'stable');

fitDiagnostics = struct();
fitDiagnostics.continuous_fit_report = continuousFitReport;
fitDiagnostics.discrete_fit_report = discreteFitReport;
fitDiagnostics.selected_delay_samples = selectedDelay;
fitDiagnostics.identification_segment_count = height(curatedIdentificationSegments);
fitDiagnostics.note = "Validation-участки не использовались для подбора параметров.";
end
