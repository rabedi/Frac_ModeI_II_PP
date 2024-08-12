function debugJobsPrint(jobs, numAxes, axIDs)

if nargin < 1
    THROW('Insufficient number of inputs.');
end

fid = fopen(fullfile('aux_functions','jobs_debug.log'),'w');

    for i = 1:length(jobs)
        flag = '';
        if i == 1
            flag = 'SINGLE_RUN';
        elseif i == 2
            flag = 'MULTI_RUN';
        else
            THROW('Invalid index.');
        end
       fprintf(fid,'%s[%02d]:\n ID:[',flag,numAxes(i));
       for j = 1:length(axIDs{i})
           fprintf(fid,' %02d',axIDs{i}(j));
       end
       fprintf(fid,' ]\n');
       for j = 1:length(jobs{i})
           format = 'axNo.  %02d  folder  %s  suff  %s  xdata  %s  latex  %s  ydata  %s  latex  %s\n';
           fprintf(fid,format,jobs{i}{j}.axNo,...
               jobs{i}{j}.runFolder,...
               jobs{i}{j}.suffix,...
               jobs{i}{j}.xData,...
               jobs{i}{j}.xLab,...
               jobs{i}{j}.yData,...
               jobs{i}{j}.yLab);
       end
    end

fclose(fid);    
    
end