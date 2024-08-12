classdef aSDG_old_run_summary1R1cp % data for one critical point / time
    properties
        valid = 0;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % from front and sync front files
        % serial number for front and sync front
        cpDatFront = aSDG_old_run_summary1R1cp1frnt; 
        cpDatSyncFront = aSDG_old_run_summary1R1cp1frnt; 
        
        % these are for the non-synchronized front
        timeMin_front = nan;
        timeMax_front = nan;
        delTime_front = nan;

       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % from zpp file
        zppDat;
%        zppDatNames;

        % from zpr file
        zprDat;
%        zprDatNames;
    end
    methods
        function [scalarNames, scalarNamesLatex] = getNames(obj, zppScalarNames, zppScalarNamesLatex, zprScalarNames, zprScalarNamesLatex)
            pt = 1;
            scalarNames{pt} = 't_min';
            scalarNamesLatex{pt} = 't_{\mathrm{min}}';
            pt = pt + 1;
            
            scalarNames{pt} = 't_max';
            scalarNamesLatex{pt} = 't_{\mathrm{max}}';
            pt = pt + 1;

            scalarNames{pt} = 'delTime_front';
            scalarNamesLatex{pt} = '\Delta t';
            pt = pt + 1;
            
            prename = 'frnt_';
            [scalarNamesTmp, scalarNamesLatexTmp] = obj.cpDatFront.getNames(prename);
            sz = length(scalarNamesTmp);
            for i = 1:sz
                scalarNames{pt} = scalarNamesTmp{i};
                scalarNamesLatex{pt} =scalarNamesLatexTmp{i};
                pt = pt + 1;
            end
                
            prename = 'sync_';
            [scalarNamesTmp, scalarNamesLatexTmp] = obj.cpDatSyncFront.getNames(prename);
            sz = length(scalarNamesTmp);
            for i = 1:sz
                scalarNames{pt} = scalarNamesTmp{i};
                scalarNamesLatex{pt} =scalarNamesLatexTmp{i};
                pt = pt + 1;
            end

            sz = length(zppScalarNames);
            for i = 1:sz
                scalarNames{pt} = zppScalarNames{i};
                scalarNamesLatex{pt} =zppScalarNamesLatex{i};
                pt = pt + 1;
            end
 
            sz = length(zprScalarNames);
            for i = 1:sz
                scalarNames{pt} = zprScalarNames{i};
                scalarNamesLatex{pt} = zprScalarNamesLatex{i};
                pt = pt + 1;
            end
        end
        function vals = getScalarValues(obj)
            pt = 1;
            vals{pt} = obj.timeMin_front;
            pt = pt + 1;

            vals{pt} = obj.timeMax_front;
            pt = pt + 1;

            vals{pt} = obj.delTime_front;
            pt = pt + 1;
            
            valsTmp = obj.cpDatFront.getScalarValues();
            sz = length(valsTmp);
            for i = 1:sz
                vals{pt} = valsTmp{i};
                pt = pt + 1;
            end
                
            valsTmp = obj.cpDatSyncFront.getScalarValues();
            sz = length(valsTmp);
            for i = 1:sz
                vals{pt} = valsTmp{i};
                pt = pt + 1;
            end
            
            sz = length(obj.zppDat);
            for i = 1:sz
                vals{pt} = obj.zppDat(i);
                pt = pt + 1;
            end
            
            sz = length(obj.zprDat);
            for i = 1:sz
                vals{pt} = obj.zprDat(i);
                pt = pt + 1;
            end
        end
    end
end