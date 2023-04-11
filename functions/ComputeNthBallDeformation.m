% -------------------------------------------------------------------------
% Compute the deformation between race and each ball from the total deplac-
% ement on x and y direction, and return a (1 x n) matrix of defomation, n 
% is the number of balls.
% 
% Last modified 2023.4.10 By WangBowei.
% ---------------------------------Input-----------------------------------
% Displacement.x;
% Displacement.y;
% BallsPosition = [position1 position2 ...... positionN]
% IRPosition
% Clearance;
% FaultStruct.Type;         % 0: No faults  1: OR fault 2: IR fault
% FaultStruct.Depth;        % Depth of spall (m)
% FaultStruct.Position;     % Position of spall, 0 - 2pi
% FaultStruct.Length;       % Length of spall, 0 - 2pi
% ---------------------------------Output----------------------------------
% NthBallDeformation = [deformation1 deformation1 ...... deformationN]
% -------------------------------------------------------------------------


function [NthBallDeformation] = ComputeNthBallDeformation(BallsPosition, IRPosition, Displacement, Clearance, FaultStruct)
    
    FaultStruct.Type;
    FaultStruct.Depth;
    FaultStruct.Position;
    FaultStruct.Length;

    AbsoluteBallPosition = mod(BallsPosition, (2 * pi));

    % Compute deformation of Nth ball
    NthBallDeformation = (Displacement.x .* cos(BallsPosition)) + (Displacement.y .* sin(BallsPosition)) - Clearance;

    switch FaultStruct.Type

        case 1

            SpallPositionMax = FaultStruct.Position + FaultStruct.Length;
            SpallPositionMin = FaultStruct.Position;
        
            for i = 1 : length(AbsoluteBallPosition(:))
                
                if ((AbsoluteBallPosition(i) >= SpallPositionMin) && ...
                   (AbsoluteBallPosition(i) <= SpallPositionMax))
        
                    NthBallDeformation(i) = NthBallDeformation(i) - FaultStruct.Depth;
        
                end
        
            end

        case 2

            SpallPositionMax = mod(IRPosition + FaultStruct.Position + FaultStruct.Length, (2 * pi));
            SpallPositionMin = mod(IRPosition + FaultStruct.Position, (2 * pi));


            for i = 1 : length(AbsoluteBallPosition(:))
                
                if ((AbsoluteBallPosition(i) >= SpallPositionMin) && ...
                   (AbsoluteBallPosition(i) <= SpallPositionMax)) || ...
                   ((SpallPositionMax < SpallPositionMin) && ...
                   ((AbsoluteBallPosition(i) >= SpallPositionMin) || ...
                   (AbsoluteBallPosition(i) <= SpallPositionMax)))
                    
                    NthBallDeformation(i) = NthBallDeformation(i) - FaultStruct.Depth;

                end
        
            end
            
    end

    % Prevent non-positive values
    NthBallDeformation = NthBallDeformation .* heaviside(NthBallDeformation);

end