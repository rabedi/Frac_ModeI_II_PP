%{
Vector_pSpec class represents a vector of pSpec class objects

Created: 4/7/2016
%}
classdef Vector_pSpec < handle
    properties(Access = public)
        pSpecs;     %cell array of pSpecs class objects
        version;    %configuration scheme for reading version
        numFields;  %number of output fields; should be the size of pSpecs
        map;
        
        LimitSchemes = {};      %cell array of limit schemes
        field2Scheme = {};      %map between field and index of 'LimitSchemes' field uses 
    end
    
    properties(Access = private)
        
    end
    
    methods(Access = public)
        function obj = Vector_pSpec(num_elements)
            if nargin < 1
                obj.numFields = 0;
                obj.pSpecs = {};
                obj.map = {};
            else
                obj.numFields = num_elements;
                obj.pSpecs = cell(num_elements,1);
                obj.map = cell(num_elements,1);
            end
        end
        
        function reset(obj)
            %Empty for now...
        end
        
        function setVersion(obj,ver)
            obj.version = ver; 
        end
        
        function resize(obj,sz)
           orig_size = size(obj.pSpecs); osize = orig_size(1);
           
           if (sz < osize)
               for (i = sz + 1:osize)
                  obj.pSpecs{i,1} = [];
                  obj.pSpecs(i,:) = [];
                  
                  obj.map{i,1} = [];
                  obj.map(i,:) = [];
               end
               obj.numFields = sz;
           elseif (sz == osize)
               return;
           else
               for (i = osize+1 : sz)
                  obj.pSpecs{i,1} = [];
                  obj.map{i,1} = [];
               end 
               obj.numFields = sz;
           end
        end
        
        function readName(obj, field_str, field_enum)
            obj.pSpecs{field_enum + 1} = pSpec(field_str,field_enum);
            obj.map{field_enum + 1} = field_str;
        end
        
        function insertLimitScheme(obj, lsClassObj)
%           len = length(obj.LimitScheme);
           obj.LimitSchemes{lsClassObj.index} = lsClassObj;
           return;
        end
        
        function sch = getLimitScheme(obj,fld)
           for i = 1:length(obj.field2Scheme)
               testfld = obj.field2Scheme{i}.field;
               ind = obj.field2Scheme{i}.limitIndex;
              if (strcmp(fld,testfld) == 1)
                  sch = obj.LimitSchemes{ind};
                  return;
              end
           end
           THROW(['ERROR:(',fld,') is not a valid field']);
        end
        
        function insertField2Scheme(obj,tempObj)
            for i = 1:length(tempObj.field)
                tmpObj = struct('field',[],'limitIndex',[]);
                tmpObj.field = tempObj.field{i};
                tmpObj.limitIndex = tempObj.limitIndex;
                obj.field2Scheme{length(obj.field2Scheme)+1} = tmpObj;
            end
        end
        
        function bool = haveScheme(obj,fld)
            bool = 0;
            for i = 1:length(obj.field2Scheme)
              tempfld = obj.field2Scheme{i}.field;
              if (strcmp(fld,tempfld) == 1)
                  bool = 1;
                  return;
              end
            end
           return;
        end
        
        function enumStrOrVal = find(obj,enumValOrStr)
           if isnumeric(enumValOrStr)
               enumStrOrVal = obj.map{enumValOrStr + 1};
               return;
           else
               orig_size = size(obj.pSpecs); osize = orig_size(1);
               for f = 1 : osize 
                   if strcmp(obj.map{f},enumValOrStr) == 1
                       enumStrOrVal = f - 1 ;
                       return;
                   end
               end
               THROW(['ERROR: file('+ enumValOrStr +') is invalid field option']);
           end
        end
    end
    
    methods(Access = private)
        
    end
    
end
