close all;
clear;
clc;

% xlsread is NOT RECOMMENDED after MATLAB R2019a. Use readmatrix.
BearingPara = readmatrix('systemparameter\para.xlsx', 'Range', 'A3:H3');
SystemPara = readmatrix('systemparameter\para.xlsx', 'Range', 'A7:H7');
AnaPara = readmatrix('systemparameter\para.xlsx', 'Range', 'A12:H12');
FaultPara = readmatrix('systemparameter\para.xlsx', 'Range', 'A16:D16');
MotorPara = readmatrix('systemparameter\para.xlsx', 'Range', 'A20:B20');

FaultStruct.Type = FaultPara(1);
FaultStruct.Depth = FaultPara(2);
FaultStruct.Position = FaultPara(3) / 180 * pi;
FaultStruct.Length = FaultPara(4) / 180 * pi;


% Declare the time limit & time step.
TimeLimit = AnaPara(1);

% Set time step.
TimeStep = AnaPara(2);

% Get time vector.
Time = 0 : TimeStep : TimeLimit;

% Initial values of the differential equation;
% Set initial angular speed to 1500 rpm(convert to rad/s)
y0 = [0 0 0 0 0 SystemPara(8)/60*2*pi];

% Get the solution.
[t,y] = ode45(@(t,y) BearingDynamicModel(t, y, BearingPara, SystemPara, FaultPara, MotorPara), Time, y0);   

% Save result on '{CurrentDirectory}\results\Solution.mat'
save('results\Solution.mat', 'y');


% Figure 1: Bearing displacement vs. Time
figure(1);
subplot(1,2,1);
plot(t,y(:,1),'-');
title('X-direction displacement');
xlabel('Time');
ylabel('Displacement');
axis([5.5 6 -Inf Inf]);
subplot(1,2,2);
plot(t,y(:,2),'-');
title('Y-direction displacement');
xlabel('Time');
ylabel('Displacement');
axis([5.5 6 -Inf Inf]);

% Figure 2: IAS vs. Time
figure(2);
subplot(1,2,1);
plot(t,y(:,6),'-');
legend('IAS of inner ring');
xlabel('Time');
ylabel('IAS');
axis([5 6 100 Inf]);

subplot(1,2,2);
plot(t,y(:,6)/2/pi*60,'-');
legend('Speed');
xlabel('Time');
ylabel('Speed');
axis([5 6 1000 Inf]);


% Figure 3: IAS vs. Rotation angle
figure(3);
plot(y(:,3)/2/pi,y(:,6),'-');
legend('IAS of inner ring');
xlabel('Rotation angle of the shaft (rev)');
ylabel('IAS');


NumberOfBalls = BearingPara(8);

Clearance = SystemPara(3);
RaceContactStiffness =  SystemPara(4);

% Loop to get data of all 10 seconds, TotalTimeDivision is the loop times.
TotalTimeDivision = TimeLimit / TimeStep + 1;

% Declare variables of ball contact force and ball position.
TimeBallContactForce = zeros(TotalTimeDivision, NumberOfBalls);
TimeBallPosition = zeros(TotalTimeDivision, NumberOfBalls);
TimeBallDeformation = zeros(TotalTimeDivision, NumberOfBalls);


% Loop
for i = 1 : TimeLimit / TimeStep + 1

    % Convert variable i to real time(by seconds).
    RealTime = double(i - 1) * TimeStep;

    % Initial Parameter.
    IR.IAS      = y(i, 6);
    OR.IAS      = 0;
    IR.Radius = BearingPara(6);
    OR.Radius = BearingPara(7);
    
    % Declare structure of Ball and Cage.
    Ball.IAS = 0;
    Cage.IAS = 0;

    % Declare the displacement from the solution of differential equation.
    Displacement.x = y(i, 1);
    Displacement.y = y(i, 2);    

    % Compute the intermediate values.
    [Ball, Cage, IR, OR] = ComputeIAS(Ball, Cage, IR, OR);
    [BallsPosition, IRPosition] = ComputeBallPosition(NumberOfBalls, Cage, IR, RealTime);
    [NthBallDeformation] = ComputeNthBallDeformation(BallsPosition, IRPosition, Displacement, Clearance, FaultStruct); 
    [ContactForce, NthBallContactForce] = ComputeContactForce(RaceContactStiffness, NthBallDeformation, BallsPosition);

    % Unbalance magnetic pull
    [MagneticPull.x, MagneticPull.y] = MagPull(RealTime, Displacement, IR.IAS);

    % Assign to output variables.
    
    TimeBallContactForce(i,:) = NthBallContactForce;
    TimeBallPosition(i,:) = BallsPosition;
    TimeBallDeformation(i,:) = NthBallDeformation;

    TimeMagneticPull.x(i) = MagneticPull.x;
    TimeMagneticPull.y(i) = MagneticPull.y;


end


