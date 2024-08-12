%clearvars -except AllSVEData

set(groot,'defaulttextinterpreter','latex');  
set(groot, 'defaultAxesTickLabelInterpreter','latex');  
set(groot, 'defaultLegendInterpreter','latex');

baseprocessedname = 'zpp_';
baserawname = 'zppr_';
outputbase = 'D:/Documents/PhD/OSU_Justin/RezaStuff/New_averageS/MatlabFigs/';
volfracbase = 'D:/Documents/PhD/OSU_Justin/RezaStuff/Nanotube_Geom/Nanotube_Geom/';
plottypefolder = {'TimeHistory/';'StrainHistory/';'SVE/';'PDF/';'CDF/';'Bar/';'CorStage/';'VolFraction/'};
barplottype = {'mean/';'stddev/';'variance/';'skew/';'kurt/'};


% processedparameternames = {'psi_t';'psi_r';'psi_d';'psi_t_npsif';'psi_r_npsif';'psi_d_npsif';'D';'Ddot'};
% latexprocnames = {'$\psi_t$';'$\psi_r$';'$\psi_d$';'$\psi_{t,npsif}$';'$\psi_{r,npsif}$';'$\psi_{d,npsif}$';'$D$';'$\dot{D}$'};
processedparameternames = {'eps_scalar';'sig_scalar';'eps_voigt';'sig_voigt';'Y';...
    'psi_t';'psi_r';'psi_d';'psi_t_npsif';'psi_r_npsif';'psi_d_npsif';...
    'Din';'Dindot';'psi_d_to_t';'psi_r_to_t';'D'};
latexprocnames = {'$\epsilon$';'$\sigma$';'$\tilde{\epsilon}$';...
    '$\tilde{\sigma}$';'Y';'$\psi_t$';'$\psi_r$';'$\psi_d$';...
    '$\psi_{t,norm \psi_f}$';'$\psi_{r,norm \psi_f}$';...
    '$\psi_{d,norm \psi_f}$';'$D_{in}$';'$\dot{D_{in}}$';...
    '$\psi_{d,norm \psi_t}$';'$\psi_{r,norm \psi_t}$';'$D_{ext}$'};
procnamesubfolder = {'epsilon/';'sigma/';'epsilonvoigt/';'sigmavoigt/';'Y/';...
    'psit/';'psir/';'psid/';'psitnormpsif/';'psirnormpsif/';'psidnormpsif/';...
    'Din/';'DinDot/';'psidnormpsit/';'psirnormpsit/';'Dext'};
epssigfolder = {'epsversussig/'};
intextdamagefolder = {'intversusextdamagecomp/'};

rawparameternames = {'stnst_xx';'stnst_yy';'stnst_xy';'stssh_xx';...
    'stssh_yy';'stssh_xy';'D'};
criticalpointnames = {'cpt_fulldamage_';'cpt_final_';'cpt_maxsts_';...
    'cpt_homogdini_';'cpt_damageext1_'};
latexcritnames = {',$0$';',$\mathrm{f}$';',$\mathrm{m}$';',$\mathrm{i}$';',$\bar{i}$'};
loadcasenames ={'LC0';'LC1';'LC2';'LC3'};

procnamelength = length(processedparameternames);
rawnamelength = length(rawparameternames);
critnamelength = length(criticalpointnames);
numSVE = 1024;
numLC = length(loadcasenames);

for i = 1:numLC
    xaxes(i) = i-1;
end

for i = 1:numSVE
    sveaxes(i) = i-1;
end

%Import Geometry Cell
for i = 1:numSVE
    SVENumStr = num2str(i-1);
    GeoFilename = strcat(volfracbase,'RVE0SVE',SVENumStr,'Geo.txt');
    VolFracMatrix = importGeometryInfo(GeoFilename);
    VolFraction(i) = VolFracMatrix(1,1);
end


baraxes = categorical({'LC0','LC1','LC2','LC3'});

