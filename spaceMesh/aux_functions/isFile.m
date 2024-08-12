function is = isFile(filefull)
is = 0;
if exist(filefull,'file')
    is = 1;
end
end