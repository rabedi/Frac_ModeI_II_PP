function [vec, noteof] = readVector(fid, columnSize, readOption)

noteof = 1;
if (readOption == 'a')
    [vec, noteof] = fscanf(fid,'%lg',columnSize);
    if (noteof == 0)
        return;
    end
else % binary
    numpts = fread(fid,1,'int');
    if (numpts ~= columnSize)
        fprintf(1, 'binary data does not have the right size');
        pause;
    end
    if (length(numpts) == 0)
        noteof = 0;
        vec = 0;
        return;
    end        
    vec = fread(fid,numpts,'double');
end
