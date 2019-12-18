function schools = allSpellAssembler(maxLevel)
    if nargin < 1
        maxLevel = 5;
    end
    
    %% open file
    opts = detectImportOptions('AllSpells.xlsx','NumHeaderLines',2);
    opts.VariableNamesRange = 'A1';
    f = readtable("AllSpells.xlsx",opts,'ReadVariableNames',true);

    %% read in the file line by line and sort into schools and disciplines
    schools = SpellSchool.empty;
    for i = 1:height(f)
        newSpell = Spell();
        newSpell.ReadLine(f(i,:));

        schoolFound= false;
        for j = 1:length(schools)
            if strcmp(schools(j).Name,newSpell.School) == 1            
                schoolFound = true;
                disc = schools(j).hasDiscipline(newSpell.Discipline);
                if disc > 0    
                    schools(j).Discipline(disc).Spells{newSpell.Level}(end+1) = newSpell;
                else
                    newDisc = SpellDiscipline(newSpell.Discipline);
                    newDisc.Spells{newSpell.Level}(1) = newSpell;
                    schools(j).Discipline(end+1) = newDisc;
                end
            end
        end

        if schoolFound == false
           newSchool = SpellSchool(newSpell.School);
           newDisc = SpellDiscipline(newSpell.Discipline);
           newDisc.Spells{newSpell.Level}(1) = newSpell;
           newSchool.Discipline(1) = newDisc;
           schools(end+1) = newSchool;
        end
    end
    
    %%sort alphabetically
    [~,I] =sort({schools.SortName});
    schools = schools(I);
    for i = 1:length(schools)
       [~,I]= sort({schools(i).Discipline.Name});
       schools(i).Discipline = schools(i).Discipline(I);
    end
    
    %% create text for discipline tables
    disciplineTableText =  '\\scriptsize';
    
    for i = 1:length(schools)
        t = "\\vbox{\n\\subsection{" + schools(i).Name + "}\n";
        
        for j = 1:length(schools(i).Discipline)
            disc = schools(i).Discipline(j);
            t = t + "\n\\vbox{\n"; 
            
            col = ">{\\centering\\arraybackslash}m{\\w cm} >{\\centering\\arraybackslash}m{\\s cm}";
            t = t + "\\begin{rndtable}{"+ col + col + col + col + col + "}\n";
            t =t + "\\multicolumn{10}{c}{\\bf \\normalsize " + disc.Name + "} \n\\\\\n ";
            for q = 1:5
                t = t + "\\multicolumn{2}{c}{\\cellcolor{\\tablecolorhead} \\bf Level~" + num2str(q) + "}";
                if q <5
                    t = t + "&";
                end
            end
            
            for row = 1:disc.maxSpellNumber()
                t = t + "\n \\\\ \n";
                for column = 1:5
                    
                    if row <= length(disc.Spells{column})
                        sp = disc.Spells{column}(row);
                        t = t + prepareText(sp.Name) + " & " +sp.Symbol;
                    else
                        t = t + "~\t & ~\t";
                    end
                    
                    if column < 5
                        t = t + " & ";
                    end
                end        
            end
            t= t + "\n\\end{rndtable}\n\\vspace{3ex}\n}";
        end
        
        t = t + "\n}";
        disciplineTableText = disciplineTableText + t + "\n\n";
    end
    
    
    fullText = disciplineTableText;% + alphList + "\\end{multicols}";
    fileName = '../Chapters/SpellList.tex';
%     if cutoff < 3
%         fileName =  '../Chapters/SpellListShort.tex';
%     end
    FID = fopen(fileName,'w');
    fprintf(FID, fullText);
    fclose(FID);
end