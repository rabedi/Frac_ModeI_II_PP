function [dataPoints,names, numBaseFld, fldMult, typeMult, dimMult, energyReleaseRate] = ...
    generateIntegrationRelatedCrackData(fidInt, fidSpt, timeStart, timeStep, ctTimes, ctVel, normalizerOption, numDflds, indx2zero)

global nrmlzrRun;
global nrmlzrSptl;
global nrmlzrPW;

global cnfg;
global ImaxPowerRatioEReleaseRate;

numDim = 3;
if nargin < 6
    normalizerOption = -1;
end
if nargin < 7
    numDflds = 3;
end



numComb = numDim * numDflds;
% this is the number of fields that are derived from int fields: if f is integrands integrals of f 
% in time and space are called ft and fx and in both ftx = F so dF/dx = ft
% and dF/dt = fx and dF/da (crack length) = fx / v_cr, fields that we are
% interested are 
% F
% dF/dt = fx
% dF/da = fx / v
baseName = 'X';

fldMult = numComb;
typeMult = numDflds;
dimMult = 1;
[times, valuesInt, normalizersInt, numBaseFld] = readIntegratedRelatedFile(fidInt, timeStart, timeStep, normalizerOption);
[times, valuesSpt, normalizersSpt, numBaseFld] = readIntegratedRelatedFile(fidSpt, timeStart, timeStep, normalizerOption);

numCTs = length(ctTimes);

dataPoints = cell(numBaseFld, 1);
for fld = 1:numBaseFld
    dataPoints{fld} = zeros(numCTs, numComb);
end

global cnfg;
global ImaxPowerRatioEReleaseRate;



maxRatio = power(10.0, cnfg{ImaxPowerRatioEReleaseRate}) * normalizersInt{1}(nrmlzrPW);

names = cell(fld, 1);
for dim = 1:numDim - 1
    post{dim} = num2str(dim - 1);
end
post{numDim } = 's';

for fld = 1:numBaseFld
    for dim = 1:numDim
        names{fld}{dim} = ['F', baseName, num2str(fld - 1), '_', post{dim}];
    end
    for dim = 1:numDim
        names{fld}{dim + numDim} = ['Ft', baseName, num2str(fld - 1), '_', post{dim}];
    end
    for dim = 1:numDim
        names{fld}{dim + 2 * numDim} = ['Fa', baseName, num2str(fld - 1), '_', post{dim}];
    end
end
returnInfs = 1;
for i = 1:numCTs
    t = ctTimes(i);
    if (isnan(t) == 1)
        for fld = 1:numBaseFld
            dataPoints{fld}(i, 1:3 * numDim) = nan;
        end        
    else
        rat = (t - timeStart) / timeStep;
        ind = round(rat) + 1;
        vcr = ctVel(i);
        for fld = 1:numBaseFld
            dataPoints{fld}(i, 1:numDim) = valuesInt{fld}(ind, 1:numDim);
            dataPoints{fld}(i, numDim + 1:2 * numDim) = valuesSpt{fld}(ind, 1:numDim);
            for j = 1:numDim
                dataPoints{fld}(i, 2 * numDim + j) = computeRatio(valuesSpt{fld}(ind, j) , vcr, maxRatio, returnInfs);
            end
    %        dataPoints{fld}(i, 2 * numDim + 1:3 * numDim) = valuesSpt{fld}(ind, 1:numDim) /vcr;
        end
    end
end

fldTotal = 1;
%j spans from 1 to 3 (dim 0-2 and scalar value)
% G = energyReleaseRate = D(dissipation)/Da
energyReleaseRate = dataPoints{fldTotal}(:, 2 * numDim + 1:3 * numDim);