%Plotting processed parameters, critical parameters, and statistics

for i = 1:procnamelength
    
    datanamei = strcat(baseprocessedname,processedparameternames{i});
    for sz = 1:numSVE
        for lc = 1:numLC
            SVE = AllSVEData{sz}{lc}.getDataVectorByDataName(datanamei);
            SVEData(sz,lc,:) = SVE;
        end
    end
    
    %Raw data for each SVE
    for lc = 1:numLC
        h = figure;
        outputname = strcat(outputbase,plottypefolder{1},datanamei,'_',loadcasenames{lc});
        hold on
        for sz = 1:numSVE
            SVE(:) = SVEData(sz,lc,:);
            plot(SVE);
        end
        hold off
        ax = gca;
        ax.FontSize = 16;
        x1 = xlabel('t','FontSize',18);
        label = strcat(latexprocnames{i});
        x2 = ylabel(label,'FontSize',18);
        savefig(h,outputname);
        saveas(h,outputname,'png');
        close(h)
    end
    
    for k = 1:critnamelength
        datanameik = strcat(baseprocessedname,criticalpointnames{k},processedparameternames{i});
        for sz = 1:numSVE
            for lc = 1:numLC
                SVECrit = AllSVEData{sz}{lc}.getDataVectorByDataName(datanameik);
                SVEDataCrit(sz,lc) = SVECrit;
            end
        end
        
        %Raw critical values for each SVE
        for lc = 1:numLC
            h = figure;
            outputname = strcat(outputbase,plottypefolder{3},datanameik,'_',loadcasenames{lc});
            SVE = SVEDataCrit(:,lc);
            plot(sveaxes,SVE);
            ax = gca;
            ax.FontSize = 16;
            x1 = xlabel('SVE Number','FontSize',18);
            label = strcat(latexprocnames{i},latexcritnames{k});
            x2 = ylabel(label,'FontSize',18);
            savefig(h,outputname);
            saveas(h,outputname,'png');
            close(h)
        end
        
        %Critical Data Statistics
        for lc = 1:numLC
            SVE = SVEDataCrit(:,lc);
            SVE = SVE(~isnan(SVE));
            standev(lc) = std(SVE);
            aver(lc) = mean(SVE);
            vari(lc) = var(SVE);
            sk(lc) = skewness(SVE);
            kt(lc) = kurtosis(SVE);
            [fpdf(:,lc),xpdf(:,lc)] = ksdensity(SVE,'Function','pdf','NumPoints',200);
            [fcdf(:,lc),xcdf(:,lc)] = ksdensity(SVE,'Function','cdf','NumPoints',200);
        end
        
        outputnamepdf = strcat(outputbase,plottypefolder{4},datanameik,'_PDF','_AllLC');
        h = figure;
        hold on
        for lc = 1:numLC
            plot(xpdf(:,lc),fpdf(:,lc));
        end
        hold off
        ax = gca;
        ax.FontSize = 16;
        label = strcat(latexprocnames{i},latexcritnames{k});
        x1 = xlabel(label,'FontSize',18);
        label = '$\mathrm{PDF}$';
        x2 = ylabel(label,'FontSize',18);
        legend('LC0','LC1','LC2','LC3');
        savefig(h,outputnamepdf);
        saveas(h,outputnamepdf,'png');
        close(h);
        
        
        outputnamecdf = strcat(outputbase,plottypefolder{5},datanameik,'_CDF','_AllLC');
        h = figure;
        hold on
        for lc = 1:numLC
            plot(xcdf(:,lc),fcdf(:,lc));
        end
        hold off
        ax = gca;
        ax.FontSize = 16;
        label = strcat(latexprocnames{i},latexcritnames{k});
        x1 = xlabel(label,'FontSize',18);
        label = '$\mathrm{CDF}$';
        x2 = ylabel(label,'FontSize',18);
        legend('LC0','LC1','LC2','LC3');
        savefig(h,outputnamecdf);
        saveas(h,outputnamecdf,'png');
        close(h);
        
        outputnamemean = strcat(outputbase,plottypefolder{6},barplottype{1},datanameik,'_mean','_AllLC');
        h = figure;
        bar(baraxes,aver);
        ax = gca;
        ax.FontSize = 16;
        label = 'LC Number';
        x1 = xlabel(label,'FontSize',18);
        label = strcat('Mean,',latexprocnames{i},latexcritnames{k});
        x2 = ylabel(label,'FontSize',18);
        savefig(h,outputnamemean);
        saveas(h,outputnamemean,'png');
        close(h);
        
        outputnamestd = strcat(outputbase,plottypefolder{6},barplottype{2},datanameik,'_std','_AllLC');
        h = figure;
        bar(baraxes,standev);
        ax = gca;
        ax.FontSize = 16;
        label = 'LC Number';
        x1 = xlabel(label,'FontSize',18);
        label = strcat('Standard Deviation,',latexprocnames{i},latexcritnames{k});
        x2 = ylabel(label,'FontSize',18);
        savefig(h,outputnamestd);
        saveas(h,outputnamestd,'png');
        close(h);
        
        outputnamevar = strcat(outputbase,plottypefolder{6},barplottype{3},datanameik,'_var','_AllLC');
        h = figure;
        bar(baraxes,vari);
        ax = gca;
        ax.FontSize = 16;
        label = 'LC Number';
        x1 = xlabel(label,'FontSize',18);
        label = strcat('Variance,',latexprocnames{i},latexcritnames{k});
        x2 = ylabel(label,'FontSize',18);
        savefig(h,outputnamevar);
        saveas(h,outputnamevar,'png');
        close(h);
        
        outputnameskew = strcat(outputbase,plottypefolder{6},barplottype{4},datanameik,'_skew','_AllLC');
        h = figure;
        bar(baraxes,sk);
        ax = gca;
        ax.FontSize = 16;
        label = 'LC Number';
        x1 = xlabel(label,'FontSize',18);
        label = strcat('Skewness,',latexprocnames{i},latexcritnames{k});
        x2 = ylabel(label,'FontSize',18);
        savefig(h,outputnameskew);
        saveas(h,outputnameskew,'png');
        close(h);
        
        outputnamekurt = strcat(outputbase,plottypefolder{6},barplottype{5},datanameik,'_kurt','_AllLC');
        h = figure;
        bar(baraxes,kt);
        ax = gca;
        ax.FontSize = 16;
        label = 'LC Number';
        x1 = xlabel(label,'FontSize',18);
        label = strcat('Kurtosis,',latexprocnames{i},latexcritnames{k});
        x2 = ylabel(label,'FontSize',18);
        savefig(h,outputnamekurt);
        saveas(h,outputnamekurt,'png');
        close(h);
        
    end
    
    %Plotting Critical processed parameters versus each other
    for j = 1:procnamelength
        
        if i ~= j
            continue
        end
        
        for k = 1:critnamelength
            for l = 1:critnamelength
                
                datanameik = strcat(baseprocessedname,criticalpointnames(k),processedparameternames(i));
                datanamejl = strcat(baseprocessedname,criticalpointnames(l),processedparameternames(j));
                
                for sz = 1:numSVE
                    for lc = 1:numLC
                        SVECritik = AllSVEData{sz}{lc}.getDataVectorByDataName(datanameik);
                        SVEDataCritik(sz,lc) = SVECritik;
                        SVECritjl = AllSVEData{sz}{lc}.getDataVectorByDataName(datanamejl);
                        SVEDataCritjl(sz,lc) = SVECritjl;
                    end
                end
                
                for lc = 1:numLC
                    lcname = char(loadcasenames{lc});
                    outputname = char(strcat(outputbase,plottypefolder{7},procnamesubfolder{i},datanameik,'_versus_',datanamejl,'_',lcname));
                    SVECritik = SVEDataCritik(:,lc);
                    SVECritjl = SVEDataCritjl(:,lc);
