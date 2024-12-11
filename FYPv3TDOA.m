% TDOA calculator - plots mean square error for four range-only sensors
close all;
clear all;

% Read collapsed ranges
input_file = readmatrix('fypstg2T3.xlsx');
sensorRanges = input_file(:, [3, 5, 7, 9]); % Extract sensor ranges
sensorLocations = [5, 10, 20, 25]; % Distance along the x-axis for the four sensors (cm)
numSensors = 4;
maxY = 100; % cm search space
maxX = 50; % cm search space
stepSize = 1; % cm
theta = -pi/2:0.01:pi/2;

% Initialize RMS arrays
RMS = zeros(length(-maxX:stepSize:maxX), length(0:stepSize:maxY), size(sensorRanges, 1));

% Calculate arc coordinates for each set of sensor ranges
arcX = zeros(size(sensorRanges, 1), numSensors, length(theta));
arcY = zeros(size(sensorRanges, 1), numSensors, length(theta));

for i = 1:size(sensorRanges, 1)
    for n = 1:numSensors
        arcX(i, n, :) = sensorLocations(n) + sensorRanges(i, n) * sin(theta);
        arcY(i, n, :) = sensorRanges(i, n) * cos(theta);
    end
end

% Plot sensor arcs
figure;
for i = 1:size(sensorRanges, 1)
    for n = 1:numSensors
        plot(squeeze(arcX(i, n, :)), squeeze(arcY(i, n, :)), 'Color', rand(1,3)); % Random color for each set of sensor ranges
        hold on;
    end
end
xlabel('x (cm)');
ylabel('y (cm)');
title('Sensor arcs');
grid on;

% Calculate RMS errors
for i = 1:size(sensorRanges, 1)
    for n = 1:numSensors
        arcX(i, n, :) = sensorLocations(n) + sensorRanges(i, n) * sin(theta);
        arcY(i, n, :) = sensorRanges(i, n) * cos(theta);
    end
    
    xCounter = 0;
    for x = -maxX:stepSize:maxX
        xCounter = xCounter + 1;
        yCounter = 0;
        for y = 0:stepSize:maxY
            yCounter = yCounter + 1;
            for sensor = 1:numSensors
                distanceFromArc = sqrt((x - squeeze(arcX(i, sensor, :))).^2 + (y - squeeze(arcY(i, sensor, :))).^2);
                minDistanceFromArc(sensor) = min(distanceFromArc);
            end
            RMS(xCounter, yCounter, i) = sqrt(mean(minDistanceFromArc.^2));
        end
    end
    
    % Plot RMS errors for each set of sensor ranges
    figure;
    imagesc(-maxX:stepSize:maxX, 0:stepSize:maxY, RMS(:, :, i)');
    colorbar;
    title(['RMS Error for Sensor Ranges ' num2str(i)]);
    xlabel('x (cm)');
    ylabel('y (cm)');
end