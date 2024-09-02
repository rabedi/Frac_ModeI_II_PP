function plotStarVertices(vertex, root)
if nargin < 2
    root = 'C:/project/old_2015_07_02DBRock/physics/';
end

n = length(root);
if (n > 0)
    if (root(n) ~= '/')
        root = [root, '/'];
    end
end

logName = [root, '__acpLog__sv_', num2str(vertex), '.txt'];
fid = fopen(logName);
[name, eof] = fscanf(fid, '%s', 1);
while (eof ~= 0)
    vertexFileName = [root, name];
    plotStarVertex(vertexFileName);
    [name, eof] = fscanf(fid, '%s', 1);
end

fclose 'all';
