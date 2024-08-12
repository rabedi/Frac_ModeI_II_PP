function gen_printTab(fid, numTab)
for i = 1:numTab
    fprintf(fid, '\t');
end