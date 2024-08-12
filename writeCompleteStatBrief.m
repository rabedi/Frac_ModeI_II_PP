function writeCompleteStatBrief(fileNameStatOut, startingPtsOut, colSizeOut, maxCrossOut, minVOut, minCoordOut, min_eIDOut, min_idOut, maxVOut, maxCoordOut, max_eIDOut, max_idOut, counterOut, averageOut, sumOut, sDiviationOut, fieldNameOut)


fidStatOut = fopen(fileNameStatOut, 'w');
writeStartingPoints(fidStatOut, startingPtsOut);
fprintf(fidStatOut,'%d\t', colSizeOut);
fprintf(fidStatOut,'%d\n', maxCrossOut);
writeBriefStat(fidStatOut, minVOut, minCoordOut, min_eIDOut, min_idOut, maxVOut, maxCoordOut, max_eIDOut, max_idOut, counterOut, averageOut, sumOut, sDiviationOut, fieldNameOut);
fclose(fidStatOut);
