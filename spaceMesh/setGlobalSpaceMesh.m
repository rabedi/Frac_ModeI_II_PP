function setGlobalSpaceMesh()


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

global I_includeRefineInLegend;
global I_includeLegend; 
global I_includeColorbar;
global I_elementEdgeColor;
global I_elementEdgeWidth;
global I_legendLocation;

global I_damageLevelsFlag;
global I_includeRefinementClrs;

global g_pltDmgdUnDmaged;
global g_plotAxis;

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


s_serialStart = 1;
s_serialStep = 2;
s_serialEnd = 3;
s_dirPreName = 4;
s_dirRunName = 5;
s_dirPostName = 6;
s_dir = 7;
s_dirOut = 8;
s_runName = 9;
s_middlename = 10;
s_midNData = 11;
s_printOption = 12;
s_printOptionExt = 13;
s_doPrintEPS = 14;
s_b_xlim = 15;
s_xmin_all = 16;
s_xmax_all = 17;
s_b_ylim = 18;
s_ymin_all = 19;
s_ymax_all = 20;
enforceLimitsWithxlim_ylim = 21;
s_runNameAppendix = 22;

I_numberDistDPts = 25;
I_DistDPts = 26;

I_includeRefineInLegend = 27;
I_includeLegend = 28; 
I_elementEdgeColor = 29;
I_elementEdgeWidth = 30;
I_legendLocation = 31;

I_damageLevelsFlag = 32;
I_includeRefinementClrs = 33;

g_pltDmgdUnDmaged = 37;
g_plotAxis = 38;



g_clr_none = 40;
g_clr_refine = 41;
g_clr_coarsen = 42;

g_plt_vids = 51;
g_vids_fnt_sz = 52;
g_plt_noncollinearCoarsenable = 53;
g_noncollinearCoarsenable_symbl = 54;
g_noncollinearCoarsenable_clr = 55;
g_noncollinearCoarsenable_sz = 56;

g_plotMeshCoh = 57;
g_MeshCohLineColor = 58;
g_MeshCohLineStyle = 59;
g_MeshCohLineWidth = 60;

g_plot_spaceElement = 65;
g_spaceElement_font_size = 66;
g_spaceElement_text_color = 67;

g_box_xys = 68;
g_box_line_width = 69;
g_box_line_color = 70;

I_includeColorbar = 71;


idam_level = 1;
id_clr = 2;
id_lstyle = 3;
id_lwdth = 4;



% data regarding spacemesh data
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


MAX_T = 1;
MIN_T = 2;
N_MAX_MIN = 3;
N_DECIDED = 4;

NONE = 0;
REFINE = 1;
COARSEN  = 2;

d_id = 1;
d_adp = 2;
d_angleMark = 3;
d_faceMark = 4;

d_vid = 5;
d_vNonCollinearCoarsenable = 6;
d_vDirGiven = 7;

d_crd = 10;
d_edgef = 11;

d_numInflowE = 12;
d_inflowData = 13;

    d_infd_id = 1;
	d_infd_face = 2;
	d_infd_numEdge = 3;
	d_infd_edgeData = 4;
        difnd_edgeIndex = 1;
        difnd_numInfCracks = 2;
        difnd_InfCracksData = 3;

           		nbhd_ind = 1;
           		nbhd_limT = 2;
           		nbhd_startP = 3;
           		nbhd_endP = 4;
           		nbhd_numP = 5;

                pt_dataCrd = 6;
                pt_dataDamage = 7;

                
              