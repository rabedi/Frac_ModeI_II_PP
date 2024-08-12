function plotAddModifiedOptNumber = getAddCurveOptionNumber(plotAddCRVS, additionalCurveOptionNumber)

% all quantities are normalized
%PZ process zone size
% v velocity
% t time
% a crack length (increment)
% vMax is maximum material velocity normal to crack surface (for mode I)
% vc: is cohesive time scale

global AddCRVSopt_a_t;
global AddCRVSopt_v_t;
global AddCRVSopt_PZ_v;
global AddCRVSopt_00_11Unbounded;
global AddCRVSopt_00_11Bounded;
global AddCRVSopt_1_Unbounded;
global AddCRVSopt_1Bounded;
global AddCRVSopt_vMax_rp2rsv;
global AddCRVSopt_rp_rsv_GivenSigmaForceSigmaC;
global AddCRVSopt_vMax_vc;
global AddCRVSopt_rprss_sigmaForceSigmaCUnbounded;
global AddCRVSopt_rprss_sigmaForceSigmaCBounded;
global AddCRVSopt_rprss_velocityUnbounded;
global AddCRVSopt_rprss_velocityBounded;


plotAddModifiedOptNumber = additionalCurveOptionNumber;

if (additionalCurveOptionNumber < 0)
    return;
end

if (plotAddCRVS <= 0)
    plotAddModifiedOptNumber = -1;
    return;
end

plotAddCRVS_ = plotAddCRVS - 1;
additionalCurveOptionNumber_ = mod(additionalCurveOptionNumber, 100);

plotAddModifiedOptNumber = additionalCurveOptionNumber_ + (plotAddCRVS_ * 100);


if (plotAddCRVS == 1)       % traction separation model modification of flags
    % additional modifications
    return;
end

if (plotAddCRVS == 2)       % Damage model modification of flags
    % additional modifications
    return;
end
    
    

