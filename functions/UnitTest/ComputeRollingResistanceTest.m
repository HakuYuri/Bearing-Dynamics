% -------------------------------------------------------------------------
% Test program for ComputeNthBallDeformation.m
% 
% Last modified 2023.3.22.
% -------------------------------------------------------------------------

% Declare IR radius to compute torque.
IR.Radius     = 0.012;

% Declare rolling resistance coefficient.
ResistanceCoefficient = 0.060;

% Initial parameter of contact force.
NthBallContactForce = [206.5743  477.8472  555.8779  378.7995 90.8457   0   0   0   0   0   0 ];

% Call function.
[NthBallRollingResistance, ResistanceTorque] = ComputeRollingResistance(NthBallContactForce, ResistanceCoefficient, IR);

disp(NthBallRollingResistance);
disp(ResistanceTorque);

