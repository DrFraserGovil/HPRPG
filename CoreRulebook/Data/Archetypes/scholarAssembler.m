function scholarAssembler(fileNameRoot)
   
    %if no target given, assume that called directly, else assume called by
    %master
   
    if nargin < 1
        disp('Insufficient inputs provided');
        addpath('../Functions/');
        fileNameRoot = '../../Chapters/';
        originRoot = "";
    end
    
    f = readtable("Archetype Supplementals/Scholar_Discoveries.xlsx");
    f = sortrows(f);
    h = height(f);
  
    text = "";
    for i = 1:h
        if ~isempty(f{i,1}{1})
            line = "\discovery{";

            line = line + f{i,1}{1} +"}{";
            
            
            if ~isempty(f{i,2}{1})
                line = line + "1}{" + f{i,2}{1} + "}{";
            else
                 line = line + "0}{}{";
            end
            
            line = line + f{i,4}{1};
            
            

            line = line + "}";
            text = text + prepareText(line) + "\n";
        end
    end
    
    readFile = fileread("Scholar.tex");   
    insertPoint = strfind(readFile, '%%DiscoBegin');
    endPoint = strfind(readFile, '%%DiscoEnd');
    firstHalf = prepareText(readFile(1:insertPoint+11),0);
    secondHalf = prepareText(readFile(endPoint:end),0);
    fullText = firstHalf +"\n" + text  + "\n"+ secondHalf;
    
    FID = fopen("Scholar.tex",'w');
    fprintf(FID, fullText);
    fclose(FID);
end
    