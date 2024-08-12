function plotDisjointSetStatistics(varargin)

close all;

addpath('../');                               
global TOPDIR; TOPDIR = '../../'; 


serialNumbers = [0 1 0];   
fileNameBase = 'ds';   
outputPhysicsDirectory = 'physics/output_disjointSet/';   
runFolder = '';   


N = nargin;
if mod(N,2)~=0
   THROW('insufficent number of input, must be flag-option pair.'); 
end

i = 1;
while(i <= N)
   if strcmpi(varargin{i},'-f')==1
       i = i + 1;
       runFolder = fullfile('..',varargin{i});
   elseif strcmpi(varargin{i},'-d')==1
       i = i + 1;
       outputPhysicsDirectory = varargin{i};
   elseif strcmpi(varargin{i},'-sn')==1
       i = i + 1;
       serialNumbers = varargin{i};
   elseif strcmpi(varargin{i},'-bn')==1
       i = i + 1;
       fileNameBase = varargin{i};
   else
       THROW('Invalid Option');
   end
   i = i + 1;
end

if length(serialNumbers) ~= 3
   THROW('Serial name must be vector of size 3; i.e. [serialStart serialIncrement serialEnd].'); 
end

X = {};

count = 0;
for i = serialNumbers(1):serialNumbers(2):serialNumbers(3)
   filePathBase = fullfile(TOPDIR,runFolder,outputPhysicsDirectory,[fileNameBase,sprintf('%010d',i)]); 
    
   refs = readReferencedFile([filePathBase,'.refs']); 
   
   if isempty(X)
       X = cell(length(refs),1); 
        for j = 1:length(refs)
            X{j} = struct('refID',-1,'set',-1,'x',[],'n',[],'L',[]);   
        end
   end
   count = count + 1;   
   for j = 1:length(refs)
       if i ~= serialNumbers(1)
            index = findID(X,refs{j}.refID);
                        
            indepVar = count;
            X{index}.x = [X{index}.x, indepVar];
            X{index}.n = [X{index}.n, refs{j}.n];
            X{index}.L = [X{index}.L, refs{j}.L];
       else
           
            indepVar = count;
            X{j} = struct('refID',refs{j}.refID,'set',refs{j}.set,'x',[indepVar],'n',[refs{j}.n],'L',[refs{j}.L]); 
       end
   end
end


%PLOTTING
fig = figure;
ax = axis;
hold on;
title('Total Crack Length','Interpreter','latex')
xlabel('time, $t$','Interpreter','latex')
ylabel('length, $L$','Interpreter','latex')
leg = cell(length(refs),1);
for j = 1:length(refs)   
    [X{j}.x,indices] = sort(X{j}.x);
    X{j}.n = X{j}.n(indices);
    X{j}.L = X{j}.L(indices);  
    
    plot(X{j}.x,X{j}.L,'-','LineWidth',2.0);
    leg{j} = ['$ID_{ref}$: ',num2str(X{j}.refID)];
end
legend(leg,'Interpreter','latex');
end


%AUX FUNCTION
function referencedDisjointSetStruct = readReferencedFile(refFileName)
    fid = fopen(refFileName,'r');
    if fid < 1
        str = ['File:[',refFileName,'] not accessible for read'];
        THROW(str);
    end
        
    buf = READ(fid,'s');
    numSets = READ(fid,'i');
    
    referencedDisjointSetStruct = cell(1,numSets);
    
    for i = 1:numSets
        allDisjointSetStruct{i} = struct('refID',-1,'set',-1,'n',0,'L',0.0);
        
        buf = READ(fid,'s');
        referencedDisjointSetStruct{i}.refID = READ(fid,'i');
        buf = READ(fid,'s');
        referencedDisjointSetStruct{i}.set = READ(fid,'i');
        buf = READ(fid,'s');
        referencedDisjointSetStruct{i}.n = READ(fid,'i');
        buf = READ(fid,'s');
        referencedDisjointSetStruct{i}.L = READ(fid,'d');
    end
    
    fclose(fid);
end

function allDisjointSetStruct = readAllFile(allFileName)
    fid = fopen(allFileName,'r');
    if fid < 1
        str = ['File:[',allFileName,'] not accessible for read'];
        THROW(str);
    end
        
    buf = READ(fid,'s');
    numSets = READ(fid,'i');
    
    allDisjointSetStruct = cell(1,numSets);
    for i = 1:numSets
        allDisjointSetStruct{i} = struct('set',-1,'n',0,'L',0.0);
        
        buf = READ(fid,'s');
        allDisjointSetStruct{i}.set = READ(fid,'i');
        buf = READ(fid,'s');
        allDisjointSetStruct{i}.n = READ(fid,'i');
        buf = READ(fid,'s');
        allDisjointSetStruct{i}.L = READ(fid,'d');
    end
    
    fclose(fid);
end

function index = findDS(allDisjointSetStruct,groupdSET)
    success = 0;
      
    found = cellfun(@(x) groupdSET == x.set, allDisjointSetStruct, 'UniformOutput', false);
    index = find(cellfun(@(x) x==1,found));
end

function index = findID(allDisjointSetStruct,ID)
    success = 0;
    
    found = cellfun(@(x) ID == x.refID, allDisjointSetStruct, 'UniformOutput', false);
    index = find(cellfun(@(x) x==1,found)); 
end