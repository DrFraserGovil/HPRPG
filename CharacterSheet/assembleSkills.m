statuses= readtable('../CoreRulebook/Data/skills.xlsx');
[n,~] = size(statuses);
statuses = sortrows(statuses);
for i = 1:n
    j = statuses.Prerequisite{i};
    e = 6;
    if length(j) < 6
        e = length(j);
    end
    r = str2num(j(4:e));
    if (size(r) > 0)
        statuses.LVL(i) = r;
    end
end


%statuses = sortrows(statuses,5);



fileName = 'CharacterSheet.tex';
readFile = fileread(fileName);


insertPoint = strfind(readFile, '%%SkillBegin');

endPoint = strfind(readFile, '%%SkillEnd');

firstHalf = readFile(1:insertPoint+12);

secondHalf = readFile(endPoint:end);


preamble = '\begin{longtable}{|m{\x cm}|m{\y cm}|m{\z cm}|}';
headers = '\hline  \bf Skill & \bf Prerequisite & \bf Level \\ \hline \hline ';

text = [preamble headers];



for (i = 1:n)
    skilldots = '\vspace{-1ex} \normalsize $$';
    m = 0;
    j = statuses.SkillLevels(i);
    while m < j
        skilldots = [skilldots '\circ'];
        m = m + 1;
    end
    skilldots = [skilldots '$$\vspace{1ex}'];
    
    if ismember(statuses.Name{i}, {'Battlemage','Clairvoyant','Defender','Thaumaturgus','Magician','Sorcerer','Brawler','Countervail'})
        skilldots = '\vspace{-1ex} \normalsize $$\oneblack$$\vspace{1ex}';
    end
    line = ['\vspace{1ex}\parbox[t]{\x cm}{\raggedright ' statuses.Name{i},...
        '}\vspace{1ex}  &  \vspace{1ex}\parbox[t]{\y cm}{\centering \color{pale}', statuses.Prerequisite{i},...
        '\vspace{1ex}}& {\vspace{-\top ex}',  skilldots,    '\vspace{-\bottom ex}}\\ \hline '];
    text = [text line];
end
ender = '\end{longtable}';

fullText = [firstHalf, text, ender, secondHalf];

FID = fopen(fileName,'w');
fwrite(FID, fullText);
