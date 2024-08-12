function rat = computeRatio(a, b, maxVal, returnInfs)

len = length(a);

for i = 1:len
    if (isnan(a(i)) || isnan(b(i)))
        rat(i) = nan;
        continue;
    end
    rat(i) = a(i) / b(i);
    if (rat(i) > maxVal)
        if (returnInfs == 1)
            rat(i) = inf;
        else
            rat(i) = maxVal;
        end
    elseif (rat(i) < -maxVal)
        if (returnInfs == 1)
            rat(i) = -inf;
        else
            rat(i) = -maxVal;
        end
    end
end