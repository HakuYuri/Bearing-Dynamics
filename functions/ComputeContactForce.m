% -------------------------------------------------------------------------
% Compute the contact force of nth ball from the position and deformation, 
% and give the total force components on x and y directions.
% 
% Last modified 2023.3.22 By WangBowei.
% ---------------------------------Input-----------------------------------
% RaceContactStiffness;
% NthBallDeformation = [deformation1 deformation1 ...... deformationN];
% BallsPosition = [position1 position2 ...... positionN];
% ---------------------------------Output----------------------------------
% NthBallContactForce = [contactforce1 contactforce2 ...... contactforceN];
% ContactForce.x;
% ContactForce.y;
% -------------------------------------------------------------------------

function [ContactForce, NthBallContactForce] = ComputeContactForce(RaceContactStiffness, NthBallDeformation, BallsPosition)

    % Compute Hertz contact forces of each ball.
    NthBallContactForce = RaceContactStiffness * sqrt(NthBallDeformation .^ 3);

    % Compute total Hertz contact forces on x and y directions.
    % Contact exponent = 1.5 between the raceway and ball.
    ContactForce.x = RaceContactStiffness * sum(sqrt(NthBallDeformation .^ 3) .* cos(BallsPosition));
    ContactForce.y = RaceContactStiffness * sum(sqrt(NthBallDeformation .^ 3) .* sin(BallsPosition));

end