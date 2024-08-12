function [AllSVEData] = ProcessAllSVEs(TotalSVENumber)
% This function is used to loop through each SVE and process each one
% individually. Boolean determines whether data is processed for interior
% or boundary stresses.

InteriorStressBool = 1; % If 1, then process with interior (average) stresses, if 0 process for boundary stresses.
RVENumberString = 'RVE0';

    if nargin < 1
        TotalSVENumber = 1;
        SVENumberString = 'SVE0';
        ProcessSVEs(RVENumberString,SVENumberString,InteriorStressBool);
        return
    end

    for i = 1:TotalSVENumber
        SVENumber = i-1;
        SVENumber = num2str(SVENumber);
        SVENumberString = strcat('SVE',SVENumber);
        zppCell = ProcessSVEs(RVENumberString,SVENumberString,InteriorStressBool);
        AllSVEData{i} = zppCell;
    end
end