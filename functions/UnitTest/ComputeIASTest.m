% -------------------------------------------------------------------------
% Test program for ComputeIAS.m
% 
% Last modified 2023.3.22.
% -------------------------------------------------------------------------

close all;
clear;
clc;

% Initial Parameter.
IR.IAS      = 2 * pi;
OR.IAS      = 0;
IR.Radius = 0.012;
OR.Radius = 0.013;

% Declare structure of Ball and Cage.
Ball.IAS = 0;
Cage.IAS = 0;

% Call function.
[Ball, Cage, IR, OR] = ComputeIAS(Ball, Cage, IR, OR);

% Display results.
disp(Ball);
disp(Cage);
disp(IR);
disp(OR);
