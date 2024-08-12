function mapObj = readMapStr(parsed_str)

addpath('../');
addpath('../../');

mapObj = [];%containers.Map();

len = length(parsed_str);
if len == 2
   THROW('Cannot define empty map.\n');
end
if strcmpi(parsed_str{1},'{') ~= 1 || strcmpi(parsed_str{len},'}') ~= 1
   THROW('map block must be enclosed by "{ }" characters.\n'); 
end

ks = [];
vs = [];

kTypeSame = 1;
vTypeSame = 1;

keys = {{}};
values = {{}}; 

parsed_str([1 len]) = [];
len = length(parsed_str);

pos = 0;
bracI = pos + 1;
ketI = bracI;
while pos < len    
    
    if strcmpi(parsed_str{bracI},'{') ~= 1
       THROW('map type block must begin with "{" character\n.');
    end

    closed = 0;
    for jj = bracI:length(parsed_str)
       pos = pos + 1;
       if strcmpi(parsed_str{jj},'{') == 1
           closed = closed + 1;
       elseif strcmpi(parsed_str{jj},'}') == 1
           closed = closed - 1;
       end
       if jj == length(parsed_str) && closed ~= 0
          THROW('map type block must end with "}" character\n.'); 
       elseif closed == 0                           
          ketI = jj;
          break;
       end       
    end       

    if strcmp(parsed_str{bracI+1},'[') == 1
        if strcmp(parsed_str{ketI-2},']') ~= 1
            THROW('Invalid map input, cannot have more than one value in each map pair.\n');
        end
        keys = parsed_str(bracI+2:ketI-3);
        values{1} = parsed_str{ketI-1};
    elseif ketI - bracI - 1 == 2
        keys{1} = parsed_str{bracI + 1};
        values{1} = parsed_str{ketI - 1};
    else
        THROW('Invalid key:value pair');
    end
    
    bracI = pos + 1;
    ketI = bracI;

    % SORT KEYS AND VALUES;
    for i = 1:length(keys) 
       for j = 1:length(values)
           [keyOut,ksuccess]=str2num(keys{i});
           [valOut,vsuccess]=str2num(values{j});
           if ksuccess ~= 1
              keyOut = keys(i); 
           end
           if vsuccess ~= 1
              valOut = values(j); 
           end
           if isempty(mapObj)
              mapObj = containers.Map(keyOut,valOut);
           else
               mapObj(keyOut) = valOut;
           end
       end
    end
end


end

