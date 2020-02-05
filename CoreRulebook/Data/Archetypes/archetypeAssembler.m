function archetypeAssembler(fileNameRoot)
   
    %if no target given, assume that called directly, else assume called by
    %master
   
    if nargin < 1
        disp('Insufficient inputs provided');
        addpath('../Functions/');
        fileNameRoot = '../../Chapters/';
        originRoot = "";
    end
    
    texFiles = dir(originRoot + "*.tex");
    for i = 1:length(texFiles)
        targetName = texFiles(i).name;
        originName = targetName(1:end-4) + ".xlsx";
        
        f = readtable(originName);
        h = height(f);
        
        text = "\\archetype{";
        
        
        statNames = ["name","hp","fp","armour","tool","disc","weapon","prof","equip","memorised"];
        for i = 1:length(statNames)
            l =  statNames(i) + "=" + f{i,6}{1};
            text = text + prepareText(l) + ", ";
        end
        
        j = 1;
        while j <= h && ~isempty(f{j,1}(1))
            num = num2roman(j);
            
            feat = "";
            
            exp = "expert" + num + " = " + num2str(f{j,2}) + ", ";
            spell = "maxspell" + num + " = " + prepareText(f{j,3}{1}) + ", ";
            
            if ~isempty(f{j,4}{1})
                feat = "bonus" + num + " = " + prepareText(f{j,4}{1}) + ", ";
            end        
            text = text + exp + spell + feat;
            j = j + 1;
        end
        
        charname= char(f{1,6});
        fLet = charname(1);
        if any(fLet == ["A","E","I","O","U"])
           text = text + "anMode = 1,";  
        end
        
        l = "shortmode = 0";
        if h < 20
            l = "shortmode = 1";
        end
        text = text + l + "}";
        
        
      
        readFile = fileread(targetName);
        insertPoint = strfind(readFile, '%%archBegin');
        endPoint = strfind(readFile, '%%archEnd');
        firstHalf = prepareText(readFile(1:insertPoint+11),0);

        secondHalf = prepareText(readFile(endPoint:end),0);

        fullText = firstHalf + text  + "\n"+ secondHalf;
        FID = fopen(targetName,'w');
        fprintf(FID, fullText);
        fclose(FID);
        
    end
end