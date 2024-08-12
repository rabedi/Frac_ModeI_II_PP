function [Energy0, Energy1] = ComputeEnergyRelease(runFolder,...
                                    outputPhysicsDirectory, topLevelDirectory, processingOutput, edgeFlg)
global DEBUG_MODE;
DEBUG_MODE = 0;
          
pdext = '.pudat';

addpath('../');                               
global TOPDIR; TOPDIR = '../../'; 
DIM = 2;

DO_PLOT = 1;

if nargin < 1
    runFolder = '';
else
    runFolder = fullfile('..',runFolder);
end
if nargin < 2
    outputPhysicsDirectory = 'physics';
end
if nargin < 3
    TOPDIR = '../../';
else
    TOPDIR = topLevelDirectory;
end
if nargin < 4
   processingOutput = [runFolder,pdext];%'strain_strain_data.txt';
end
if nargin < 5
   edgeFlg = [2;3;4;5]; %bottom;right;top;left
end

if DEBUG_MODE == 1 
    TOPDIR = '';
    outputPhysicsDirectory = '';
end

front_output_dir = 'output_front';
frontFileName = 'frontSync.all';

syncFrontAllPath = fullfile(TOPDIR,runFolder,outputPhysicsDirectory);

%==============================================================
%==============================================================
strstrndir = fullfile(syncFrontAllPath,front_output_dir);
if exist(strstrndir,'dir') ~= 7
   mkdir(strstrndir); 
end
global strStrnOut;
strStrnOut = fopen(fullfile(strstrndir,processingOutput),'w');
%fprintf(strStrnOut,'# Time\tEdgeFlag\tL\tPn\tPt\tUx\tUy\t...\n');
%==============================================================
%==============================================================

if DEBUG_MODE == 0
fcSync = frontClass();
fidSync = fopen(fullfile(syncFrontAllPath,frontFileName),'r');
fcSync.readAll(fidSync);
fclose(fidSync);
numFls = fcSync.numFiles;
else
numFls = 1;
end

fprintf(1,'DATA ACQUISITION:\n');
t = datetime('now','TimeZone','local','Format','d-MMM-y HH:mm:ss Z');
fprintf(1,'START_TIME:=');
disp(t);
%fprintf(1,'\n');
fprintf(1,'PROGRESS:=[%3.0f]',0.0);
if numFls ~= 0
    
%     P = nan.*ones(DIM,numFls);
%     dU = nan.*ones(DIM,numFls);
    data = cell(numFls,1);
    
    vspecObj = Vector_syncSpec();
    for i = 1:numFls
       if DEBUG_MODE == 1
           %fcSyncFile = 'MicroSLfrontSync0000000035.txt';
           fcSyncFile = 'C:\Users\pclarke1\Desktop\PvDISPFOLDER\MicroSLfrontSync0000000035.txt';
       else
           fcSyncFile = fcSync.fronts{i}.file;
       end
       [path,name,~] = fileparts(fullfile(syncFrontAllPath,fcSyncFile));
       syncFilePath = fullfile(path,name);
       statFile = [syncFilePath, '.stat']
       fidstat = fopen(statFile, 'r');
       acceptable = 0;
       if (fidstat > 0)
            while (~feof(fidstat))
                buf = fscanf(fidstat, '%s', 1);
                if (strcmp(buf, 'statThisFrontBrief') == 1)
                    for i = 1:4
                        buf = fscanf(fidstat, '%s', 1);
                    end
                    slved = fscanf(fidstat, '%d', 1);
                    if (slved > 0)
                        acceptable = 1;
                    end
                end
            end
            fclose(fidstat);
       end
       if (acceptable == 0)
           numFls = i - 1;
           break;
       end
       %vspecObj.read(syncFilePath);
       %[P(:,i),dU(:,i)] = ComputeLoadVSDisplacement(vspecObj);
       data{i} = PvsDisp(vspecObj, syncFilePath, edgeFlg);
       %==============
       %OUTPUT
       % HARDCODED FOR NOW SINCE WE KNOW ITS 4 FLAGS (2,3,4,5)
       fprintf(strStrnOut,'%.20f\t%i\t%.20f\t%.20f\t%.20f\t%.20f\t%.20f\t%i\t%.20f\t%.20f\t%.20f\t%.20f\t%.20f\t%i\t%.20f\t%.20f\t%.20f\t%.20f\t%.20f\t%i\t%.20f\t%.20f\t%.20f\t%.20f\t%.20f\n',...
           data{i}{end}.T,...
           edgeFlg(1), data{i}{1}.L(data{i}{1}.L~=0.0), data{i}{1}.P(1), data{i}{1}.P(2), data{i}{1}.U(1), data{i}{1}.U(2),...
           edgeFlg(2), data{i}{2}.L(data{i}{2}.L~=0.0), data{i}{2}.P(1), data{i}{2}.P(2), data{i}{2}.U(1), data{i}{2}.U(2),...
           edgeFlg(3), data{i}{3}.L(data{i}{3}.L~=0.0), data{i}{3}.P(1), data{i}{3}.P(2), data{i}{3}.U(1), data{i}{3}.U(2),...
           edgeFlg(4), data{i}{4}.L(data{i}{4}.L~=0.0), data{i}{4}.P(1), data{i}{4}.P(2), data{i}{4}.U(1), data{i}{4}.U(2));
       %==============
       fprintf(1,'\b\b\b\b%3.0f]',i/numFls*100);	
    end
    fclose(strStrnOut);
    
    t = datetime('now','TimeZone','local','Format','d-MMM-y HH:mm:ss Z');
    fprintf(1,'\nEND_TIME:=');
    disp(t);
    fprintf(1,'\n');
    
    %SORTING
%     [dU(1,:),indices] = sort(dU(1,:));
%     P(1,:) = P(1,indices);
%     [dU(2,:),indices] = sort(dU(2,:));
%     P(2,:) = P(2,indices);
    
    %ENERGY OUTPUT
    Energy0 = 0.0;%trapz(dU(1,:),P(1,:));
    Energy1 = 0.0;%trapz(dU(2,:),P(2,:));
    
    %PLOTTING
    if DO_PLOT == 1
       stress_strain_curves(fullfile(strstrndir,processingOutput),1); 
    end
%     figure
%     ax = axis;
%     plot(dU(1,:),P(1,:),'-o');
%     hold on
%     plot(dU(2,:),P(2,:),'-o');
%     title('Energy Release');
%     xlabel('$\Delta U$','Interpreter','latex');
%     ylabel('$P$','Interpreter','latex');
%     str1 = ['$E_{1}=$',num2str(Energy0)];
%     str2 = ['$E_{2}=$',num2str(Energy1)];
%     legend({str1,str2},'Interpreter','latex');
else
   THROW('Sync file empty.'); 
end


end