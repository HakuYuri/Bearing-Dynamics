% -------------------------------------------------------------------------
% Compute the rolling resistance for each ball and the resulting resistance
% torque on the inner race (IR).
%
% This function calculates:
% 1. The rolling resistance for each ball based on its contact force and a
%    given resistance coefficient.
% 2. The total resistance torque on the inner race by summing the contribution
%    from all balls.
%
% Last modified: 2024.11.27
% ---------------------------------Input-----------------------------------
% NthBallContactForce   - A (1 x N) array of contact forces for each ball (in Newtons).
% ResistanceCoefficient - Rolling resistance coefficient (unitless, typically small).
% IR.Radius             - Radius of the inner race (in meters).
% ---------------------------------Output----------------------------------
% NthBallRollingResistance - A (1 x N) array of rolling resistance forces for
%                            each ball (in Newtons).
% ResistanceTorque         - Total rolling resistance torque on the inner race
%                            (in Newton-meters).
% -------------------------------------------------------------------------

function [NthBallRollingResistance, ResistanceTorque] = ComputeRollingResistance(NthBallContactForce, ResistanceCoefficient, IR)

    % Step 1: Compute the rolling resistance force for each ball
    % Formula: Resistance = ContactForce * ResistanceCoefficient
    NthBallRollingResistance = NthBallContactForce * ResistanceCoefficient;

    % Step 2: Compute the total rolling resistance torque on the inner race
    % Formula: Torque = Radius * Sum of Rolling Resistances
    ResistanceTorque = IR.Radius * sum(NthBallRollingResistance);

end
