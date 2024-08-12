function returnVal = modifySpaceMeshConfig(xlim, ylim, printOption, outputDirectoryMidName, startFileName)
%Note(4/13/2106):May need to alter later for sync plots

global configGen;
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



configGen{s_dirPreName} = '../../';
configGen{s_dirRunName} = outputDirectoryMidName;
configGen{s_runName} = startFileName;
configGen{s_dirPostName} = '/output_front/';
configGen{s_dir} = [configGen{s_dirPreName} configGen{s_dirRunName} configGen{s_dirPostName}];

step = 25000;

cnf = step;
dataFileName = [configGen{s_dir}, configGen{s_runName}, configGen{s_middlename}, configGen{s_midNData}, num2str(cnf, '%0.10d'),'.', 'txt'];
fid = fopen(dataFileName, 'r');

if (fid < 0)
    returnVal = 0;
    return;
end

while (fid > 0)
    cnf = cnf + step;
    dataFileName = [configGen{s_dir}, configGen{s_runName}, configGen{s_middlename}, configGen{s_midNData}, num2str(cnf, '%0.10d'),'.', 'txt'];
    fid = fopen(dataFileName, 'r');
end
configGen{s_serialStart} = cnf - step;
configGen{s_serialStep} = step;
configGen{s_serialEnd} = configGen{s_serialStart};


%if (strcmp(configGen{s_dirOut}, 'runFolder') == 1)
    configGen{s_dirOut} = [configGen{s_runName}, '_front'];
        %%, '_', configGen{s_dirRunName}
%end

%        fileName = [outputFolder, outputFile, '_', num2str(num, '%08d'), '.', printOption];
%        print(['-d', printOption], fileName);


if (strcmp(configGen{s_dirOut}, '') ~= 1)
    b_dir = isdir(configGen{s_dirOut});
    if (b_dir == 1)
    %    rmdir(configGen{s_dirOut},'s');
    else
        mkdir(configGen{s_dirOut});
    end
    configGen{s_dirOut} = [configGen{s_dirOut}, '/'];
end

configGen{s_printOptionExt} = printOption;
configGen{s_printOption} = ['-d', configGen{s_printOptionExt}];
if (strcmp(configGen{s_printOptionExt}, 'epsc') == 1)
    configGen{s_printOptionExt} = 'eps';
end    

configGen{s_runNameAppendix} = outputDirectoryMidName;


configGen{s_b_xlim} = 1;
configGen{s_xmin_all} = xlim(1);
configGen{s_xmax_all} = xlim(2);
configGen{s_b_ylim} = 1;
configGen{s_ymin_all} = ylim(1);
configGen{s_ymax_all} = ylim(2);


returnVal = 1;