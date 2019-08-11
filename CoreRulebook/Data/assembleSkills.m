statuses= readtable('skills.xlsx');
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



fileName = '../Chapters/Skills.tex';
readFile = fileread(fileName);


insertPoint = strfind(readFile, '%%SkillBegin');

endPoint = strfind(readFile, '%%SkillEnd');

firstHalf = readFile(1:insertPoint+12);

secondHalf = readFile(endPoint:end);


preamble = '\begin{center} \tablealternate \begin{longtable}{|m{\w cm} m{\x cm} m{\y cm} m{\z cm}|}';
headers = '\hline \tablehead \normalsize \bf Name & \normalsize \bf Description & \normalsize \bf Effect & \normalsize \bf Prerequisite \\ \hline \hline ';

text = [preamble headers];



for (i = 1:n)
    line = ['\bf \begin{flushleft} ' statuses.Name{i}, '\end{flushleft}  &  \parbox[t]{\x cm}{\begin{flushleft}',  statuses.Description{i}, '\end{flushleft}}',...
        '  &   \parbox[t]{\y cm}{\begin{flushleft}', statuses.Effect{i}, '\end{flushleft}}',...
        '  &   \parbox[t]{\z cm}{\begin{center}', statuses.Prerequisite{i}, '\end{center}}  \\  '];
    inc = statuses.Include(i);
    if inc == 1
        text = [text line];
    end
end
ender = '\hline\end{longtable} \end{center}';

fullText = [firstHalf, text, ender, secondHalf];

FID = fopen(fileName,'w');
fwrite(FID, fullText);
