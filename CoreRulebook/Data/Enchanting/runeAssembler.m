function runeAssembler(fileNameRoot)
   
    %if no target given, assume that called directly, else assume called by
    %master
   
    if nargin < 1
        disp('Insufficient inputs provided');
        addpath('../Functions/');
        fileNameRoot = '../../Chapters/Part3_Items/';
    end
    %% open file
    
	names = ["Duration","Action","Subject"];
    f = readtable("Runes.xlsx");
	h = height(f);
	text = "";
    deftext = "";
    levelTable = cell(3,3);
	for q = 1:3
		
		id = 1 + (q - 1)*4;
		j = 2;
		line = "\\runeList{" + names{q} + "}{" + prepareText(f{1,id}{1}) + "}{\n";
		defline = "";
		while j <= h && ~isempty(f{j,id}{1}) 
			temp = "";
			temp = temp + "\runeRow{";
            defline = defline + "\\def\\"+ f{j,id}{1} + "{" + prepareText(f{j,id+1}{1}) + "}\n";
			temp = temp + f{j,id}{1} + "}{";
			temp = temp + f{j,id+1}{1} + "}{";
			temp = temp + f{j,id+2}{1} + "}";
			
            z = f{j,id+3};
            s = convertCharsToStrings(f{j,id}{1});

            levelTable{q,z}(end+1) = s;
            
			line = line + prepareText(temp) + "\n";
			j = j + 1;
		end
		 
		text = text +line  + "} \n\n";
		deftext = deftext + defline + "\n";
    end
	
    names = ["Common", "Mystical", "Legendary"];
    ts = ["\\commonText","\\mysticalText","\\legendText"];
    table = "\n\\learnText";
	for level = 1:3
        t = "\n \\runeLevel{" + names(level) + "}{"+ ts(level) + "}{";
        dur = levelTable{1,level};
        action = levelTable{2,level};
        subject = levelTable{3,level};
        N = max(max(length(dur),length(action)),length(subject));
        for r= 1:N
            l = "";
            if r <= length(dur)
                l = l + dur(r) + " (\\rune{\\" + dur(r) + "})";
            else
                l =l + "~";
            end
            l = l + " & ";
            if r <= length(action)
               l = l + action(r) + " (\\rune{\\" + action(r) + "})";
            else
                l = l + "~";
            end
            l = l + " & ";
            if r <= length(subject)
                l = l + subject(r) +  " (\\rune{\\" + subject(r) + "})";
            else
                l = l + "~";
            end
            l = l + "\n\\\\\n";
            
            t = t + l;
        end
        
        table = table + t + "}\n\n";
    end

	
	fileName = strcat(fileNameRoot, 'Enchanting.tex');
	
	readFile = fileread(fileName);
	insertPoint = strfind(readFile, '%%RuneBegin');
    endPoint = strfind(readFile, '%%RuneEnd');
    firstHalf = prepareText(readFile(1:insertPoint+12),0);

    secondHalf = prepareText(readFile(endPoint:end),0);
	
	fullText = firstHalf + text  + "\n" + table + "\n" + secondHalf;
	FID = fopen(fileName,'w');
    fprintf(FID, fullText);
    fclose(FID);
    
end