%                     CombineSVE = [SVECritik, SVECritjl];
%                     CombineSVE = CombineSVE(sum(isnan(CombineSVE), 2) == 0);
%                     SVECritik = CombineSVE(:,1);
%                     SVECritjl = CombineSVE(:,2);
                    
%                     p = polyfit(SVECritik,SVECritjl,1);
%                     yfit = polyval(p,SVECritik);
%                     yresid = SVECritjl - yfit;
%                     SSresid = sum(yresid.^2);
%                     SStotal = (length(SVECritjl)-1) * var(SVECritjl);
%                     rsq_adj = 1 - SSresid/SStotal * (length(SVECritjl)-1)/(length(SVECritjl)-length(p));
                    h = figure;
                    hold on
                    scatter(SVECritik,SVECritjl);
                    hold off
                    ax = gca;
                    ax.FontSize = 16;
                    label = strcat(latexprocnames{i},latexcritnames{k});
                    x1 = xlabel(label,'FontSize',18);
                    label = strcat(latexprocnames{j},latexcritnames{l});
                    x2 = ylabel(label,'FontSize',18);
                    savefig(h,outputname);
                    saveas(h,outputname,'png');
                    close(h);
                end
                
            end
        end
    end
end
%Plotting sig - eps curve
datanameik = strcat(baseprocessedname,'eps_scalar');
datanamejl = strcat(baseprocessedname,'sig_scalar');

