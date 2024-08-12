function confGen = readSpaceMeshConfigFile(opt, configName, modifyInput)

global configSync;

global s_serialStart;
global s_serialStep;
global s_serialEnd;
global s_dirPreName;
global s_dirRunName;
global s_runNameAppendix;
global s_dirPostName;
global s_dir;
global s_dirOut;
global s_runName;
global s_middlename;
global s_midNData;
global s_printOption;
global s_printOptionExt;
global s_doPrintEPS;
global s_b_xlim;
global s_xmin_all;
global s_xmax_all;
global s_b_ylim;
global s_ymin_all;
global s_ymax_all;
global enforceLimitsWithxlim_ylim;

global I_numberDistDPts;
global I_DistDPts;
global g_pltDmgdUnDmaged;
global g_plotAxis;

global I_includeRefineInLegend;
global I_includeLegend; 
global I_includeColorbar;
global I_elementEdgeColor;
global I_elementEdgeWidth;
global I_legendLocation;

global I_damageLevelsFlag;
global I_includeRefinementClrs;

global g_clr_none;
global g_clr_refine;
global g_clr_coarsen;

global g_plt_vids;
global g_vids_fnt_sz;
global g_plt_noncollinearCoarsenable;
global g_noncollinearCoarsenable_symbl;
global g_noncollinearCoarsenable_clr;
global g_noncollinearCoarsenable_sz;

global g_plotMeshCoh;
global g_MeshCohLineColor;
global g_MeshCohLineStyle;
global g_MeshCohLineWidth;

global g_plot_spaceElement;
global g_spaceElement_font_size;
global g_spaceElement_text_color;

global g_box_xys;
global g_box_line_width;
global g_box_line_color;

global idam_level;
global id_clr;
global id_lstyle;
global id_lwdth;

global MAX_T;
global MIN_T;
global N_MAX_MIN;
global N_DECIDED;

global NONE;
global REFINE;
global COARSEN;

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

global vpsObj;
global vssObj;

setGlobalSpaceMesh();
fid = fopen(configName, 'r');
if (fid < 0)
    fprintf(1, 'Cannot open file %s\t', configName);
    pause;
end

tmp = READ(fid,'s',2);
confGen{s_serialStart} = READ(fid,'d');
tmp = READ(fid,'s');
confGen{s_serialStep} = READ(fid,'d');
tmp = READ(fid,'s');
confGen{s_serialEnd} = READ(fid,'d');
if (confGen{s_serialEnd} == -1)
    confGen{s_serialEnd} = confGen{s_serialStart};
end

tmp = READ(fid,'s');
tmp = READ(fid,'s');
if (strcmp(tmp, 'NULL') == 1)
    confGen{s_dirPreName} = '';
else
    confGen{s_dirPreName} = tmp;
end

tmp = READ(fid,'s');
tmp = READ(fid,'s');
if (strcmp(tmp, 'NULL') == 1)
    confGen{s_dirRunName} = '';
else
    confGen{s_dirRunName} = tmp;
end

tmp = READ(fid,'s');
tmp = READ(fid,'s');
if (strcmp(tmp, 'NULL') == 1)
    confGen{s_runNameAppendix} = '';
else
    confGen{s_runNameAppendix} = tmp;
end


tmp = READ(fid,'s');
tmp = READ(fid,'s');
if (strcmp(tmp, 'NULL') == 1)
    confGen{s_dirPostName} = '';
else
    confGen{s_dirPostName} = tmp;
end

confGen{s_dir} = [confGen{s_dirPreName} confGen{s_dirRunName} confGen{s_dirPostName}];
if (strcmp(confGen{s_dir}, '') == 0)
    confGen{s_dir} = [confGen{s_dir}, '/'];
end


tmp = READ(fid,'s');
confGen{s_dirOut} = READ(fid,'s');

tmp = READ(fid,'s');
confGen{s_runName} = READ(fid,'s');

confGen{s_middlename} = 'SL';

if (strcmp(confGen{s_dirOut}, 'runFolder') == 1)
    confGen{s_dirOut} = [confGen{s_runName}, '_', confGen{s_dirRunName}];
