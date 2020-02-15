function assembleBeasts(fileNameRoot)
   
    %if no target given, assume that called directly, else assume called by
    %master
   
    if nargin < 1
        disp('Insufficient inputs provided');
        addpath('../../../CoreRulebook/Data/Functions/');
        fileNameRoot = '../../Chapters/';
 
    end
  
    f = readtable("Species.xlsx");
    f = sortrows(f);
    List = Species.empty;
    for i = 1:height(f)
        List(i) = Species(f.Name{i},f.Description{i});
    end
    
    f = readtable("NewBeasts.xlsx");
    f = sortrows(f);
    h = height(f);
    
    
    for i = 1:h
        b = Beast(f(i,:));
        
        for j = 1:length(List)
           if strcmp(List(j).Name,b.Species)
               List(j).Beasts(end+1) = b;
           end
        end
    end
    text = "";
    for j = 1:length(List)
        entry = "\\species{" + List(j).Name + "}{";
        entry = entry + prepareText(List(j).Description) + "}{\n";
        
        [~,I] = sort([List(j).Beasts.Order]);
         List(j).Beasts = List(j).Beasts(I);
        
  
        for k = 1:length(List(j).Beasts)
            List(j).Beasts(k).ImagePos = (mod(k,2));
            entry = entry + List(j).Beasts(k).print() + "\n\n\n";
            List(j).Beasts(k).Name
        end
        entry = entry + "}";
        text = text + entry + "\n\n\n\n\n";
    end
    
    
    targetName = fileNameRoot + "BeastsBeings.tex";
    readFile = fileread(targetName);
    insertPoint = strfind(readFile, '%%BeastBegin');
    endPoint = strfind(readFile, '%%BeastEnd');
    firstHalf = prepareText(readFile(1:insertPoint+12),0,0);

    secondHalf = prepareText(readFile(endPoint:end),0,0);

    fullText = firstHalf + text  + "\n"+ secondHalf;

    FID = fopen(targetName,'w');
    fprintf(FID, fullText);
    fclose(FID);
    
end