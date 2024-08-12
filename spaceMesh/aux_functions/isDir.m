function is = isDir(folderfull)
is = 0;
if exist(folderfull,'dir')
    is = 1;
end
end