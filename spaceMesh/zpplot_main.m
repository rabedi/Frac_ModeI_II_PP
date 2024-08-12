function [AllSVEData, success] = zpplot_main(AllSVEData, datapath, config)

%Initializing Latex Interpreters
close all;
clearvars -except AllSVEData
set(groot,'defaulttextinterpreter','latex');  
set(groot, 'defaultAxesTickLabelInterpreter','latex');  
set(groot, 'defaultLegendInterpreter','latex');
addpath('../');

%Initially only able to process 1 RVE at a time. 
numRVE = 1;

%Checking if input variables exist or not, initialize to common location if
%does not exist.Comment out load if data already loaded.
if nargin < 1
   datamatfilename = 'AllSVEData1.mat'; 
   load(datamatfilename);
   datapath = 'D:/Documents/PhD/OSU_Justin/RezaStuff/New_averageS/OutputFiles/'; 
   config = 'zpplot_configfile.txt';
elseif nargin < 2
   datapath = 'D:/Documents/PhD/OSU_Justin/RezaStuff/New_averageS/OutputFiles/'; 
   config = 'zpplot_configfile.txt';
elseif nargin < 3
   config = 'zpplot_configfile.txt'; 
end

%Reading config file for plot
fidb = fopen(config,'r');
plotConfigContents = zpplot_plotConfigurationParameters.ReadConfig(fidb);

for i = 1:length(plotConfigContents.plotTypes)

    if strcmp('TimeHistoryAllSVE',plotConfigContents.plotTypes{i}) == 1
       zpplot_TimeHistoryAllSVE(AllSVEData,plotConfigContents);
    elseif strcmp('TimeHistorySingleSVE',plotConfigContents.plotTypes{i}) == 1
       zpplot_TimeHistorySingleSVE(AllSVEData,plotConfigContents);
    elseif strcmp('StrainHistory',plotConfigContents.plotTypes{i}) == 1
       zpplot_StrainHistory(AllSVEData,plotConfigContents);
    elseif strcmp('SVE',plotConfigContents.plotTypes{i}) == 1
        zpplot_SVE(AllSVEData,plotConfigContents);
    elseif strcmp('PDF',plotConfigContents.plotTypes{i}) == 1
        zpplot_PDF(AllSVEData,plotConfigContents);
    elseif strcmp('CDF',plotConfigContents.plotTypes{i}) == 1
        zpplot_CDF(AllSVEData,plotConfigContents);
    elseif strcmp('Bar',plotConfigContents.plotTypes{i}) == 1
        zpplot_Bar(AllSVEData,plotConfigContents);
    elseif strcmp('StageCorrelation',plotConfigContents.plotTypes{i}) == 1
        zpplot_StageCorrelation(AllSVEData,plotConfigContents);
    else
        THROW('Not a valid plot option!');
    end    
    
end

success = 1;
end