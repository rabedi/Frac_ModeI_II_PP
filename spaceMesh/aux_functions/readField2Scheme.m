function [who, tempObj] = readField2Scheme(fid)
    head = '{';
    tail = '}';
    ind = -1;
    tempObj = struct('field',[],'limitIndex',[]);

    buf = READ(fid);
    if strcmp(buf,head) == 1
        who = READ(fid,'s','<>');
        
        buf = READ(fid); buf = lower(buf);
        while strcmp(buf,tail) ~= 1
            
           if strcmp(buf,'field') == 1
               tempObj.field = READ(fid,'s','{}');
           elseif strcmp(buf,'limitindex') == 1
               tempObj.limitIndex = READ(fid,'i');    
           elseif strcmp(buf,tail) ~= 1
               THROW(['ERROR:(',buf,') Block must end with "}"']);
           end   
           
           buf = READ(fid); buf = lower(buf); 
        end
    else
        THROW(['ERROR:(',buf,') Block must start with "{"']);
    end
end

