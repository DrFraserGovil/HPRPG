statuses= readtable('Statuss.xlsx');
statuses = sortrows(statuses);

fileName = '../Chapters/HealthFortitudeStatuses.tex';
readFile = fileread(fileName);


insertPoint = strfind(readFile, '%%StatusBegin');

endPoint = strfind(readFile, '%%StatusEnd');

firstHalf = readFile(1:insertPoint+13);

secondHalf = readFile(endPoint:end);


preamble = '\begin{center} \begin{longtable}{|m{\w cm}|m{\x cm}|m{\y cm}|m{\z cm}|}';
headers = '\hline \normalsize \bf Status & \normalsize \bf Description & \normalsize \bf Effect & \normalsize \bf Duration \\ \hline \hline ';

text = [preamble headers];

n = size(statuses);

for (i = 1:n)
    line = ['\bf \begin{flushleft} ' statuses.Name{i}, '\end{flushleft}  &  \parbox[t]{\x cm}{\begin{flushleft}',  statuses.Description{i}, '\end{flushleft}}',...
           '  &   \parbox[t]{\y cm}{\begin{flushleft}', statuses.Effect{i}, '\end{flushleft}}',...
           '  &   \parbox[t]{\z cm}{\begin{flushleft}', statuses.Duration{i}, '\end{flushleft}}  \\ \hline '];
    text = [text line];
end
ender = '\end{longtable} \end{center}';

fullText = [firstHalf, text, ender, secondHalf];

FID = fopen(fileName,'w');
fwrite(FID, fullText);
