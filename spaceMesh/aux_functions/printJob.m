function printJob(job)
fprintf(1,'axes number:  %d\n',job.axNo);
fprintf(1,'x data:  %s\n',job.xData);
fprintf(1,'y data:  %s\n',job.yData);
if ~isempty(job.zData)
    fprintf(1,'z data:  %s\n',job.zData);
else
    fprintf(1,'z data: \n');
end
fprintf(1,'x label:  %s\n',job.xLab);
fprintf(1,'y label:  %s\n',job.yLab);
if ~isempty(job.zLab)
    fprintf(1,'z label:  %s\n',job.zLab);
else
    fprintf(1,'z label: \n');
end
fprintf(1,'runfolder:  %s\n',job.runFolder);
fprintf(1,'vdata suffix:  %s\n',job.suffix);
end