end


if (modifyInput == 0)
    if (strcmp(confGen{s_dirOut}, '') ~= 1)
        b_dir = isdir(confGen{s_dirOut});
        if (b_dir == 1)
        %    rmdir(confGen{s_dirOut},'s');
        else
            mkdir(confGen{s_dirOut});
        end
        confGen{s_dirOut} = [confGen{s_dirOut}, '/'];
    end
end


tmp = READ(fid,'s');
confGen{s_midNData} = READ(fid,'s');


tmp = READ(fid,'s');
confGen{s_printOptionExt} = READ(fid,'s');


confGen{s_printOption} = ['-d', confGen{s_printOptionExt}];
if (strcmp(confGen{s_printOptionExt}, 'epsc') == 1)
    confGen{s_printOptionExt} = 'eps';
end

tmp = READ(fid,'s');
confGen{s_doPrintEPS} = READ(fid,'s');



tmp = READ(fid,'s');
confGen{s_b_xlim} = READ(fid,'d');
tmp = READ(fid,'s');
confGen{s_xmin_all} = READ(fid,'lg');
tmp = READ(fid,'s');
confGen{s_xmax_all} = READ(fid,'lg');
tmp = READ(fid,'s');
confGen{s_b_ylim} = READ(fid,'d');
tmp = READ(fid,'s');
confGen{s_ymin_all} = READ(fid,'lg');
tmp = READ(fid,'s');
confGen{s_ymax_all} = READ(fid,'lg');

tmp = READ(fid,'s');
confGen{enforceLimitsWithxlim_ylim} = READ(fid,'d');


tmp = READ(fid,'s');
confGen{g_plotAxis} = READ(fid,'d');



stmp = READ(fid,'s');
confGen{I_includeRefineInLegend} = READ(fid,'d');
stmp = READ(fid,'s');
confGen{I_includeLegend} = READ(fid,'d');
stmp = READ(fid,'s');
confGen{I_includeColorbar} = READ(fid,'d');
stmp = READ(fid,'s');
confGen{I_elementEdgeColor} = readClr(fid);
stmp = READ(fid,'s');
confGen{I_elementEdgeWidth} = READ(fid,'d');
stmp = READ(fid,'s');
confGen{I_legendLocation} = READ(fid,'s');

%Sync configuration block..................................................
configSync = readSyncConfigBlock(fid);
%..........................................................................
b1 = '<';
b2 = '>';

stmp = READ(fid,'s');
buf = READ(fid,'s');
if strcmp(buf,b1) == 1
   buf = READ(fid,'s'); buf = lower(buf);
   while strcmp(buf,b2) ~= 1
       if strcmp(buf,'lim') == 1
           tempLS = limitScheme();
           tempLS.read(fid);

           if strcmp(opt,'-both')
               vpsObj.insertLimitScheme(tempLS);
               vssObj.insertLimitScheme(tempLS);
           elseif strcmp(opt,'-sync')
               vssObj.insertLimitScheme(tempLS);
           elseif strcmp(opt,'-mesh')
               vpsObj.insertLimitScheme(tempLS);
           else
               THROW(['ERROR: plotting option:(',opt,') not valid']);
           end
       elseif strcmp(buf,b2) == 1
           continue;
       else
           THROW(['ERROR: option:(',buf,') not valid']);
       end
       buf = READ(fid,'s'); buf = lower(buf);
   end
else
    THROW(['ERROR: block must start with ',b1]);
end

stmp = READ(fid,'s');
buf = READ(fid,'s');
if strcmp(buf,b1) == 1
   buf = READ(fid,'s'); buf = lower(buf);
   while strcmp(buf,b2) ~= 1
       if strcmp(buf,'fld') == 1
           [who, tempObj] = readField2Scheme(fid);
           if any(strcmp(who,{'mesh','sync','both','none'}))
               tempOpt = ['-',who{1}];
               if strcmp(tempOpt,opt)
                   if strcmp(who,'both')
                       vpsObj.insertField2Scheme(tempObj);
                       vssObj.insertField2Scheme(tempObj);
                   elseif strcmp(who,'sync')
                       vssObj.insertField2Scheme(tempObj);
                   elseif strcmp(who,'mesh')
                       vpsObj.insertField2Scheme(tempObj);
                   elseif strcmp(who,'none')
                       %continue...
                   end
               end
           else
               THROW(['ERROR: option:(',who,') not valid']);
           end
       elseif strcmp(buf,b2) == 1
           continue;
       else
           THROW(['ERROR: option:(',buf,') not valid']);
       end
       buf = READ(fid,'s'); buf = lower(buf);
   end
