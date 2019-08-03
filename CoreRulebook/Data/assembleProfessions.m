professions = readtable('Professions.xlsx');
professions = sortrows(professions);

fileName = '../Chapters/CharacterCreation.tex';
readFile = fileread(fileName);


insertPoint = strfind(readFile, '%%ProfessionBegin');

endPoint = strfind(readFile, '%%ProfessionEnd');

firstHalf = readFile(1:insertPoint+18);

secondHalf = readFile(endPoint:end);


preamble = '\begin{center} \begin{longtable}{|m{\w cm}|m{\x cm}|m{\y cm}|m{\z cm}|}';
headers = '\hline \normalsize \bf Profession & \normalsize \bf Description & \normalsize \bf Associated Skills & \normalsize \bf Notes \\ \hline \hline ';

text = [preamble headers];

n = size(professions);

for (i = 1:n)
    line = ['\bf \begin{flushleft} ' professions.Profession{i}, '\end{flushleft}  &  \parbox[t]{\x cm}{\begin{flushleft}',  professions.Description{i}, '\end{flushleft}}',...
           '  &   \parbox[t]{\y cm}{\begin{flushleft}', professions.AssociatedSkills{i}, '\end{flushleft}}',...
           '  &   \parbox[t]{\z cm}{\begin{flushleft}', professions.Notes{i}, '\end{flushleft}}  \\ \hline '];
    text = [text line];
end
ender = '\end{longtable} \end{center}';

fullText = [firstHalf, text, ender, secondHalf];

FID = fopen(fileName,'w');
fwrite(FID, fullText);
