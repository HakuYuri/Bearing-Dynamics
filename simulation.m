% -------------------------------------------------------------------------
% Bearing Dynamics Simulation and Result Analysis
%
% This script simulates the dynamics of a bearing system under various
% operating and fault conditions. It reads system parameters from an Excel
% file, solves the bearing's dynamic differential equations, and saves the
% results for post-processing.
%
% Main steps:
% 1. Load bearing parameters, system parameters, and fault parameters.
% 2. Initialize time vector and state variables.
% 3. Solve the bearing dynamics using `ode45`.
% 4. Save the results for further analysis.
% 5. Run a separate script for result visualization and analysis.
%
% Last modified: 2024.11.27
% -------------------------------------------------------------------------

% Clear workspace, close figures, and clear command window
close all; 
clear; 
clc;

% -------------------------------------------------------------------------
% Step 1: Load system parameters and fault parameters from Excel
% -------------------------------------------------------------------------

% Load bearing parameters (e.g., damping, stiffness, radius, mass, etc.)
BearingPara = readmatrix('systemparameter\para.xlsx', 'Range', 'A3:H3');

% Load system parameters (e.g., damping, inertia, clearance, etc.)
SystemPara = readmatrix('systemparameter\para.xlsx', 'Range', 'A7:H7');

% Load analysis parameters (e.g., time limit, time step, etc.)
AnaPara = readmatrix('systemparameter\para.xlsx', 'Range', 'A12:B12');

% Load fault parameters (e.g., fault type, depth, position, length, etc.)
FaultPara = readmatrix('systemparameter\para.xlsx', 'Range', 'A16:D16');

% Initialize fault structure
FaultStruct.Type = FaultPara(1);                    % Fault type
FaultStruct.Depth = FaultPara(2);                   % Fault depth (m)
FaultStruct.Position = FaultPara(3) / 180 * pi;     % Fault position (rad)
FaultStruct.Length = FaultPara(4) / 180 * pi;       % Fault length (rad)

% -------------------------------------------------------------------------
% Step 2: Declare time parameters and initialize time vector
% -------------------------------------------------------------------------

% Declare the total simulation time limit (seconds)
TimeLimit = AnaPara(1);

% Set the time step (seconds)
TimeStep = AnaPara(2);

% Generate the time vector from 0 to TimeLimit with increments of TimeStep
Time = 0 : TimeStep : TimeLimit;

% -------------------------------------------------------------------------
% Step 3: Initialize the state variables for the differential equation
% -------------------------------------------------------------------------

% Initial state vector:
% [x_displacement, y_displacement, angular_position, x_velocity, y_velocity, angular_velocity]
% Set initial angular speed to 1500 rpm (convert to rad/s)
y0 = [0, 0, 0, 0, 0, SystemPara(8) / 60 * 2 * pi];

% -------------------------------------------------------------------------
% Step 4: Solve the bearing dynamics differential equations
% -------------------------------------------------------------------------

% Solve the differential equations using `ode45`
% BearingDynamicModel computes the derivatives of the state variables
fprintf("Simulating...")
[t, y] = ode45(@(t, y) BearingDynamicModel(t, y, BearingPara, SystemPara, FaultPara), Time, y0);

% -------------------------------------------------------------------------
% Step 5: Save simulation results for further analysis
% -------------------------------------------------------------------------

% Save results to the 'results' directory as a .mat file
currentTime = datetime('now');
date_str = string(currentTime, 'yyyyMMdd_HHmmss');
filepath = 'results\Solution_' + date_str + '.mat';
save(filepath, 'y', 't', 'BearingPara', 'SystemPara', 'FaultPara', 'AnaPara');

% -------------------------------------------------------------------------
% Step 6: Run result analysis script
% -------------------------------------------------------------------------

% Execute the result analysis script for visualization and additional analysis
run resultAnalysis2.m
