function symfs = computeSymbolFS(symfsIn, Lsymbol)

if (symfsIn < 0)
    symfs = -symfsIn;
    return;
else
    symfs = symfsIn;
end


numEntries = length(Lsymbol);

if (numEntries > 5)
    symfs = 20;%11.5;
end
if (numEntries > 7)
    symfs = 18;%11;
end
if (numEntries > 9)
    symfs = 16;%10.5;
end
if (numEntries > 11)
    symfs = 14;%10;
end
if (numEntries >= 13)
    symfs = 12;%9.5;
end

