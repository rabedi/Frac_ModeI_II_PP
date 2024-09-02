%function plotAngularFunction()
dat = load('testRandomVertexOut.txt')
plot(dat(:,1), dat(:,2));
[mVal, ind] = min(dat(:,2));
mAngle = dat(ind, 1)
mVal
[MVal, ind] = max(dat(:,2));
MAngle = dat(ind, 1)
MVal
