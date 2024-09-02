function bDomainBoundary = isDomainBoundary(x, y)
%Razaldo
xave = average(x);
yave = average(y);
bDomainBoundary = 0;

x1 = x(1);
y1 = y(1);

tol = 1e-2;

if (DoublesAreEqual(abs(yave), 4, tol) == 1)
    bDomainBoundary = 1;
end

if (DoublesAreEqual(xave, 16, tol) == 1)
    bDomainBoundary = 1;
end

if (xave < 1.95)
    bDomainBoundary = 1;
end

