function rawData = zpp_FakeDamageSet(epsLower, epsUpper, strainComp, strainSign, E, nu, planeStrain, numPoints)
if nargin < 1
    epsLower = 0.5;
end
if nargin < 2
    epsUpper = 1.0;
end
    
if nargin < 3
    strainComp = 1; % 1 epsxx, 2 epsyy, 3 epsxy
end

if nargin < 4
    strainSign = 1; % positive values
end

if nargin < 5
    E = 1.0;
end

if nargin < 6
    nu = 0.3;
end

if nargin < 7
    planeStrain = 1; % plain strain mode
end

if nargin < 8
    numPoints = 400;
end

dim = 2;
if (planeStrain)
    mult = (E / (1 + nu) / (1 - 2 * nu));
	A = mult * (1 - nu);
    B = mult * nu;
    C = mult * (1 - 2 * nu);
else
    mult = (E / (1 - nu*nu));
    A = mult;
    B = mult * nu;
    C = mult * (1 - nu);
end

stiff = [A B 0;B A 0; 0 0 C];

epsScalar = 0:epsUpper/numPoints:epsUpper;
sz = length(epsScalar);

rawData = gen_textIndexedDatasets;
rawData = rawData.Initialize(sz, 'time');
rawData = rawData.AddDataSetFirstPt(0, 'zpr_stnst_xx', 0);
rawData = rawData.AddDataSetFirstPt(0, 'zpr_stnst_yy', 0);
rawData = rawData.AddDataSetFirstPt(0, 'zpr_stnst_xy', 0);
rawData = rawData.AddDataSetFirstPt(0, 'zpr_stssh_xx', 0);
rawData = rawData.AddDataSetFirstPt(0, 'zpr_stssh_yy', 0);
rawData = rawData.AddDataSetFirstPt(0, 'zpr_stssh_xy', 0);
rawData = rawData.AddDataSetFirstPt(0, 'zpr_d', 0);
rawData = rawData.AddDataSetFirstPt(0, 'zpr_power', 0);

factPower = (epsUpper / 1)^2 * A;
for i = 1:sz
    t = (i - 1) / (sz - 1);
    rawData.xAxesVals(i) = t;
    eps = epsScalar(i);
    D = 0;
    if (eps > epsUpper)
        D = 1;
    elseif (eps > epsLower)
        D = (eps - epsLower)/(epsUpper - epsLower);
    end
    d = D;
    D = D * D;
    if (strainSign ~= 1)
        eps = -eps;
    end
    strain = [0 0;0 0];
    if (strainComp == 1)
        strain(1, 1) = eps;
    elseif (strainComp == 2)
        strain(2, 2) = eps;
    elseif (strainComp == 3)
        strain(1, 2) = eps;
        strain(2, 1) = eps;
    end
    strainVoight(1) = strain(1, 1);
    strainVoight(2) = strain(2, 2);
    strainVoight(3) = 2 * strain(1, 2);
    stressVoight = (1 - D) * stiff * strainVoight';
    
    stress(1, 1) = stressVoight(1);
    stress(2, 2) = stressVoight(2);
    stress(1, 2) = stressVoight(3);
    stress(2, 1) = stressVoight(3);
    
    rawData.data{1}{i} = strainVoight(1);
    rawData.data{2}{i} = strainVoight(2);
    rawData.data{3}{i} = strainVoight(3);
    
    rawData.data{4}{i} = stressVoight(1);
    rawData.data{5}{i} = stressVoight(2);
    rawData.data{6}{i} = stressVoight(3);
    
    rawData.data{7}{i} = d;
    rawData.data{8}{i} = factPower * t;
end

% x = rawData.getDataVectorByDataName('zpr_stnst_xx');
% y = rawData.getDataVectorByDataName('zpr_stssh_xx');
% plot(x, y);
