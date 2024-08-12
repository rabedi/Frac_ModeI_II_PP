function nrm = gen_matNorm(mat)
[r, c] = size(mat);
if (sum(isnan(mat)) > 0)
    nrm = nan;
    return;
end
[vec, lam] = eig(mat);
nrm = max(abs(lam(1, 1)), abs(lam(r, r)));
end