for lc = 1:numLC
    lcname = char(loadcasenames{lc});
    outputname = char(strcat(outputbase,plottypefolder{7},epssigfolder{1},datanameik,'_versus_',datanamejl,'_',lcname));
    h = figure;
    hold on
    for sz = 1:numSVE
        SVECritik = AllSVEData{sz}{lc}.getDataVectorByDataName(datanameik);
        SVEDataCritik = SVECritik;
        SVECritjl = AllSVEData{sz}{lc}.getDataVectorByDataName(datanamejl);
        SVEDataCritjl = SVECritjl;
        plot(SVEDataCritik,SVEDataCritjl)
    end
    hold off
    ax = gca;
    ax.FontSize = 16;
    label = strcat(latexprocnames{1});
    x1 = xlabel(label,'FontSize',18);
    label = strcat(latexprocnames{2});
    x2 = ylabel(label,'FontSize',18);
    savefig(h,outputname);
    saveas(h,outputname,'png');
    close(h);
end

%Plotting sig - eps critical curves
for k = 1:critnamelength
    for l = 1:critnamelength
        i = 1;
        j = 2;
        datanameik = strcat(baseprocessedname,criticalpointnames(k),'eps_scalar');
        datanamejl = strcat(baseprocessedname,criticalpointnames(l),'sig_scalar');
        
        for sz = 1:numSVE
            for lc = 1:numLC
                SVECritik = AllSVEData{sz}{lc}.getDataVectorByDataName(datanameik);
                SVEDataCritik(sz,lc) = SVECritik;
                SVECritjl = AllSVEData{sz}{lc}.getDataVectorByDataName(datanamejl);
                SVEDataCritjl(sz,lc) = SVECritjl;
            end
        end
        
        for lc = 1:numLC
            lcname = char(loadcasenames{lc});
            outputname = char(strcat(outputbase,plottypefolder{7},epssigfolder{1},datanameik,'_versus_',datanamejl,'_',lcname));
            h = figure;
            hold on
            scatter(SVEDataCritik(:,lc),SVEDataCritjl(:,lc))
            hold off
            ax = gca;
            ax.FontSize = 16;
            label = strcat(latexprocnames{1},latexcritnames{k});
            x1 = xlabel(label,'FontSize',18);
            label = strcat(latexprocnames{2},latexcritnames{l});
            x2 = ylabel(label,'FontSize',18);
            savefig(h,outputname);
            saveas(h,outputname,'png');
            close(h);
        end
        
    end
