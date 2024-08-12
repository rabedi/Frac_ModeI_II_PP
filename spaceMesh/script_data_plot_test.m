addpath('../');
addpath('aux_functions');
addpath('plt');


aa = gen_textIndexedDatasets;
aa = aa.fromFile('_testDataSet.txt');
fid = fopen('_testDataSet_plot.txt', 'r');

datx = gen_dat_xOrys;
datx = datx.Read(fid);
datx = aa.FinalizeData_in_gen_dat_xOrys(datx);

specificPtsIndices = [1, 5, 9, 13];
for i = 1:datx.number
    xss{i} = aa.getSpecificPtsDataVectorByDataIndex(specificPtsIndices, datx.datPos(i), datx.indices1(i), datx.indices2(i));
end    

daty = gen_dat_xOrys;
daty = daty.Read(fid);
daty = aa.FinalizeData_in_gen_dat_xOrys(daty);
for i = 1:daty.number
    yss{i} = aa.getSpecificPtsDataVectorByDataIndex(specificPtsIndices, daty.datPos(i), daty.indices1(i), daty.indices2(i));
end    



binstOut = gen_dataBreakerInstruction1L;
binstOut = binstOut.Read(fid);

binstMiddle = gen_dataBreakerInstruction1L;
binstMiddle = binstMiddle.Read(fid);

fclose(fid);

breaker1Lin = gen_dataBreaker1L;
breaker1Lout = aa.updateDataBreakerUsingInstruction(breaker1Lin, binstOut);

for j = 1:breaker1Lout.numLeaves
    breaker1Lout.leaves{j} = aa.updateDataBreakerUsingInstruction(breaker1Lout.leaves{j}, binstMiddle);
end

xInd = 6;
yInd = 7;

tfs = 20;
legfs = 15;

for j = 1:breaker1Lout.numLeaves
    figure(j);
    numOuterIndsBreaker = breaker1Lout.leaves{j}.numDataBreaker;
    dataPos = breaker1Lout.leaves{j}.dataPoss;
    dataVls = breaker1Lout.leaves{j}.dataVals;
    dataInds4Vals = breaker1Lout.leaves{j}.dataInds4Vals;
    outputPlotName = ['plt_', num2str(j, '%04d'), '_'];
    strLatexAll = [];
    strAll = [];
    indexBase = [];
    for k = 1:numOuterIndsBreaker
        datpos = dataPos(k);
        indexBase(datpos) = dataInds4Vals(k);
        str = aa.dataNames{datpos};
        str = [str, '=',  num2str(dataVls(k))];
        strLtx = aa.dataNamesLatex{datpos};
        strLtx = [strLtx, ' = ',  num2str(dataVls(k))];
        
        if (k < numOuterIndsBreaker)
            strAll = [strAll, str, '_'];
            strLatexAll = [strLatexAll , strLtx, ', '];
        else
            strAll = [strAll, str];
            strLatexAll = [strLatexAll , strLtx];
        end
    end
    strAll = [outputPlotName, strAll];
    
    strLatexAll = ['$$ ', strLatexAll, ' $$'];
    title(strLatexAll, 'FontSize', tfs, 'interpreter', 'latex');
    numCurve = breaker1Lout.leaves{j}.numLeaves;
    ptInds = cell(numCurve, 1);
    labelsLeg = cell(numCurve, 1);
    indexCr = cell(numCurve, 1);
    for c = 1:numCurve
        numIndsBreakerCr = breaker1Lout.leaves{j}.leaves{c}.numDataBreaker;
        dataPossCr = breaker1Lout.leaves{j}.leaves{c}.dataPoss;
        dataVlsCr = breaker1Lout.leaves{j}.leaves{c}.dataVals;
        dataInds4ValsCr = breaker1Lout.leaves{j}.leaves{c}.dataInds4Vals;
        ptInds{c} = breaker1Lout.leaves{j}.leaves{c}.dataIndices;
        strLatexAllLeg = [];
        indexCr{c} = indexBase;
        for k = 1:numIndsBreakerCr
            datposCr = dataPossCr(k);
            indexCr{c}(datposCr) = dataInds4ValsCr(k);
            strCr = aa.dataNames{datposCr};
            header = aa.dataNamesLatex{datpos};
            if (numIndsBreakerCr == 1)
                strLatexAllLeg = num2str(dataVlsCr(k));
            else
                strLtxLeg = aa.dataNamesLatex{datposCr};
                strLtxLeg = [strLtxLeg, ' = ',  num2str(dataVlsCr(k))];
                if (k < numOuterIndsBreaker)
                    strLatexAllLeg = [strLatexAllLeg , strLtxLeg, ', '];
                else
                    strLatexAllLeg = [strLatexAllLeg, strLtxLeg];
                end
            end
        end
        labelsLeg{c} = ['$$ ', strLatexAllLeg, ' $$'];
    end
    xs = cell(numCurve, 1);
    ys = cell(numCurve, 1);
    for c = 1:numCurve
        szPt = length(ptInds{c});
        x = zeros(szPt, 1);
        y = zeros(szPt, 1);
        for k = 1:szPt
            ptInd = ptInds{c}(k);
            x(k) = aa.data{xInd}{ptInd};
            y(k) = aa.data{yInd}{ptInd};
        end
        xs{c} = x;
        ys{c} = y;
    
        plot(x, y);
        hold on;
    end
    legend(labelsLeg, 'FontSize', legfs, 'interpreter', 'latex');
    legend('boxoff');
    print('-dpng', [strAll, '.png']);
end
