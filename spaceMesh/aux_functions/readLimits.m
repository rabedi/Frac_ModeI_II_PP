function lim = readLimits(lim, fid)
if fid < 1
   msg = sprintf('input file became accessible:fid{%i}.',fid);
   THROW(msg); 
end
if isempty(lim)
    lim = limitstruct();
end
buf = READ(fid,'s');
if strcmpi(buf,'auto') == 1
    lim = limitstruct();
elseif strcmpi(buf,'[') == 1
    bools = READ(fid,'d',2);
    buf = READ(fid,'s');
    vals = READ(fid,'d','[]');
    if length(bools) ~= length(vals)
        THROW('invalid limit specification.');
    end
    lim.active(1) = bools(1);
    lim.active(2) = bools(2);
    lim.value(1) = vals(1);
    lim.value(2) = vals(2);
end
end