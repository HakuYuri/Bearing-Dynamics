% -------------------------------------------------------------------------
% Test program for ComputeBallPosition.m
% 
% Last modified 2023.3.22.
% -------------------------------------------------------------------------

% Initial ball & IR position.
BallsPosition = [6.0319  6.6031  7.1743  7.7455  8.3167  8.8879  9.4590 10.0302 10.6014 11.1726 11.7438];
IRPosition = 10;

% Initial displacement of x and y direction.
Displacement.x = 2.290e-4;
Displacement.y = 2.235e-4;

% Declare fault parameter.
FaultStruct.Type        = 1;            % 0: No faults  1: OR fault 2: IR fault
FaultStruct.Depth       = 5e-5;         % Depth of spall (m)
FaultStruct.Position    = 1 / 2 * pi;   % Position of spall, 0 - 2pi
FaultStruct.Length      = 8 / 180 * pi; % Length of spall, 0 - 2pi


% Declare bearing clearance.
Clearance = 4e-6;

% Call function.
[NthBallDeformation] = ComputeNthBallDeformation(BallsPosition, IRPosition, Displacement, Clearance, FaultStruct);

% Display results.
disp(NthBallDeformation);