function [vpsObj,data] =  readStatFile(fid,vpsObjIn)
noteof = 1;
vpsObj = [];
data = [];

[tmp, noteof] = fscanf(fid,'%s', 1);
if (noteof == 0)
    %...do something
    return;
end

%version value
ver = fscanf(fid,'%d', 1);
numFields = fscanf(fid,'%*s %i', 1);

if nargin < 2
    vpsObj = Vector_pSpec(numFields);
else
    vpsObj = vpsObjIn;
    vpsObj.resize(numFields);
end

vpsObj.setVersion(ver);

for fld = 0:vpsObj.numFields - 1
    ind = fscanf(fid,'%i', 1);
    fld = fscanf(fid,'%s', 1);
    
    vpsObj.readName(fld,ind);
end
% read supplementary data
data = struct('crackSizeAdded2PtData', 0,...
    'crackSizeAdded2Stat',	0,...	
    'timeMin',              inf,...	
    'timeMax',              -inf,...	
    'numNewCrack',          0,...	
    'crackNewLength',       0.0,...	
    'numAllCrack',          0,...		
    'crackAllLength',       0.0);

buf = READ(fid,'s');
data.crackSizeAdded2PtData = READ(fid,'i');
buf = READ(fid,'s');
data.crackSizeAdded2Stat = READ(fid,'i');
buf = READ(fid,'s');
data.timeMin = READ(fid,'d');
buf = READ(fid,'s');
data.timeMax = READ(fid,'d');
buf = READ(fid,'s');
data.numNewCrack = READ(fid,'i');
buf = READ(fid,'s');
data.crackNewLength = READ(fid,'d');
buf = READ(fid,'s');
data.numAllCrack = READ(fid,'i');
buf = READ(fid,'s');
data.crackAllLength = READ(fid,'i');

 return;
end