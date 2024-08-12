sz = size(Frame);

for i = 1:sz
    correcteddamage(i) = (M_omega1(i)+(matrixsizezero - M_area1(i)))/matrixsizezero;
end