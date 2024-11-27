% -------------------------------------------------------------------------
% Compute the positions of balls in a bearing and the inner ring position
% at a given time `t`. Returns the positions of all balls in a (1 x n) matrix.
%
% The function calculates:
% 1. The angular position of each ball based on the cage's angular speed and time.
% 2. The position of the inner ring based on its angular speed and time.
%
% Last modified: 2023.3.22
% ---------------------------------Input-----------------------------------
% NumberOfBalls  - Total number of balls in the bearing (scalar).
% Cage.IAS       - Angular speed of the cage (rad/s).
% IR.IAS         - Angular speed of the inner ring (rad/s).
% t              - Time at which to compute the positions (scalar, in seconds).
% ---------------------------------Output----------------------------------
% BallsPosition  - A (1 x NumberOfBalls) matrix containing the angular 
%                  positions of all balls (in radians).
% IRPosition     - The angular position of the inner ring at time `t` (in radians).
% -------------------------------------------------------------------------

function [BallsPosition, IRPosition] = ComputeBallPosition(NumberOfBalls, Cage, IR, t)

    % Initialize an array to store the positions of all balls
    BallsPosition = zeros(1, NumberOfBalls);

    % Compute the angular position of each ball
    for nthBall = 1:NumberOfBalls
        % Angular position of nth ball = cage angular motion + ball angular offset
        BallsPosition(nthBall) = Cage.IAS * t + 2*pi * (nthBall - 1) / NumberOfBalls;
    end

    % Compute the angular position of the inner ring
    IRPosition = IR.IAS * t;

end
