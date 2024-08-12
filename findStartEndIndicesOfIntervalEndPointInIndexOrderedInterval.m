function [st, en, found] = findStartEndIndicesOfIntervalEndPointInIndexOrderedInterval(xSt, xEn, tx, include)

% include:
% if 1 means we find st s.t. tx(st) <= xSt, and tx(en) >= xEn, so (xSt,
% xEn) is included
% if 0 we do such that tx(st) >= xSt and tx(en) <=xEn

if nargin < 4
    include = 0;
end

lentx = length(tx);

found = 1;
indS = find(tx >= xSt);
if (length(indS) > 0)
    st = indS(1);
else
    st = inf;
    found = 0;
end

indE = find(tx <= xEn);
if (length(indE) > 0)
    en = indE(length(indE));
else
    en = -inf;
    found = 0;
end

if (st > en)
    found = 0;
end

if (include == 1)
    if (found == 1)
        if (abs(tx(st) - xSt) > 1e-15)
            st = st - 1;
        end
        if (abs(tx(en) - xEn) > 1e-15)
            en = en + 1;
        end   
    else
        if (abs(tx(lentx) - xSt) < 1e-5)
            st = lentx;
            en = lentx;
            found = 1;
        elseif (abs(tx(1) - xEn) < 1e-5)
            st = 1;
            en = 1;
            found = 1;
        end
    end
end

