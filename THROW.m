%Error message display and stack calling
function THROW(message)
    %fprintf(1,['\nERROR: ',message,'\n']);
    dbstack()
    [ST,I] = dbstack();
    
%    fprintf(1,'Variables in present scope:\n');

    w = evalin('caller','who');

    % Remove 'ans' if it is present.
    w = setdiff(w,'ans');

    % Loop through variables and put them in base workspace.
    for i = 1:length(w)
        assignin('base',w{i},evalin('caller',w{i}))
    end

    error(['ERROR: ',message])
    %ref: https://www.mathworks.com/matlabcentral/newsreader/view_thread/278880
end