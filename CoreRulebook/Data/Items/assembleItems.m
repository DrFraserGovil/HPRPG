function assembleItems(fileNameRoot)
    if nargin < 1
        disp('Insufficient inputs provided');
        addpath('../Functions/');
        fileNameRoot = '../../Chapters/Part3_Items/';
    end
    items = readtable('Items/generic.xlsx');

    items = sortrows(items);
    I = [];
    for i = 1:size(items)
        if isempty(items.Name{i})
            I(end+1) = i;
        end
    end
    items(I,:) = [];
    
    fileName = fileNameRoot + "BasicGear.tex";
    readFile = fileread(fileName);


    insertPoint = strfind(readFile, '%%ItemsBegin');

    endPoint = strfind(readFile, '%%ItemsEnd');

    firstHalf = prepareText(readFile(1:insertPoint+13));

    secondHalf = prepareText(readFile(endPoint:end));



    text = "";
    text = prepareText(text);
    [n,~] = size(items);
    descriptionText = "";
    line = "";
    split = 30;
    if 2*split < n
        disp ("Split value too low. Not all values will display")
    end
    descs = cell(1,n);
    for (i = 1:split)

        tool = prepareText(items.Name{i});
        weight = prepareText(items.Weight{i});
        cost = prepareText(items.Cost(i));
        description = prepareText(items.Description{i});
        %line = strcat('\t  \\parbox[t]{\\q cm}{\\bf \\raggedright \\footnotesize',{' '}, tool, '}\t&\t  ', weight, '\t&\t', cost);

       	item1 = "{ " + tool + "}{" + weight + "}{"+ cost + "}";
        
        if description~=""
            entry = strcat('\n \n \\generic{',tool,'}{',description,'}');
            descs{i} = entry;
        else
            descs{i} = "";
        end
        j = split + i;
        if j <= n
            tool = prepareText(items.Name{j});
            weight = prepareText(items.Weight{j});
            cost = prepareText(items.Cost(j));
            description = prepareText(items.Description{j});

            %line = strcat(line,'\t&~&\t \\bf \\parbox[t]{\\q cm}{\\raggedright \\footnotesize',{' '}, tool, '}\t&\t  ', weight, '\t&\t', cost, '\\\\ \n');
            item2 = "{ " + tool + "}{" + weight + "}{"+ cost + "}";
            if description~=""
                entry = strcat('\n \n \\generic{',tool,'}{',description,'}');
                descs{j} = entry;
            else
                descs{j} = "";
            end

        else
            item2 = "{ ~}{~}{~}";
        end
        
        line = "\\doubleRow{" + item1 + "}{" + item2 + "} \n";
        
        text = strcat(text,line);

    end
    for j = 1:n
        descriptionText = strcat(descriptionText,descs{j});
    end



    ender = '\\hline\n\\end{rndtable}\n\\end{center} \n';

    fullText = strcat(firstHalf, text, ender, descriptionText, secondHalf);



    FID = fopen(fileName,'w');
    fprintf(FID,fullText);
end