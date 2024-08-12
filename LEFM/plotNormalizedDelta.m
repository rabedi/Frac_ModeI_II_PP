function plotNormalizedDelta(nu, maxVValue, vresolution) 
E = 1;
rho = 1;
[cd, cs, cr]  = computeCrackVelocities(E, nu, rho);


% if nargin < 2
%     VscaleCR = 1;
% end
% 
% if nargin < 3
%     VmaxCR = 1;
% end

if nargin < 2
    maxVValue = 0.9999;
end

if nargin < 3
    vresolution = 0.002;
end
% 
% if (VmaxCR == 1)
%     vma = cr * maxVValue;
% else
%     vma = cs * maxVValue;
% end
% 
% if (VscaleCR == 1)
%     vm = vma / cr;
% else
%     vm = vma / cs;
% end
v = 0:vresolution:maxVValue;
numv = length(v);
if (v(numv) ~= maxVValue)
    v(numv + 1) = maxVValue;
    numv = numv + 1;
end

% if (VscaleCR == 1)
%     for nv = 1:numv
%         if (v(nv) == 1)
%             v(nv) = 0.5 * (v(nv) + v(nv - 1));
%             break;
%         end
%     end
% end
% 
% normalization2cs = ~VscaleCR;

p = 1;
p = 5/3;
for nv = 1:numv
    
%     if (VscaleCR == 1)
        V = v(nv) * cr;
%     else
%         V = v(nv) * cr;
%     end

    ad = sqrt(1 - V * V / cd / cd);
    as = sqrt(1 - V * V / cs / cs);
    D = 4 * ad * as - (1 + as * as)^2;
    
    nDelp(nv) = (1 - nu) * D / (1 - as^2) * 1/ad;
    nDels(nv) = (1 - V/cr)^p / (1 - V/cd);
%    normalizedDelta(nv) = (1 - nu) * D / (1 - as^2) ;
    
end
plot(v, nDelp, v, nDels);
legend('nrp', 'nrs');
Delp = (pi / 4) * nDelp;
Dels = (1 / pi) * nDels;

figure(2);
plot(v, Delp, v, Dels); 
legend('rp', 'rs');
