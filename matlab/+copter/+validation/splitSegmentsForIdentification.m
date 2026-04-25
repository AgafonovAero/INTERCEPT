function splitRegistry = splitSegmentsForIdentification(segmentRegistry, settings)
% Разделяет участки на identification и validation с фиксированным seed.

if nargin < 2 || isempty(settings)
    settings = struct();
end

if ~isfield(settings, 'random_seed')
    settings.random_seed = 57700;
end

if ~isfield(settings, 'train_validation_split')
    settings.train_validation_split = 0.6;
end

splitRegistry = segmentRegistry;
if isempty(splitRegistry)
    splitRegistry.split_role = strings(0, 1);
    return;
end

splitRegistry.split_role = strings(height(splitRegistry), 1);
rng(settings.random_seed, 'twister');
segmentTypes = unique(splitRegistry.segment_type, 'stable');

for typeIndex = 1:numel(segmentTypes)
    mask = splitRegistry.segment_type == segmentTypes(typeIndex);
    indices = find(mask);
    if numel(indices) == 1
        splitRegistry.split_role(indices) = "validation";
        continue;
    end

    order = indices(randperm(numel(indices)));
    trainCount = max(1, floor(numel(order) * settings.train_validation_split));
    trainCount = min(trainCount, numel(order) - 1);
    splitRegistry.split_role(order(1:trainCount)) = "identification";
    splitRegistry.split_role(order(trainCount + 1:end)) = "validation";
end

if ~any(splitRegistry.split_role == "identification") && height(splitRegistry) >= 2
    splitRegistry.split_role(1) = "identification";
end

if ~any(splitRegistry.split_role == "validation") && height(splitRegistry) >= 2
    splitRegistry.split_role(end) = "validation";
end
end
