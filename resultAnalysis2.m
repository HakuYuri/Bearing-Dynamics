% -------------------------------------------------------------------------
% Results Presentation & Simulation Loop
%
% This code performs a simulation loop to calculate the contact forces,
% positions, and deformations of balls over the entire simulation time.
% These values couldn't be directly extracted from ode45.
%
% Last modified: 2024.11.27
% -------------------------------------------------------------------------

%% Initialize
close all;
clc;
% Load solution data
fprintf("Reading results...")
% Use this if you want to use historical data
load 'results/Solution.mat';

% Declare the time limit & time step
TimeLimit = AnaPara(1);

% Set time step
TimeStep = AnaPara(2);

% Get time vector
Time = 0 : TimeStep : TimeLimit;

% Equivalent sampling frequency
FreqSam = 1 / TimeStep;

% Extract parameters
NumberOfBalls = BearingPara(8);           % Number of rolling elements
Clearance = SystemPara(3);                % Bearing clearance
RaceContactStiffness = SystemPara(4);     % Hertz contact stiffness

% Spall fault parameter
FaultStruct.Type = FaultPara(1);
FaultStruct.Depth = FaultPara(2);
FaultStruct.Position = FaultPara(3) / 180 * pi;
FaultStruct.Length = FaultPara(4) / 180 * pi;


% Calculate the total number of time steps in the simulation
TotalTimeDivision = TimeLimit / TimeStep + 1;

% Preallocate variables to store simulation results
TimeBallContactForce = zeros(TotalTimeDivision, NumberOfBalls); % Contact forces of balls
TimeBallPosition = zeros(TotalTimeDivision, NumberOfBalls);     % Positions of balls
TimeBallDeformation = zeros(TotalTimeDivision, NumberOfBalls);  % Deformations of balls

%% Simulation loop
for i = 1:TotalTimeDivision
    % Convert loop index to real time (in seconds)
    RealTime = (i - 1) * TimeStep;

    % Extract instantaneous parameters at current time step
    IR.IAS = y(i, 6); % Inner race instantaneous angular speed
    OR.IAS = 0;       % Outer race angular speed is fixed (0)
    IR.Radius = BearingPara(6); % Inner race radius
    OR.Radius = BearingPara(7); % Outer race radius

    % Initialize Ball and Cage structures for intermediate calculations
    Ball.IAS = 0;
    Cage.IAS = 0;

    % Extract displacement values from the solution
    Displacement.x = y(i, 1); % Displacement in x direction
    Displacement.y = y(i, 2); % Displacement in y direction

    % Compute intermediate values for ball dynamics
    % Calculate the IAS of balls and cage
    [Ball, Cage, IR, OR] = ComputeIAS(Ball, Cage, IR, OR);

    % Calculate the positions of the balls at the current time step
    [BallsPosition, IRPosition] = ComputeBallPosition(NumberOfBalls, Cage, IR, RealTime);

    % Calculate the deformation of each ball on the raceway
    [NthBallDeformation] = ComputeNthBallDeformation(BallsPosition, IRPosition, Displacement, Clearance, FaultStruct);

    % Calculate contact forces for each ball
    [ContactForce, NthBallContactForce] = ComputeContactForce(RaceContactStiffness, NthBallDeformation, BallsPosition);

    % Store results in preallocated arrays
    TimeBallContactForce(i, :) = NthBallContactForce; % Contact forces
    TimeBallPosition(i, :) = BallsPosition;          % Ball positions
    TimeBallDeformation(i, :) = NthBallDeformation;  % Ball deformations
end




%% Figure 1: Bearing Acceleration vs. Time
figure(1);
% Subplot for X-direction Acceleration
subplot(2,1,1);
x_acc = diff(y(:,4));
plot(t(1:end-1), x_acc, '-b', 'LineWidth', 0.6); % Thicker lines for better visibility
grid on; % Add grid
title('Bearing Acceleration in X Direction', 'FontSize', 12, 'FontWeight', 'bold');
xlabel('Time (s)', 'FontSize', 10);
ylabel('Displacement (m)', 'FontSize', 10);
xlim([1.91 2]);

