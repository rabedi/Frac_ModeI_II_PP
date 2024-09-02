function out = readStringWithoutSpace(str, chF, chT)
len = length(str);
I = 1;
for i = 1:len
    
    if (str(i) == chF) 
        if (length(chT) > 0)
            out(I) = chT;
            I = I + 1;
        end
    else 
        out(I) = str(i);
        I = I + 1;
    end
end

        
    