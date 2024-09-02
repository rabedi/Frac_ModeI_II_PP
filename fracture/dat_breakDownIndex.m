function [criticalPtType, dataSet, nm, dir] = dat_breakDownIndex(dataIndex)

% N below is one integer in the following format
% 0 nonnormalized values obtained
% > 0 normalized set N is used to normalize the value

% dataIndex =  
%     (ab)(N)dir   (ab) two digits           (ab) field
%               dir direction
%     (cd)(ab)(N)dir   (ab) (cd) two digits  (ab) field (cd)
%     criticalPt type  dir direction

% example   921: direction 1 data type 9  normalization 2
% example   902: direction 2 data type 9  No normalization
%           30902: direction 2, data type 9, critical type 3,
%           nonormalization

remaining10000 = mod(dataIndex, 10000);
criticalPtType = (dataIndex - remaining10000) / 10000;
remainingNormalizationDir = mod(remaining10000, 100);
dir = mod(remainingNormalizationDir, 10);
% normalization mode
nm = (remainingNormalizationDir - dir) / 10;
dataSet = (remaining10000 - 10 * nm - dir) / 100;
