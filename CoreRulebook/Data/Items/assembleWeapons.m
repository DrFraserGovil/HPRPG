function assembleWeapons()

    weapon = readtable('weapons.xlsx');
  

    n = size(weapon);
    
    %%process and sort categories
    knownNames = ["Unarmed", "Simple","Bladed", "Brutish", "Reach", "Exotic",  "Simple Ranged","Ranged","Firearms" ];
    foundNames = [];
    foundLines = {};
    for i = 1:n
        type = weapon.Type{i};
        
        found = -1;
        for j = 1:length(foundNames)
           if strcmp(type,foundNames{j})
               found=j;
               foundLines{found}(end+1,:) = weapon(i,:);
           end
        end
        if found == -1
            foundNames{end+1} = type;

            found = length(foundNames);
            foundLines{end+1} = weapon(i,:);
        end
    end
    I = [];
    lost =[];
    for j = 1:length(foundNames)
       loc = -1;
       for q = 1:length(knownNames)
          if strcmp(knownNames{q},foundNames{j})
              I(q) = j; 
              loc = j;
          end
       end
       if loc == - 1;
           lost(end+1) = j;
       end
    end
    I = [I lost];
    foundNames= foundNames(I);
    foundLines = foundLines(I);
    %% write to table
    preamble = '\begin{rndtable}{|l l c c l |}';
    headers = '\hline \tablehead \normalsize \bf Weapon & \normalsize \bf Cost & \normalsize \bf Modifier &  \normalsize \bf Damage & \normalsize \bf Properties \\ \hline';
    text = prepareText(strcat(preamble,headers));
    for j = 1:length(foundNames)
        text = strcat(text, "{ \\it ", foundNames{j}," Weapons} & & & & \\\\ \n");
        
        for (i = 1:height(foundLines{j}))
            line = foundLines{j}(i,:);
            notes = strcat('\\parbox[t]{\\l cm}{', line.Notes{1}, '}');
            check = strcat(line.Dice{1},'~', line.Damage{1});


            line = strcat("\\bf ~~~~~", line.Weapon{1}, "\t&\t", prepareText(line.Cost{1}),"\t&\t",line.Check{1},"\t&\t",check, "\t&\t",notes,"\\\\ \n");
            text = strcat(text, line);
        end
    end
    ender = prepareText('\hline\end{rndtable} ');


    fileName = '../Chapters/Items.tex';
    readFile = fileread(fileName);
    insertPoint = strfind(readFile, '%%WeaponsBegin');
    endPoint = strfind(readFile, '%%WeaponsEnd');

    firstHalf = prepareText(readFile(1:insertPoint+14));
    secondHalf = prepareText(readFile(endPoint:end));

    fullText = strcat(firstHalf, text, ender, secondHalf);

    FID = fopen(fileName,'w');
    fprintf(FID, fullText);
end