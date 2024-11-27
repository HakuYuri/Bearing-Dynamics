% -------------------------------------------------------------------------
% Compute the contact forces of balls in a bearing based on their positions
% and deformations, and calculate the total force components in the x and y
% directions.
%
% This function calculates:
% 1. The Hertzian contact force for each ball based on its deformation.
% 2. The total x and y components of the contact forces from all balls.
%
% The Hertzian contact model assumes the contact force is proportional to
% deformation raised to the power of 1.5 (suitable for ball-raceway contacts).
%
% Last modified: 2023.3.22
% ---------------------------------Input-----------------------------------
% RaceContactStiffness  - Contact stiffness of the raceway-ball system (scalar).
% NthBallDeformation    - A (1 x N) array of deformations for each ball (in meters).
% BallsPosition         - A (1 x N) array of angular positions of each ball (in radians).
% ---------------------------------Output----------------------------------
% NthBallContactForce   - A (1 x N) array of contact forces for each ball (in Newtons).
% ContactForce          - A structure containing the total contact force components:
%                         .x - Total force in the x direction (in Newtons).
%                         .y - Total force in the y direction (in Newtons).
% -------------------------------------------------------------------------

function [ContactForce, NthBallContactForce] = ComputeContactForce(RaceContactStiffness, NthBallDeformation, BallsPosition)

    % Compute the Hertzian contact force for each ball
    % Using the formula: F = k * deformation^(1.5)
    NthBallContactForce = RaceContactStiffness * sqrt(NthBallDeformation .^ 3);

    % Calculate the total contact forces in the x and y directions
    % The force components are projected based on the angular positions
    ContactForce.x = RaceContactStiffness * sum(sqrt(NthBallDeformation .^ 3) .* cos(BallsPosition));
    ContactForce.y = RaceContactStiffness * sum(sqrt(NthBallDeformation .^ 3) .* sin(BallsPosition));

end
