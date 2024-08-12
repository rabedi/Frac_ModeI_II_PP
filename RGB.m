%EXTERNAL AUX FUNCTIONS TO TRANSFORM COLOR DEFINITION TO RGB ARRAY
function rgbArray = RGB(str)
rgbArray = [];

if(isnumeric(str))
    rgbArray = str;
    return;
end

str = char(str);
str = lower(str);

if(length(str)>1)
    if (strcmp(str,'black') == 1)
        str = 'k';
    else
        str = str(1);
    end
end

if ~isempty(floor((strfind('kbgcrmyw', str) - 1)))
rgbArray = rem(floor((strfind('kbgcrmyw', str) - 1) .* [0.25 0.5 1]), 2);
end

end

