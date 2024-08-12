function [dim, fld] = getDimensionFieldOfPrimaryFldOutput(colN, startingPts)

numPFields = startingPts(30);

if (colN >= startingPts(12))
    dim = -1;
    fld = -1;
    return;
end
fld = colN - startingPts(11);

dimTemp = floor(fld / numPFields);
fld = mod(fld, numPFields);

if (dimTemp == 2)
    dim = dimTemp;
    return;
end

dim = mod(fld, 2);
fld = floor(fld/ 2);