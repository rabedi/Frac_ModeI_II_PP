function [stiffness, compliance] = el_ComputeVoigtStiffnessCompliance(E, nu, planeStrain, dim)

addpath('../');
if nargin < 1
    E = 1;
end
if nargin < 2
    nu = 0.3;
end
if nargin < 3
    planeStrain = 1;
end

if nargin < 4
    if ((planeStrain == 0) || (planeStrain == 1))
        dim = 2;
    else
        THROW('dimension not specified\n');
    end
end

if (dim == 2)
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
    stiffness = [A B 0;B A 0; 0 0 C];
elseif (dim == 1)
    stiffness = E;
elseif (dim == 3)
    THROW('Implement stiffness for 3D\n');
end

compliance = inv(stiffness);