function gen_toFile_vecString(fido, str)
m = length(str);
if (m == 1) 
    fprintf(fido, '%s\t', str{1});
    return;
end
if (m == 0)
    fprintf(fido, 'null\t');
    return;
end
fprintf(fido, '[ ( %d )', m);
for i = 1:m
    fprintf(fido, '\t%s', str{i});
end
fprintf(fido, ' ]\t\n');
