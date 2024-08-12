set(groot,'defaulttextinterpreter','latex');  
set(groot, 'defaultAxesTickLabelInterpreter','latex');  
set(groot, 'defaultLegendInterpreter','latex');


numSVE = 1024;
numLC = 4;
outputbase = 'D:/Documents/PhD/OSU_Justin/RezaStuff/New_averageS/MatlabFigs/EverySVELinePlots/';
loadcasenames ={'LC0';'LC1';'LC2';'LC3'};
latexprocnames = {'$\epsilon$';'$\sigma$';'$\tilde{\epsilon}$';...
    '$\tilde{\sigma}$';'Y';'$\psi_t$';'$\psi_r$';'$\psi_d$';...
    '$\psi_{t,norm \psi_f}$';'$\psi_{r,norm \psi_f}$';'$\psi_{d,norm \psi_f}$';'$D$';'$\dot{D}$'};
i = 1;
j=2;
datanamei = 'zpp_eps_scalar';
datanamej = 'zpp_sig_scalar';

         for sz = 1:numSVE
            SVENameNum = sz-1;
            SVEName = num2str(SVENameNum);
            for lc = 1:numLC
                lcname = lc-1;
                lcname = num2str(lcname);
                lcname = strcat('LC',lcname);
                h = figure;
                SVE = AllSVEData{sz}{lc}.getDataVectorByDataName(datanamei);
                SVE1 = AllSVEData{sz}{lc}.getDataVectorByDataName(datanamej);
                %plot(SVE);
                plot(SVE,SVE1);
                ax = gca;                
                outputname = strcat(outputbase,lcname,'/','eps_vs_sig','_',SVEName,'_',loadcasenames{lc});
                ax.FontSize = 16;
                label = strcat(latexprocnames{i});
                x1 = xlabel(label,'FontSize',18);
                label = strcat(latexprocnames{j});
                x2 = ylabel(label,'FontSize',18);
                savefig(h,outputname);
                saveas(h,outputname,'png');
                close(h)
            end
         end