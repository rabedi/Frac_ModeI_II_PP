function rat = computeRatioTwoSided(a, b, maxVal, returnInfs)

rat1 = computeRatio(a, b, maxVal, returnInfs);
rat2 = computeRatio(b, a, maxVal, returnInfs);

mxv = maxVal;
if (returnInfs == 1)
    mxv = inf;
end

mnv = -maxVal;
if (returnInfs == 1)
    mnv = -inf;
end

len = length(a);
maxV = maxVal * 0.99999;
for i = 1:len
    if (rat1(i) > maxV)
        rat(i) = mxv;
    elseif (rat1(i) < -maxV)
        rat(i) = mnv;
    elseif ((rat2(i) > maxV) || (rat2(i) < -maxV))
        rat(i) = 0.0;
    else
        rat(i) = rat1(i);
    end
end