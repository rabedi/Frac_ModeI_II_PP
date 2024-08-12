function asdg_conf = MAIN_ASDG_RUNS(configName)
if nargin < 1
    configName = 'config_aSDG.txt';
end
addpath('../');
addpath('aux_functions');
addpath('plt');
fclose('all');

asdg_conf = aSDG_old_Config;
asdg_conf = asdg_conf.MAIN(configName);