function axb = gen_crossProduct(a, b)
cellEntry = iscell(a);
if (~cellEntry)
    m = length(a);
    n = length(b);
    axb = ones(m, n);
    for i = 1:m
        for j = 1:n
            axb(i, j) = a(i) * b(j);
        end
    end
    return;
end
numPts = length(a);
if (numPts == 0)
    axb = [];
    return;
end
m = length(a{1});
iscellb = iscell(b);
if (iscellb)
    n = length(b{1});
else
    n = length(b);
end
axb = cell(numPts,1);
for pt = 1:numPts
    axb{pt} = ones(m, n);
    atmp = a{pt};
    if (iscellb)
        btmp = b{pt};
    else
        btmp = b;
    end
    for i = 1:m
        for j = 1:n
            axb{pt}(i, j) = atmp(i) * btmp(j);
        end
    end
end