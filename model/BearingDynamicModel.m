% -------------------------------------------------------------------------
% Bearing Dynamic Model for Simulating Bearing Vibrations and Rotational Dynamics
%
% This function models the dynamics of a bearing system under various
% forces, including contact forces, rolling resistance, and external
% input torque. It calculates the time derivatives of displacement,
% velocity, and angular velocity based on system parameters and fault
% conditions.
%
% Last modified: 2024.11.27
% ---------------------------------Input-----------------------------------
% t              - Time (scalar, in seconds).
% y              - State vector:
%                  y(1): Displacement in x direction (m).
%                  y(2): Displacement in y direction (m).
%                  y(3): Angular displacement (rad).
%                  y(4): Velocity in x direction (m/s).
%                  y(5): Velocity in y direction (m/s).
%                  y(6): Angular velocity (rad/s).
% BearingPara    - Bearing parameters:
%                  [DampingX, DampingY, StiffnessX, StiffnessY, Mass,
%                   InnerRadius, OuterRadius, NumberOfBalls]
% SystemPara     - System parameters:
%                  [OuterDamping, EquivalentInertia, Clearance,
%                   RaceContactStiffness, ResistanceCoefficient, InputTorque]
% FaultPara      - Fault parameters:
%                  [FaultType, FaultDepth, FaultPosition(deg), FaultLength(deg)]
% ---------------------------------Output----------------------------------
% dydt           - Time derivatives of the state vector:
%                  dydt(1): Velocity in x direction (m/s).
%                  dydt(2): Velocity in y direction (m/s).
%                  dydt(3): Angular velocity (rad/s).
%                  dydt(4): Acceleration in x direction (m/s²).
%                  dydt(5): Acceleration in y direction (m/s²).
%                  dydt(6): Angular acceleration (rad/s²).
% -------------------------------------------------------------------------

function dydt = BearingDynamicModel(t, y, BearingPara, SystemPara, FaultPara)

    % Extract bearing parameters
    BearingDamping.x = BearingPara(1); % Damping in x direction
    BearingDamping.y = BearingPara(2); % Damping in y direction
    BearingStiffness.x = BearingPara(3); % Stiffness in x direction
    BearingStiffness.y = BearingPara(4); % Stiffness in y direction
    BearingMass = BearingPara(5);       % Bearing mass (kg)
    IR.Radius = BearingPara(6);         % Inner race radius (m)
    OR.Radius = BearingPara(7);         % Outer race radius (m)
    NumberOfBalls = BearingPara(8);     % Number of rolling elements

    % Extract system parameters
    OuterDamping = SystemPara(1);       % Rotational damping of outer ring
    EquivalentInertia = SystemPara(2);  % Moment of inertia of outer ring (kg·m²)
    Clearance = SystemPara(3);          % Bearing clearance (m)
    RaceContactStiffness = SystemPara(4); % Hertz contact stiffness (N/m^(3/2))
    ResistanceCoefficient = SystemPara(5); % Rolling resistance coefficient

    InputTorque = SystemPara(6);        % Input torque (N·m)

    % Declare the input torque as a ramp function. (for Speed ​​Shifting Process)
%     InputTorque = 1 + t.*(t>=0 & t<9) + 9.*(t>=9);

%     Gvt = SystemPara(7);                % Gravity acceleration.

    % Initial value of IAS
    IR.IAS      = y(6);
    OR.IAS      = 0;


    % Extract fault parameters
    FaultStruct.Type = FaultPara(1);    % Fault type: 0 (none), 1 (OR), 2 (IR)
    FaultStruct.Depth = FaultPara(2);   % Fault depth (m)
    FaultStruct.Position = FaultPara(3) / 180 * pi; % Fault position (rad)
    FaultStruct.Length = FaultPara(4) / 180 * pi;   % Fault length (rad)

    % Declare displacement components
    Displacement.x = y(1); % Displacement in x direction
    Displacement.y = y(2); % Displacement in y direction

    % Initialize intermediate variables for Ball and Cage
    Ball.IAS = 0; % Instantaneous angular speed of ball
    Cage.IAS = 0; % Instantaneous angular speed of cage

    % Compute angular speeds for balls and cage
    [Ball, Cage, IR, OR] = ComputeIAS(Ball, Cage, IR, OR);

    % Compute positions of rolling elements at time t
    [BallsPosition, IRPosition] = ComputeBallPosition(NumberOfBalls, Cage, IR, t);

    % Compute deformation of rolling elements
    [NthBallDeformation] = ComputeNthBallDeformation(BallsPosition, IRPosition, Displacement, Clearance, FaultStruct);

    % Compute contact forces and total force components
    [ContactForce, NthBallContactForce] = ComputeContactForce(RaceContactStiffness, NthBallDeformation, BallsPosition);

    % Compute rolling resistance and resistance torque
    [NthBallRollingResistance, ResistanceTorque] = ComputeRollingResistance(NthBallContactForce, ResistanceCoefficient, IR);

    % Initialize output derivative vector
    dydt = zeros(6, 1);

    % Define velocity components
    dydt(1) = y(4); % Velocity in x direction
    dydt(2) = y(5); % Velocity in y direction
    dydt(3) = y(6); % Angular velocity
    
    % Force components of the bearing itself
    InitialForce.x = 300;
    InitialForce.y = 300;

    % Define acceleration components
    dydt(4) = (InitialForce.x - ContactForce.x - BearingDamping.x * y(4) - BearingStiffness.x * y(1)) / BearingMass;
    dydt(5) = (InitialForce.y - ContactForce.y - BearingDamping.y * y(5) - BearingStiffness.y * y(2)) / BearingMass;

    % Define angular acceleration
    dydt(6) = (InputTorque - ResistanceTorque - OuterDamping * y(6)) / EquivalentInertia;

end
