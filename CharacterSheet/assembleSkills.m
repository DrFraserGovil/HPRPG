	skills= readtable('../CoreRulebook/Data/skills.xlsx');
[n,~] = size(skills);
skills = sortrows(skills);

skills.SortName = skills.Name;
for i = 1:n
   if contains(skills.Name{i},"Species")
      skills.SortName{i} = strcat('zzz_', skills.SortName{i}); 
   end
   if contains(skills.Name{i},"Magic:")
      skills.SortName{i} = strcat('A_',skills.SortName{i}); 
   end
end

[~,I] = sort(skills.SortName);
skills = skills(I,:);
%statuses = sortrows(statuses,5);



preamble = '\begin{longtable}{|m{\x cm}|m{\y cm}|m{\z cm}|}';
headers = '\hline  \bf Skill & \bf Prerequisite & \bf Level \\ \hline \hline ';

text = [preamble headers];



for (i = 1:n)
    skilldots = '\vspace{-1ex} \normalsize $$';
    m = 0;
    j = skills.SkillLevels(i);
    while m < j
        skilldots = [skilldots '\circ'];
        m = m + 1;
    end
    skilldots = [skilldots '$$\vspace{1ex}'];
    
    if contains(skills.Name{i},"Magic:")
        skilldots = '\vspace{-1ex} \normalsize $$\oneblack$$\vspace{1ex}';
    end
    line = ['\vspace{1ex}\parbox[t]{\x cm}{\raggedright ' skills.Name{i},...
        '}\vspace{1ex}  &  \vspace{1ex}\parbox[t]{\y cm}{\centering \color{pale}', skills.Prerequisite{i},...
        '\vspace{1ex}}& {\vspace{-\top ex}',  skilldots,    '\vspace{-\bottom ex}}\\ \hline '];
    
    text = [text line];
    
end
ender = '\end{longtable} ';




fileName = 'CharacterSheet.tex';
readFile = fileread(fileName);


insertPoint = strfind(readFile, '%%SkillBegin');

endPoint = strfind(readFile, '%%SkillEnd');

firstHalf = readFile(1:insertPoint+12);

secondHalf = readFile(endPoint:end);

fullText = [firstHalf, text, ender, secondHalf];

FID = fopen(fileName,'w');
fwrite(FID, fullText);
