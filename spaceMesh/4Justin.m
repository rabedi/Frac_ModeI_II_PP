
in zpp_DamageHomoge.. 1R
here
.// last two change based on i
        function objout = Process(obj, rawDataIn, scalarStrsVoigtPos, scalarStrsVoigtPos)
for the function, send scalarStrsVoigtPos and scalarStrsSign as your input arguments of the function and comment out this block, replace it with one that uses input argumetns, 
ptCheck = 2;
            if (isnan(obj.scalarStrsVoigtPos)) % dominant component not chosen
                sig = vstress{ptCheck};
                [mx, obj.scalarStrsVoigtPos] = max(abs(sig));
            end
            if (isnan(obj.scalarStrsSign))
                obj.scalarStrsSign = sign(sig(obj.scalarStrsVoigtPos));
            end

            
            classdef gen_map < handle
    properties(Access = public)
        keys = cell(0);
        valsStr = cell(0);
    end
