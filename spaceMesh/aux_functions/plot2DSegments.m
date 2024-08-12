function [X,Y,clr,lstyle,lwidth] = plot2DSegments(x, y, z, levels, segColors, segLineStyles, segLineWidths)
numSegments = length(x);

sz = numSegments - 1;
idx = 1;

for s =1:numSegments - 1
    hold on;
    fldAve = 0.5 * (z(s) + z(s + 1));
    [f1, f2] = find(levels <= fldAve);
%    [f1, f2] = find([-Inf Inf] <= fldAve);
    if (isempty(f2))
        continue;
    end
    ind = f2(1);
    
    X(:,idx) = [x(s);x(s+1)];
    Y(:,idx) = [y(s);y(s+1)];
    clr{idx} = segColors{ind};
    lstyle{idx} = segLineStyles{ind};
    lwidth{idx} = segLineWidths(ind);
    idx = idx + 1;
end

return;
end