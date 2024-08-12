function [clr, rem, II] = sReadColour(rem, pos)
% sReadColour reads colour specs from input string 'rem' starting from
% position 'pos' which contains the start of the colour specs. it then
% deletes the colour input from the string.

if nargin < 2
    pos = 1;
end
if isempty(rem(pos:end))
   return 
end
clr = nan.*ones(1,3);
II = pos;
buf = rem{II};
if strcmpi(buf,'[') == 1
    for i = 1:3
        II = II + 1;
        [clr(i),status] = str2num(rem{II});
        if status ~= 1           
           error('%s is not a valid RGB colour value',rem{II});
        end
    end
    II = II + 1;
    if strcmpi(rem{II},']') ~= 1
       error('colour RGB input must be enclosed in []'); 
    end
elseif all(ismember(buf, '0123456789+-.eEdD')) == 1
    clr(1) = str2double(buf);
    for i = 1:2
        II = II + 1;
        [clr(i),status] = str2num(rem{II});
        if status ~= 1           
           error('%s is not a valid RGB colour value',rem{II});
        end       
    end
else
    clr = RGB(buf);
end

rem(pos:II) = [];
II = pos;

end