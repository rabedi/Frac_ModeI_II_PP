classdef ftexMap < handle
    %energyFrontClass used to store energy outputs
    
    properties(Access = public)
        numFields;    %columns of storage matrix
    end
    
    properties(Access = private)
        names = {};
        latex = {};
        
        % stress strain state 1: Philip's old data
        stressstrainStart;
        stressstrainEnd;
        
        % 2019: new sigma epsilon fields: the names start with zpr, those
        % are read from configAllRunsSyncNew and are put here

        % stress strain state 2: Reza's raw strain stress post process data
        % plus bunch of other fields processed from sync files
        zpr_fieldBaseNames = {};
        zpr_fieldLatexNames = {};

        % these are post-processed fields such as homogenized damage,
        % energies, ...
        % stress strain state 3: homogenized from previous data: includes
        % things such as homogenized damage, ...
        zpp_fieldBaseNames = {};
        zpp_fieldLatexNames = {};
    end
    
    methods(Access = public)
       
        function obj = ftexMap(fileName, configAllRunsSyncNew)
            if nargin == 0
                fileName = 'none';
            end
            if (strcmp(fileName, 'none') == 0)
                obj.readLatexNameFile(fileName)
            else
                obj.hardSet();
            end
            if ((nargin > 1) && (~isempty(configAllRunsSyncNew)))
                obj.setNewConfigFldLatexNames(configAllRunsSyncNew);
            end
    end
        
        function readLatexNameFile(obj,latexFile)
            spacer = '&';
            fid = fopen(latexFile,'r');
            if fid < 1
               msg = sprintf('input file is inaccessible{%s}.',latexFile);
               THROW(msg); 
            end

            pool = [];
            %BEGIN READ
            buf = READ(fid,'s');
            obj.numFields = READ(fid,'i');
            for i = 1:obj.numFields
            buf = READ(fid,'s');
            [~,status] = str2num(buf);
            if status ~= 1           
                THROW('invalid index')
            end
            index = str2num(buf) + 1;
            if any(pool == index) == 1
               msg = sprintf('field latex string index (%i) repeated',index-1);
               THROW(msg);
            end
            pool = [pool,index];

            obj.names{index} = READ(fid,'s');
            obj.latex{index} = READ(fid,'s');

            found = strfind(obj.latex{index},spacer);
            obj.latex{index}(found) = ' ';
            end        
        end
        
        function hardSet(obj)                        
            obj.names{1}='D';       obj.latex{1}='D';
            obj.names{2}='cr';      obj.latex{2}='\eta';
            obj.names{3}='str';     obj.latex{3}='\gamma';
            obj.names{4}='ba';      obj.latex{4}='a_B';
            obj.names{5}='sa';      obj.latex{5}='a_S';
            obj.names{6}='ca';      obj.latex{6}='a_C';
            obj.names{7}='sta';     obj.latex{7}='a_{ST}';
            obj.names{8}='sla';     obj.latex{8}='a_{SL}';
            obj.names{9}='pf';      obj.latex{9}='f_p';
            obj.names{10}='p';      obj.latex{10}='p';
            obj.names{11}='df';     obj.latex{11}='D_f';
            obj.names{12}='ds';     obj.latex{12}='D_s';
            obj.names{13}='ldid';   obj.latex{13}='L_{i}|i'; %
            obj.names{14}='dset';   obj.latex{14}='DSET'; %
            obj.names{15}='delu0';  obj.latex{15}='\Delta u_{n}';
            obj.names{16}='delu1';  obj.latex{16}='\Delta u_{t}';
            obj.names{17}='delus';  obj.latex{17}='|\Delta \mathbf{u}|';
            obj.names{18}='s0';     obj.latex{18}='s_{n}';
            obj.names{19}='s1';     obj.latex{19}='s_{t}';
            obj.names{20}='ss';     obj.latex{20}='|\mathbf{s}|';
            obj.names{21}='delv0';  obj.latex{21}='\Delta v_{1}';
            obj.names{22}='delv1';  obj.latex{22}='\Delta v_{2}';
            obj.names{23}='delvs';  obj.latex{23}='|\mathbf{v}|';
            obj.names{24}='uin0';   obj.latex{24}='u_{1}';
            obj.names{25}='uin1';   obj.latex{25}='u_{2}';
            obj.names{26}='uins';   obj.latex{26}='|\mathbf{u}|';
            obj.names{27}='uout0';  obj.latex{27}='u^-_{1}';
            obj.names{28}='uout1';  obj.latex{28}='u^-_{2}';
            obj.names{29}='uouts';  obj.latex{29}='|\mathbf{u}^-|';
            
            %ENERGIES
            count = 30;
            for r = 1:9
                for c = 1:8
                    title = '';
                    switch r
                        case 1
