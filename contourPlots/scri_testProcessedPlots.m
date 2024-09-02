

numPt = 100;
xmin = -1.2;
xmax = 5.1;
delx = 3.5;
delxs = 0.1;

ymin = -3.9;
ymax = 3.9;
dely = 111.5;
delys = .05;

% xmin = -2.2;
% xmax = 6.1;
% delx = 1.2;
% delxs = 0.1;
% 
% ymin = -3.2;
% ymax = 1.1;
% dely = 1.1;
% delys = .05;
global cnfg;
global pl_conf;
global pf_plots;
global pl_normalizers;
global figHandles;

[cnfg, pl_conf, pf_plots, pl_normalizers, figHandles] = readProcessedPlotsConfigFile();

if (delx > (xmax - xmin))
    xL = [xmin xmax];
else
    xL = xmin:delx:xmax;
end
if (dely > (ymax - ymin))
    yL = [ymin ymax];
else
    yL = ymin:dely:ymax;
end

numxL = length(xL);
numyL = length(yL);

for i = 1:(numxL-1)
    xn = xL(i);
    xx = xL(i + 1);
    delx = xx - xn;
    for j = 1:(numyL - 1)
        yn = yL(j);
        yx = yL(j + 1);
        dely = yx - yn;
        x = rand(numPt,1)*delx+xn;  y = rand(numPt,1)*dely+yn;
        z = zeros(numPt, 24);
        for k = 1:24
%            z(:, k) = log(x + 10) .* power(y, 1 + k/20);
            z(:, k) = x + power(abs(y), 1 + k/20);
%           z(:, k) = y + k/60;
        end
        originalXvals = xn:delxs:xx;
        originalYVals = yn:delys:yx;
        plotProcessedPlots(x, y, z, originalXvals, originalYVals);
    end
end