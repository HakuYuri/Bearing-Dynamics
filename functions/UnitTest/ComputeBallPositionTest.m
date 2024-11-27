% -------------------------------------------------------------------------
% Test program for ComputeBallPosition.m
% 
% Last modified 2023.4.11.
% -------------------------------------------------------------------------

close all;
clear;
clc;

% Inner race radius = 0.012;
% Outer race radius = 0.013;
% Compute Instantaneous Angular Speed of cage.
IR.IAS = 2*pi;
Cage.IAS = 0.012 / (0.012 + 0.013) * IR.IAS;

% time = 2s.
t = 10;

% 11 balls in the bearing.
NumberOfBalls = 11;

% Call function.
[BallsPosition, IRPosition] = ComputeBallPosition(NumberOfBalls, Cage, IR, t);

% Display results.
disp(BallsPosition);
disp(mod(BallsPosition, 2*pi));

% Convert to degree and show figure.
plot(1:NumberOfBalls, rad2deg(mod(BallsPosition, 2*pi)),'o');
axis([1 11 0 360]);
