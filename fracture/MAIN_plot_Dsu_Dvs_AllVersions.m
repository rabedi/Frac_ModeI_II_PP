function plot_Dsu_Dvs_AllVersions(xMode, forceDroppingDir, vers)

if nargin < 1
    % choice for x axis
    xMode = 2; % 1 for deltau_s normalization, 2 for deltav_s normalization
end

if nargin < 2
    forceDroppingDir = 0;
end
    
if nargin < 3
    vers = [20, 21, 22, 23, 24, 25, 11, 10, 9, 14, 8, 12, 13, 15, 30, 31, 32, 33, 34, 35, 36]; %33, 32, 31, 30];
end

for i = 1:length(vers)
    plot_Dsu_Dvs(xMode, vers(i), forceDroppingDir);
end

