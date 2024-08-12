%function sortFileListForPostProcessing(filePath, prefix2Ignore, primary_sorters, secondary_sorters)
%
%e.g.:= sortFileListForPostProcessing('C:\Users\pclarke1\Desktop\fileForSorting.txt', {{'05','inf'},{'p16em2','p16em3'}}, {{'_x'},{'a013','a13'}});
%
function sortFileListForPostProcessing(filePath, primary_sorters, secondary_sorters)
if isempty(primary_sorters)
    error('cell array of strings need to be specified to sort file.');
end

if nargin < 3
   secondary_sorters = {}; 
end

treeStructure = fillTree(primary_sorters, secondary_sorters);

fid = fopen(filePath,'r');
if fid < 1
   error('file:=[%s] not accessible.',filePath); 
end
buf = fgetl(fid);

while ischar(buf)
    direc = buf;
%    C = strsplit(buf,{'_',prefix2Ignore});
    treeStructure = add2Tree(treeStructure, direc);
    buf = fgetl(fid);
end
fclose(fid);

%PRINT
[path,file,ext] = fileparts(filePath);
newFile = fullfile(path,[file,'_sorted',ext]);
outID = fopen(newFile,'w');
printTree(treeStructure, outID);
fclose(outID);
end

function treeStructure = printTree(treeStructure, fileID)
if ~isempty(treeStructure.data)
   for i = 1:length(treeStructure.data)
    fprintf(fileID,'%s\n', treeStructure.data{i});
   end
   fprintf(fileID,'\n');
end
if ~isempty(treeStructure.branch)
    for i = 1:length(treeStructure.branch)
        treeStructure.branch{i} = printTree(treeStructure.branch{i}, fileID);
    end
end
end

function treeStructure = fillTree(primary_sorters, secondary_sorters)
p_len = length(primary_sorters);
s_len = length(secondary_sorters);
maxii = [];
for i = 1:p_len
   maxii = [maxii,length(primary_sorters{i})]; 
end
for i = 1:s_len
   maxii = [maxii,length(secondary_sorters{i})+1]; 
end

level = length(maxii);
ii = zeros(1,level);

tree = createTreeNode('**');

[treeStructure, ii, maxii, primary_sorters, secondary_sorters] = varFor(tree, level, ii, maxii, primary_sorters, secondary_sorters);

end

function [tree, I, MaxI, primary_sorters, secondary_sorters] = varFor(tree, level, I, MaxI, primary_sorters, secondary_sorters)
if level == 0
    p_len = length(primary_sorters);
    s_len = length(secondary_sorters);
    len = p_len + s_len;
    words = {};
    for i = 1:len
        j = I(i);
        word = '*';
        if i <= p_len
            word = primary_sorters{i}{j};
        elseif j <= length(secondary_sorters{i - p_len})
            word = secondary_sorters{i - p_len}{j};
        end 
        words = [words,word]; 
    end
    tree = defineFullPath(tree, words);
else
   for temp_i = 1 : MaxI(level)
       I(level) = temp_i;
       [tree, I, MaxI, primary_sorters, secondary_sorters] = varFor(tree, level - 1, I, MaxI, primary_sorters, secondary_sorters);
   end
end
end

function tree = defineFullPath(tree, data)
level = length(data);
[tree, ~] = TreeTraverseBranchSet(tree, level, data);
end

function [treeNode, data] = TreeTraverseBranchSet(treeNode, level, data)
if level > 0
   i = length(data) - level + 1;
   try
   found = find(cellfun(@(x) strcmp(data{i},x.base{1})==1,treeNode.branch,'UniformOutput',true));
   catch e
      disp(e); 
   end
   if ~isempty(found)
       pos = found;
   else
       pos = length(treeNode.branch) + 1;
       treeNode.branch{pos} = createTreeNode(data{i});
   end
   [treeNode.branch{pos}, data] = TreeTraverseBranchSet(treeNode.branch{pos}, level-1, data);
else
    return;
end
end

function treeStructure = add2Tree(treeStructure, directoryPath)
[treeStructure, ~] = TreeTraverseNodeSet(treeStructure, directoryPath);
end

function [treeNode, fullName] = TreeTraverseNodeSet(treeNode, fullName)
found = find(cellfun(@(x) ~isempty(strfind(fullName, x.base{1})),treeNode.branch,'UniformOutput',true));
foundSecondary = find(cellfun(@(x) strcmp('*', x.base{1})==1,treeNode.branch,'UniformOutput',true));
if ~isempty(found)
   pos = found;
elseif ~isempty(foundSecondary)
   pos = foundSecondary;
else
   pos = -1;
end
if pos == -1
   if strcmp(treeNode.base{1},'**') == 1
       disp('STOP');
   end
   treeNode.data = [treeNode.data,fullName];
else
   [treeNode.branch{pos}, fullName] = TreeTraverseNodeSet(treeNode.branch{pos}, fullName); 
end

return;
end

function treeNode = createTreeNode(baseContent)
treeNode = struct('base',{{baseContent}},'branch',{{}},... // if branch is empty then data is set
    'data',{{}});
end

