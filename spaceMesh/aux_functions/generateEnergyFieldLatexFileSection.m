
fid = fopen('file_latex_append.txt','w');
count = 29;
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

        fprintf(fid,'%i  EN%02d%02d\t %s^{%s}\n',count,c,r,fld,title);
        count = count + 1;
        
    end
end

fclose(fid);