% -------------------------------------------------------------------------
% Compute the IAS of cage and ball from inner/outer race.
% 
% Last modified 2023.3.22 By WangBowei.
% -------------------------------------------------------------------------
% Each structure has three subparameters:
% Str.Radius
% Str.LineSpeed
% Str.IAS
% ---------------------------------Input-----------------------------------
% IR.IAS;           OR.IAS;
% IR.Radius;        OR.Radius;
% --------------------------------Output-----------------------------------
% IR.LineSpeed;     OR.LineSpeed;       Ball.LineSpeed;     Cage.LineSpeed;
%                                       Ball.IAS;           Cage.IAS;
%                                       Ball.Radius;        Cage.Radius;
% -------------------------------------------------------------------------

function [Ball, Cage, IR, OR] = ComputeIAS(Ball, Cage, IR, OR)

    % Compute line speed
    IR.LineSpeed = IR.Radius * IR.IAS;
    OR.LineSpeed = OR.Radius * OR.IAS;
    Ball.LineSpeed = 1/2 * (IR.LineSpeed + OR.LineSpeed);
    Cage.LineSpeed = Ball.LineSpeed;

    % Convert to IAS
    Ball.IAS = 2 * Ball.LineSpeed / (IR.Radius + OR.Radius);
    Cage.IAS = Ball.IAS;

    % Compute radius of plitch circle
    Ball.Radius = 1/2 * (IR.Radius + OR.Radius);
    Cage.Radius = Ball.Radius;

end
