function [NthBallRollingResistance, ResistanceTorque] = ComputeRollingResistance(NthBallContactForce, ResistanceCoefficient, IR)
    
    NthBallRollingResistance = NthBallContactForce * ResistanceCoefficient;

    ResistanceTorque = IR.Radius * sum(NthBallRollingResistance);

end