%                            title = 'outflowOc';
                            title = 'o';
                        case 2
%                            title = 'inflowIC';
                            title = '{IC}';
                        case 3
%                            title = 'inflowBC';
                            title = '{BC}';
                        case 4
%                            title = 'inflowICBC';
                            title = 'i';
                        case 5
%                            title = 'lossBody';
                            title = '\Omega';
                        case 6
%                            title = 'lossInterface';
                            title = '\mathcal{I}';
                        case 7
%                            title = 'lossPhysical';
                            title = '\mathcal{P}';
                        case 8
%                            title = 'lossNumeric';
                            title = '\mathcal{N}';
                        case 9
%                            title = 'lossTotal';
                            title = '\mathcal{T}';
                    end

                    fld = '';
                    eBaseName = '\mathcal{E}';
                    if r == 5 || r == 6 || r == 7 || r == 8 || r == 9
                        eBaseName = '\Delta';
                    end
                    switch c
                        case 1
%                            fld = 'E\cdot n_{all}';                           
                            fld = eBaseName;
                        case 2
%                            fld = 'E\cdot n_{t}';
                            fld = [eBaseName,'_{t}'];
                        case 3
%                            fld = 'E\cdot n_{x}';
                            fld = [eBaseName,'_{x}'];
                        case 4
%                            fld = 'E\cdot n_{s}';
                            fld = [eBaseName,'_{s}'];
                        case 5
                            fld = 'K';
                        case 6
                            fld = 'U';
                        case 7
                            fld = 'P';
                        case 8
                            fld = 'B';
                    end
                    
                    obj.names{count}=sprintf('EN%02d%02d',c,r);
                    obj.latex{count}=sprintf('%s^{%s}',fld,title);
                    count = count + 1;

                end
            end
            %STRESSSTRAINS
            obj.stressstrainStart = count + 1;
            % t s00L s00R s01L s01R e00 e01 s11T s11B s10T s10B e11 e10
            obj.names{count+1}='t';         obj.latex{count+1}='t';
            obj.names{count+2}='s00L';     obj.latex{count+2}='\sigma^{L}_{xx}';
            obj.names{count+3}='s00R';     obj.latex{count+3}='\sigma^{R}_{xx}';
            obj.names{count+4}='s01L';     obj.latex{count+4}='\sigma^{L}_{xy}';
            obj.names{count+5}='s01R';     obj.latex{count+5}='\sigma^{R}_{xy}';
            obj.names{count+6}='e00';      obj.latex{count+6}='\epsilon_{xx}';
            obj.names{count+7}='e01';      obj.latex{count+7}='\epsilon_{xy}';
            obj.names{count+8}='s11T';     obj.latex{count+8}='\sigma^{T}_{yy}';
            obj.names{count+9}='s11B';     obj.latex{count+9}='\sigma^{B}_{yy}';
            obj.names{count+10}='s10T';     obj.latex{count+10}='\sigma^{T}_{yx}';
            obj.names{count+11}='s10B';     obj.latex{count+11}='\sigma^{B}_{yx}';
            obj.names{count+12}='e11';      obj.latex{count+12}='\epsilon_{yy}';
            obj.names{count+13}='e10';      obj.latex{count+13}='\epsilon_{yx}';
            obj.stressstrainEnd = count + 13;
            
            obj.numFields = length(obj.names);
        end
        
        function setNewConfigFldLatexNames(obj, configAllRunsSyncNew)
            obj.zpr_fieldBaseNames = configAllRunsSyncNew.fld2printInBriefRaw;
            obj.zpr_fieldLatexNames = configAllRunsSyncNew.fld2printInBriefRawLatexName;
            
            obj.zpp_fieldBaseNames = configAllRunsSyncNew.fld2printInBriefPP;
            obj.zpp_fieldLatexNames = configAllRunsSyncNew.fld2printInBriefPPLatexName;
        end

        function [latexString, index] = find(obj,str)
