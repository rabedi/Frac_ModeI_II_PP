%function mapClr() allows acces to specific color bar 

function colorVector = mapClr(arg1,arg2) 
colorVector = [];
MAP = {'parula','jet','hsv','hot','cool',...
    'spring','summer','autumn','winter','gray',...
    'bone','copper','pink','lines','colorcube',...
    'prism','flag','white','default'};
defaultName = MAP{2};
defaultNum = 64;

if nargin < 2
    if nargin < 1
        mapName = defaultName;
        num = defaultNum;
    else
        if isnumeric(arg1)
            num = arg1;
            mapName = defaultName;
        elseif ischar(arg1)
            mapName = arg1;
            num = defaultNum;
        else
            fprintf(1,'WARNING: no instance of overloaded function for specified class :: input Type: %s\n',class(arg1));
            return;
        end
    end
else
    mapName = arg1;
    num = arg2;
end

%==========================================================================
%Exceptions
if ~ischar(mapName)
    fprintf(1,'WARNING: input colormap name is not char class :: input Type: %s\n',class(mapName));
    return;
end
if ~isnumeric(num) 
    fprintf(1,'WARNING: input number of vals for colormap is not numeric type class :: input Type: %s\n',class(num));
    return;
elseif mod(num,1)~=0
    fprintf(1,'WARNING: input number of vals for colormap is not integer :: input number: %d\n',num);
    return;
end

sz = size(num);      
if sz(1)~=sz(2) && sz(1)~=1
    fprintf(1,'WARNING: number input should be scalar\n');
    return;
end

%==========================================================================
if any( cellfun(@(s) strcmpi(s,mapName),MAP) )
    %Continue...
else
    fprintf(1,'WARNING: colormap( %s ) does not exist\n',mapName);
    return;
end

if strcmpi(mapName,'default') == 1
    mapName = defaultName;
end
mapName = lower(mapName);

%==========================================================================
if num > 1
    delh = floor(defaultNum/(num-1));
    interv = num - 1;
else
    delh = 0;
    interv = 0;
end

tmpClrs = eval([mapName,'(',num2str(defaultNum),')']);

for i = 0:1:interv
    I = (i*delh) + 1;
    if (I > defaultNum) 
        I = defaultNum; 
    end
    
    colorVector(i+1,:) = tmpClrs(I,:);
end
    
end