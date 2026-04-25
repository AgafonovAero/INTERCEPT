function [figureHandle, animationReport] = animateCopterFlight(time, position, attitude, vehicleConfig, options)
% Создает анимацию движения квадрокоптера по траектории.

if nargin < 4 || isempty(vehicleConfig)
    vehicleConfig = copter.config.defaultVehicleConfig();
end

if nargin < 5 || isempty(options)
    options = struct();
end

options = normalizeOptions(options);
time = double(time(:));
position = double(position);
attitude = double(attitude);
frameIndex = selectFrames(numel(time), options.max_frames);

figureHandle = figure('Visible', options.visible);
axesHandle = axes(figureHandle);
plot3(axesHandle, position(:, 1), position(:, 2), position(:, 3), 'Color', [0.6, 0.6, 0.6]);
grid(axesHandle, 'on');
axis(axesHandle, 'equal');
xlabel(axesHandle, 'X, м');
ylabel(axesHandle, 'Y, м');
zlabel(axesHandle, 'Z, м');
title(axesHandle, 'Анимация квадрокоптера');
view(axesHandle, 3);
hold(axesHandle, 'on');

gifFile = string(options.gif_file);
for localIndex = 1:numel(frameIndex)
    index = frameIndex(localIndex);
    delete(findobj(axesHandle, 'Tag', 'copter_frame'));
    handles = copter.visualization.drawCopterFrame(axesHandle, ...
        transpose(position(index, :)), transpose(attitude(index, :)), struct());
    set(handles(isgraphics(handles)), 'Tag', 'copter_frame');
    drawnow;
    if strlength(gifFile) > 0
        appendGifFrame(figureHandle, gifFile, localIndex, options.delay_time_s);
    end
end

animationReport = struct();
animationReport.frame_count = numel(frameIndex);
animationReport.gif_file = gifFile;
animationReport.note = "Анимация является демонстрацией постпроцессора, а не валидацией изделия.";
end

function appendGifFrame(figureHandle, gifFile, frameNumber, delayTime)
folder = fileparts(gifFile);
if strlength(string(folder)) > 0 && ~isfolder(folder)
    mkdir(folder);
end

frame = getframe(figureHandle);
[imageIndexed, colorMap] = rgb2ind(frame2im(frame), 128);
if frameNumber == 1
    imwrite(imageIndexed, colorMap, gifFile, 'gif', 'LoopCount', Inf, 'DelayTime', delayTime);
else
    imwrite(imageIndexed, colorMap, gifFile, 'gif', 'WriteMode', 'append', 'DelayTime', delayTime);
end
end

function frameIndex = selectFrames(sampleCount, maxFrames)
if sampleCount <= maxFrames
    frameIndex = 1:sampleCount;
else
    frameIndex = unique(round(linspace(1, sampleCount, maxFrames)));
end
end

function options = normalizeOptions(options)
if ~isfield(options, 'visible')
    options.visible = 'off';
end

if ~isfield(options, 'max_frames')
    options.max_frames = 80;
end

if ~isfield(options, 'gif_file')
    options.gif_file = "";
end

if ~isfield(options, 'delay_time_s')
    options.delay_time_s = 0.05;
end
end
