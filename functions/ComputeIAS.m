% -------------------------------------------------------------------------
% Compute the IAS (Instantaneous Angular Speed) of the cage and ball based on
% the inner and outer race parameters.
%
% This function calculates:
% 1. The line speed of the inner race (IR), outer race (OR), ball, and cage.
% 2. The IAS of the ball and cage.
% 3. The pitch circle radius of the ball and cage.
%
% Last modified: 2023.3.22
% ---------------------------------Input-----------------------------------
% IR, OR - Structures containing parameters of the inner and outer races:
%          .Radius     - Radius of the race (in meters).
%          .IAS        - Angular speed of the race (in rad/s).
% --------------------------------Output-----------------------------------
% IR, OR - Updated structures with computed line speed:
%          .LineSpeed  - Line speed of the race (in m/s).
% Ball, Cage - Structures containing the computed properties:
%          .LineSpeed  - Line speed of the ball/cage (in m/s).
%          .IAS        - Angular speed of the ball/cage (in rad/s).
%          .Radius     - Radius of the pitch circle of the ball/cage (in meters).
% -------------------------------------------------------------------------

function [Ball, Cage, IR, OR] = ComputeIAS(Ball, Cage, IR, OR)

    % Step 1: Compute the line speeds of inner race (IR) and outer race (OR)
    IR.LineSpeed = IR.Radius * IR.IAS;  % Line speed of the inner race (m/s)
    OR.LineSpeed = OR.Radius * OR.IAS;  % Line speed of the outer race (m/s)

    % Step 2: Compute the average line speed for the ball and cage
    % The ball's line speed is the average of the inner and outer race speeds
    Ball.LineSpeed = 0.5 * (IR.LineSpeed + OR.LineSpeed);
    Cage.LineSpeed = Ball.LineSpeed;  % Cage shares the same line speed as the ball

    % Step 3: Convert the line speed to IAS (Instantaneous Angular Speed)
    % Formula: IAS = 2 * LineSpeed / (IR.Radius + OR.Radius)
    Ball.IAS = 2 * Ball.LineSpeed / (IR.Radius + OR.Radius);
    Cage.IAS = Ball.IAS;  % Cage shares the same IAS as the ball

    % Step 4: Compute the pitch circle radius of the ball and cage
    % The pitch circle radius is the average of the inner and outer race radii
    Ball.Radius = 0.5 * (IR.Radius + OR.Radius);
    Cage.Radius = Ball.Radius;  % Cage shares the same pitch circle radius as the ball

end
