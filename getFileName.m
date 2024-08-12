function filename = getFileName(directory, runname, middlename, flagnum, name, serial, ext)
if (directory(length(directory)) ~= '/')
    rootname = sprintf('%s/', directory);
else
    rootname = directory;
end
if (strcmp(directory, '') == 1)
    rootname = '';
end


if (serial > 0)
    if (flagnum >= 0)
        filename = sprintf('%s%s%s%s%05d_%05d.%s',rootname, runname, middlename, name, flagnum, serial, ext);
    else
        filename = sprintf('%s%s%s%s%05d.%s',rootname, runname, middlename, name, serial,ext );
    end
else
    if (flagnum >= 0)
        filename = sprintf('%s%s%s%s%05d.%s',rootname, runname, middlename, name, flagnum, ext);
    else
        filename = sprintf('%s%s%s%s.%s',rootname, runname, middlename, name, ext);
    end
end    



% if (serial > 0)
%     if (flagnum >= 0)
%         filename = sprintf('%s%s%s%s%03d_%04d.%s',rootname, runname, middlename, name, flagnum, serial, ext);
%     else
%         filename = sprintf('%s%s%s%s%04d.%s',rootname, runname, middlename, name, serial,ext );
%     end
% else
%     if (flagnum >= 0)
%         filename = sprintf('%s%s%s%s%03d.%s',rootname, runname, middlename, name, flagnum, ext);
%     else
%         filename = sprintf('%s%s%s%s.%s',rootname, runname, middlename, name, ext);
%     end
% end    
