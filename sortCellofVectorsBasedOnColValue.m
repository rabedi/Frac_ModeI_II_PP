function sorted = sortCellofVectorsBasedOnColValue(inputCell, col)


siz = length(inputCell);
if siz == 0
    sorted = zeros(0, 0);
    return;
end

for i = 1:siz
    colm(i) = inputCell{i}(col);
end

[colmN, index] = sort(colm);

for i = 1:siz
    sorted{i} = inputCell{index(i)};
end
