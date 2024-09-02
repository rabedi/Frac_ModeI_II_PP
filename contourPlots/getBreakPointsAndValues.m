function [breakPoints, values] =  getBreakPointsAndValues(z)

num = length(z);
zdiff = z - [0, z(1:num - 1)];
zdiff(num) = -1;
zdiff(num) = -1;

breakPoints = find(zdiff ~= 0);
numBreak = length(breakPoints);
values = zeros(numBreak - 1, 1);
for i = 1:(numBreak - 1)
    values(i) = z(breakPoints(i));
end
