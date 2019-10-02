tools = readtable('Items/tools.xlsx');
tools = sortrows(tools);

fileName = '../Chapters/Items.tex';
readFile = fileread(fileName);


insertPoint = strfind(readFile, '%%ToolsBegin');

endPoint = strfind(readFile, '%%ToolsEnd');

firstHalf = readFile(1:insertPoint+13);

secondHalf = readFile(endPoint:end);


preamble = ' \begin{center}\begin{rndtable}{|l l l|}';
headers = '\hline \tablehead \normalsize \bf Name & \normalsize \bf Weight & \normalsize \bf Cost \\ \hline ';

text = [preamble headers];

n = size(tools);

for (i = 1:n)
    tool = tools.Name{i};
    weight = tools.Weight{i};
    cost = tools.Cost(i);
    
    line = ['\bf ', tool, ' &  ', weight, ' & ', num2str(cost), ' gold \\  '];
     
    text = [text line];
end
ender = '\hline\end{rndtable}\end{center} ';

fullText = [firstHalf, text, ender, secondHalf];

FID = fopen(fileName,'w');
fwrite(FID, fullText);
