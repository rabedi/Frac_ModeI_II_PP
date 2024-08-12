% shortConfigFileRead is a truncated version of readSpaceMeshConfigFile
% used to extract output directory and base run names from given configFile
function confGen = shortConfigFileRead(configName, modifyInput)

%for now modifyInput will always be 0
modifyInput = 0;

fid = fopen(configName, 'r');
if (fid < 0)
    fprintf(1, 'Cannot open file %s\t', configName);
    pause;
end

s_serialStart = 1;
s_serialStep = 2;
s_serialEnd = 3;
s_dirPreName = 4;
s_dirRunName = 5;
s_dirPostName = 6;
s_dir = 7;
s_dirOut = 8;
s_runName = 9;
s_middlename = 10;
s_runNameAppendix = 11;%22;

confGen = {};

tmp = READ(fid,'s',2);
confGen{s_serialStart} = READ(fid,'d');
tmp = READ(fid,'s');
confGen{s_serialStep} = READ(fid,'d');
tmp = READ(fid,'s');
confGen{s_serialEnd} = READ(fid,'d');
if (confGen{s_serialEnd} == -1)
    confGen{s_serialEnd} = confGen{s_serialStart};
end

tmp = READ(fid,'s');
tmp = READ(fid,'s');
if (strcmp(tmp, 'NULL') == 1)
    confGen{s_dirPreName} = '';
else
    confGen{s_dirPreName} = tmp;
end

tmp = READ(fid,'s');
tmp = READ(fid,'s');
if (strcmp(tmp, 'NULL') == 1)
    confGen{s_dirRunName} = '';
else
    confGen{s_dirRunName} = tmp;
end

tmp = READ(fid,'s');
tmp = READ(fid,'s');
if (strcmp(tmp, 'NULL') == 1)
    confGen{s_runNameAppendix} = '';
else
    confGen{s_runNameAppendix} = tmp;
end


tmp = READ(fid,'s');
tmp = READ(fid,'s');
if (strcmp(tmp, 'NULL') == 1)
    confGen{s_dirPostName} = '';
else
    confGen{s_dirPostName} = tmp;
end

confGen{s_dir} = [confGen{s_dirPreName} confGen{s_dirRunName} confGen{s_dirPostName}];
if (strcmp(confGen{s_dir}, '') == 0)
    confGen{s_dir} = [confGen{s_dir}, '/'];
end


tmp = READ(fid,'s');
confGen{s_dirOut} = READ(fid,'s');

tmp = READ(fid,'s');
confGen{s_runName} = READ(fid,'s');

confGen{s_middlename} = 'SL';

if (strcmp(confGen{s_dirOut}, 'runFolder') == 1)
    confGen{s_dirOut} = [confGen{s_runName}, '_', confGen{s_dirRunName}];
end


if (modifyInput == 0)
    if (strcmp(confGen{s_dirOut}, '') ~= 1)
        b_dir = isdir(confGen{s_dirOut});
        if (b_dir == 1)
        %    rmdir(confGen{s_dirOut},'s');
        else
            mkdir(confGen{s_dirOut});
        end
        confGen{s_dirOut} = [confGen{s_dirOut}, '/'];
    end
end

fclose(fid);

end