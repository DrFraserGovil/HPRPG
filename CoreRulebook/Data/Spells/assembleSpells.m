function assembleSpells(fileRoot)

    %if no target given, assume that called directly, else assume called by
    %master

    if nargin < 1
        disp('Insufficient inputs provided');
        addpath('../Functions/');
        fileRoot = '../../';
    end
    fileNameRoot = strcat(fileRoot,'Chapters/Part4_Magic/');
    %% open file

    f = readtable("Spells.xlsx");   
    headers = f.Properties.VariableNames;
     f = sortrows(f,1);
    f = sortrows(f,2);
    
    disciplines = Spell.empty;
    discNames = string.empty;
    discCounts = [];
    for i = 1:height(f)
       sp = Spell();
       sp.ReadLine(f(i,:));
       
       if ~(isempty(sp.Name) || sp.Name == "")


              id = find(discNames == sp.Discipline);
              
              if isempty(id)
                  discNames(end+1) = sp.Discipline;
                  discCounts(end+1) = 1;
                  disciplines(length(discNames),1) = sp;
              else
                  discCounts(id) = discCounts(id)+1;
                  disciplines(id,discCounts(id)) = sp;
              end

          
       end
    end

    
    tSummary = "\\spellList{";  
    
    t = "";
    for i = 1:length(discNames)
        tSummary = tSummary + "\n\t\\summaryRow{" + discNames(i) + "}{";
        t = t + "\\discipline{" +discNames{i} + "}\n{\n";
        
        [a,b] = size(disciplines);
        
        for j = 1:b
            if disciplines(i,j).Name ~= "None"
                t = t + "\t" + disciplines(i,j).Print() + "\n\n";
                if j > 1
                    tSummary = tSummary + ", ";
                end
                tSummary = tSummary + disciplines(i,j).Name;
                
            end
           
            
        end
           
        
        
        t = t + "\n}\n\n\n";
        tSummary = tSummary + "}";
    end
    
    tSummary = tSummary + "\n}\n\n";


    %% output to file

    fileName = strcat(fileNameRoot, 'Spells.tex');


    readFile = fileread(fileName);
    insertPoint = strfind(readFile, '%%Begin');
    endPoint = strfind(readFile, '%%End');
    firstHalf = prepareText(readFile(1:insertPoint+7),0,0);

    secondHalf = prepareText(readFile(endPoint:end),0,0);

    fullText = firstHalf +tSummary + t + "\n" + secondHalf;
    FID = fopen(fileName,'w');
    fprintf(FID, fullText);
    fclose(FID);

end