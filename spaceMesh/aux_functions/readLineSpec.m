function lsObj = readLineSpec(lsObj,fid)
if fid < 1
   msg = sprintf('input file became accessible:fid{%i}.',fid);
   THROW(msg); 
end
if isempty(lsObj)
    lsObj = createLineSpec();
end
buf = READ(fid,'s');
if strcmpi(buf,'{') == 1
    buf = READ(fid,'s');
    while strcmpi(buf,'}') ~= 1
        if strcmpi(buf,'ls')==1
            lsObj.ls = READ(fid,'s');
        elseif strcmpi(buf,'lc')==1
            lsObj.lc = readColour(fid);
        elseif strcmpi(buf,'lw')==1
            lsObj.lw = READ(fid,'d');
        elseif strcmpi(buf,'ms')==1
            lsObj.ms = READ(fid,'s');
        elseif strcmpi(buf,'mw')==1
            lsObj.mw = READ(fid,'d');
        elseif strcmpi(buf,'}')~=1
            msg = sprintf('invalid option {%s}',buf);
            THROW(msg);
        end
        buf = READ(fid,'s');
    end
else
    msg = sprintf('block must begin with "{" character. invalid{%s}',buf);
    THROW(msg);  
end
end