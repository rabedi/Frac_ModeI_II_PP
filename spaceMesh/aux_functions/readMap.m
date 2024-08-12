function mapObj = readMap(fid)

if fid < 1
   THROW('File not accessible to read map.'); 
end

addpath('../');
addpath('../../');

mapObj = [];%containers.Map();

buf = READ(fid,'s');
if strcmpi(buf,'{') ~= 1
   THROW('map block must begin with "{" character'); 
end

ks = [];
vs = [];

kTypeSame = 1;
vTypeSame = 1;

buf = READ(fid,'s');
while strcmpi(buf,'}') ~= 1
   keys = {{}};
   values = {{}}; 
   if strcmpi(buf,'{') == 1
       %key(s) read
       buf = READ(fid,'s');
       if strcmpi(buf,'[') == 1
           buf = READ(fid,'s');
           while strcmpi(buf,']') ~= 1
              keys = [keys,{buf}];               
              buf = READ(fid,'s');
           end
       else
           keys = [keys,{buf}];
       end
       
       %key values
       buf = READ(fid,'s');
       if strcmpi(buf,'}') == 1
           THROW('each map pair must have a valid key and value');
       else
           values = [values,{buf}];
       end
   elseif strcmpi(buf,'}') ~= 1
      ss = sprintf('buf: %s\nEach map pair must be within {} characters',buf);
      THROW(ss); 
   end
   buf = READ(fid,'s');
   
   % SORT KEYS AND VALUES;
   for i = 1:length(keys) 
       for j = 1:length(values)
           [keyOut,ksuccess]=str2num(keys(i));
           [valOut,vsuccess]=str2num(values(j));
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

