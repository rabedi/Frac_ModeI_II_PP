function [x, y] = plotNormalizedCrackGrowth4ContactLoadLEFM(doPlot, lineStyle, lineColor, lineWidth, markerStyle, xlimMinChosen,  xlimMaxChosen, ...
                  E, rho, nu, sigmaForce, rampTime, FractureEnergy)

[cd, cs, cr]  = computeCrackVelocities(E, nu, rho);
tau = pi / 8.0 / (1 + nu) * E * cd * FractureEnergy / (cs * sigmaForce)^2;
rampRatio = rampTime / tau;


finalCTVel2cr = 1  - 1 / xlimMaxChosen;
alphaPower = - log(1 - finalCTVel2cr) / log(10);
[time, ldotCrack, lCrack] = getSemiInfiniteConstantLoadingWithInitialRampResponse(nu, rampRatio, alphaPower);%, numPtPerRamp, numPtPerT)
x = time;
y = lCrack;


% xlimMaxChosen = min(xlimMaxChosen, 200); 
% xlimMaxChosen = max(xlimMaxChosen, 2);
% vresolution = 0.5;
% vresolution = max(vresolution, (xlimMaxChosen - 1) / 600);
% vresolution = min(vresolution, (xlimMaxChosen - 1) / 300);
% x = [0 1:vresolution:xlimMaxChosen];
% y(1) = 0;
% for i = 2:length(x)
%     y(i) = x(i) - 1 - log(x(i));
% end

if doPlot
    plot(x, y, 'LineStyle', lineStyle, 'Color', lineColor, 'LineWidth', lineWidth, 'Marker', markerStyle);
end