end

%Plotting External Damage -Homogeneous Damage curves
datanameik = strcat(baseprocessedname,'D');
datanamejl = strcat(baserawname,'d');

for lc = 1:numLC
    lcname = char(loadcasenames{lc});
    outputname = char(strcat(outputbase,plottypefolder{7},intextdamagefolder{1},datanameik,'_versus_',datanamejl,'_',lcname));
    h = figure;
    hold on
    for sz = 1:numSVE
        SVECritik = AllSVEData{sz}{lc}.getDataVectorByDataName(datanameik);
        SVEDataCritik = SVECritik;
        SVECritjl = AllSVEData{sz}{lc}.getDataVectorByDataName(datanamejl);
        SVEDataCritjl = SVECritjl;
        plot(SVEDataCritik,SVEDataCritjl)
    end
    hold off
    ax = gca;
    ax.FontSize = 16;
    label = strcat(latexprocnames{12});
    x1 = xlabel(label,'FontSize',18);
    label = '$d_{Ext}$';
    x2 = ylabel(label,'FontSize',18);
    savefig(h,outputname);
    saveas(h,outputname,'png');
    close(h);
end

%Plotting External Damage -Homogeneous Damage critical curves
for k = 1:critnamelength
    for l = 1:critnamelength
        i = 1;
        j = 2;
        datanameik = strcat(baseprocessedname,criticalpointnames(k),'D');
        datanamejl = strcat(baserawname,criticalpointnames(l),'d');
        
        for sz = 1:numSVE
            for lc = 1:numLC
                SVECritik = AllSVEData{sz}{lc}.getDataVectorByDataName(datanameik);
                SVEDataCritik(sz,lc) = SVECritik;
                SVECritjl = AllSVEData{sz}{lc}.getDataVectorByDataName(datanamejl);
                SVEDataCritjl(sz,lc) = SVECritjl;
            end
        end
        
        for lc = 1:numLC
            lcname = char(loadcasenames{lc});
            outputname = char(strcat(outputbase,plottypefolder{7},intextdamagefolder{1},datanameik,'_versus_',datanamejl,'_',lcname));
            h = figure;
            hold on
            scatter(SVEDataCritik(:,lc),SVEDataCritjl(:,lc))
            hold off
            ax = gca;
            ax.FontSize = 16;
            label = strcat(latexprocnames{12},latexcritnames{k});
            x1 = xlabel(label,'FontSize',18);
            label = strcat('$d_{Ext}$',latexcritnames{l});
            x2 = ylabel(label,'FontSize',18);
            savefig(h,outputname);
            saveas(h,outputname,'png');
            close(h);
        end
        
    end
end


%Plot values versus volume fraction

for i = 1:procnamelength
    for k = 1:critnamelength
        datanameik = strcat(baseprocessedname,criticalpointnames{k},processedparameternames{i});
        for sz = 1:numSVE
            for lc = 1:numLC
                SVECrit = AllSVEData{sz}{lc}.getDataVectorByDataName(datanameik);
                SVEDataCrit(sz,lc) = SVECrit;
            end
        end
        
        %Raw critical values for each SVE
        for lc = 1:numLC
            h = figure;
            outputname = strcat(outputbase,plottypefolder{8},'VolFrac_',datanameik,'_',loadcasenames{lc});
            SVE = SVEDataCrit(:,lc);
            scatter(VolFraction,SVE);
            ax = gca;
            ax.FontSize = 16;
            x1 = xlabel('Volume Fraction','FontSize',18);
            label = strcat(latexprocnames{i},latexcritnames{k});
            x2 = ylabel(label,'FontSize',18);
            savefig(h,outputname);
            saveas(h,outputname,'png');
            close(h)
        end
    end
    
end