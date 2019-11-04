skills= readtable('skills.xlsx');
[n,~] = size(skills);



%statuses = sortrows(statuses,5);



fileName = '../Chapters/Skills.tex';
readFile = fileread(fileName);


insertPoint = strfind(readFile, '%%SkillBegin');

endPoint = strfind(readFile, '%%SkillEnd');

firstHalf = readFile(1:insertPoint+12);

secondHalf = readFile(endPoint:end);


preamble = '\begin{center} \tablealternate \begin{longtable}{|m{\w cm}  m{\y cm} m{\x cm} m{\z cm}|}';
headers = '\hline \tablehead \normalsize \bf Name  & \normalsize \bf Effect & \bf \normalsize Levels & \normalsize \bf Prerequisite \\ \hline \hline ';

text = [preamble headers];



for (i = 1:n)
    line = ['\bf \begin{flushleft} ' skills.Name{i}, '\end{flushleft}',...
        '  &   \parbox[t]{\y cm}{\begin{flushleft}', skills.Effect{i}, '\end{flushleft}}',...
        '  &   \parbox[t]{\x cm}{\begin{center}', num2str(skills.SkillLevels(i)), '\end{center}}',...
        '  &   \parbox[t]{\z cm}{\begin{center} \it ', skills.Prerequisite{i}, '\end{center}}  \\  '];
    inc = skills.Include(i);
    if inc == 1
        text = [text line];
    end
end
ender = '\hline\end{longtable} \end{center}';

fullText = [firstHalf, text, ender, secondHalf];

FID = fopen(fileName,'w');
fwrite(FID, fullText);
