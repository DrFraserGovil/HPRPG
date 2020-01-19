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
    fileNameRoot = "../Chapters/";
    
	%basic output
	fileName = strcat(fileNameRoot, 'Artificing.tex');
	I = [potions.SimpleInclude] == 1;
	subset = potions(I);
	writeToFile(fileName,subset);
	
	%longer output
	fileName = strcat(fileNameRoot, 'PotionList.tex');
	writeToFile(fileName,potions);
	
	%rulebook output
	fileName = strcat(fileNameRoot, '../../GameMasterGuide/Chapters/Potions.tex');
	writeToFile(fileName,potions);
    
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

function writeToFile(fileName,potions)
	[~,I] = sort({potions.Name});
	potions = potions(I);
	potionText = "\n";
	for i = 1:length(potions)
		p = potions(i);
		potionText = potionText + p.print() + "\n";
	end
	
	
	%% output to file

	readFile = fileread(fileName);
	insertPoint = strfind(readFile, '%%PotionBegin');
    endPoint = strfind(readFile, '%%PotionEnd');
    firstHalf = prepareText(readFile(1:insertPoint+13),0);

    secondHalf = prepareText(readFile(endPoint:end),0);
	
	fullText = firstHalf + potionText + "\n" + secondHalf;
	FID = fopen(fileName,'w');
    fprintf(FID, fullText);
    fclose(FID);
	
end