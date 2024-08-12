function [data, noteof, doPlot] = readSpaceMeshBlock(fid)
global numflds

global configGen;
global s_b_xlim;
global s_xmin_all;
global s_xmax_all;
global s_b_ylim;
global s_ymin_all;
global s_ymax_all;

global d_id;
global d_adp;
global d_angleMark;
global d_faceMark;

global d_vid;
global d_vNonCollinearCoarsenable;
global d_vDirGiven;

global d_crd;
global d_edgef;

global d_numInflowE;
global d_inflowData;

    global d_infd_id;
	global d_infd_face;
	global d_infd_numEdge;
	global d_infd_edgeData;
        global difnd_edgeIndex;
        global difnd_numInfCracks;
        global difnd_InfCracksData;

           	global 	nbhd_ind;
           	global 	nbhd_limT;
           	global 	nbhd_startP;
           	global 	nbhd_endP;
           	global 	nbhd_numP;

                global pt_dataCrd;
                global pt_dataDamage;
                global pt_dataVector;
      
                pt_dataVector = pt_dataDamage;
                

noteof = 1;
[tmp, noteof] = fscanf(fid,'%s', 1);
if (noteof == 0)
    doPlot = 0;
    data = cell(0);
    return;
end

b_xlim = configGen{s_b_xlim};
b_ylim = configGen{s_b_ylim};

doPlot = 1;
if (b_xlim == 1)
    doPlot = 0;
    xmin = configGen{s_xmin_all};
    xmax = configGen{s_xmax_all};
end
if (b_ylim == 1)
    doPlot = 0;
    ymin = configGen{s_ymin_all};
    ymax = configGen{s_ymax_all};
end


data{d_id} = fscanf(fid, '%d', 1);

tmp = fscanf(fid,'%s', 1);
data{d_adp} = fscanf(fid, '%d', 1);

tmp = fscanf(fid,'%s', 1);
data{d_angleMark} = fscanf(fid, '%d', 1);

tmp = fscanf(fid,'%s', 1);
data{d_faceMark} = fscanf(fid, '%d', 1);

tmp = fscanf(fid,'%s', 1);
data{d_vid} = fscanf(fid, '%d', 3);

tmp = fscanf(fid,'%s', 1);
data{d_vNonCollinearCoarsenable} = fscanf(fid, '%d', 3);

tmp = fscanf(fid,'%s', 1);
data{d_vDirGiven} = fscanf(fid, '%d', 3);


tmp = fscanf(fid,'%s', 1);
data{d_crd} = fscanf(fid, '%lg', [3 3]); % first num col, second number of rows
data{d_crd} = data{d_crd}';

% id = data{d_id};
% if ((id == 46301) || (id == 45402) || (id == 61673) || (id == 62547) || (id == 48556) )
%     id
%     crds = data{d_crd}
% end
%     

if (doPlot == 0)
    mins = min(data{d_crd});
    maxs = max(data{d_crd});
    if (b_xlim == 1)
        if (((mins(1) <= xmax) && (maxs(1) >= xmin)))
            doPlot = 1;
        end
    end
    if ((b_ylim == 1) && (doPlot == 0))
        if (((mins(2) <= ymax) && (maxs(2) >= ymin)))
            doPlot = 1;
        end
    end
end   

try
    data{d_crd}(4,:) = data{d_crd}(1,:);
catch
    disp('Exception caught');
end

tmp = fscanf(fid,'%s', 1);
data{d_edgef} = fscanf(fid, '%d', 3);

tmp = fscanf(fid,'%s', 1);
data{d_numInflowE} = fscanf(fid,'%d', 1);


