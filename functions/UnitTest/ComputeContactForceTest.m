% -------------------------------------------------------------------------
% Test program for ComputeBallPosition.m
% 
% Last modified 2023.3.22 By WangBowei.
% -------------------------------------------------------------------------

% Initial ball position and deformation.
NthBallDeformation =    [0.1622  0.2837  0.3138  0.2430  0.0938     0     0     0     0     0     0] * 1e-3;
BallsPosition =         [6.0319  6.6031  7.1743  7.7455  8.3167  8.8879  9.4590 10.0302 10.6014 11.1726 11.7438];

% Declare the stiffness of the race.
RaceContactStiffness =  1e8;

% Call function.
[ContactForce, NthBallContactForce] = ComputeContactForce(RaceContactStiffness, NthBallDeformation, BallsPosition);

% Display results.
disp(ContactForce);
disp(NthBallContactForce);
