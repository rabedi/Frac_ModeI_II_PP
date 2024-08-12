function Vec = getNonZeroPartOfBreakingPoints(vec)
Vec = vec;
Vec(30:length(Vec)) = 0;
[mv, nsiz] = min(Vec(2:length(Vec)) ~= 0);
nsiz = nsiz;
Vec = Vec(1:nsiz);
