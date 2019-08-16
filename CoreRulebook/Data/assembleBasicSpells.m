function assembleSpells2(maxLevel)
    files ={'hexes.xlsx','transfiguration.xlsx','charms.xlsx','recuperation.xlsx','illusion.xlsx','divination.xlsx','darkarts.xlsx'};

    sectionHeads = {'Hexes \\& Curses', 'Transfiguration','Charms','Recuperation','Illusion','Divination','Dark Arts'};
    filler ={'Combat-based magic, used to incapacitate or even inflict pain upon your enemies.',...
        'Alter the very fabric of reality with these spells, changing one thing, into another and even conjuring things from thin air.  ',...
        'Manipulate objects with magic: cause things to levitate, fix things that are broken and control the elements.',...
        'Set up wards and protective barriers, and heal those who are injured. Recuperative magic is used to stop further harm coming to individuals under your protection. ',...
        'Impose your will on other people, and alter the way they perceive the world. Play tricks with light, and with people\apos{}s minds.',...
        'Peer through the mystic veil and perceive things beyond human comprehension: past, present and future.',...
        'Evil spells, used by evil people. Expect a heavy burden on your soul if you rely on the dark arts to accomplish your goals.'};
    [files,I] =sort(files);
    sectionHeads = sectionHeads(I);
    filler = filler(I);


    fileName = '../Chapters/SpellList.tex';
    readFile = fileread(fileName);


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
    text = '\\begin{multicols}{3}';
    for j = 1:length(files)
        t = "\\subsubsection{" + sectionHeads{j} + "}\n";
        array = schoolSpells{j};
        N = length(array);
        lvl = array(1).Level;
        loopContinues = (lvl <= cutoff);
        idx = 1;
        while loopContinues
            tp = "\\textbf{Level " + num2str(lvl)+ " Spells}\n\\begin{itemize}[itemsep=0em]\n\\renewcommand\\labelitemi{-}\n";
            while idx <= N &&  array(idx).Level == lvl
                n = prepareText(array(idx).Name);
                tp = tp + "\\item " + n + "\n\n";
                idx = idx + 1;
            end
            if (idx <= N)
                lvl = array(idx).Level;
            end
            endNotReached = (idx <= N);
            cutoffNotReached = (lvl <=cutoff);

            loopContinues = endNotReached && cutoffNotReached;
            t = t + tp + "\n\\end{itemize}\n";
        end

        text = text + t;
    end
    text = text + "\\end{multicols}";
    %% Assemble alphabetised lists


    FID = fopen(fileName,'w');
    fprintf(FID, text);
end