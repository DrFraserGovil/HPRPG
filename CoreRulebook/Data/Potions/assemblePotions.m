function assemblePotions()

	opts = detectImportOptions('potions.xlsx','NumHeaderLines',2);
    opts.VariableNamesRange = 'A1';
    f = readtable("potions.xlsx",opts,'ReadVariableNames',true);
	
	N = height(f);
	
	potions = Potion.empty;
	
	pouch = IngredientPouch();
	for i = 1:N
		p = Potion(f(i,:),pouch);
		
		if ~isempty(p.Name)
		
			potions(end+1) = p;
		end
	end
	
	for i = 1:length(pouch.Ingredients)
		ing = pouch.Ingredients(i);
		
        if isempty(ing.CriticalPotions) && isempty(ing.OptionalPotions)
           disp(ing.Name + " has no uses") 
        end
	end
	
	%% output to files
    fileNameRoot = "../../Chapters/";
    potionSTrigger = "%%PotionBegin";
    potionETrigger = "%%PotionEnd";
    
	%basic output
	fileName = strcat(fileNameRoot, 'Artificing.tex');
	I = [potions.SimpleInclude] == 1;
	subset = potions(I);
	writeToFile(fileName,subset,potionSTrigger,potionETrigger);
	
	%longer output
	fileName = strcat(fileNameRoot, 'PotionList.tex');
	writeToFile(fileName,potions,potionSTrigger,potionETrigger);
	
	%rulebook output
	fileName = strcat(fileNameRoot, '../../GameMasterGuide/Chapters/Potions.tex');
	writeToFile(fileName,potions,potionSTrigger,potionETrigger);
    
    %%ingredient output
    ingSTrigger = "%%IngredientBegin";
    ingETrigger = "%%IngredientEnd";
    q = [pouch.Ingredients];
    writeToFile(fileName,q,ingSTrigger,ingETrigger);
    
    gnnText = "";
    for i = 1:length(potions)
        name = potions(i).Name;
        if strfind(name,"\apos{}")
           start = strfind(name,"\apos{}")-1;
           endish = start + 8;
           firstHalf = name(1:start);
           secondHalf = name(endish:length(name));
           name = strcat(firstHalf,"'",secondHalf);
        end
       eff = potions(i).Name;
        gnnText = gnnText + name + ": " + prepareText(eff,0) + "\n";
    end
    FID = fopen("gnnData.txt",'w');
    fprintf(FID, gnnText);
    fclose(FID);
end

function writeToFile(fileName,list,startTrigger,endTrigger)
s = cellstr({list.Name});
	[~,I] = sort(char(s));
	list = list(I);
	potionText = "\n";
	for i = 1:length(list)
		p = list(i);
		potionText = potionText + p.print() + "\n";
	end
	
	
	%% output to file

	readFile = fileread(fileName);
    
	insertPoint = strfind(readFile, startTrigger);
    endPoint = strfind(readFile, endTrigger);
    firstHalf = prepareText(readFile(1:insertPoint+length(char(startTrigger))),0);

    secondHalf = prepareText(readFile(endPoint:end),0);
	
	fullText = firstHalf + potionText + "\n\n" + secondHalf;
	FID = fopen(fileName,'w');
    fprintf(FID, fullText);
    fclose(FID);
	sprintf(fullText);
end