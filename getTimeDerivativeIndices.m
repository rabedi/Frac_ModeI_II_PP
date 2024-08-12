function [xindex, yindex, solindex] = getTimeDerivativeIndices(startingPts, dimension)

counter = 1;
% DSDT

yin = getColNumberFromSymbolNumber('space', 0, startingPts);
solin = getColNumberFromSymbolNumber('DspaceDT', 0, startingPts);

if ((yin > 0) && (solin > 0))
    yindex(counter) = yin;
    solindex(counter) = solin;
    counter = counter + 1;
end

%DXDT
for dim = 0:(dimension - 1)
    yin = getColNumberFromSymbolNumber('X', dim, startingPts);
    solin = getColNumberFromSymbolNumber('DXDT', dim, startingPts);
    if ((yin > 0) && (solin > 0))
        yindex(counter) = yin;
        solindex(counter) = solin;
        counter = counter + 1;
    end
end

%DvalDT

for fld = 0:(startingPts(12) - startingPts(11) - 1)
    yin = getColNumberFromSymbolNumber('fldInternal', fld, startingPts);
    solin = getColNumberFromSymbolNumber('DfldDT', fld, startingPts);
    if ((yin > 0) && (solin > 0))
        yindex(counter) = yin;
        solindex(counter) = solin;
        counter = counter + 1;
    end
end

xindex = ones(1, counter - 1);
xindex(:) = getColNumberFromSymbolNumber('time', fld, startingPts);
