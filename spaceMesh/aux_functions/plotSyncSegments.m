function plotSyncSegments()%( fileNameWOExt )
fileNameWOExt = ['C:\Users\pjclarke4\Dropbox\ACTIVE RESEARCH\projects\DAMAGE MODEL IMPLEMENTATION\',...
    'SpaceMesh\old_2016_04_06MATLABTOOLDEBUG\physics\output_front\HFWellSLfrontSync0000000050'];

args = struct('scalingFactor',[],'plotBdry',[],'keepFlgs',[],'discardFlgs',[]);
args.scalingFactor = 100;
args.plotBdry = 0;

%spaceMesh
MAINFILE_operatorSpaceMesh('-both ConfigPhilipDebug.txt');

%
vssObj = Vector_syncSpec();
vssObj.read(fileNameWOExt);
%general plotting
[X,Y] = packageForDeform(vssObj,args);

close all;
plot(X',Y','Color','k');
axis equal;

%end plot
end

