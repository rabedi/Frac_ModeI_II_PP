classdef mDefaults < handle
    %energyFrontClass used to store energy outputs
    
    properties(Access = public)
        figureDefaults = {};
        lineDefaults = {};
        axisDefaults = {};
        legendDefaults = {};
    end
    
    properties(Access = private)

    end
    
    methods(Access = public)
        function obj = mDefaults(fid)
            figSpecs = struct('visible',0,...
                'fullscreen',0,...
                'save',struct('active',1,'exts',{{}}));
            lineSpecs = struct('line',createLineSpec(),...
                'bfit',createLineSpec());
            axisSpecs = struct('fontSize',20,...
                'interpreter','latex',...
                'ticsActive',1,...
                'gridOn',1,...
                'xLabVAlign','top',...
                'yLabVAlign','top',...
                'zLabVAlign','top',...
                'xLimit',limitstruct(),...
                'yLimit',limitstruct(),...
                'zLimit',limitstruct());
            legSpecs = struct('location','northeast',...
                'orientation','vertical',...
                'in_out','inside',...
                'fontSize',18,...
                'interpreter','latex',...
                'boxOn',0,...
                'boxWidth','default');
            
            obj.figureDefaults = figSpecs;
            obj.lineDefaults = lineSpecs;
            obj.axisDefaults = axisSpecs;
            obj.legendDefaults = legSpecs;
            
            if nargin < 1
                obj.hardSet();
            elseif fid < 1 
                obj.hardSet();
            else
                obj.read(fid);
            end
       
        end
        
        function read(obj,fid)
           if fid < 1
               msg = sprintf('input file became accessible:fid{%i}.',fid);
               THROW(msg); 
            end

            %BEGIN READ
            buf = READ(fid,'s');
            if strcmpi(buf,'{') == 1
                buf = READ(fid,'s');
                while strcmpi(buf,'}') ~= 1
                    if ~isempty(strfind(buf,'fig_'))
                        found = strfind(buf,'fig_');
                        buf = buf(found+length('fig_'):end);
                        if strcmpi(buf,'visible')==1
                            tmp = READ(fid,'b');
                            if tmp == 1
                                obj.figureDefaults.visible = 'on';
                            elseif tmp == 0
                                obj.figureDefaults.visible = 'off';
                            else
                                THROW('boxOn must either be 0 or 1 value');                                
                            end                            
                        elseif strcmpi(buf,'fullscreen')==1
                            obj.figureDefaults.fullscreen = READ(fid,'b');
                        elseif strcmpi(buf,'save')==1    
                            obj.figureDefaults.save.active = READ(fid,'b');
                            obj.figureDefaults.save.exts = READ(fid,'s','{}');
                        else
                            THROW('invalid option');
                        end
                    elseif ~isempty(strfind(buf,'line_'))
                        found = strfind(buf,'line_');
                        buf = buf(found+length('line_'):end);
                        if strcmpi(buf,'all_spec')==1
                            obj.lineDefaults.line = readLineSpec(obj.lineDefaults.line,fid);
                        elseif strcmpi(buf,'bfit_spec')==1
                            obj.lineDefaults.bfit = readLineSpec(obj.lineDefaults.bfit,fid);
                        else
                            THROW('invalid option');
                        end
                    elseif ~isempty(strfind(buf,'ax_'))
                        found = strfind(buf,'ax_');
                        buf = buf(found+length('ax_'):end);
                        if strcmpi(buf,'fontsize')==1
                             obj.axisDefaults.fontSize = READ(fid,'d');
                        elseif strcmpi(buf,'interpreter')==1
                            obj.axisDefaults.interpreter = READ(fid,'s');
                        elseif strcmpi(buf,'tic_active')==1
                            tmp = READ(fid,'b');
                            if tmp == 1
                                obj.axisDefaults.ticActive = 'on';
                            elseif tmp == 0
                                obj.axisDefaults.ticActive = 'off';
                            else
                                THROW('boxOn must either be 0 or 1 value');                                
                            end
                        elseif strcmpi(buf,'grid_on')==1
                            tmp = READ(fid,'b');
                            if tmp == 1
                                obj.axisDefaults.gridOn = 'on';
                            elseif tmp == 0
                                obj.axisDefaults.gridOn = 'off';
                            else
                                THROW('boxOn must either be 0 or 1 value');                                
                            end
                        elseif strcmpi(buf,'xlab_vert_align')==1
                            obj.axisDefaults.xLabVAlign = READ(fid,'s');
                        elseif strcmpi(buf,'ylab_vert_align')==1
                            obj.axisDefaults.yLabVAlign = READ(fid,'s');
                        elseif strcmpi(buf,'zlab_vert_align')==1
                            obj.axisDefaults.zLabVAlign = READ(fid,'s');
                        elseif strcmpi(buf,'x_limit')==1
                            obj.axisDefaults.xLimit = readLimits(obj.axisDefaults.xLimit,fid);
                        elseif strcmpi(buf,'y_limit')==1
                            obj.axisDefaults.yLimit = readLimits(obj.axisDefaults.yLimit,fid);
                        elseif strcmpi(buf,'z_limit')==1 
                            obj.axisDefaults.zLimit = readLimits(obj.axisDefaults.zLimit,fid);
                        else
                            THROW('invalid option');
                        end
                    elseif ~isempty(strfind(buf,'leg_'))
                        found = strfind(buf,'leg_');
                        buf = buf(found+length('leg_'):end);
                        if strcmpi(buf,'location')==1
                             obj.legendDefaults.location = READ(fid,'s');
                        elseif strcmpi(buf,'orientation')==1
                            obj.legendDefaults.orientation = READ(fid,'s');
                        elseif strcmpi(buf,'in_or_out')==1
                            obj.legendDefaults.in_out = READ(fid,'s');
                        elseif strcmpi(buf,'fontsize')==1
                            obj.legendDefaults.fontSize = READ(fid,'d');
                        elseif strcmpi(buf,'interpreter')==1
                            obj.legendDefaults.interpreter = READ(fid,'s');
                        elseif strcmpi(buf,'box_on')==1
                            tmp = READ(fid,'b');
                            if tmp == 1
                                obj.legendDefaults.boxOn = 'on';
                            elseif tmp == 0
                                obj.legendDefaults.boxOn = 'off';
                            else
                                THROW('boxOn must either be 0 or 1 value');                                
                            end
                        elseif strcmpi(buf,'box_width')==1
                            obj.legendDefaults.boxWidth = READ(fid,'d');
                        else
                            THROW('invalid option');
                        end
                    else
                        THROW('invalid option');
                    end
                    buf = READ(fid,'s');
                end
            else
                msg = sprintf('block must begin with "{" character. invalid{%s}',buf);
                THROW(msg);  
            end 
            obj.setMatlabLineDefaults();
        end
        
        function hardSet(obj)
            obj.figureDefaults.visible = 'on';
            obj.figureDefaults.fullscreen = 1;
            obj.figureDefaults.save.active = 1;
            obj.figureDefaults.save.exts = {'png','fig','eps'};
            
            obj.lineDefaults.line.ms = 'o';
            obj.lineDefaults.line.ls = 'none';
            obj.lineDefaults.line.lc = RGB('b'); % = '' for random colour select 
            obj.lineDefaults.line.lw = 2.0;
            obj.lineDefaults.bfit.ms = 'none';
            obj.lineDefaults.bfit.ls = '-';
            obj.lineDefaults.bfit.lc = RGB('b'); % = '' for random colour select
            obj.lineDefaults.bfit.lw = 2.0;
            
            obj.axisDefaults.fontSize = 30;
            obj.axisDefaults.interpreter = 'latex';
            obj.axisDefaults.ticActive = 'on';
            obj.axisDefaults.gridOn = 'on';
            obj.axisDefaults.xLabVAlign = 'top';
            obj.axisDefaults.yLabVAlign = 'top';
            obj.axisDefaults.zLabVAlign = 'top';
            obj.axisDefaults.xLimit = limitstruct();
            obj.axisDefaults.yLimit = limitstruct();
            obj.axisDefaults.zLimit = limitstruct();
            
            obj.legendDefaults.location = 'northeast';
            obj.legendDefaults.orientation = 'vertical';
            obj.legendDefaults.in_out = 'inside';
            obj.legendDefaults.fontSize = 24;
            obj.legendDefaults.interpreter = 'latex';
            obj.legendDefaults.boxOn = 'off';
            obj.legendDefaults.boxWidth = 1.0;
            
            obj.setMatlabLineDefaults();
        end
        
        function lsObj = setLineDefaults(obj,lsObj)
            if isempty(lsObj.ls)
                lsObj.ls = obj.lineDefaults.line.ls;
            end
            if isempty(lsObj.lc)
                lsObj.lc = obj.lineDefaults.line.lc;
            end
            if isempty(lsObj.lw)
                lsObj.lw = obj.lineDefaults.line.lw;
            end
            if isempty(lsObj.ms)
                lsObj.ms = obj.lineDefaults.line.ms;
            end
            if isempty(lsObj.mw)
                lsObj.mw = obj.lineDefaults.line.mw;
            end
        end
        
        function lsObj = setBestFitLineDefaults(obj,lsObj)
            if isempty(lsObj.ls)
                lsObj.ls = obj.lineDefaults.bfit.ls;
            end
            if isempty(lsObj.lc)
                lsObj.lc = obj.lineDefaults.bfit.lc;
            end
            if isempty(lsObj.lw)
                lsObj.lw = obj.lineDefaults.bfit.lw;
            end
            if isempty(lsObj.ms)
                lsObj.ms = obj.lineDefaults.bfit.ms;
            end
            if isempty(lsObj.mw)
                lsObj.mw = obj.lineDefaults.bfit.mw;
            end
        end
    end
    
    methods (Access = private)
        function setMatlabLineDefaults(obj)
            %GENERAL LINE DEFAULTS
            if isempty(obj.lineDefaults.line.ls)
                obj.lineDefaults.line.ls = '-';
            end
            if isempty(obj.lineDefaults.line.lc)
                obj.lineDefaults.line.lc = [];
            end
            if isempty(obj.lineDefaults.line.lw)
                obj.lineDefaults.line.lw = 0.5;
            end
            if isempty(obj.lineDefaults.line.ms)
                obj.lineDefaults.line.ms = 'none';
            end
            if isempty(obj.lineDefaults.line.mw)
                obj.lineDefaults.line.mw = 6.0;
            end
            %BESTFIT LINE DEFAULTS
            if isempty(obj.lineDefaults.bfit.ls)
                obj.lineDefaults.bfit.ls = '-';
            end
            if isempty(obj.lineDefaults.bfit.lc)
                obj.lineDefaults.bfit.lc = [];
            end
            if isempty(obj.lineDefaults.bfit.lw)
                obj.lineDefaults.bfit.lw = 0.5;
            end
            if isempty(obj.lineDefaults.bfit.ms)
                obj.lineDefaults.bfit.ms = 'none';
            end
            if isempty(obj.lineDefaults.bfit.mw)
                obj.lineDefaults.bfit.mw = 6.0;
            end
        end
    end
    
end