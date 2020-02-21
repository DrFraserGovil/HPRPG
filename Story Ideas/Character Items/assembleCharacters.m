function assembleCharacters(fileNameRoot)
   
    %if no target given, assume that called directly, else assume called by
    %master
   
    if nargin < 1
        disp('Insufficient inputs provided');
        addpath('../../CoreRulebook/Data/Functions/');
        fileNameRoot = '';
		originRoot = '';
    end
  
    Characters = Character.empty;
	base = ["Cerise","Helena","Luke","Nikc","GM"];
    texFiles = base +".tex";
    for i = 1:length(texFiles)
        targetName = char(texFiles(i));
        originName = targetName(1:end-4) + ".xlsx";
    
		f = readtable(originName,'ReadVariableNames',false);
		
        name = f{1,2}{1};
        species = f{2,2}{1};
        archetype = f{3,2}{1};
        physical = f{4,2}{1};
        background = f{5,2}{1};
        personality = f{6,2}{1};
        c = Character(name,species,base(i),archetype,physical,background,personality);
        Characters(end+1) = c;
        
        targetName = texFiles(i);
        readFile = fileread(targetName);
		insertPoint = strfind(readFile, '%%CharBegin');
		endPoint = strfind(readFile, '%%CharEnd');
		firstHalf = prepareText(readFile(1:insertPoint+11),0,0);

		secondHalf = prepareText(readFile(endPoint:end),0,0);

		fullText = firstHalf + c.print()  + "\n"+ secondHalf;

		FID = fopen(targetName,'w');
		fprintf(FID, fullText);
		fclose(FID);
    end
    
end
