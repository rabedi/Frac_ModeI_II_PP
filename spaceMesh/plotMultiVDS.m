function plotMultiVDS( multi_file )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

clearvars -except multi_file

figureOutputDir = 'output_plots';
RUNCONFIG   = 1;
RUNDESC     = 2;
RUN_IDNUMS   = 2;

addpath('aux_functions');
addpath('../');
if nargin < 1
   THROW('File must be specified to list plotVDS configuration files.'); 
end

fid = fopen(multi_file,'r');
if fid < 1
    multi_file
   THROW(['File:={',multi_file,'} not accessible.']); 
end

jobs = {};
%tline = fgetl(fid);
buf = READ(fid,'s',1);
counter = 1;
while strcmpi(buf,'end') ~= 1
%   C = strsplit(strtrim(tline));
    C = cell(RUN_IDNUMS,1);
%   if length(C) ~= RUN_IDNUMS
%      THROW(['Each file line should only contain (',RUN_IDUMS,') entries.']); 
%   end
    jobs{counter}{1} = buf;
   for jj = 2:RUN_IDNUMS
    jobs{counter}{jj} = READ(fid,'s',1);
   end
   counter = counter + 1;
   buf = READ(fid,'s',1);
end
fclose(fid);

%OPERATE ON EACH ENTRY
for ii = 1:length(jobs)
   folderNew = [figureOutputDir, '_', jobs{ii}{RUNDESC}, '_', datestr(now,'yyyy_mm_dd')];
   plotVDS(jobs{ii}{RUNCONFIG}, folderNew);
%   dirResult = exist(figureOutputDir,'dir');
%   if dirResult ~= 7
%      THROW(['directory::{',figureOutputDir,'} does not exist.']); 
%   end
%   movefile(figureOutputDir, [datestr(now,'yyyy_mm_dd'),'_',jobs{ii}{RUNDESC}]);
end

end