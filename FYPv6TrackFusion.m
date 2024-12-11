% Kalman filter plot fusion

% Import data
input_file = readmatrix("fypstg2T3.xlsx");

sen1Az = input_file(:,2);
sen1Rng = input_file(:,3);
sen2Az = input_file(:,4);
sen2Rng = input_file(:,5);
sen3Az = input_file(:,6);
sen3Rng = input_file(:,7);
sen4Az = input_file(:,8);
sen4Rng = input_file(:,9);

[x1,y1] = pol2cart(sen1Az,sen1Rng);
[x2,y2] = pol2cart(sen2Az,sen2Rng);
[x3,y3] = pol2cart(sen3Az,sen3Rng);
[x4,y4] = pol2cart(sen4Az,sen4Rng);

% Sensor positions
senPos = [5, 10, 20, 25];
x1 = x1 + senPos(1);
x2 = x2 + senPos(2);
x3 = x3 + senPos(3);
x4 = x4 + senPos(4);

%object truth position
objTruth = [10 20 30 40 50 60 70 80 90 100];
%object truth position
objTruthx = ones(size(objTruth))*15;
objTruthy = objTruth;

% sensor average data
avgX = [15.8219; 14.3404; 14.5775; 23.8637; 8.0309; 0.8336; -2.4931; -15.1593; -12.4975; -11.7587];

avgY = [5.1723; 18.0544; 27.9657; 36.4983; 45.0393; 52.7455; 61.7592; 68.5702; 81.0917; 91.8972];

% Initialize Kalman Filter for each sensor
KF1 = trackingKF('MotionModel', '2D Constant Velocity', 'State', [x1(1); 0; y1(1); 0]);
KF2 = trackingKF('MotionModel', '2D Constant Velocity', 'State', [x2(1); 0; y2(1); 0]);
KF3 = trackingKF('MotionModel', '2D Constant Velocity', 'State', [x3(1); 0; y3(1); 0]);
KF4 = trackingKF('MotionModel', '2D Constant Velocity', 'State', [x4(1); 0; y4(1); 0]);
KF5 = trackingKF('MotionModel', '2D Constant Velocity', 'State', [avgX(1); 0; avgY(1); 0]);

% Define object's position
% vy = 9; % Constant velocity in y-direction
T  = 1;   % Time step
N = 10; % number of time steps
% pos = [0:vy*T:5; 0:vy*T:5]'; % Object's positions over time in y-direction
pos1 = [x1 y1]; % Sensor 1 positional data
pos2 = [x2 y2]; % Sensor 2 positional data
pos3 = [x3 y3]; % Sensor 3 positional data
pos4 = [x4 y4]; % Sensor 4 positional data
pos5 = [avgX avgY]; % average positional data
pos6 = [objTruthx ;objTruthy]';

% Predict and correct using Kalman Filter for each sensor
for k = 1:size(pos1, 1)
    pstates1(k,:) = predict(KF1, T);
    cstates1(k,:) = correct(KF1, pos1(k,:));
end
for k = 1:size(pos2, 1)
    pstates2(k,:) = predict(KF2, T);
    cstates2(k,:) = correct(KF2, pos2(k,:));
end
for k = 1:size(pos3, 1)
    pstates3(k,:) = predict(KF3, T);
    cstates3(k,:) = correct(KF3, pos3(k,:));
end
for k = 1:size(pos4, 1)
    pstates4(k,:) = predict(KF4, T);
    cstates4(k,:) = correct(KF4, pos4(k,:));
end
for k = 1:size(pos5, 1)
    pstates5(k,:) = predict(KF5, T);
    cstates5(k,:) = correct(KF5, pos5(k,:));
end

%  x vs y
% Plot the results
figure;
sgtitle('Kalman Filter - Cartesian')
subplot(2, 2, 1);
plot(pos6(:,1), pos6(:,2), "k.", pstates1(:,1), pstates1(:,3), "-+", ...
    cstates1(:,1), cstates1(:,3), "-o")
xlabel("x [cm]", 'FontSize',20)
ylabel("y [cm]", 'FontSize',20)
title('Sensor 1 - Kalman Filter', 'FontSize',20)
grid on
legend("Truth", "Predicted", "Corrected", 'FontSize',10)

subplot(2, 2, 2);
plot(pos6(:,1), pos6(:,2), "k.", pstates2(:,1), pstates2(:,3), "-+", ...
    cstates2(:,1), cstates2(:,3), "-o")
xlabel("x [cm]", 'FontSize',20)
ylabel("y [cm]", 'FontSize',20)
title('Sensor 2 - Kalman Filter', 'FontSize',20)
grid on
legend("Truth", "Predicted", "Corrected", 'FontSize',10)

subplot(2, 2, 3);
plot(pos6(:,1), pos6(:,2), "k.", pstates3(:,1), pstates3(:,3), "-+", ...
    cstates3(:,1), cstates3(:,3), "-o")
xlabel("x [cm]", 'FontSize',20)
ylabel("y [cm]", 'FontSize',20)
title('Sensor 3 - Kalman Filter', 'FontSize',20)
grid on
legend("Truth", "Predicted", "Corrected", 'FontSize',10)