% Figure 4: Contact force on each ball.
% Declare ball number;
BallNumber = 1 : 1 : NumberOfBalls;

% Set time on 2.55s.
TimeSlice = int16(2.55 / TimeStep);

figure(4);
plot(BallNumber, TimeBallContactForce(TimeSlice,:),'-o');
axis([1 NumberOfBalls 0 Inf]);
xlabel('Ball number');
ylabel('Total contact force')

% Figure 5: Angular-variant contact force on each ball
figure(5);
plot(y(:, 3)/2/pi,TimeBallContactForce(:,1),'--.',...
    y(:, 3)/2/pi,TimeBallContactForce(:,2),'--.',...
    y(:, 3)/2/pi,TimeBallContactForce(:,3),'--.',...
    y(:, 3)/2/pi,TimeBallContactForce(:,4),'--.',...
    y(:, 3)/2/pi,TimeBallContactForce(:,5),'--.',...
    y(:, 3)/2/pi,TimeBallContactForce(:,6),'--.',...
    y(:, 3)/2/pi,TimeBallContactForce(:,7),'--.',...
    y(:, 3)/2/pi,TimeBallContactForce(:,8),'--.'...
    );

xlabel('Rotation angle of the shaft (rev)');
ylabel('Total contact force')
legend('1','2','3','4','5','6','7','8');
% Limit axis.
% X: procedure from 84% to 84.5%;
% Y: 0 to 3/4 times of the max contact force.
axis([0.84 * max(y(:, 3)/2/pi) 0.845 * max(y(:, 3)/2/pi) 0 max(TimeBallContactForce(:,1) / 4 * 3)]);

% Figure 6: Radial X Speed vs. Rotation angle
figure(6);
plot(y(:,3)/2/pi,y(:,4),'-',y(:,3)/2/pi,y(:,5),'-');
legend('Radial X Speed', 'Radial Y Speed');
xlabel('Rotation angle of the shaft (rev)');
ylabel('Speed');
axis([9.2 9.6 -0.02 0.02]);



disp(Ball);

disp(IR);


% 读取信号数据
data = y(:,4);
data = data - mean(data);

% 计算Hilbert变换
hilb = hilbert(data);

% 计算包络
envelope = abs(hilb);
envelope1 = envelope - mean(envelope);

% 计算谱
fs = 20e3; % 采样频率
N = length(data); % 信号长度
f = (0:N-1)*(fs/N); % 构造频率轴
psd = abs(fft(envelope1)/N); % 计算谱

% 绘制包络谱图
figure(7);
% subplot(1,2,1);
% plot(data);
% hold on;
% plot(envelope, 'r');
% legend('Signal', 'Envelope');
% xlabel('Sample');
% ylabel('Amplitude');
% title('X-Direction Signal Envelope');


% subplot(1,2,2);
plot(f(1:int16(N/2)), psd(1:int16(N/2)));
xlabel('Frequency (Hz)');
ylabel('Amptitude');
title('X-Direction Speed Amptitude/Frequency');axis([0 500 0 Inf]);

% 读取信号数据
data = y(:,4);
data = diff(data);
data = data - mean(data);

% 计算Hilbert变换
hilb = hilbert(data);

% 计算包络
envelope = abs(hilb);
envelope1 = envelope - mean(envelope);

% 计算谱
fs = 20e3; % 采样频率
N = length(data); % 信号长度
f = (0:N-1)*(fs/N); % 构造频率轴
psd = abs(fft(envelope1)/N); % 计算谱

% 绘制包络谱图
figure(8);
% subplot(1,2,1);
plot(data);
hold on;
plot(envelope, 'r');
legend('Signal', 'Envelope');
xlabel('Sample');
ylabel('Amplitude');
title('Signal Envelope');

figure(9);
% subplot(1,2,2);
plot(f(1:N/2), 1000 * psd(1:N/2));
xlabel('Frequency (Hz)');
ylabel('Amptitude');
title('Y-Direction Speed Amptitude/Frequency');
axis([0 500 0 1.2 * max(1000 * psd(1:N/2))]);





% Set sampling frequency and signal duration
Fs = 1 / TimeStep; % Sampling frequency
T = 10; % Total signal duration is 10 seconds
t = 0:1/Fs:T-1/Fs; % Time vector

% Load the signal data
signal = y(:,1);
signal1 = signal - mean(signal);

% Perform Fourier transform
n = length(signal1); % Length of the signal
transformed_signal = fft(signal1)/n; % Fourier transform of the signal
frequencies = (0:n-1)*(Fs/n); % Frequency vector

% Plot the amplitude spectrum
figure(10);
plot(frequencies(1:int16(n/2)), abs(transformed_signal(1:int16(n/2))));
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('Amplitude spectrum of the signal (left-hand side)');
% xlim([0 2000]); % Set X-axis range from 0 to 2000 Hz.



figure(11);
plot(Time, TimeMagneticPull.x, '-',Time, TimeMagneticPull.y, '-');




