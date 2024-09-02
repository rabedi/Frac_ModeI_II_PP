
fid = 1;
i = 0;
while fid > 0
name = ['loadHistories_load_', num2str(i), '.txt'];
nameOut = ['loadHistories_load_', num2str(i), '.png'];
fid = fopen(name, 'r');
    if (fid > 0)
        dat = load(name);
        %dat = load('C:\project\new_2015_07_03B\sdgfem\TestSuites\loadHistory_outVal.txt');
        time = dat(:,1);
        val = dat(:,2);
        plot(time, val);
        print('-dpng', nameOut);
    end
    i = i + 1;
end
fclose('all');