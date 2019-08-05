files ={'hexes.xlsx','transfiguration.xlsx','charms.xlsx','healing.xlsx','illusion.xlsx','divination.xlsx','darkarts.xlsx'};
sectionHeads = {'Hexes \& Curses', 'Transfiguration','Charms','Healing \& Warding','Illusion','Divination','Dark Arts'};
filler ={'Combat-based magic, used to incapacitate or even inflict pain upon your enemies.','Alter the very fabric of reality with these spells, changing one thing, into another and even conjuring things from thin air.  ',...
    'Manipulate objects with magic: cause things to levitate, fix things that are broken and control the elements.',...
    'Set up wards and protective barriers, and heal those who are injured. Wards are special magic effects that are cast on an area (rather than a person or object). Unlike normal defensive spells, they can be cast once, and then forgotten about, but move outside the protected area, and there is no defence. Wards also have a nasty habit of interfering with each other if they overlap. ',...
    'Impose your will on other people, and alter the way they perceive the world.',...
    'Peer through the mystic veil and perceive things beyond human comprehension: past, present and future.',...
    'Evil spells, used by evil people. Expect a heavy burden on your soul if you rely on the dark arts to accomplish your goals.'};
fileName = '../Chapters/Spells.tex';
readFile = fileread(fileName);

insertPoint = strfind(readFile, '%%SpellBegin');

endPoint = strfind(readFile, '%%SpellEnd');

firstHalf = readFile(1:insertPoint+12);
secondHalf = readFile(endPoint:end);
text = '';

for i = 1:length(files)
    files{i}
    statuses= readtable(files{i});
    [n,~] = size(statuses);
    statuses = sortrows(statuses);
    for j = 1:n
        statuses.Name{j}
        m = statuses.Level{j};
        e = 6;
        if length(m) < 6
            e = length(m);
        end
        
        r = str2num(m(1));
        if (size(r) > 0)
            statuses.LVL(j) = r;
        end
    end
    
    
    statuses = sortrows(statuses,8);
    
    title = ['\subsection*{', sectionHeads{i}, '} \addcontentsline{toc}{subsection}{Spell School: ',sectionHeads{i},' } ', filler{i} '\\ '];
    preamble = '\footnotesize \begin{center} \tablealternate \begin{longtable}{|m{\t cm} m{\u cm} m{\v cm} m{\w cm} m{\x cm} m{\z cm}|}';
    headers = '\hline \tablehead {\normalsize \bf Name } & {\normalsize \bf Class} & {\normalsize \bf Mastery}& {\normalsize \bf FP}  & {\normalsize \bf Check} & \bf {\normalsize Effect}  \\ \hline \hline ';
    
    text = [text title preamble headers];
    
    
    
    for (i = 1:n)
        line = ['\bf \begin{center}' statuses.Name{i}, '\end{center} &  \parbox[t]{\u cm}{\begin{center}',  statuses.Class{i}, '\end{center}}',...
            '  &   \parbox[t]{\v cm}{\begin{center}', statuses.Level{i}(3:end), '\end{center}}',...
            '  &   \parbox[t]{\w cm}{\begin{center}', num2str(statuses.Fortitude(i)), '\end{center}}',...
            ' &    \parbox[t]{\x cm}{\begin{center} ',  statuses.Check{i} '\\~\\ Target:', num2str(statuses.Difficulty(i)),'\end{center}}',...
            '&      \parbox[t]{\z cm}{\begin{flushleft}', statuses.Effect{i}, '\end{flushleft}} \\  '];
        text = [text line];
    end
    ender = '\hline\end{longtable} \end{center} \normalsize \vspace{4ex}';
    
    text = [text ender];
end
fullText = [firstHalf, text, secondHalf];
FID = fopen(fileName,'w');
fwrite(FID, fullText);