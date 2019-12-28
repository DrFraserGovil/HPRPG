function assembleStatus()
statuses= readtable('Statuss.xlsx');
statuses = sortrows(statuses);

preamble = '\begin{center} \tablealternate\begin{longtable}{|m{\w cm}  m{\y cm} m{\z cm}|}';
headers = '\hline  \tablehead  \normalsize {\bf Status} & \normalsize \bf Effect & \normalsize \bf Duration \\  ';

text = [preamble headers];

n = size(statuses);

for (i = 1:n)
    line = ['\bf \begin{flushleft} ' statuses.Name{i}, '\end{flushleft}  ',...
           '  &   \parbox[t]{\y cm}{\begin{flushleft}', statuses.Effect{i}, '\end{flushleft}}',...
           '  &   \parbox[t]{\z cm}{\begin{flushleft}', statuses.Duration{i}, '\end{flushleft}}  \\'];
    text = [text line];
end
ender = ' \hline \end{longtable} \end{center}';



fileName = '../Chapters/HealthFortitudeStatuses.tex';
readFile = fileread(fileName);


insertPoint = strfind(readFile, '%%StatusBegin');

endPoint = strfind(readFile, '%%StatusEnd');

firstHalf = readFile(1:insertPoint+13);

secondHalf = readFile(endPoint:end);
fullText = [firstHalf, text, ender, secondHalf];

FID = fopen(fileName,'w');
fwrite(FID, fullText);
end