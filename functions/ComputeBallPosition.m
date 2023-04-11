% -------------------------------------------------------------------------
% Compute the position of nth ball on time t, and return a (1 x n) matrix,
% n is the number of balls.
% 
% Last modified 2023.3.22 By WangBowei.
% ---------------------------------Input-----------------------------------
% IR.IAS;           OR.IAS;
% IR.Radius;        OR.Radius;
% ---------------------------------Output----------------------------------
% BallsPosition = [position1 position2 ...... positionN]
% -------------------------------------------------------------------------

function [BallsPosition, IRPosition] = ComputeBallPosition(NumberOfBalls, Cage, IR, t)

    BallsPosition = zeros(1, NumberOfBalls);

    for nthBall = 1 : NumberOfBalls

        BallsPosition(nthBall) = Cage.IAS * t + 2*pi * (nthBall - 1) / NumberOfBalls;
    
    end

    IRPosition = IR.IAS * t;
end
