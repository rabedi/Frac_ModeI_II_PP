function folderString = getCurrentWorkingRunFolder()
    str = pwd;
    [C,~] = strsplit(str,{'\','/'});
    len = length(C);
    folderString = C{len-2};
end