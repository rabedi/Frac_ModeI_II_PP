%{
pSpec class allows the data and configuration information for single field
to be stored.

Created: 4/7/2016
%}
classdef pSpec  < handle
    
    properties(Access = public)
 %       LEGEND;                                                             %access handle for manual legend class
        Field = struct('NAME',[],'ENUM',[]);                                %allows enumeration value to be linked to field name e.g. D(0), str(2)
        LimitInd = -1;
    
        xdat = [];
        ydat = [];
        lclr = {};
        lstyle = {};
        lwidth = {};
    end
    
    properties(Access = private)
        
    end
    
    methods(Access = public)
        function obj = pSpec(field_str,field_enum)
            obj.Field.NAME = field_str;
            obj.Field.ENUM = field_enum;
        end
    end
    
    methods(Access = private)
        
    end
    
end