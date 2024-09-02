function MAIN_plotDamagePaperPlots(configName, clr, isPSFrag, forceDroppingDir, addFieldNameInsideLeg, plot21_25kLoadVal, plot30_36kRate, plot8_15kRate)

if (nargin < 1)
    configName = 'plotConfigExtended.txt';
end
if (nargin < 2)
    clr = 1;
end
if (nargin < 3)
    isPSFrag = 0;
end

if (nargin < 4)
    plot21_25kLoadVal = 1;
end
if (nargin < 5)
    plot30_36kRate = 1;
end
if (nargin < 6)
    plot8_15kRate = 1;
end


if plot21_25kLoadVal

% constant loads
% different ultimate loads from 0.85 to 1.1 - delv k = 1 (load is suddently applied => no ramp time)
% k = 0.01
GENERAL_DATA_SET_PLOT(21, clr, isPSFrag, configName, [0.01 0.06 1.1 4.0, 5.0], forceDroppingDir, addFieldNameInsideLeg);
% k = 0.1
GENERAL_DATA_SET_PLOT(22, clr, isPSFrag, configName, [0.1 0.33 0.90 3.5, 5.0], forceDroppingDir, addFieldNameInsideLeg);
% k = 1
GENERAL_DATA_SET_PLOT(23, clr, isPSFrag, configName, [0.8 2.0 0.80 2.0, 5.0], forceDroppingDir, addFieldNameInsideLeg);
% k = 100
GENERAL_DATA_SET_PLOT(24, clr, isPSFrag, configName, [0.6 1.4 0.06 0.14, 5.0], forceDroppingDir, addFieldNameInsideLeg);
% k = infinity
GENERAL_DATA_SET_PLOT(25, clr, isPSFrag, configName, [0.6 1.4 0.06 0.14, 5.0], forceDroppingDir, addFieldNameInsideLeg);



% delv different k's (log k >= 0) with constant load v 1.0
GENERAL_DATA_SET_PLOT(20, clr, isPSFrag, configName, [0.55 1.1 1.2 4.5, 5.0], forceDroppingDir, addFieldNameInsideLeg);
GENERAL_DATA_SET_PLOT(60, clr, isPSFrag, configName, [0.55 1.1 1.2 4.5, 5.0], forceDroppingDir, addFieldNameInsideLeg);

end


if plot30_36kRate
% rate loadings 
% delk, delv = 0
GENERAL_DATA_SET_PLOT(30, clr, isPSFrag, configName, [4.0 1.2 1.2 3.0 4.0], forceDroppingDir, addFieldNameInsideLeg);
% delv k = 100
GENERAL_DATA_SET_PLOT(31, clr, isPSFrag, configName, [4.0 1.2 1.2 3.0 4.0], forceDroppingDir, addFieldNameInsideLeg);
% delv k = 10
GENERAL_DATA_SET_PLOT(32, clr, isPSFrag, configName, [2.5 1.2 1.2 3.0 4.0], forceDroppingDir, addFieldNameInsideLeg);
% delv k = 1
GENERAL_DATA_SET_PLOT(33, clr, isPSFrag, configName, [0.8 1.2 1.2 3.0 5.0], forceDroppingDir, addFieldNameInsideLeg);
% delv k = 0.1
GENERAL_DATA_SET_PLOT(34, clr, isPSFrag, configName, [0.15 1.2 1.2 3.0 5.0], forceDroppingDir, addFieldNameInsideLeg);
% delv k = 0.01
GENERAL_DATA_SET_PLOT(35, clr, isPSFrag, configName, [0.0125 1.2 1.2 3.0 10.0], forceDroppingDir, addFieldNameInsideLeg);
% delv k = 0.001
GENERAL_DATA_SET_PLOT(36, clr, isPSFrag, configName, [0.00125 1.2 1.2 3.0 10.0], forceDroppingDir, addFieldNameInsideLeg);


%%%%%%%%%%%%%%%%
% delk, delv = 0
%GENERAL_DATA_SET_PLOT(50, clr, isPSFrag, configName, [4.0 1.2 1.2 3.0 4.0], forceDroppingDir, addFieldNameInsideLeg);
% delv k = 100
GENERAL_DATA_SET_PLOT(51, clr, isPSFrag, configName, [4.0 1.2 1.2 3.0 4.0], forceDroppingDir, addFieldNameInsideLeg);
% delv k = 10
GENERAL_DATA_SET_PLOT(52, clr, isPSFrag, configName, [2.5 1.2 1.2 3.0 4.0], forceDroppingDir, addFieldNameInsideLeg);
% delv k = 1
GENERAL_DATA_SET_PLOT(53, clr, isPSFrag, configName, [0.8 1.2 1.2 3.0 5.0], forceDroppingDir, addFieldNameInsideLeg);
% delv k = 0.1
GENERAL_DATA_SET_PLOT(54, clr, isPSFrag, configName, [0.15 1.2 1.2 3.0 5.0], forceDroppingDir, addFieldNameInsideLeg);
% delv k = 0.01
GENERAL_DATA_SET_PLOT(55, clr, isPSFrag, configName, [0.0125 1.2 1.2 3.0 10.0], forceDroppingDir, addFieldNameInsideLeg);
% delv k = 0.001
GENERAL_DATA_SET_PLOT(56, clr, isPSFrag, configName, [0.00125 1.2 1.2 3.0 10.0], forceDroppingDir, addFieldNameInsideLeg);


end

%%% rate loading all k's to generate sequence for run comparison plots

if plot8_15kRate

% ramp loads 8 original damage
% delv k = 0.001
%%%%
GENERAL_DATA_SET_PLOT(12, clr, isPSFrag, configName, [0.0015 1.2 1.2 3.0 5.0], forceDroppingDir, addFieldNameInsideLeg);
% delv k = 0.01
GENERAL_DATA_SET_PLOT(11, clr, isPSFrag, configName, [0.015 1.2 1.2 3.0 8.5], forceDroppingDir, addFieldNameInsideLeg);
% delv k = 0.1
GENERAL_DATA_SET_PLOT(10, clr, isPSFrag, configName, [0.15 1.2 1.2 3.0 5.0], forceDroppingDir, addFieldNameInsideLeg);
% delv k = 1
GENERAL_DATA_SET_PLOT(9, clr, isPSFrag, configName, [1.2 1.2 1.2 3.0 6.5], forceDroppingDir, addFieldNameInsideLeg);
% delv k = 10
%%%%
GENERAL_DATA_SET_PLOT(13, clr, isPSFrag, configName, [4.0 1.2 1.2 3.0 4.0], forceDroppingDir, addFieldNameInsideLeg);
% delv k = 100
GENERAL_DATA_SET_PLOT(14, clr, isPSFrag, configName, [4.0 1.2 1.2 3.0 4.0], forceDroppingDir, addFieldNameInsideLeg);
% delv k = 1000
%%%%
GENERAL_DATA_SET_PLOT(15, clr, isPSFrag, configName, [4.0 1.2 1.2 3.0 4.0], forceDroppingDir, addFieldNameInsideLeg);
% delv k = infinity
GENERAL_DATA_SET_PLOT(8, clr, isPSFrag, configName, [4.0 1.2 1.2 3.0 4.0], forceDroppingDir, addFieldNameInsideLeg);
end
