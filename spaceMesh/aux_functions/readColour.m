function clr = readColour(fid)
if fid < 1
   msg = sprintf('input file became accessible:fid{%i}.',fid);
   THROW(msg); 
end
clr = [];
buf = READ(fid,'s');
if strcmpi(buf,'[')
    clr = READ(fid,'d',3);
elseif all(ismember(buf, '0123456789+-.eEdD')) == 1
    gb = READ(fid,'d',2);
    clr = [str2double(buf),gb(1),gb(2)];
else
    clr = RGB(buf);
end
end