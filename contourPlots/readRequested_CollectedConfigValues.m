function [cnfgFld, NcnfgFld] = readRequested_CollectedConfigValues(fid, isReqType, isComplete)
global ind_sl_sym;
global ind_sl_index;
global ind_sl_finderT;
global ind_sl_nrmlzrT;
global ind_sl_dim;
global ind_sl_name;
global ind_sl_MkrStyl;
global ind_sl_MkrClr;
global ind_sl_MkrSize;
global ind_sl_MkrActive;



tmp = fscanf(fid, '%s', 1);
NcnfgFld = fscanf(fid, '%d', 1);

cnfgFld = cell(NcnfgFld, 1);
tmp = fscanf(fid, '%s', 1);
for i = 1:NcnfgFld
    cnfgFld{i}{ind_sl_sym} =  fscanf(fid, '%s', 1);
end

tmp = fscanf(fid, '%s', 1);
for i = 1:NcnfgFld
    cnfgFld{i}{ind_sl_index} =  fscanf(fid, '%d', 1);
end
if (isReqType ~= 0)
    tmp = fscanf(fid, '%s', 1);
    for i = 1:NcnfgFld
        cnfgFld{i}{ind_sl_finderT} =  fscanf(fid, '%s', 1);
    end
end
tmp = fscanf(fid, '%s', 1);
for i = 1:NcnfgFld
    tmp = fscanf(fid, '%d', 1);
    if (tmp == 0)
        cnfgFld{i}{ind_sl_nrmlzrT} = 'relCoh';
    elseif (tmp == 1)
        cnfgFld{i}{ind_sl_nrmlzrT} = 'relLoad';
    else
        cnfgFld{i}{ind_sl_nrmlzrT} = 'none';
    end
end

for i = 1:NcnfgFld
    dim = -1;
    if (strcmp(cnfgFld{i}{ind_sl_sym}, 'fld0') == 1)
        dim = 0;
    elseif (strcmp(cnfgFld{i}{ind_sl_sym}, 'fld1') == 1)
        dim = 1;
    elseif (strcmp(cnfgFld{i}{ind_sl_sym}, 'flds') == 1)
        dim = 2;
    end
    if (dim < 0)
        cnfgFld{i}{ind_sl_nrmlzrT} = 'none';
    end
    cnfgFld{i}{ind_sl_dim} = dim;
end

if (isComplete == 0)
    return;
end


tmp = fscanf(fid, '%s', 1);
for i = 1:NcnfgFld
    cnfgFld{i}{ind_sl_name} =  fscanf(fid, '%s', 1);
end

tmp = fscanf(fid, '%s', 1);
for i = 1:NcnfgFld
    inp = fscanf(fid, '%s', 1);
    cnfgFld{i}{ind_sl_MkrStyl} = getMarkerStyleByInput(inp);
end

tmp = fscanf(fid, '%s', 1);
for i = 1:NcnfgFld
    inp = fscanf(fid, '%s', 1);
    cnfgFld{i}{ind_sl_MkrClr} = getColorByInput(inp);
end

tmp = fscanf(fid, '%s', 1);
for i = 1:NcnfgFld
    inp = fscanf(fid, '%d', 1);
    cnfgFld{i}{ind_sl_MkrSize} = getMarkerSizeByInput(inp);
end

tmp = fscanf(fid, '%s', 1);
for i = 1:NcnfgFld
    cnfgFld{i}{ind_sl_MkrActive} =  fscanf(fid, '%d', 1);
end