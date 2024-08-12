function [lsObj, rem] = sReadLineSpec(lsObj,rem,pos)
% sReadLineSpec reads line specs from input string 'rem' starting from
% position 'pos' which contains the start of the {} enclosed specs. it then
% deletes the specs from the string bounded by the {} braces.

if nargin < 3
    pos = 1;
end
if isempty(lsObj)
    lsObj = createLineSpec();
end
if isempty(rem(pos:end))
   return 
end

II = pos;
buf = rem{II};
if strcmpi(buf,'{') == 1
    II = II + 1;
    buf = rem{II};
    while strcmpi(buf,'}') ~= 1
        if strcmpi(buf,'ls')==1
            II = II + 1;
            lsObj.ls = rem{II};
        elseif strcmpi(buf,'lc')==1
            II = II + 1;
            [lsObj.lc, rem, II] = sReadColour(rem,II);
            II = II - 1;
        elseif strcmpi(buf,'lw')==1
            II = II + 1;
            lsObj.lw = rem{II};
        elseif strcmpi(buf,'ms')==1
            II = II + 1;
            lsObj.ms = rem{II};
        elseif strcmpi(buf,'mw')==1
            II = II + 1;
            lsObj.mw = rem{II};
        elseif strcmpi(buf,'}')~=1
            msg = sprintf('invalid option {%s}',buf);
            THROW(msg);
        end
        II = II + 1;
        buf = rem{II};
    end
    
    rem(pos:II) = [];
else
    msg = sprintf('block must begin with "{" character. invalid{%s}',buf);
    THROW(msg);  
end

end