classdef energyFrontClass < handle
    %energyFrontClass used to store energy outputs
    % Energy storage matrix is indexed EN(fld,loss_gain)
    
    properties(Access = public)
        numFields;    %rows of storage matrix
        numInputLoss;  %columns of storage matrix
    end
    
    properties(Access = private)
        EN;     %energies
        namePrefix
    end
    
    methods(Access = public)
        function obj = energyFrontClass(energyFilePath)
            obj.numFields = 0;
            obj.numInputLoss = 0;

            obj.EN = [];
            if nargin > 0
                obj.read(energyFilePath);
            end
            obj.namePrefix = 'EN';
        end    
        
        function AllEnergies = getAllEnergies(obj)
            AllEnergies = obj.EN;
        end
        
        function obj = resize(obj,numField,numGainLosses)
            if numField < 0
                numField = 0;
            end
            if numGainLosses < 0
                numGainLosses = 0;
            end

            obj.numFields = numField;
            obj.numInputLoss = numGainLosses;
            
            obj.EN = NaN.*ones(numField,numGainLosses);
        end
        
        function sz = size(obj)
            sz = [];
            sz(1) = obj.numFields;
            sz(2) = obj.numInputLoss;            
        end
        
        function bool = isempty(obj)
            bool  = 0;
            sz = obj.size();
            if sz(1)==0 || sz(2)==0
                bool = 1;
            end
        end
        
        function val = get(obj,r,c)
            val = NaN;
            if validIndices(obj,r,c) == 1
                val = obj.EN(r,c);
            end
        end
        
        function val = staticGetByStr(obj,ENin,indStrIn)
            [indStr,valid] = validString(obj,indStrIn);
            if (valid ~= 1)
                msg = sprintf('Invalid energy indexing{%s}',indStrIn);
                THROW(msg);
            end
            
            [r,status] = str2num(indStr(1:2));
            if (status ~= 1)
                msg = sprintf('Invalid energy indexing{%s}',indStr(1:2));
                THROW(msg);
            end
            [c,status] = str2num(indStr(3:4));
            if (status ~= 1)
                msg = sprintf('Invalid energy indexing{%s}',indStr(3:4));
                THROW(msg);
            end
            
            tmpEN = obj.EN;
            obj.EN = ENin;
            val = get(obj,r,c);
            obj.EN = tmpEN;
        end
        
        function val = getByStr(obj,indStrIn)
            [indStr,valid] = validString(obj,indStrIn);
            if (valid ~= 1)
                msg = sprintf('Invalid energy indexing{%s}',indStrIn);
                THROW(msg);
            end
            
            [r,status] = str2num(indStr(1:2));
            if (status ~= 1)
                msg = sprintf('Invalid energy indexing{%s}',indStr(1:2));
                THROW(msg);
            end
            [c,status] = str2num(indStr(3:4));
            if (status ~= 1)
                msg = sprintf('Invalid energy indexing{%s}',indStr(3:4));
                THROW(msg);
            end
            val = get(obj,r,c);
        end
        function obj = set(obj,r,c,val)
            if validIndices(obj,r,c) == 1
                obj.EN(r,c) = val;
            end
        end
        function obj = setByStr(obj,indStrIn,val)
            [indStr,valid] = validString(obj,indStrIn);
            if (valid ~= 1)
                msg = sprintf('Invalid energy indexing{%s}',indStrIn);
                THROW(msg);
            end
            
            [r,status] = str2num(indStr(1:2));
            if (status ~= 1)
                msg = sprintf('Invalid energy indexing{%s}',indStr(1:2));
                THROW(msg);
            end
            [c,status] = str2num(indStr(3:4));
            if (status ~= 1)
                msg = sprintf('Invalid energy indexing{%s}',indStr(3:4));
                THROW(msg);
            end
            obj.set(r,c,val);
        end
        
        function bool = read(obj,filePath)
            bool = 1;
            
            fid = fopen(filePath,'r');
            if fid < 1
                bool = 0;
                return;
            end
            buf = READ(fid,'s');
            numFlds = READ(fid,'i');
            buf = READ(fid,'s');
            numGnL = READ(fid,'i');
            obj.resize(numFlds,numGnL);
            headers = READ(fid,'s',(1+numFlds));
            for r = 1:numGnL
                buf = READ(fid,'s');
                for c = 1:numFlds                   
                    val = READ(fid,'d');
                    obj.set(c,r,val);
                end
            end
            fclose(fid);
        end
        
        function [numericString,valid] = validString(obj,str)
            valid = 1;
            lenStr = length(str);
            lenPre = length(obj.namePrefix);
            found = strfind(str,obj.namePrefix);
            prefixFound = ~isempty(found);
            
            if (lenStr ~= 4 && ~prefixFound) || (prefixFound == 1 && (length(found) > 1 || lenStr ~= (4+lenPre)))
%                 msg = sprintf('Invalid energy indexing{%s}',str);
%                 THROW(msg);
                numericString = [];
                valid = 0;
                return;
            end
            
            if prefixFound == 1
                numericString = str(found+lenPre:end);
            else
                numericString = str;
            end
            
        end
    end
    
    methods(Access = public)
        function bool = validIndices(obj,r,c)
            bool = 1;
            sz = size(obj);
            if r < 1 || r > sz(1) || c < 1 || c > sz(2)
                bool = 0;
            end
        end
        
        
    end
 
end

