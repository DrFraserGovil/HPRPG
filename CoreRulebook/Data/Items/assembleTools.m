function assembleTools()
    tools = readtable('Items/tools.xlsx');
    tools = sortrows(tools);

    fileName = '../Chapters/Tools.tex';
    readFile = fileread(fileName);


    insertPoint = strfind(readFile, '%%ToolsBegin');

    endPoint = strfind(readFile, '%%ToolsEnd');

    firstHalf = prepareText(readFile(1:insertPoint+13));

    secondHalf = prepareText(readFile(endPoint:end));


    preamble = ' \begin{center}\begin{rndtable}{|l l l|}';
    headers = '\hline \normalsize \bf Name & \normalsize \bf Weight & \normalsize \bf Cost \\ \hline ';

    text = [preamble headers];
    text = prepareText(text);
    n = size(tools);
    descriptionText = "";
    for (i = 1:n)
        if ~isempty(tools.Name{i})
            tool = prepareText(tools.Name{i});
            weight = prepareText(tools.Weight{i});
            cost = prepareText(tools.Cost(i));
            description = prepareText(tools.Description{i});
            line = strcat('\t\\bf ',{' '}, tool, '\t&\t ', weight, '\t&\t', cost, '\n \\\\ \n'); 
            text = strcat(text,line);

            entry = strcat('\n \n \\tool{',tool,'}{',description,'}');
            descriptionText = descriptionText + entry;
        end
    end
    ender = '\\hline\n\\end{rndtable}\n\\end{center} \n';

    fullText = strcat(firstHalf, text, ender, descriptionText, secondHalf);



    FID = fopen(fileName,'w');
    fprintf(FID,fullText);
end