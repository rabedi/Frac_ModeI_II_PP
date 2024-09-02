function plotStar()

%fileName = ['star', num2str(counter), '_', num2str(vs(I)), '.txt'];
fileName = 'star.txt';
        fid = fopen(fileName, 'r');

colors{1} = 'b';
colors{2} = 'r';
for I = 0:6
    counter = fscanf(fid, '%d', 1);
    for I = 1:2
        buf = fscanf(fid, '%s', 1);
        id = fscanf(fid, '%d', 1);

        buf = fscanf(fid, '%s', 1);
        p0(1) = fscanf(fid, '%g', 1);
        buf = fscanf(fid, '%s', 1);
        p0(2) = fscanf(fid, '%g', 1);
        buf = fscanf(fid, '%s', 2);

        num = fscanf(fid, '%d', 1);
        for i = 1:num
            ids(i) = fscanf(fid, '%d', 1);
            buf = fscanf(fid, '%s', 1);
            p{i}(1) = fscanf(fid, '%g', 1);
            buf = fscanf(fid, '%s', 1);
            p{i}(2) = fscanf(fid, '%g', 1);
            buf = fscanf(fid, '%s', 2);
        end

        for i = 1:num
            plot([p0(1) p{i}(1)], [p0(2) p{i}(2)], 'Color', colors{I});
            text(p{i}(1), p{i}(2), num2str(ids(i)));
            hold on;
        end

        text(p0(1), p0(2), num2str(id));
    end
    %[pathstr,name,ext] = fileparts(fileName);
    plotName = ['star', num2str(counter), '.png'];
    print('-dpng', plotName);
    close(gcf);
end