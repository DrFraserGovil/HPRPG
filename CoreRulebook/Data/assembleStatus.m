function assembleStatus()
    statuses= readtable('Statuses.xlsx');
    statuses = sortrows(statuses);

    
    text = "";

    n = size(statuses);
    W= width(statuses);
    for (i = 1:n)
        
        r = statuses{i,3}{1};
        line = "\status{" + statuses.Name{i} + "}{";
        if W < 3 || isempty(r)
           line = line + statuses{i,2};
        else
            line = line + "\begin{itemize} \renewcommand\labelitemi{-}";
            j =2;
             r = statuses{i,j}{1};
            while j <= W && ~isempty(r) 
               
                line = line + "\item " + r;
                j = j +1;
                
                r = "";
                if j <= W
                    r = statuses{i,j}{1};
                end
            end
            line = line + "\end{itemize}";
        end
        line = line + "}";
        text = text + prepareText(line) + "\n\n";
    end

    fileName = '../Chapters/Part5_Lists/StatusList.tex';
    readFile = fileread(fileName);


    insertPoint = strfind(readFile, '%%StatusBegin');

    endPoint = strfind(readFile, '%%StatusEnd');

    firstHalf = prepareText(readFile(1:insertPoint+13));

    secondHalf = prepareText(readFile(endPoint:end));
    fullText = firstHalf+text + secondHalf;

    FID = fopen(fileName,'w');
    fprintf(FID, fullText);
end