% Subplot for Y-direction Acceleration
subplot(2,1,2);
y_acc = diff(y(:,4));
plot(t(1:end-1), y_acc, '-b', 'LineWidth', 0.6);
grid on;
title('Bearing Acceleration in Y Direction', 'FontSize', 12, 'FontWeight', 'bold');
xlabel('Time (s)', 'FontSize', 10);
ylabel('Displacement (m)', 'FontSize', 10);
xlim([1.91 2]);

% Adjust the figure layout for readability
sgtitle('Bearing Acceleration Over Time', 'FontSize', 14, 'FontWeight', 'bold'); % Overall title



%% Figure 2: IAS and Speed vs. Time
figure(2);
% Subplot for IAS of inner ring
subplot(2,1,1);
plot(t, y(:,6), '-', 'LineWidth', 1.5);
grid on;
legend('IAS of Inner Ring', 'FontSize', 10, 'Location', 'best');
title('Instantaneous Angular Speed (IAS)', 'FontSize', 12, 'FontWeight', 'bold');
xlabel('Time (s)', 'FontSize', 10);
ylabel('IAS (rad/s)', 'FontSize', 10);
xlim([1.9 2]);

% Subplot for Speed
subplot(2,1,2);
plot(t, y(:,6)/2/pi*60, '-', 'LineWidth', 1.5);
grid on;
legend('Speed of Inner Ring', 'FontSize', 10, 'Location', 'best');
title('Rotational Speed of Inner Ring', 'FontSize', 12, 'FontWeight', 'bold');
xlabel('Time (s)', 'FontSize', 10);
ylabel('Speed (RPM)', 'FontSize', 10);
xlim([1.9 2]);

% Adjust the figure layout for readability
sgtitle('Bearing Angular Speed Analysis', 'FontSize', 14, 'FontWeight', 'bold'); % Overall title


%% Figure 3: IAS vs. Rotation Angle
figure(3);
plot(y(:,3)/2/pi, y(:,6), '-', 'LineWidth', 1.5); % Thicker line for better visibility
grid on; % Add grid for improved readability
legend('IAS of Inner Ring', 'FontSize', 10, 'Location', 'best'); % Improved legend
title('Instantaneous Angular Speed vs. Shaft Rotation Angle', 'FontSize', 14, 'FontWeight', 'bold');
xlabel('Rotation Angle of the Shaft (revolutions)', 'FontSize', 12);
ylabel('IAS (rad/s)', 'FontSize', 12);
xlim([19 21]);



%% Figure 4: Contact Force on Each Ball at 1.5s
BallNumber = 1:NumberOfBalls; % Ball numbers
ballLoadTime = int16(1.5 / TimeStep); % Time index for 1.5s

