function configStruct = readSyncConfigBlock( fid )

c = struct('serialNum',[],'scalingFactor',[],'plotBdry',[],...
    'keepFlgs',[],'discardFlgs',[]);

buf = READ(fid,'s');
if strcmp(buf,'{') ~= 1
    THROW('ERROR: Block must start with "{"');
else
    buf = READ(fid,'s');
    while strcmp(buf,'}') ~= 1
       
        if strcmp(buf,'serialNum') == 1
            for i = 1:3
               toss = READ(fid, 's');
               c.serialNum(i) = READ(fid, 'i'); 
            end
        elseif strcmp(buf,'scalingFactor') == 1
            c.scalingFactor = READ(fid,'d');
        elseif strcmp(buf,'plotBoundary') == 1
            c.plotBdry = READ(fid,'i');
        elseif strcmp(buf,'flagsToKeep') == 1
            c.keepFlgs = READ(fid,'i','[]');
        elseif strcmp(buf,'flagstoDiscard') == 1
            c.discardFlgs = READ(fid,'i','[]');
        elseif strcmp(buf,'}') ~= 1
            THROW(['ERROR: Invalid block option(',buf,')']);
        end
        buf = READ(fid,'s');
    end
end

configStruct = c;

end

