function  transferredData = transferDataForPlotComparison(x, typeAxis, changeLogData)


if ((changeLogData == 0) || (strcmp(typeAxis,'linear') == 1))
    transferredData = x;
else
    transferredData = log10(x);
end
    