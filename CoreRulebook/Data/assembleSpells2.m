function assembleSpells2(maxLevel)
    if nargin < 1
        maxLevel =5;
    end
    files ={'hexes.xlsx','transfiguration.xlsx','charms.xlsx','recuperation.xlsx','illusion.xlsx','divination.xlsx','darkarts.xlsx'};

    sectionHeads = {'Hexes \\& Curses', 'Transfiguration','Charms','Recuperation','Illusion','Divination','Dark Arts'};

    [files,I] =sort(files);
    sectionHeads = sectionHeads(I);

    allSpells = Spell.empty;
    schoolSpells = {};
    c = 1;
    cutoff = maxLevel;

    %% Read in spells
    for i = 1:length(files)
        schoolArray = Spell.empty;
        disp(files{i})
        spells= readtable(files{i});

        [n,~] = size(spells);

        for j = 1:n
            newSpell = Spell();
            newSpell = newSpell.ReadLine(spells(j,:),sectionHeads{i});
            L = newSpell.Level;
            if L <=cutoff
                allSpells(c) = newSpell;
                schoolArray(j) = newSpell;
                c= c+1;
            end
        end
        schoolSpells{i} = schoolArray;
    end

    %% Assemble school-ordered lists


    schoolList = '\\begin{multicols}{4} \\raggedbottom';
    for j = 1:length(files)
        pageJump = "\\vfill\\null\n\\columnbreak";
        if cutoff <3 && mod(j,2)>0
            pageJump = "";
        end
        t = "\\subsubsection{" + sectionHeads{j} + "}\n";
        array = schoolSpells{j};
        [~,I] = sort([array.Level]);
        array = array(I);
        N = length(array);
        lvl = array(1).Level;
        loopContinues = (lvl <= cutoff);
        idx = 1;
        while loopContinues
            tp = "\\textbf{Level " + num2str(lvl)+ " Spells}\n\\begin{itemize}[itemsep=0em]\n\\renewcommand\\labelitemi{-}\n";
            spellLevels = Spell.empty;
            c = 1;
            while idx <= N &&  array(idx).Level == lvl
                spellLevels(c) = array(idx);
                c = c+1;
                idx = idx + 1;
            end

            [~,I] = sort({spellLevels.Name});
            spellLevels = spellLevels(I);
            for k = 1:length(spellLevels)
                n = prepareText(spellLevels(k).Name);
                tp = tp + "\\item " + n + "\n\n";
            end
            if (idx <= N)
                lvl = array(idx).Level;
            end
            endNotReached = (idx <= N);
            cutoffNotReached = (lvl <=cutoff);

            loopContinues = endNotReached && cutoffNotReached;
            t = t + tp + "\n\\end{itemize}\n";
        end

        schoolList = schoolList + t + pageJump;
    end
    schoolList = schoolList + "\\end{multicols}\\clearpage";

    %% Assemble alphabetised lists
    alphList = '\\begin{multicols}{3}';
    [~,I] = sort({allSpells.Name});
    allSpells = allSpells(I);

    for j = 1:length(allSpells)
        sp = allSpells(j);
        t = "\\spell{";
        t = t+ "name = " + prepareText(sp.Name)+", ";
        t = t + "incant = " + prepareText(sp.Incantation)+", ";
        if isempty(sp.Incantation)
            t = t + "noIncant = 1, ";
        end
        t = t + "school = " + sp.School+", ";
        t = t + "type = " + prepareText(sp.Type)+", ";
        t = t + "level =" + sp.LevelName+", ";
        t = t + "fp = " + num2str(sp.FP)+", ";
        t = t + "attribute =" + sp.Check+", ";
        t = t + "proficiency = " + prepareText(sp.Proficiency)+", ";
        if isempty(sp.Proficiency)
            t = t + "noProf = 1, ";
        end
        t = t + "dv = " + num2str(sp.DV)+", ";
        t = t + "effect =" + prepareText(sp.Effect) + "}";
        
        alphList = strcat(alphList, t, "\n");

    end

    fullText = schoolList + alphList + "\\end{multicols}";
    fileName = '../Chapters/SpellList.tex';
    FID = fopen(fileName,'w');
    fprintf(FID, fullText);
    fclose(FID);
end