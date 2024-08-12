function isEmpty = isDirEmpty(folderfull)
isEmpty = 1;
if isDir(folderfull)
    foldercontent = dir(folderfull);
    if numel(foldercontent) > 2
        isEmpty = 0;
    end
end
end