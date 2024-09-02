function plotStarVertex(fileName)

fid = fopen(fileName, 'r');

colors{1} = 'k';
colors{2} = 'b';
colors{3} = 'r';
buf = '';
while (strcmp(buf, 'v_id') == 0)
    buf = fscanf(fid, '%s', 1);
end
id = fscanf(fid, '%d', 1);
while (strcmp(buf, 'x') == 0)
    buf = fscanf(fid, '%s', 1);
end
p0(1) = fscanf(fid, '%g', 1);
buf = fscanf(fid, '%s', 1);
p0(2) = fscanf(fid, '%g', 1);

while (strcmp(buf, 'vertexType') == 0)
    buf = fscanf(fid, '%s', 1);
end
vt = fscanf(fid, '%d', 1);

while (strcmp(buf, '=======NodeStar') == 0)
    buf = fscanf(fid, '%s', 1);
end
num = fscanf(fid, '%d', 1);
for i = 1:num
    ids(i) = fscanf(fid, '%d', 1);
    buf = fscanf(fid, '%s', 1);
    p{i}(1) = fscanf(fid, '%g', 1);
    buf = fscanf(fid, '%s', 1);
    p{i}(2) = fscanf(fid, '%g', 1);
    buf = fscanf(fid, '%s', 3);
    vts(i) = fscanf(fid, '%d', 1);
    buf = fscanf(fid, '%s', 1);
    edgeFlag(i) = fscanf(fid, '%d', 1);
    buf = fscanf(fid, '%s', 1);
    isCoh(i) = fscanf(fid, '%d', 1);
end

for i = 1:num
    if (isCoh(i)) 
        clr = colors{3};
    elseif (edgeFlag(i) > 0)
        clr = colors{2};
    else
        clr = colors{1};
    end
    plot([p0(1) p{i}(1)], [p0(2) p{i}(2)], 'Color', clr);
    txt = [num2str(ids(i)), ',', num2str(vts(i))];
    text(p{i}(1), p{i}(2), txt);
    if (edgeFlag(i) ~= 0)
        xv = (p{i}(1) + p0(1))/2.0;
        yv = (p{i}(2) + p0(2))/2.0;
        text(xv, yv, num2str(edgeFlag(i)));
    end
    hold on;
end

text(p0(1), p0(2), num2str(id));

[pathstr,name,ext] = fileparts(fileName);

if (length(pathstr) > 0)
    pathstr = [pathstr, '/'];
end
plotName = [pathstr, name, '.png'];
print('-dpng', plotName);
close(gcf);
%fclose('all');