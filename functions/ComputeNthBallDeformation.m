% -------------------------------------------------------------------------
% Compute the deformation between the raceway and each ball from the total
% displacement in the x and y directions, considering geometric clearance and 
% potential faults in the raceway.
%
% This function calculates:
% 1. The initial deformation for each ball based on displacement and clearance.
% 2. Adjustments to deformation if a fault is present, depending on the type
%    (outer race fault or inner race fault) and its geometry (depth, position, length).
%
% Last modified: 2023.4.10 By WangBowei.
% ---------------------------------Input-----------------------------------
% Displacement.x      - Displacement in the x direction (scalar or vector).
% Displacement.y      - Displacement in the y direction (scalar or vector).
% BallsPosition       - A (1 x N) array of angular positions of the balls (in radians).
% IRPosition          - Angular position of the inner race (in radians).
% Clearance           - Geometric clearance between the raceway and balls (scalar, in meters).
% FaultStruct.Type    - Fault type:
%                       0: No faults
%                       1: Outer race fault
%                       2: Inner race fault
% FaultStruct.Depth   - Depth of the spall (in meters).
% FaultStruct.Position - Angular position of the spall start (in radians, 0 to 2*pi).
% FaultStruct.Length  - Angular length of the spall (in radians, 0 to 2*pi).
% ---------------------------------Output----------------------------------
% NthBallDeformation  - A (1 x N) array of deformations for each ball (in meters).
% -------------------------------------------------------------------------

function [NthBallDeformation] = ComputeNthBallDeformation(BallsPosition, IRPosition, Displacement, Clearance, FaultStruct)

    % Extract fault properties (included here for clarity and future expansion)
    FaultType = FaultStruct.Type;
    FaultDepth = FaultStruct.Depth;
    FaultPosition = FaultStruct.Position;
    FaultLength = FaultStruct.Length;

    % Ensure ball positions are within [0, 2*pi]
    AbsoluteBallPosition = mod(BallsPosition, 2 * pi);

    % Compute the initial deformation for each ball
    % Formula: deformation = displacement projection - clearance
    NthBallDeformation = (Displacement.x .* cos(BallsPosition)) + ...
                         (Displacement.y .* sin(BallsPosition)) - Clearance;

    % Adjust deformation if a fault is present
    switch FaultType
        case 1 % Outer race fault
            % Define spall angular range
            SpallPositionMax = FaultPosition + FaultLength;
            SpallPositionMin = FaultPosition;

            % Check if each ball's position is within the spall
            for i = 1:length(AbsoluteBallPosition)
                if AbsoluteBallPosition(i) >= SpallPositionMin && ...
                   AbsoluteBallPosition(i) <= SpallPositionMax
                    % Reduce deformation by the fault depth
                    NthBallDeformation(i) = NthBallDeformation(i) - FaultDepth;
                end
            end

        case 2 % Inner race fault
            % Define spall angular range relative to the inner race position
            SpallPositionMax = mod(IRPosition + FaultPosition + FaultLength, 2 * pi);
            SpallPositionMin = mod(IRPosition + FaultPosition, 2 * pi);

            % Check if each ball's position is within the spall range
            for i = 1:length(AbsoluteBallPosition)
                if (AbsoluteBallPosition(i) >= SpallPositionMin && ...
                    AbsoluteBallPosition(i) <= SpallPositionMax) || ...
                   (SpallPositionMax < SpallPositionMin && ...
                   (AbsoluteBallPosition(i) >= SpallPositionMin || ...
                    AbsoluteBallPosition(i) <= SpallPositionMax))
                    % Reduce deformation by the fault depth
                    NthBallDeformation(i) = NthBallDeformation(i) - FaultDepth;
                end
            end
    end

    % Ensure deformations are non-negative
    % Negative deformations are physically unrealistic
    NthBallDeformation = NthBallDeformation .* heaviside(NthBallDeformation);

end