%             if (strncmp(str, 'zp', 2) == 1)
%                 str
%                 THROW('Function [latexString, index] = find(obj,str) should not have been called for new stress strain pp data\n');
%             end
        	[valid, ssState, index, latexString] = obj.newSSIndex(str);
            if (valid == 1)
                return;
            end

            latexString = '';
            index = [];
            
            tmpLatex = find(cellfun(@(x) strcmp(x,str),obj.names,'UniformOutput',true));
            if isempty(tmpLatex)
                return;
            else                
                if length(tmpLatex) > 1
                    THROW('field name conflict. consider renaming field to avoid name conflicts.');
                end            
                latexString = obj.latex{tmpLatex};
                index = [tmpLatex(1)];
            end
        end
        
        function [isSS, index] = isStressStrain(obj, str)
        	[valid, isSS, index, latexString] = obj.newSSIndex(str);
            if (valid == 1)
                return;
            end

            isSS = 0;
            index = -1;
            [~, indexAll] = obj.find(str);
            
            if isempty(indexAll)
                return;
            end
            
            if (indexAll >= obj.stressstrainStart && indexAll <= obj.stressstrainEnd)
                isSS = 1;
                index = indexAll - obj.stressstrainStart + 1;
            end            
        end
        
        

        % fields starting with ss
        function [valid, ssState, index, latexName] = newSSIndex(obj, str)
            ssState = [];
            index = [];
            latexName = [];
            valid = 0;
            if (strncmp(str, 'zpr', 3) == 1)
                ssState = 2;
                index = -1;
                for i = 1:length(obj.zpr_fieldBaseNames)
                    if (strcmp(str, obj.zpr_fieldBaseNames{i}) == 1)
                        index = i;
                        break;
                    end
                end
                if (index > 0)
                    latexName = obj.zpr_fieldLatexNames{index};
                elseif (contains(str, 'serial'))
                    latexName = '\mathrm{serial\ number}';
                elseif (contains(str, 'xvals'))
                    latexName = '\mathrm{serial value}';
                elseif (contains(str, 'time'))
                    latexName = '\mathrm{time}';
                else
                    msg = [str, ' <- this field. New data field, zpr, this field should first be given in _configSyncNew (under fld2printInBriefRaw) as pairs of field name and field latex name. Make sure these fields are first given there before using them in plot instructions.'];
                    THROW(msg);
                end
                valid = 1;
            elseif (strncmp(str, 'zpp', 3) == 1)
                ssState = 3;
                index = -1;
                for i = 1:length(obj.zpp_fieldBaseNames)
                    if (strcmp(str, obj.zpp_fieldBaseNames{i}) == 1)
                        index = i;
                        break;
                    end
                end
                if (index > 0)
                    latexName = obj.zpp_fieldLatexNames{index};
                else
                    msg = [str, ' <- this field. New data field, zpp, this field should first be given in _configSyncNew (under fld2printInBriefPP) as pairs of field name and field latex name. Make sure these fields are first given there before using them in plot instructions.'];
                    THROW(msg);
                end
                valid = 1;
            end
        end
    end
end