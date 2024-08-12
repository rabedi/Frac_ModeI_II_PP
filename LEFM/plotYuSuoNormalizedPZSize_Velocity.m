function [v, nDelp] = plotYuSuoNormalizedPZSize_Velocity(nu, doPlot, lineStyle, lineColor, lineWidth, markerStyle, maxVValue, vresolution) 
E = 1;
rho = 1;
[cd, cs, cr]  = computeCrackVelocities(E, nu, rho);

if nargin < 2
    doPlot = 1;
end

if nargin < 3
    lineStyle = '-';
end

if nargin < 4
    lineColor = 'g';
end

if nargin < 5
    lineWidth = 0.5;
end

if nargin < 6
    markerStyle = 'none';
end

if nargin < 7
    maxVValue = 0.9999;
end

if nargin < 8
    vresolution = 0.02;
end

v = 0:vresolution:maxVValue;
numv = length(v);
if (v(numv) ~= maxVValue)
    v(numv + 1) = maxVValue;
    numv = numv + 1;
end

% p = 1;
% p = 5/3;
for nv = 1:numv
    V = v(nv) * cr;
    ad = sqrt(1 - V * V / cd / cd);
    as = sqrt(1 - V * V / cs / cs);
    D = 4 * ad * as - (1 + as * as)^2;
    
    nDelp(nv) = (1 - nu) * D / (1 - as^2) * 1/ad;
%    nDels(nv) = (1 - V/cr)^p / (1 - V/cd);
% %    normalizedDelta(nv) = (1 - nu) * D / (1 - as^2) ;
    
end
if doPlot
    plot(v, nDelp, 'LineStyle', lineStyle, 'Color', lineColor, 'LineWidth', lineWidth, 'Marker', markerStyle);
end
%legend('nrp', 'nrs');
% Delp = (pi / 4) * nDelp;
% Dels = (1 / pi) * nDels;
% 
% figure(2);
% plot(v, Delp, v, Dels); 
% legend('rp', 'rs');
