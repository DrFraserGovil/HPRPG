function runeAssembler(fileNameRoot)
   
    %if no target given, assume that called directly, else assume called by
    %master
   
    if nargin < 1
        disp('Insufficient inputs provided');
        addpath('../Functions/');
        fileNameRoot = '../../Chapters/';
    end
    %% open file
    
	names = ["Duration","Action","Subject"];
    f = readtable("Runes.xlsx");
	h = height(f);
	text = "";
	for q = 1:3
		
		id = 1 + (q - 1)*3;
		j = 2;
		line = "\\runeList{" + names{q} + "}{" + prepareText(f{1,id}{1}) + "}{\n";
		
		while j <= h && ~isempty(f{j,id}{1}) 
			temp = "";
			temp = temp + "\rune{";
			temp = temp + f{j,id}{1} + "}{";
			temp = temp + f{j,id+1}{1} + "}{";
			temp = temp + f{j,id+2}{1} + "}";
			
			line = line + prepareText(temp) + "\n";
			j = j + 1;
		end
		 
		text = text +line  + "} \n";
		
	end
	
	
	sprintf(text)
	
	fileName = strcat(fileNameRoot, 'Artificing.tex');
	
	readFile = fileread(fileName);
	insertPoint = strfind(readFile, '%%RuneBegin');
    endPoint = strfind(readFile, '%%RuneEnd');
    firstHalf = prepareText(readFile(1:insertPoint+12),0);

    secondHalf = prepareText(readFile(endPoint:end),0);
	
	fullText = firstHalf + text + "\n" + secondHalf;
	FID = fopen(fileName,'w');
    fprintf(FID, fullText);
    fclose(FID);
    
end
