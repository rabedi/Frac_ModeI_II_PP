function  [style, color, marker] = gRegLineStyleBlack(n)
 

%   plotConfigFilesScriptCZDissAdapt
lineCell = {'-.' [0 0 0]  'none';
            '-' [0 0 0]  'none';
            '-' [0.6 0.6 0.6]  'none';
            '-' [0.3 0.3 0.3]  'none';
            '-' [0 0 0]  'none';
            '--' [0 0 0]  'd';
            ':' [0 0 0]  'd';
            '-.' [0 0 0]  'd'};            
%   plotConfigFilesScriptCZCohAdapt
% lineCell = {'-' [0.6 0.6 0.6]  'none';
%             '--' [0.4 0.4 0.4]  'none';
%             '-' [0 0 0]  'none';
%             '-.' [0 0 0]  'none';
%             '-' [0 0 0]  'none';
%             '--' [0 0 0]  'd';
%             ':' [0 0 0]  'd';
%             '-.' [0 0 0]  'd'};            
%   plotConfigFilesScriptCZCohAdaptDsDtImp
% lineCell = {            '-' [0 0 0]  'none';
%             '-' [0.6 0.6 0.6]  'none';
%             '--' [0.3 0.3 0.3]  'none';
%             '-.' [0 0 0]  'none';
%             '-' [0 0 0]  'none';
%             '--' [0 0 0]  'd';
%             ':' [0 0 0]  'd';
%             '-.' [0 0 0]  'd'};            


% lineCell = {'-' [0 0 0]  'none';
%             '--' [0 0 0]  'none';
%             ':' [0 0 0]  'none';
%             '-.' [0 0 0]  'none';
%             '-' [0 0 0]  'd';
%             '--' [0 0 0]  'd';
%             ':' [0 0 0]  'd';
%             '-.' [0 0 0]  'd'};            

    style = lineCell{n,1};
    color = lineCell{n,2};
    marker = lineCell{n,3};

