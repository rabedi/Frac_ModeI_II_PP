function AllSVEData = readSVEOutputData(datapath,numRVE,numLC,numSVE)

RVEString = strcat('RVE',num2str(numRVE-1));
filebase = strcat(datapath,RVEString);

for i = 1:numSVE
    for j = 1:numLC

        SVEString = strcat('SVE',num2str(i-1));
        LCString = strcat('LC',num2str(i-1));
        
        filename = strcat(filebase,SVEString,LCString,'Processed.out');
        
        zpp = zpp_DamageHomogenization1R;
        
        fidzzc = fopen(filename, 'r');
        AllSVEData{i}{j} = zpp.fromFile(fidzzc);
        fclose(fidzzc);

    end
end

end