for infE = 1:data{d_numInflowE}
    tmp = fscanf(fid,'%s', 1);
    data{d_inflowData}{infE}{d_infd_id} = fscanf(fid, '%d', 1);
    tmp = fscanf(fid,'%s', 1);
    data{d_inflowData}{infE}{d_infd_face} = fscanf(fid, '%d', 1);
    tmp = fscanf(fid,'%s', 1);
    data{d_inflowData}{infE}{d_infd_numEdge} = fscanf(fid, '%d', 1);

    for edge = 1:data{d_inflowData}{infE}{d_infd_numEdge}
        tmp = fscanf(fid,'%s', 1);
        data{d_inflowData}{infE}{d_infd_edgeData}{difnd_edgeIndex}{edge} = fscanf(fid, '%d', 1);
        tmp = fscanf(fid,'%s', 1);
        data{d_inflowData}{infE}{d_infd_edgeData}{difnd_numInfCracks}{edge} = fscanf(fid, '%d', 1);
        
        for ic = 1:data{d_inflowData}{infE}{d_infd_edgeData}{difnd_numInfCracks}{edge}  %ic inflow crack
            tmp = fscanf(fid,'%s', 1);
            tmp_nbhd_ind = fscanf(fid, '%d', 1);
            tmp = fscanf(fid,'%s', 1);
            tmp_nbhd_limT = fscanf(fid, '%d', 1);

            tmp = fscanf(fid,'%s', 1);
            startP = fscanf(fid, '%lg', 3);
            tmp = fscanf(fid,'%s', 1);
            endP = fscanf(fid, '%lg', 3);
            
            tmp = fscanf(fid,'%s', 1);
            numP = fscanf(fid, '%d', 1);
            if (numP == 0)
                data{d_inflowData}{infE}{d_infd_edgeData}{difnd_numInfCracks}{edge} = 0;
                break;
            end
            
            data{d_inflowData}{infE}{d_infd_edgeData}{difnd_InfCracksData}{edge}{nbhd_ind}{ic} = tmp_nbhd_ind;
            data{d_inflowData}{infE}{d_infd_edgeData}{difnd_InfCracksData}{edge}{nbhd_limT}{ic} = tmp_nbhd_limT;

            data{d_inflowData}{infE}{d_infd_edgeData}{difnd_InfCracksData}{edge}{nbhd_startP}{ic} = startP;
            data{d_inflowData}{infE}{d_infd_edgeData}{difnd_InfCracksData}{edge}{nbhd_endP}{ic} = endP;
            data{d_inflowData}{infE}{d_infd_edgeData}{difnd_InfCracksData}{edge}{nbhd_numP}{ic} = numP;  

            data{d_inflowData}{infE}{d_infd_edgeData}{difnd_InfCracksData}{edge}{pt_dataCrd}{ic} = zeros(numP, 3); 
%            celldisp(data{d_inflowData}{infE}{d_infd_edgeData}{difnd_InfCracksData}{edge}{pt_dataCrd});
            
            data{d_inflowData}{infE}{d_infd_edgeData}{difnd_InfCracksData}{edge}{pt_dataVector}{ic} = zeros(numP,numflds);
%            celldisp(data{d_inflowData}{infE}{d_infd_edgeData}{difnd_InfCracksData}{edge}{pt_dataVector});
            
            for p = 1:numP
                bary = fscanf(fid, '%lg', 1);
                crd_ = bary * endP + (1 - bary) * startP;
                data{d_inflowData}{infE}{d_infd_edgeData}{difnd_InfCracksData}{edge}{pt_dataCrd}{ic}(p, :) = crd_';  
               
               % instead of reading 1 value by fscanf(fid, '%lg', 1); 
               % you read 17 values (in general this value should be taken
               % from *.stat file)
%                tmp =  fscanf(fid, '%lg', 18);
%                if (length(tmp) ~= 18)
%                    length(tmp)
%                    pause;
%                end
%                data{d_inflowData}{infE}{d_infd_edgeData}{difnd_InfCracksData}{edge}{pt_dataDamage}{ic}(p) = tmp(1);    
               for f = 1:numflds
               data{d_inflowData}{infE}{d_infd_edgeData}{difnd_InfCracksData}{edge}{pt_dataVector}{ic}(p,f) = fscanf(fid, '%lg', 1); 
               end
            end
        end
    end
end
