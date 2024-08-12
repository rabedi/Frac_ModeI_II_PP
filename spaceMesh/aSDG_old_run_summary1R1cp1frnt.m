classdef aSDG_old_run_summary1R1cp1frnt % data for one front (e.g. sync or non-sync front) critical point
    properties
        time = nan;
        index = -1;
        sn = nan;

        %%%%% front front OR front sync files
        numNewCrack = nan;
        crackNewLength = nan;
        numAllCrack = nan;
        crackAllLength = nan;
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % EDenergyfrontSync_All_(sync_sn).txt
        % EDenergyfront_All_(patch_sn).txt
        energyFrontClass = energyFrontClass;   
        %%% number of elements Solved
        numElementsSolved = nan;
        
        % Dissipations
        dissipationBody = nan;
        dissipationInterface = nan;
        dissipationPhysics = nan; % sum of the two above
        dissipationNumerical = nan;
        dissipationTotal = nan;
        dissipationNumerical2Total = nan; % division of the two above
        
        % energies (U internal, K kinetic, T = U + K, xt = total of T
        % (temporal) and spatial
        % outflow
        eneOutflow_U = nan;
        eneOutflow_K = nan;
        eneOutflow_T = nan;
        eneOutflow_x = nan;
        eneOutflow_xt = nan; % sum of the last two
        % inflow
        eneInflow_U = nan;
        eneInflow_K = nan;
        eneInflow_T = nan;
        % Boundary condition power
        eneBC_P = nan;
        eneICBC = nan; % sum of the last two

        eneO2I = nan;
        eneDissNum2I = nan;
        enePhys2I = nan;
        
        % max energy errors per element
        maxErrorDissipation = nan;
        % fracture max error
        maxErrorInterface = nan;
    end
    methods
        function [objout, bool] = ComputeEnergies(obj, energyFullName, sn)
            computeNelementsErrorMax = 1;
            if (sn >= 0)
                [bool, obj.numElementsSolved, obj.maxErrorDissipation, obj.maxErrorInterface] = obj.energyFrontClass.read(energyFullName, computeNelementsErrorMax);
            else
                bool = 0;
                obj.numElementsSolved = nan;
                obj.maxErrorDissipation = nan;
                obj.maxErrorInterface = nan;
            end
                
            if (bool == 0) % energy file does not exist
                objout = obj;
                obj.dissipationBody = nan;
                obj.dissipationInterface = nan;
                obj.dissipationPhysics = nan;
                obj.dissipationNumerical = nan;
                obj.dissipationTotal = nan;
                obj.dissipationNumerical2Total = nan;
            
                obj.eneOutflow_U = nan;
                obj.eneOutflow_K = nan;
                obj.eneOutflow_T = nan;
                obj.eneOutflow_x = nan;
                obj.eneOutflow_xt = nan;

                obj.eneInflow_U = nan;
                obj.eneInflow_K = nan;
                obj.eneInflow_T = nan;
            
                obj.eneBC_P = nan;

                obj.eneICBC = nan;
            
               obj.eneO2I = nan;
               obj.eneDissNum2I = nan;
               obj.enePhys2I = nan;
               objout = obj;
               return;
            end

            fldAll = 1;
            fldNt = 2;
            fldNx = 3;
            % fldNs = 4;
            fldK = 5;
            fldU = 6;
            fldP = 7;
            % fldB = 8;

            eneOut = 1;
            eneIC = 2;
            eneBC = 3;
            eneICBC = 4;
            eneLossBody = 5;
            eneLossInteriorF = 6;
            eneLossPhys = 7;
            eneLossNum = 8;
            eneAll = 9;

            obj.dissipationBody = obj.energyFrontClass.get(fldAll, eneLossBody);
            obj.dissipationInterface = obj.energyFrontClass.get(fldAll, eneLossInteriorF);
            obj.dissipationPhysics = obj.energyFrontClass.get(fldAll, eneLossPhys);
            obj.dissipationNumerical = obj.energyFrontClass.get(fldAll, eneLossNum);
            obj.dissipationTotal = obj.energyFrontClass.get(fldAll, eneAll);
            if (abs(obj.dissipationTotal) > 0)
                obj.dissipationNumerical2Total = obj.dissipationNumerical / obj.dissipationTotal;
            else
                obj.dissipationNumerical2Total = nan;
            end
            
            obj.eneOutflow_U = obj.energyFrontClass.get(fldU, eneOut);
            obj.eneOutflow_K = obj.energyFrontClass.get(fldK, eneOut);
            obj.eneOutflow_T = obj.eneOutflow_U + obj.eneOutflow_K;
            obj.eneOutflow_x = obj.energyFrontClass.get(fldNx, eneOut);
            obj.eneOutflow_xt = obj.energyFrontClass.get(fldAll, eneOut);

            obj.eneInflow_U = obj.energyFrontClass.get(fldU, eneIC);
            obj.eneInflow_K = obj.energyFrontClass.get(fldK, eneIC);
            obj.eneInflow_T = obj.eneInflow_U + obj.eneInflow_K;
            
            obj.eneBC_P = obj.energyFrontClass.get(fldP, eneBC);

            obj.eneICBC = obj.energyFrontClass.get(fldAll, eneICBC);
            
            if (abs(obj.eneICBC) > 0)
               obj.eneO2I = obj.eneOutflow_xt / obj.eneICBC;
               obj.eneDissNum2I = obj.dissipationNumerical / obj.eneICBC;
               obj.enePhys2I = obj.dissipationPhysics / obj.eneICBC;
            end
            
            objout = obj;
        end
        function [scalarNames, scalarNamesLatex] = getNames(obj, prename)
            if nargin < 2
                prename = '';
            end
            pt = 1;
            scalarNames{pt} = [prename, 'time'];
            scalarNamesLatex{pt} = 't';
            pt = pt + 1;
            
            scalarNames{pt} = [prename, 'index'];
            scalarNamesLatex{pt} = 'i';
            pt = pt + 1;
            
            scalarNames{pt} = [prename, 'sn'];
            scalarNamesLatex{pt} = 'n';
            pt = pt + 1;
            
            scalarNames{pt} = [prename, 'numNewCrack'];
            scalarNamesLatex{pt} = 'n_{cr}^{\mathrm{new}}';
            pt = pt + 1;

            scalarNames{pt} = [prename, 'crackNewLength'];
            scalarNamesLatex{pt} = 'l_{cr}^{\mathrm{new}}';
            pt = pt + 1;

            scalarNames{pt} = [prename, 'numAllCrack'];
            scalarNamesLatex{pt} = 'n_{cr}';
            pt = pt + 1;

            scalarNames{pt} = [prename, 'crackAllLength'];
            scalarNamesLatex{pt} = 'l_{cr}';
            pt = pt + 1;

            scalarNames{pt} = [prename, 'numElementsSolved'];
            scalarNamesLatex{pt} = 'n_e';
            pt = pt + 1;

            ene = 'ene_';
%            eneLatex = '\mathcal{E}'
            prenameene = [prename, ene];

            scalarNames{pt} = [prenameene, 'dissipationBody'];
            scalarNamesLatex{pt} = '\Delta^\mathrm{B}';
            pt = pt + 1;
            
            scalarNames{pt} = [prenameene, 'dissipationInterface'];
            scalarNamesLatex{pt} = '\Delta^\mathrm{I}';
            pt = pt + 1;
            
            scalarNames{pt} = [prenameene, 'dissipationPhysics'];
            scalarNamesLatex{pt} = '\Delta^\mathrm{P}';
            pt = pt + 1;

            scalarNames{pt} = [prenameene, 'dissipationNumerical'];
            scalarNamesLatex{pt} = '\Delta^\mathrm{N}';
            pt = pt + 1;

            scalarNames{pt} = [prenameene, 'dissipationTotal'];
            scalarNamesLatex{pt} = '\Delta^\mathrm{T}';
            pt = pt + 1;

            scalarNames{pt} = [prenameene, 'dissipationNumerical2Total'];
            scalarNamesLatex{pt} = '\Delta^\mathrm{N}/\Delta^\mathrm{T}';
            pt = pt + 1;
            
            scalarNames{pt} = [prenameene, 'eneOutflow_U'];
            scalarNamesLatex{pt} = 'U^o';
            pt = pt + 1;

            scalarNames{pt} = [prenameene, 'eneOutflow_K'];
            scalarNamesLatex{pt} = 'K^o';
            pt = pt + 1;

            scalarNames{pt} = [prenameene, 'eneOutflow_T'];
            scalarNamesLatex{pt} = 'T^o';
            pt = pt + 1;

            scalarNames{pt} = [prenameene, 'eneOutflow_x'];
            scalarNamesLatex{pt} = '\mathcal{E}^o_x';
            pt = pt + 1;

            scalarNames{pt} = [prenameene, 'eneOutflow_xt'];
            scalarNamesLatex{pt} = '\mathcal{E}^o_{xt}';
            pt = pt + 1;

            
            scalarNames{pt} = [prenameene, 'eneInflow_U'];
            scalarNamesLatex{pt} = 'U^i';
            pt = pt + 1;

            scalarNames{pt} = [prenameene, 'eneInflow_K'];
            scalarNamesLatex{pt} = 'K^i';
            pt = pt + 1;

            scalarNames{pt} = [prenameene, 'eneInflow_T'];
            scalarNamesLatex{pt} = 'T^i';
            pt = pt + 1;
            
            scalarNames{pt} = [prenameene, 'eneBC_P'];
            scalarNamesLatex{pt} = '\mathcal{P}^{BC}';
            pt = pt + 1;
            
            scalarNames{pt} = [prenameene, 'eneICBC'];
            scalarNamesLatex{pt} = '\mathcal{E}^{\mathrm{in}}';
            pt = pt + 1;

            scalarNames{pt} = [prenameene, 'eneO2I'];
            scalarNamesLatex{pt} = '\mathcal{E}^{\mathrm{out}}/\mathcal{E}^{\mathrm{in}}';
            pt = pt + 1;

            scalarNames{pt} = [prenameene, 'eneDissNum2I'];
            scalarNamesLatex{pt} = '\Delta^{\mathrm{P}}/\Delta^{\mathrm{N}}';
            pt = pt + 1;
            
            scalarNames{pt} = [prenameene, 'enePhys2I'];
            scalarNamesLatex{pt} = '\Delta^{\mathrm{P}}/\mathcal{E}^{\mathrm{in}}';
            pt = pt + 1;

            scalarNames{pt} = [prenameene, 'maxErrorDissipation'];
            scalarNamesLatex{pt} = '\mathrm{max}(\varepsilon_D)';
            pt = pt + 1;

            scalarNames{pt} = [prenameene, 'maxErrorInterface'];
            scalarNamesLatex{pt} = '\mathrm{max}(\varepsilon_I)';
            pt = pt + 1;
        end
        function vals = getScalarValues(obj)
            pt = 1;
            vals{pt} = obj.time;
            pt = pt + 1;
            
            vals{pt} = obj.index;
            pt = pt + 1;
            
            vals{pt} = obj.sn;
            pt = pt + 1;

            vals{pt} = obj.numNewCrack;
            pt = pt + 1;

            vals{pt} = obj.crackNewLength;
            pt = pt + 1;

            vals{pt} = obj.numAllCrack;
            pt = pt + 1;

            vals{pt} = obj.crackAllLength;
            pt = pt + 1;

%            vals{pt} = obj.energyFrontClass;
%            pt = pt + 1;

            vals{pt} = obj.numElementsSolved;
            pt = pt + 1;

            vals{pt} = obj.dissipationBody;
            pt = pt + 1;

            vals{pt} = obj.dissipationInterface;
            pt = pt + 1;

            vals{pt} = obj.dissipationPhysics;
            pt = pt + 1;

            vals{pt} = obj.dissipationNumerical;
            pt = pt + 1;

            vals{pt} = obj.dissipationTotal;
            pt = pt + 1;

            vals{pt} = obj.dissipationNumerical2Total;
            pt = pt + 1;

            vals{pt} = obj.eneOutflow_U;
            pt = pt + 1;

            vals{pt} = obj.eneOutflow_K;
            pt = pt + 1;

            vals{pt} = obj.eneOutflow_T;
            pt = pt + 1;

            vals{pt} = obj.eneOutflow_x;
            pt = pt + 1;

            vals{pt} = obj.eneOutflow_xt;
            pt = pt + 1;

            vals{pt} = obj.eneInflow_U;
            pt = pt + 1;

            vals{pt} = obj.eneInflow_K;
            pt = pt + 1;

            vals{pt} = obj.eneInflow_T;
            pt = pt + 1;

            vals{pt} = obj.eneBC_P;
            pt = pt + 1;
            
            vals{pt} = obj.eneICBC;
            pt = pt + 1;

            vals{pt} = obj.eneO2I;
            pt = pt + 1;

            vals{pt} = obj.eneDissNum2I;
            pt = pt + 1;

            vals{pt} = obj.enePhys2I;
            pt = pt + 1;

            vals{pt} = obj.maxErrorDissipation;
            pt = pt + 1;
            
            vals{pt} = obj.maxErrorInterface;
            pt = pt + 1;
        end
    end
end