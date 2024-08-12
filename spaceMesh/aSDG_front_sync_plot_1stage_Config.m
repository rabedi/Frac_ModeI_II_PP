classdef aSDG_front_sync_plot_1stage_Config
    properties
        folderNames;
        folderFieldsNamesCombined;
        folderFieldsNamesCombinedLatex;
        syncNos;
        frontNos;
        times;
        timesMin;
        timesMax;
        num = 0;
    end
    methods
        function objout = Updata(obj, syncNo, frontNo, folderName, folderFieldsNameCombined, folderFieldsNameCombinedLatex, time, timeMin, timeMax)
            num = obj.num + 1;
            objout = obj;
            objout.folderNames{num} = folderName;
            objout.folderFieldsNamesCombined{num} = folderFieldsNameCombined;
            objout.folderFieldsNamesCombinedLatex{num} = folderFieldsNameCombinedLatex;
            objout.syncNos(num) = syncNo;
            objout.frontNos(num) = frontNo;
            objout.times(num) = time;
            objout.timesMin(num) = timeMin;
            objout.timesMax(num) = timeMax;
            objout.num = num;
        end
    
        function Print(obj, fid, printFolderNameCombined, printFolderNameCombinedLatex, printTime)
            printNew = printFolderNameCombined || printFolderNameCombinedLatex || printTime;
            for k = 1:obj.num
                fprintf(fid, '%s\t', obj.folderNames{k});
                front = obj.frontNos(k);
                fprintf(fid, '-mesh { -3 %d 1 %d }\t', front, front);
                sync = obj.syncNos(k);
                fprintf(fid, '-sync { -3 %d 1 %d }\t', sync, sync);
                if (printNew)
                    fprintf(fid, '{\t');
                    if (printFolderNameCombined)
                        fprintf(fid, 'nameFlds\t%s\t', obj.folderFieldsNamesCombined{k});
                    end                    
                    if (printFolderNameCombinedLatex)
                        fprintf(fid, 'nameFldsLatex\t"%s"\t', obj.folderFieldsNamesCombinedLatex{k});
                    end                    
                    if (printTime)
                        fprintf(fid, 'time\t%f\t', obj.times(k));
                        fprintf(fid, 'timeMin\t%f\t', obj.timesMin(k));
                        fprintf(fid, 'timeMax\t%f\t', obj.timesMax(k));
                    end
                    fprintf(fid, '}');
                end
                fprintf(fid, '\n');
            end
        end
    end
end
