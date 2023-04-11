function dydt = BearingDynamicModel(t, y, BearingPara, SystemPara, FaultPara, MotorPara)

    BearingDamping.x = BearingPara(1);
    BearingDamping.y = BearingPara(2);

    BearingStiffness.x = BearingPara(3);
    BearingStiffness.y = BearingPara(4);

    BearingMass = BearingPara(5);

    % Initial Parameter of race.
    IR.IAS      = y(6);
    OR.IAS      = 0;
    IR.Radius = BearingPara(6);
    OR.Radius = BearingPara(7);
  
    NumberOfBalls = BearingPara(8);

    OuterDamping = SystemPara(1);
    EquivalentInertia = SystemPara(2);

    % Declare bearing clearance.
    Clearance = SystemPara(3);
    RaceContactStiffness =  SystemPara(4);

    FaultStruct.Type = FaultPara(1);
    FaultStruct.Depth = FaultPara(2);
    FaultStruct.Position = FaultPara(3) / 180 * pi;
    FaultStruct.Length = FaultPara(4) / 180 * pi;


    % Declare gravity acceleration.
%     G = SystemPara(7);
    
    % Declare structure of Ball and Cage.
    Ball.IAS = 0;
    Cage.IAS = 0;

    % Declare the resistance coefficient between raceway and balls.
    ResistanceCoefficient = SystemPara(5);

    % Declare displacement.
    Displacement.x = y(1);
    Displacement.y = y(2);

    
    [Ball, Cage, IR, OR] = ComputeIAS(Ball, Cage, IR, OR);

    [BallsPosition, IRPosition] = ComputeBallPosition(NumberOfBalls, Cage, IR, t);

    [NthBallDeformation] = ComputeNthBallDeformation(BallsPosition, IRPosition, Displacement, Clearance, FaultStruct);

    [ContactForce, NthBallContactForce] = ComputeContactForce(RaceContactStiffness, NthBallDeformation, BallsPosition);

    [NthBallRollingResistance, ResistanceTorque] = ComputeRollingResistance(NthBallContactForce, ResistanceCoefficient, IR);

    
    % Declare the input torque as a ramp function.
%     InputTorque = 1 + t.*(t>=0 & t<9) + 9.*(t>=9);

    InputTorque = SystemPara(6);

    % Introducing unbalance rotor magnetic pull

    [MagneticPull.x, MagneticPull.y] = MagPull(t, Displacement, IR.IAS);
    
    % Initial values of y.
    dydt = zeros(6, 1);

    % Declare displacement and line speed on x and y direction.
    dydt(1) = y(4);
    dydt(2) = y(5);
    % Declare angular speed on z rotation.
    dydt(3) = y(6);

    % Declare line acceleration on x and y direction.
    dydt(4) = (300 -ContactForce.x - BearingDamping.x * y(4) - BearingStiffness.x * y(1)) / BearingMass ...
        + MotorPara(1) * MagneticPull.x;
    dydt(5) = (300 -ContactForce.y - BearingDamping.y * y(5) - BearingStiffness.y * y(2)) / BearingMass ...
        + MotorPara(1) * MagneticPull.y;
    % Declare angular acceleration on z rotation.
    dydt(6) = (InputTorque - ResistanceTorque - OuterDamping * y(6)) / EquivalentInertia;

end
