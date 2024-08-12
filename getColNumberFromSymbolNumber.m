function colNo = getColNumberFromSymbolNumber(colSym, number, startingPts)

startMesoAreas = 4; % this is where mesoscopic areas start in appendix output for primary fields


aSep_rel = 0;
aSep_abs = 1;
aCntct_rel = 2;
aCntct_abs = 3;
aSlip_rel = 4;
aSlip_abs = 5;
aStick_rel = 6;
aStick_abs = 7;
aBonded_abs = 8;	


global cnfg;
global I_TS_numReqFlds;
global I_TS_ReqFlds;
global I_TS_totalFldsPerReqFld;
numFields = startingPts(30);
dimension = 2;
dimensionp1 = 3;
% DelU = 0;
% Sc = 1;
% Se = 2;
% Si = 3;
% V  = 4;
% DelV =5;
% U = 6;
% Sstar = 7;
% SGodunov = 8;
% Damage = 9;
%fld0 fld1 and flds are specific to cohesive post process output and t0 is
%0's component  1 is first component and flds is the scalar component
% fldx refers to flds after pairwise and scalar outputs in cohesive post
% process

if (strcmp(colSym,'fld0') == 1)
%    colNo = number + startingPts(11);
    colNo = number * 2 + 0 +  startingPts(11);
elseif (strcmp(colSym,'fld1') == 1)
%    colNo = 1 * numFields + number + startingPts(11);
    colNo = number * 2 + 1 +  startingPts(11);
elseif (strcmp(colSym,'flds') == 1)
    colNo = dimension * numFields + number + startingPts(11);
elseif (strcmp(colSym,'fldx') == 1)
    colNo = dimensionp1 * numFields + number + startingPts(11);

    
elseif (strcmp(colSym,'fldInternal') == 1)
    colNo = number + startingPts(11);
elseif (strcmp(colSym,'time') == 1)
    colNo = startingPts(7);
elseif (strcmp(colSym,'space') == 1)
    colNo = startingPts(2);
elseif (strcmp(colSym,'id') == 1)
    colNo = startingPts(4);
elseif (strcmp(colSym,'eID') == 1)
    colNo = startingPts(3);
elseif (strcmp(colSym,'normal') == 1)
    colNo = number + startingPts(5);
elseif (strcmp(colSym,'X') == 1)
    colNo = number + startingPts(6);
elseif (strcmp(colSym,'DXDT') == 1)
    colNo = number + startingPts(8);
elseif (strcmp(colSym,'DfldDT') == 1)
    colNo = number + startingPts(12);
elseif (strcmp(colSym,'DspaceDT') == 1)
    colNo = startingPts(10);
elseif (strcmp(colSym,'col') == 1)
    colNo =  number - 1;
elseif (strncmp(colSym, 'iF', 2) == 1)
    typs = colSym(3);
    dims = colSym(6);
    if (dims == 's')
        dim = 2;
    else
        dim = str2num(dims);
    end
    if (typs == 'w')
        typ = 0;
    elseif (typs == 't')
        typ = 1;
    elseif (typs == 'a')
        typ = 2;
    end
    fldMult = startingPts(33);
    typeMult = startingPts(34);
    dimMult = startingPts(35);
    fld = number;
    colNo = typ * typeMult + fld * fldMult + dim * dimMult + startingPts(13);
elseif (strcmp(colSym, 'LEFMgen') == 1)
    colNo = number + startingPts(14);
elseif (strcmp(colSym, 'LEFMrs') == 1)
    colNo = number + startingPts(15);
elseif (strcmp(colSym, 'LEFMrsRel') == 1)
    colNo = number + startingPts(16);
elseif (strcmp(colSym, 'LEFMTheo') == 1)
    colNo = number + startingPts(17);
elseif (strcmp(colSym, 'LEFMTheoFD') == 1)
    colNo = number + startingPts(18);

elseif (strcmp(colSym, 'LEFMrsnG') == 1)
    colNo = number + startingPts(19);
elseif (strcmp(colSym, 'LEFMrsRelnG') == 1)
    colNo = number + startingPts(20);
elseif (strcmp(colSym, 'LEFMTheonG') == 1)
    colNo = number + startingPts(21);
elseif (strcmp(colSym, 'LEFMTheoFDnG') == 1)
    colNo = number + startingPts(22);

elseif (strncmp(colSym, 'Slc', 3) == 1)
    typeFlg = colSym(4:5);
    derFlg = colSym(6);
    derIncm = 0;
    if (derFlg == 'D')
        derIncm = 1;
    end
    baseCollect = 0;
    if (strcmp(typeFlg, 'rS') == 1)
        baseType = 0;
    elseif (strcmp(typeFlg, 'aS') == 1)
        baseType = 1;
    elseif (strcmp(typeFlg, 'vl') == 1)
        baseType = 2;
    elseif (strcmp(typeFlg, 'cl') == 1)
        baseType = 3;
        baseCollect = str2num(colSym(7:length(colSym)));
    end
    if (number < 0)
        reqNum = - number - 1;
    else
        reqNum  = number + 3;
    end
        
    colNo = derIncm  + 2 * (baseType + baseCollect) + reqNum * cnfg{I_TS_totalFldsPerReqFld} + startingPts(23);
elseif (strcmp(typeFlg, 'mesoARSep') == 1)
        colNo = dimensionp1 * numFields + startMesoAreas + aSep_rel + startingPts(11);
elseif (strcmp(typeFlg, 'mesoAASep') == 1)
        colNo = dimensionp1 * numFields + startMesoAreas + aSep_abs + startingPts(11);
elseif (strcmp(typeFlg, 'mesoARCntct') == 1)
        colNo = dimensionp1 * numFields + startMesoAreas + aCntct_rel + startingPts(11);
elseif (strcmp(typeFlg, 'mesoAACntct') == 1)
        colNo = dimensionp1 * numFields + startMesoAreas + aCntct_abs + startingPts(11);
elseif (strcmp(typeFlg, 'mesoARSlip') == 1)
        colNo = dimensionp1 * numFields + startMesoAreas + aSlip_rel + startingPts(11);
elseif (strcmp(typeFlg, 'mesoAASlip') == 1)
        colNo = dimensionp1 * numFields + startMesoAreas + aSlip_abs + startingPts(11);
elseif (strcmp(typeFlg, 'mesoARStick') == 1)
        colNo = dimensionp1 * numFields + startMesoAreas + aStick_rel + startingPts(11);
elseif (strcmp(typeFlg, 'mesoAAStick') == 1)
        colNo = dimensionp1 * numFields + startMesoAreas + aStick_abs + startingPts(11);
elseif (strcmp(typeFlg, 'mesoAABond') == 1)
        colNo = dimensionp1 * numFields + startMesoAreas + aBonded_abs + startingPts(11);
else
    fprintf(1,'%d ', startingPts);
    fprintf(1,'%s\n', colSym);
    fprintf(1,'\n%d\n', number);
end
