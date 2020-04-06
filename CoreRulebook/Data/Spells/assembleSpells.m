function assembleSpells(maxLevel,additionalRoot)
   
    %if no target given, assume that called directly, else assume called by
    %master
   
    if nargin < 2
        disp('Insufficient inputs provided');
        if nargin < 1
            maxLevel = 6;
        end
        addpath('../Functions/');
        additionalRoot = '../../';
    end
    fileNameRoot = strcat(additionalRoot,'Chapters/Part5_Lists/');
    %% open file
    
    if ~exist("spellOpts","var")
        spellOpts = detectImportOptions('AllSpells.xlsx','NumHeaderLines',2);
        spellOpts.VariableNamesRange = 'A1';
    end
    f = readtable("AllSpells.xlsx",spellOpts,'ReadVariableNames',true);

    %% read in the file line by line and sort into schools and disciplines
    schools = SpellSchool.empty;
    allSpells = Spell.empty;
    for i = 1:height(f)
        newSpell = Spell();
        newSpell.ReadLine(f(i,:));
        allSpells(end+1) = newSpell;
        
        if newSpell.Level <= maxLevel
            schoolFound= false;
            for j = 1:length(schools)
                if strcmp(schools(j).Name,newSpell.School) == 1            
                    schoolFound = true;
                    disc = schools(j).hasDiscipline(newSpell.Discipline);
                    if disc > 0    
                        schools(j).Discipline(disc).Spells{newSpell.Level+1}(end+1) = newSpell;
                    else
                        newDisc = SpellDiscipline(newSpell.Discipline);
                        newDisc.Spells{newSpell.Level+1}(1) = newSpell;
                        schools(j).Discipline(end+1) = newDisc;
                    end
                end
            end

            if schoolFound == false
               newSchool = SpellSchool(newSpell.School);
               newDisc = SpellDiscipline(newSpell.Discipline);
               newDisc.Spells{newSpell.Level+1}(1) = newSpell;
               newSchool.Discipline(1) = newDisc;
               schools(end+1) = newSchool;
            end
        end
    end
    
    %% sort alphabetically
    [~,I] =sort({schools.SortName});
    schools = schools(I);
    for i = 1:length(schools)
       [~,I]= sort({schools(i).Discipline.Name});
       schools(i).Discipline = schools(i).Discipline(I);
       for j = 1:length(schools(i).Discipline)
            for k = 0:6
                [~,I] = sort({schools(i).Discipline(j).Spells{k+1}.Name});
                schools(i).Discipline(j).Spells{k+1} = schools(i).Discipline(j).Spells{k+1}(I);
            end
       end
    end
    [~,I] = sort({allSpells.Name});
    allSpells = allSpells(I);
    
    
    %% create text for discipline tables
    disciplineTableText =  '\\scriptsize';
    
    for i = 1:length(schools)
        t = "\\schoolTables{" + schools(i).Name + "}\n{";
        
        for j = 1:length(schools(i).Discipline)
            disc = schools(i).Discipline(j);
            t = t + "\n\t\\discTable{" + disc.Name + "}\n\t{"; 
                        
            for row = 1:disc.maxSpellNumber()
                t = t + "\n \t\t\\spellRow";
                for z = 0:6
                    column = z  +1;
                    if row <= length(disc.Spells{column})
                        sp = disc.Spells{column}(row);
                        
                        t = t + "{  \\spellEntry{" + prepareText(sp.Name) + "}{" +sp.Symbol +" } }";
                    else
                        t = t + "{ \\emptySpell{} }";
                    end

                end
                t = t + "\n";
            end
            t= t + "\t}\n ~ \n";
        end
        
        t = t + "\n}";
        disciplineTableText = disciplineTableText + t + "\n\n";
    end
    
    %% create text for description list
   
    listText = '\n \\normalsize \\clearpage \n\\begin{multicols}{3}\n';
    
    for i = 1:length(allSpells)
       listText = listText +  allSpells(i).output() + "\n\n\n";
    end
    listText = listText + "\\end{multicols}";
    
	%% output to file
    
    fileName = strcat(fileNameRoot, 'SpellList.tex');

    
	readFile = fileread(fileName);
	insertPoint = strfind(readFile, '%%SpellBegin');
    endPoint = strfind(readFile, '%%SpellEnd');
    firstHalf = prepareText(readFile(1:insertPoint+12),0);

    secondHalf = prepareText(readFile(endPoint:end),0);
	
	fullText = firstHalf + disciplineTableText + listText + "\n" + secondHalf;
	FID = fopen(fileName,'w');
    fprintf(FID, fullText);
    fclose(FID);
    
    spellBook(schools,additionalRoot)
end

function spellBook(schools,root)
    bookRoot = strcat(root,"Data/Spells/Spellbooks/");
    for i = 1:length(schools)
        for j = 1:length(schools(i).Discipline)
            
            for k = 1:length(schools(i).Discipline(j).Spells{1})
               schools(i).Discipline(j).Spells{2}(end+1) = schools(i).Discipline(j).Spells{1}(k);
            end
            
            [~,I] = sort({schools(i).Discipline(j).Spells{2}.Name});
            schools(i).Discipline(j).Spells{2} = schools(i).Discipline(j).Spells{2}(I);
        end
    end


    f = readtable(bookRoot + "bookNames.xlsx");
    text = "";
    for q = 1:6
        
        for i = 1:length(schools)
            for j = 1:length(schools(i).Discipline)
                disc = schools(i).Discipline(j);
                tit = ["Trivial \\& Beginner", "Novice", "Adept", "Expert","Master","Ascendant"];
                
                x = string(transpose(f{:,1}));
                rowID = (x==disc.Name);
                
                
                bName = prepareText(f{rowID,1+q}{1});
                sub =  tit(q) + "-level " + disc.Name;
                
                text = text + "\n \\spellBook{"+bName+"}{"+sub+"}{\n";
                
                for k = 1:length(disc.Spells{q+1})
                    
                    text = text + disc.Spells{q+1}(k).output() + "\n";
                end
                
                text = text + "}";
                
            end
            
        end
    end
    
    fileName = bookRoot + "SpellBooks.tex";

    readFile = fileread(fileName);
    insertPoint = strfind(readFile, '%%SpellbookBegin');
    endPoint = strfind(readFile, '%%SpellbookEnd');
    firstHalf = prepareText(readFile(1:insertPoint+16),0,0);

    secondHalf = prepareText(readFile(endPoint:end),0,0);

    fullText = firstHalf + text + "\n" + secondHalf;
    FID = fopen(fileName,'w');
    fprintf(FID, fullText);
    fclose(FID);
    
end