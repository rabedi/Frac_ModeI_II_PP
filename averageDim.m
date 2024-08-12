function ave = averageDim(a, dim, st, en)
[m, n] = size(a);

if nargin < 3
    st = 1;
end

if nargin < 4
    en = size(a, dim);
end


if (st > en)
    st
    en
    fprintf(1, 'start larger than end\n');
    pause;
end


if (dim == 1)
    b = a(st:en, :);
    [m, n] = size(b);
    ave = zeros(1,n);
    for j = 1:n
        s = 0;
        cntr = 0;
        for i = 1:m
            if (isfinite(b(i,j)))
                s = s + b(i, j);
                cntr = cntr + 1;
            end
        end
        ave(j) = s / cntr;
    end
else
    b = a(:, st:en);
    [m, n] = size(b);
    ave = zeros(m,1);
    for i = 1:m
        s = 0;
        cntr = 0;
        for j = 1:n
            if (isfinite(b(i,j)))
                s = s + b(i, j);
                cntr = cntr + 1;
            end
        end
        ave(i) = s / cntr;
    end
end

% s = sum(a, dim);
% n = size(a, dim);
% ave = s/n;