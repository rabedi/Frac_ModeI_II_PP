function [s00 , s01, s11] = rotatedStress(sIn00, sIn01, sIn11, teta)
a = (sIn00 + sIn11)/2;
b = (sIn00 - sIn11)/2;
c = sIn01;


s00 = a + b * cos(2 * teta) + c * sin(2 * teta);
s01 =     -b * sin(2 * teta) + c * cos(2 * teta);
s11 = a - b * cos(2 * teta) - c * sin(2 * teta);
