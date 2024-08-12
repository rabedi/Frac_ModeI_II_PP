function writeStartingPoints(fid, vec)
Vec = getNonZeroPartOfBreakingPoints(vec);
siz = length(Vec);
if (vec(33) > 0)
    fprintf(fid,'numPrimFlds1\t%d numExtFlds\t%d numIndIntFlds\t%d',  vec(30), vec(31), vec(32));
    fprintf(fid,'\tfldMult\t%d typeMult\t%d dimMult\t%d\n',  vec(33), vec(34), vec(35));
else
    fprintf(fid,'numPrimFlds\t%d numExtFlds\t%d numIndIntFlds\t%d',  vec(30), vec(31), vec(32));
    fprintf(fid,'\n');
end
    
fprintf(fid, '%d\n', siz);
fprintf(fid, '%d\t', Vec);
fprintf(fid, '\n');

