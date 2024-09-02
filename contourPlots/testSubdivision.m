tic;
% number = 400000;
number = 3000;
% maxNumPtsPerBox = 400000;
maxNumPtsPerBox = 5000;
px = 2;
py = 0.5;
doPlot = 0;
expansionRatio = 0.02;

x = zeros(number, 1);
y = zeros(number, 1);

for i = 1:number
    x_ = rand(1, 1);
    x_ = power(x_, px);
    y_ = rand(1, 1);
    y_ = (1 - power(y_, py));
    x(i,1) = x_;
    y(i,1) = y_;
end
% z = rand(number, 1);
% z = x.*exp(-x.^2-y.^2);
numFlds = 2;
z = zeros(number, numFlds);
%z(:,1) = (x - 0.5) .* (x - 0.5) .* (y - 0.5) .* (y - 0.5);
z(:,1) = (x - 0.5) .* (x - 0.5) + (y - 0.5) .* (y - 0.5);
%z(:,1) = -x .^2 + y;


for i = 1:number
   grad = [x(i) - 0.5, y(i) - 0.5];
%   grad = [-2*x(i), 1];
%   z(i,2) = atan2(grad(1), -grad(2));
   z(i,2) = atan2(grad(2), grad(1));

%     grad = [1.0, 0.0];
%     z(i,2) = atan2(grad(2), grad(1));
end
%    z(:,2) = atan2((y - 0.5), (x - 0.5));
% z(:,2) = (x - 0.5) .* (x - 0.5) + 4.0 .* (y - 0.5) .* (y - 0.5);
for fld = 1:numFlds
    lablIn{fld} = [];
    fig(fld) = figure(fld);
end

% if (doPlot == 1)
%     plot(x,y, 'x');
% end
%plot3(x,y,z, 'x');

hold on;
xmin = 0.0;
xmax = 1.0;
ymin = 0.0;
ymax = 1.0;
precisionRowCounter = 1000;
maxNumRowCounter = 10000;
maxNumGridPtsSingleContour = 40;
maxNumGridPtsALLContour = 120;
maxNumDivisions = 20;
zBasePoints = inf * ones(1, numFlds);

colormap('Jet');
colormapInput = colormap;
showLegend = 1;


figure(fig(1));
%quiver(x,y, z(:,1), z(:,2));
hold on;
zflags = [11 0];
zmin = -inf * ones(1, numFlds);
zmax = inf * ones(1, numFlds);
%[splitPtsX, splitPtsY, numberOfBoxPerAxis] = subdivideRegion(x, y, xmin, xmax, ymin, ymax, maxNumPtsPerBox, precisionRowCounter, maxNumRowCounter, doPlot)
contourPlot(x, y, z, xmin, xmax, ymin, ymax, zmin, zmax, maxNumPtsPerBox, precisionRowCounter, maxNumRowCounter, maxNumGridPtsSingleContour, maxNumGridPtsALLContour, doPlot, expansionRatio, maxNumDivisions, zBasePoints, colormapInput, fig, zflags , showLegend);
toc
%ttotal = toc

% numP = 50;
% fnumDiv = 10;
% p = 3;
% xmin = 0;
% xmax = 1;
% 
% for i = 1:numP
%     r(i) = power(i,p);
% end
% 
% r
% splitPts = getSplitPts(r, fnumDiv, xmin, xmax)

% sumTotal = sum(r)
% sumT(1) = r(1);
% for i = 2:numP
%     sumT(i) = sumT(i - 1) + r(i);
% end
% 
% nsumT1(1) = 0.0;
% nsumT1(2:numP + 1) = sumT / (sumTotal / fnumDiv)
% cntr = 1;
% delxSmall = (xmax - xmin) / numP;
% splitPts = zeros(fnumDiv + 1, 1);
% splitPts(cntr) = xmin;
% cntr = cntr + 1;
% for i = 2:(numP + 1)
%     x_1 = nsumT1(i - 1);
%     x_2 = nsumT1(i);
%     for j = (floor(x_1) + 1):(x_2)
%         index = 1 / (x_2 - x_1) * ((x_2 - j) * (i - 1) + (j - x_1) * i) - 1;
%         splitPts(cntr) = xmin + index * delxSmall;
%         cntr = cntr + 1;
%     end
% end
% splitPts        

% nsumT = floor(sumT / (sumTotal / fnumDiv))
% 
% jumpSum = nsumT(2:numP) - nsumT(1:numP - 1)
% 
% cntr = 1;
% delxSmall = (xmax - xmin) / numP;
% splitPts = zeros(fnumDiv + 1, 1);
% 
% splitPts(cntr) = xmin;
% cntr = cntr + 1;

% if (jumpSum(1) > 0)
%     if (jumpSum(2) > 0)
%         denom = splitPts(1) + 1;
%     else
%         denom = splitPts(1);
%     end
%     for k = 1:splitPts(1)
%         splitPts(cntr) = xmin + delxSmall * k / denom;
%         cntr = cntr + 1;
%     end
% end
%         
% end
%     
% for i = 2:numP
%     if (jumpSum(i) > 0)
%         
    