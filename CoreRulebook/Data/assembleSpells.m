function disciplineArray =  assembleSpells(maxLevel)
    if nargin < 1
        maxLevel =5;
    end
    order = [4,  6 ,1,5,3,2,7];
    files ={'hexes.xlsx','transfiguration.xlsx','charms.xlsx','recuperation.xlsx','illusion.xlsx','divination.xlsx','darkarts.xlsx'};

    sectionHeads = {'Malediction', 'Transfiguration','Charms','Recuperation','Illusion','Divination','Dark Arts'};
    singularHeads = {'Malediction','Transfiguration','Charm','Recuperant','Illusion','Divination','Dark Art'};
    [order,I] =sort(order);
    files = files(I);
    sectionHeads = sectionHeads(I);
    singularHeads = singularHeads(I);
    allSpells = Spell.empty;
    schoolSpells = {};
    b = 1;
    cutoff = maxLevel;
    disciplineArray = Spell.empty;
    
    %% Read in spells
    for i = 1:length(files)
        schoolArray = Spell.empty;
        c1 = 0;
        c2 = 0;
        disp(files{i})
        q = strcat('Spells/',files{i});
        spells= readtable(q);

        [n,~] = size(spells);
        disc1 = -1;
        for j = 1:n
            newSpell = Spell();
            newSpell = newSpell.ReadLine(spells(j,:),singularHeads{i});
            
            if disc1 == -1
                disc1 = newSpell.Discipline;
            end
            discID = 2;
            if strcmp(newSpell.Discipline,disc1) == 0
                discID = 1;
                c1 = c1 +1;
                c = c1;
            else 
                discID = 2;
                c2 = c2 + 1;
                c = c2;
            end
            L = newSpell.Level;
            if L <=cutoff
                allSpells(b) = newSpell;
                disciplineArray(i,discID,c) = newSpell;
                 
                b= b+1;
            end
        end

    end
    %% Assemble school-ordered lists


    schoolList = '\\scriptsize';
    for j = 1:length(files)
         t = "\\vbox{\\subsection{" + sectionHeads{j} + "}\n";
       
        for k = 1:2  
            t = t + "\n";
            array = Spell.empty;

            [~,~,r] = size(disciplineArray(j,k,:));
            
            for q = 1:r 
                if disciplineArray(j,k,q).Level > 0 
                    disciplineArray(j,k,q);
                    array(end+1) = disciplineArray(j,k,q);
                end
            end
             t = t + "\n\\vbox{\\subsubsection{" + array(1).Discipline + "}\n\n";
            [~,I] = sort([array.Level]);
            array = array(I);
            N = length(array);
            lvlArrays = Spell.empty;
            
            cs = [1,1,1,1,1];
            for i = 1:N
                L = array(i).Level;
                lvlArrays(L,cs(L)) = array(i);
                cs(L) = cs(L) + 1;
            end
            
            col = ">{\\centering\\arraybackslash}m{\\w cm} >{\\centering\\arraybackslash}m{\\s cm}";
            t = t + "\\begin{rndtable}{"+ col + col + col + col + col + "}\n";
            t = t + "\\multicolumn{2}{c}{Level 1}   &  \\multicolumn{2}{c}{Level 2} & \\multicolumn{2}{c}{Level 3} & \\multicolumn{2}{c}{Level 4} & \\multicolumn{2}{c}{Level 5} \n\\\\\n";
            [~,l] = size(lvlArrays);
            for i = 1:l
                for p = 1:5
                    if p > 1
                        t = t + "&";
                    end
                    sp = lvlArrays(p,i);
                    if sp.Level > 0
                        n = prepareText(sp.Name);
                        if ~isempty(sp.HigherLevel)
                            n = n + " (*)";
                        end
                        n = n + "& " + sp.Symbol;
                        t = t + n;
                    else
                        t = t + "~&~";
                    end
                end
                 t = t + "\n\\\\\n";
            end
             
            t = t + "\\end{rndtable}}";
            if k == 1
                t = t + "}";
            end
            t = t + "\n\n";
           
        end
         schoolList = schoolList + t + " "; % pageJump;
    end
    schoolList = schoolList + "~\\vfill~\\clearpage\\normalsize";

    %% Assemble alphabetised lists
    alphList = '\\begin{multicols}{3}';
    [~,I] = sort({allSpells.Name});
    allSpells = allSpells(I);

    for j = 1:length(allSpells)
        sp = allSpells(j);
        t = sp.output();
        
        alphList = strcat(alphList, t, "\n");

    end

    fullText = schoolList + alphList + "\\end{multicols}";
    fileName = '../Chapters/SpellList.tex';
    if cutoff < 3
        fileName =  '../Chapters/SpellListShort.tex';
    end
    FID = fopen(fileName,'w');
    fprintf(FID, fullText);
    fclose(FID);
end