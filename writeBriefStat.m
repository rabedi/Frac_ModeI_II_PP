function writeBriefStat(fid, minV, minCoord, min_eID, min_id, maxV, maxCoord, max_eID, max_id, counter, average, sum, sDiviation, name) 
i = 1;
numFlds = length(minV);
for i = 1:numFlds
    fprintf(fid,'%g\t',minV(i));
    fprintf(fid,'%d\t',min_eID(i));
    fprintf(fid, '%g\t', minCoord(i, :));
    fprintf(fid,'%d\t', min_id(i));
    
    fprintf(fid,'%g\t', maxV(i));
    fprintf(fid,'%d\t', max_eID(i));
    fprintf(fid, '%g\t', maxCoord(i, :));
    fprintf(fid,'%d\t',max_id(i));

    fprintf(fid,'%d\t', counter(i));
    fprintf(fid,'%g\t', average(i));
    fprintf(fid,'%g\t', sum(i));
    fprintf(fid,'%g\t', sDiviation(i));
    fprintf(fid,'%s\n', name{i});
end
