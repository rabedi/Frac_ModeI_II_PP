addpath('../');
addpath('aux_functions');
fclose('all');

asdg_sum = aSDG_old_run_summary1R;
rootFolderBase = '../../../';
rootFolderMain = 'old_2017_09_29_MicriUST_NA028_NP00_05x05_tau1p16em2_a13_NPa';


% aa = aSDG_old_run_summary1R1cp1frnt;
% energyFullName = [rootFolderBase, rootFolderMain, '/output_front', '/', 'EDenergyfront_All_', '16000', '.txt'];
% aa = aa.ComputeEnergies(energyFullName);


rootFolder = [rootFolderBase, rootFolderMain];
option = 1; % 1 : min / 2 : ave / 3 : max (of time of front meshes used for this purpose)
asdg_sum = asdg_sum.Process_aSDG_old_run_summary1R(rootFolder, option);


runSeparatingNames = {'xy', 'random', 'tau', 'aDot', 'resolution', 'meshNo', 'adaptive', 'tolerance'};
runSeparatingNamesLatex = {'\mathrm{xy}', 'l_c^\prime', '\tau', '\dot{a}', '\mathrm{res}', 'n_\mathrm{mesh}', '\mathrm{adapt}', '\mathrm{tol}'};
runSeparatingValues = {1, 0.05, 0.0116, 0.13, 28, -1, 0, 0};
 
fido = fopen('_test_data_write.txt', 'w');
[scalarNames, scalarNamesLatex] = asdg_sum.get_cp_Names(runSeparatingNames, runSeparatingNamesLatex);
stage = 2;
[scalarValues, vld] = asdg_sum.get_cp_Values(stage, runSeparatingValues);

sz = length(scalarNames);
szData = length(scalarValues);

for i = 1:min(sz, szData)
    fprintf(fido, '%d\t%s\t%s\t%f\n', i, scalarNames{i}, scalarNamesLatex{i}, scalarValues{i});
end
fclose(fido);
