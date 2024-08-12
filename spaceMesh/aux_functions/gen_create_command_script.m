function gen_create_command_script(fnWOExt, commandName, varargin)
numArguments = length(varargin);
numFunctionCalls = length(varargin{1});

filenamem = [fnWOExt, '.m'];
filenamel = [fnWOExt, '.last'];

fidscript = fopen(filenamem, 'w');
fidLast = fopen(filenamel, 'w');
fprintf(fidLast, '-1\n');
fclose(fidLast);
                    
openFileMsg1 = ['fidl = fopen(''', filenamel, ''', ''r'');'];
openFileMsg2 = 'lastSuccessful = fscanf(fidl, ''%d'', 1);';
fprintf(fidscript, '%s\n', openFileMsg1);
fprintf(fidscript, '%s\n', openFileMsg2);
fprintf(fidscript, 'fclose(fidl);');
fprintf(fidscript, '\n');
                    
for cntrInst = 0:numFunctionCalls - 1
    cntr = cntrInst + 1;
    args = cell(0);
    for m = 1:numArguments
        args{m} = varargin{m}{cntr};
    end

    msg1 = ['if (lastSuccessful < ', num2str(cntrInst), ')'];
    fprintf(fidscript, '%s\n', msg1);
                
    cmnd = commandName;
    for m = 1:numArguments
        if (m == 1)
            tmp = '(''';
        else
            tmp = ''', ''';
        end
        cmnd = [cmnd, tmp, args{m}];
    end
    cmnd = [cmnd, ''');'];
    fprintf(fidscript, '\t');
    fprintf(fidscript, '%s\n', cmnd);

    openFileMsg1 = ['fidl = fopen(''', filenamel, ''', ''w'');'];
    openFileMsg2 = ['fprintf(fidl, ''', num2str(cntrInst), ''');'];
    openFileMsg3 = 'fprintf(fidl, ''\n'');';

    fprintf(fidscript, '\t');
    fprintf(fidscript, '%s\n', openFileMsg1);
    fprintf(fidscript, '\t');
    fprintf(fidscript, '%s\n', openFileMsg2);
	fprintf(fidscript, '\t');
	fprintf(fidscript, '%s\n', openFileMsg3);
	fprintf(fidscript, '\t');
    fprintf(fidscript, 'fclose(fidl);\n');

	fprintf(fidscript, '\t');
 	% fprintf(fidscript, 'fclose(''all'');\n');
	% fprintf(fidscript, '\t');
	fprintf(fidscript, 'close(''all'');\n');
	fprintf(fidscript, 'end\n');
end
fclose(fidscript);

