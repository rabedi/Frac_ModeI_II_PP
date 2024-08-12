function [style, color, marker] = gLineStyleBlackAll()

for n = 1:22
    [style{n}, color{n}, marker{n}] = gLineStyleBlack(n); 
end