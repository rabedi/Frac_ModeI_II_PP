function splitPts = getSplitPts(pointIntervalDistribution, fnumDiv, xmin, xmax, numP, sumTotal)

% pointIntervalDistribution point distribution in interval
% fnumDiv number of final intervals wanted 
% xmin, xmax start and end point of interval
% numP in refined intervals (pointIntervalDistribution)
% sumTotal total number of points distributed

if (nargin < 5)
    numP = length(pointIntervalDistribution);
end

if (nargin < 6)
    sumTotal = sum(pointIntervalDistribution);
end
sumT(1) = pointIntervalDistribution(1);
for i = 2:numP
    sumT(i) = sumT(i - 1) + pointIntervalDistribution(i);
end

nsumT1(1) = 0.0;
nsumT1(2:numP + 1) = sumT / (sumTotal / fnumDiv);
cntr = 1;
delxSmall = (xmax - xmin) / numP;
if (delxSmall < 1e-56)
    splitPts = (xmin - 1)* ones(fnumDiv + 1, 1);
    splitPts(1) = xmin;
    % code may break here because the size of splitPts is not >= 2 (ma ynot
    % be a bug)
    splitPts(2) = xmin;
    return;
end
splitPts = zeros(fnumDiv + 1, 1);
    
splitPts(cntr) = xmin;
cntr = cntr + 1;
for i = 2:(numP + 1)
    x_1 = nsumT1(i - 1);
    x_2 = nsumT1(i);
    for j = (floor(x_1) + 1):(x_2)
        index = 1 / (x_2 - x_1) * ((x_2 - j) * (i - 1) + (j - x_1) * i) - 1;
        splitPts(cntr) = xmin + index * delxSmall;
        cntr = cntr + 1;
    end
end

if (abs(splitPts(cntr - 1) - xmax) / max([xmax, splitPts(cntr - 1), 1.0]) > 1e-6)
%     format long;
%     endPoint = splitPts(cntr - 1)
%     xmax
%     fprintf(1, 'last point should be the end point of the interval!\n');
%     splitPts
%     finish;
    splitPts(cntr - 1) = xmax;
end