subplot(2, 2, 4);
plot(pos6(:,1), pos6(:,2), "k.", pstates4(:,1), pstates4(:,3), "-+", ...
    cstates4(:,1), cstates4(:,3), "-o")
xlabel("x [cm]", 'FontSize',20)
ylabel("y [cm]", 'FontSize',20)
title('Sensor 4 - Kalman Filter', 'FontSize',20)
grid on
legend("Truth", "Predicted", "Corrected", 'FontSize',10)

% x vs time
figure;
sgtitle('Kalman Filter - X Position vs Time')
subplot(2, 2, 1);
plot(1:N,pos6(:,1), "k.", 1:N, pstates1(:,1), "+", ...
    1:N, cstates1(:,1), "o")
xlabel("Time (s)", 'FontSize',20)
ylabel("x [cm]", 'FontSize',20)
title('Sensor 1 - Kalman Filter', 'FontSize',20)
grid on
legend("Truth", "Predicted", "Corrected", 'FontSize',10)

subplot(2, 2, 2);
plot(1:N,pos6(:,1), "k.",1:N, pstates2(:,1), "-+", ...
   1:N, cstates2(:,1), "-o")
xlabel("Time (s)", 'FontSize',20)
ylabel("x [cm]", 'FontSize',20)
title('Sensor 2 - Kalman Filter', 'FontSize',20)
grid on
legend("Truth", "Predicted", "Corrected", 'FontSize',10)

subplot(2, 2, 3);
plot(1:N,pos6(:,1), "k.",1:N, pstates3(:,1),  "-+", ...
    1:N,cstates3(:,1), "-o")
xlabel("Time (s)", 'FontSize',20)
ylabel("x [cm]", 'FontSize',20)
title('Sensor 3 - Kalman Filter', 'FontSize',20)
grid on
legend("Truth", "Predicted", "Corrected", 'FontSize',10)

subplot(2, 2, 4);
plot(1:N,pos6(:,1), "k.",1:N,pstates4(:,1), "-+", ...
   1:N, cstates4(:,1), "-o")
xlabel("Time (s)", 'FontSize',20)
ylabel("x [cm]", 'FontSize',20)
title('Sensor 4 - Kalman Filter', 'FontSize',20)
grid on
legend("Truth", "Predicted", "Corrected", 'FontSize',10)

% y vs time
figure;
sgtitle('Kalman Filter - Y Position vs Time')
subplot(2, 2, 1);
plot(1:N, pos6(:,2), "k.", 1:N, pstates1(:,3), "-+", ...
    1:N,cstates1(:,3), "-o")
xlabel("Time (s)", 'FontSize',20)
ylabel("y [cm]", 'FontSize',20)
title('Sensor 1 - Kalman Filter', 'FontSize',20)
grid on
legend("Truth", "Predicted", "Corrected", 'FontSize',10)

subplot(2, 2, 2);
plot(1:N,pos6(:,2), "k.", 1:N, pstates2(:,3), "-+", ...
    1:N, cstates2(:,3), "-o")
xlabel("Time (s)", 'FontSize',20)
ylabel("y [cm]", 'FontSize',20)
title('Sensor 2 - Kalman Filter', 'FontSize',20)
grid on
legend("Truth", "Predicted", "Corrected", 'FontSize',10)

subplot(2, 2, 3);
plot(1:N, pos6(:,2), "k.",1:N, pstates3(:,3), "-+", ...
   1:N, cstates3(:,3), "-o")
xlabel("Time (s)", 'FontSize',20)
ylabel("y [cm]", 'FontSize',20)
title('Sensor 3 - Kalman Filter', 'FontSize',20)
grid on
legend("Truth", "Predicted", "Corrected", 'FontSize',10)

subplot(2, 2, 4);
plot(1:N, pos6(:,2), "k.", 1:N, pstates4(:,3), "-+", ...
    1:N,cstates4(:,3), "-o")
xlabel("Time (s)", 'FontSize',20)
ylabel("y [cm]", 'FontSize',20)
title('Sensor 4 - Kalman Filter', 'FontSize',20)
grid on
legend("Truth", "Predicted", "Corrected", 'FontSize',10)


figure;
plot(cstates1(:,1), cstates1(:,3), "-x")
hold on;
plot(cstates2(:,1), cstates2(:,3), "-x")
plot(cstates3(:,1), cstates3(:,3), "-x")
plot(cstates4(:,1), cstates4(:,3), "-x")
plot(cstates5(:,1), cstates5(:,3), "-x")


%object truth position
objTruth = [10 20 30 40 50 60 70 80 90 100];
%object truth position
objTruthx = ones(size(objTruth))*15;
objTruthy = objTruth;

% Plot truth track
plot(objTruthx,objTruthy,'-blackx','LineWidth',2)
% Labels and legend
xlabel("x [cm]", 'FontSize',20);
ylabel("y [cm]", 'FontSize',20);
title('Kalman Filter', 'FontSize',20);
grid on;
legend('Sensor 1', 'Sensor 2', 'Sensor 3', 'Sensor 4', 'Average Corrected Track','Object Truth', 'Location', 'Best', 'FontSize',10);