figure(4);
plot(BallNumber, TimeBallContactForce(ballLoadTime, :), '-o', 'LineWidth', 1, 'MarkerSize', 6);
grid on; % Add grid for clarity
axis([1 NumberOfBalls 0 Inf]); % Adjust axis limits
xlabel('Ball Number', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Total Contact Force (N)', 'FontSize', 12, 'FontWeight', 'bold');
title('Contact Force on Each Ball at 1.5 Seconds', 'FontSize', 14, 'FontWeight', 'bold');


%% Figure 5: Angular-Variant Contact Force on Each Ball
figure(5);
hold on; % Enable multiple plots on the same figure
for i = 1:NumberOfBalls
    plot(y(:, 3)/2/pi, TimeBallContactForce(:, i), '-', 'LineWidth', 1);
end
hold off; % Release plot

grid on; % Add grid for clarity
xlabel('Rotation Angle of the Shaft (revolutions)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Total Contact Force (N)', 'FontSize', 12, 'FontWeight', 'bold');
title('Angular-Variant Contact Force on Each Ball', 'FontSize', 14, 'FontWeight', 'bold');
legend(arrayfun(@num2str, 1:NumberOfBalls, 'UniformOutput', false), ...
       'FontSize', 10, 'Location', 'best'); % Auto-generate legend for all balls
xlim([18 20]); % Focus on the specified range



%% Figure 6: Envelope Curve of Outer Ring Acceleration vs. Time
%           Mean-Centered Input Signal vs. Time
figure(6);

% Extract outer ring acceleration signal
outerAccSig = y(:, 4);

% Compute envelope, spectrum, and mean-centered signal
[EnvCurve, ~, ~, EnvAlterData] = EnvSpec(outerAccSig, FreqSam);

% Plot envelope and mean-centered signal
plot(t, EnvCurve, '-r', 'LineWidth', 0.75); % Envelope curve in red
hold on;
plot(t, EnvAlterData, '-b', 'LineWidth', 0.75); % Mean-centered signal in blue
hold off;

% Add grid for better visualization
grid on;

% Set axis limits to focus on the specific time range
xlim([1.55 1.6]);

% Add labels and title
xlabel('Time (s)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Amplitude', 'FontSize', 12, 'FontWeight', 'bold');
title('Outer Ring Acceleration: Envelope and Mean-Centered Signal', ...
      'FontSize', 14, 'FontWeight', 'bold');

% Add legend for clarity
legend({'Envelope Curve', 'Mean-Centered Signal'}, 'FontSize', 10, 'Location', 'best'); 



%% Figure 7: Envelope Spectrum vs. Frequency
figure(7);

% Extract outer ring acceleration signal
outerAccSig = diff(y(:, 4));

% Compute envelope, spectrum, and mean-centered signal
[~, EnvelopeSpectrum, EnvFreqAxis, ~] = EnvSpec(outerAccSig, FreqSam);

% Plot envelope spectrum
plot(EnvFreqAxis, EnvelopeSpectrum, '-b', 'LineWidth', 1); % Spectrum in blue
grid on; % Add grid for better readability

% Set axis limits
xlim([0 300]);

% Add labels and title
xlabel('Frequency (Hz)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Amplitude', 'FontSize', 12, 'FontWeight', 'bold');
title('Envelope Spectrum of Outer Ring Acceleration', 'FontSize', 14, 'FontWeight', 'bold');

% Add legend
legend({'Spectrum of Outer Ring Acceleration'}, 'FontSize', 10, 'Location', 'best');



%% Figure 8: FFT Spectrum vs. Frequency
figure(8);

% Extract outer ring acceleration signal
outerAccSig = diff(y(:, 4));

% Compute FFT spectrum and frequency axis
[Spectrum, FreqAxis, AlterData] = myFFT(outerAccSig, FreqSam);

% Only display the left half of the spectrum (non-negative frequencies)
N = length(Spectrum);                % Total number of points
HalfIndex = floor(N/2) + 1;          % Index for the Nyquist frequency
FreqAxisHalf = FreqAxis(1:HalfIndex); % Non-negative frequencies
SpectrumHalf = Spectrum(1:HalfIndex); % Corresponding spectrum values

% Plot the left half of the FFT spectrum
plot(FreqAxisHalf, SpectrumHalf, '-b', 'LineWidth', 0.4);
grid on; % Add grid for better visualization

% Set axis limits
xlim([0 16000]); % Focus on the frequency range [0, 16000 Hz]

% Add labels and title
xlabel('Frequency (Hz)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Amplitude', 'FontSize', 12, 'FontWeight', 'bold');
title('FFT Spectrum of Outer Ring Acceleration', 'FontSize', 14, 'FontWeight', 'bold');

% Add legend
legend({'FFT Spectrum'}, 'FontSize', 10, 'Location', 'best');
