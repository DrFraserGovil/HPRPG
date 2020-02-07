function outlawAssembler(fileNameRoot)
   
    %if no target given, assume that called directly, else assume called by
    %master
   
    if nargin < 1
        disp('Insufficient inputs provided');
        addpath('../Functions/');
        fileNameRoot = '../../Chapters/';
        originRoot = "";
    end
    
    f = readtable("Archetype Supplementals/Outlaw_Surprises.xlsx");
    h = height(f);
    shield = string.empty;
    wand = string.empty;
    blade = string.empty;
    c = {blade,wand,shield};
    text = "";
    for i = 1:h
        if ~isempty(f{i,1}{1})
            line = "\surprise{";

            line = line + f{i,1}{1} +"}{";
            line = line + f{i,5}{1}+"}{";

            names = ["all Outlaws","Assasins","Thieves"];
            incNames = string.empty;
            for j = 1:3
                if f{i,1+j}{1} == 'Y'
                    incNames(end+1) = names(j);
                    c{j}(end+1) = f{i,1}{1};
                end
            end

            for j = 1:length(incNames)
               line = line + incNames(j);
               if j < length(incNames)


                    if length(incNames) > 1 && j == length(incNames)-1
                        line = line + " or ";
                    else
                        line = line + ", ";
                    end
               end
            end

            line = line + "}";
            text = text + prepareText(line) + "\n";
        end
    end
    
    readFile = fileread("Outlaw.tex");   
    insertPoint = strfind(readFile, '%%SurpBegin');
    endPoint = strfind(readFile, '%%SurpEnd');
    firstHalf = prepareText(readFile(1:insertPoint+11),0);
    secondHalf = prepareText(readFile(endPoint:end),0);
    fullText = firstHalf +"\n" + text  + "\n"+ secondHalf;
    
    FID = fopen("Outlaw.tex",'w');
    fprintf(FID, fullText);
    fclose(FID);
end
    