else
    THROW(['ERROR: block must start with ',b1]);
end

tmp = READ(fid,'s',3);

tmp = READ(fid,'s');
tmp = READ(fid,'s');
if (strcmp(tmp, 'sym') == 1)
    confGen{g_clr_none} = READ(fid,'s');
else
    tmp = READ(fid, 'lg', 3);
    confGen{g_clr_none} = tmp; %tmp' used before with fscanf();
end


tmp = READ(fid, 's', 2);
if (strcmp(tmp, 'sym') == 1)
    confGen{g_clr_refine} = READ(fid, 's');
else
    tmp = READ(fid, 'lg', 3);
    confGen{g_clr_refine} = tmp;
end


tmp = READ(fid, 's', 2);
if (strcmp(tmp, 'sym') == 1)
    confGen{g_clr_coarsen} = READ(fid, 's');
else
    tmp = READ(fid, 'lg', 3);
    confGen{g_clr_coarsen} = tmp;
end

includeAdaptivity = confGen{I_includeRefinementClrs};
if (includeAdaptivity == 0)
    confGen{g_clr_none} = confGen{g_clr_coarsen};
    confGen{g_clr_refine} = confGen{g_clr_coarsen};
end    

tmp = READ(fid, 's');
confGen{g_plt_vids} = READ(fid, 'd');

tmp = READ(fid, 's');
confGen{g_vids_fnt_sz} = READ(fid, 'lg');

tmp = READ(fid, 's');
confGen{g_plt_noncollinearCoarsenable} = READ(fid, 'd');

tmp = READ(fid, 's');
confGen{g_noncollinearCoarsenable_symbl} = READ(fid, 's');

tmp = READ(fid, 's');
confGen{g_noncollinearCoarsenable_clr} = READ(fid, 's');

tmp = READ(fid, 's');
confGen{g_noncollinearCoarsenable_sz} = READ(fid, 'lg');

tmp = READ(fid, 's');
confGen{g_plotMeshCoh} = READ(fid, 'lg');

tmp = READ(fid, 's');
confGen{g_MeshCohLineColor} = READ(fid, 's');

tmp = READ(fid, 's');
confGen{g_MeshCohLineStyle} = READ(fid, 's');

tmp = READ(fid, 's');
confGen{g_MeshCohLineWidth} = READ(fid, 'lg');

tmp = READ(fid, 's');
confGen{g_plot_spaceElement} = READ(fid, 'd');

tmp = READ(fid, 's');
confGen{g_spaceElement_font_size} = READ(fid, 'lg');

tmp = READ(fid, 's');
confGen{g_spaceElement_text_color} = READ(fid, 's');

tmp = READ(fid, 's');
if (strcmp(tmp, 'box') == 1)
    tmp = READ(fid, 's');
    n = READ(fid, 'd');
    tmp = READ(fid, 's', 4);
    for i = 1:n
        confGen{g_box_xys}(i,:) = READ(fid, 'lg', 4);
    end

    tmp = READ(fid, 's');
    confGen{g_box_line_width}= READ(fid, 'lg');

    tmp = READ(fid, 's');
    tmp = READ(fid, 's');
    if (strcmp(tmp, 'sym') == 1)
        confGen{g_box_line_color} = READ(fid, 's');
    else
        tmp = READ(fid, 'lg', 3);
        confGen{g_box_line_color} = tmp;
    end
else
    confGen{g_box_xys} = [];
    confGen{g_box_line_width} = 2;
    confGen{g_box_line_color} = 'k';
end

fclose(fid);