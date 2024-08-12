function integralVal = gen_equidistant_NewtonCotes_Integral(pointVals, len)
if nargin < 2
    len = 1;
end
cellForPointVals = iscell(pointVals);

numPoints = length(pointVals);
if (numPoints == 0)
    integralVal = [];
    return;
end
numSegments = numPoints - 1;
if (numPoints == 1)
    weights = 1;
elseif (numPoints == 2)
    weights = [0.5 0.5];
elseif (numPoints == 2)
    weights = [0.5 0.5];
elseif (numPoints == 3)
    weights = [1 4 1]/6;
elseif (numPoints == 4)
    weights = [1 3 3 1]/8;
elseif (numPoints == 5)
    weights = [7 32 12 32 7]/90;
elseif (numPoints == 6)
    weights = [19 75 50 50 75 19]/288;
elseif (numPoints == 7)
    weights = [41 216 27 272 27 216 41]/840;
else
    cntr = 1;
    half = floor(numSegments/2);
    for i = 1:half 
        weights(cntr) = 2;
        weights(cntr + 1) = 4;
        cntr = cntr + 2;
    end
    weights(1) = 1;
    fact = 1 / 6 * 2 / numSegments;
    if (mod(numSegments, 2) == 0)
        weights(numPoints) = 1;
        weights = fact * weights;
    else
        weights = fact * weights;
        weights(numPoints) = 0.5 / numSegments;
        weights(numPoints - 1) = 0.5 / numSegments + fact;
    end
%     weights = ones(1, numPoints) / numSegments;
%     weights(1) = weights(1) / 2;
%     weights(numPoints) = weights(1);
end
%integralVal = sum(weights)
if (~cellForPointVals)
    integralVal = 0.0;
    for i = 1:numPoints
        integralVal = integralVal + pointVals(i) * weights(i);
    end
else
    integralVal = 0 * pointVals{1};
    for i = 1:numPoints
        integralVal = integralVal + pointVals{i} * weights(i);
    end
end    
integralVal = len * integralVal;