function plot_Dsu_Dvs(xMode, version, forceDroppingDir)

fieldXIndex = 0;
for runNumber = 0:20
    plot_Dsu_Dv(version, runNumber, xMode, fieldXIndex, forceDroppingDir);
end
