function assembleArtefacts()
    if nargin < 1
        disp('Insufficient inputs provided');
        addpath('../Functions/');
        fileNameRoot = '../../Chapters/Part3_Items/';
    end
    
    items = readtable('artefacts.xlsx');
    items = sortrows(items);

     I = [];
    for i = 1:size(items)
        if isempty(items.Name{i})
            I(end+1) = i;
        end
    end
    items(I,:) = [];
    
    fileName = fileNameRoot + "Artefacts.tex";
    readFile = fileread(fileName);


    insertPoint = strfind(readFile, '%%ArtefactBegin');

    endPoint = strfind(readFile, '%%ArtefactEnd');

    firstHalf = prepareText(readFile(1:insertPoint+15));

    secondHalf = prepareText(readFile(endPoint:end));


   
    text = "";
    text = prepareText(text);
    [n,~] = size(items);
    descriptionText = "";
    line = "";
    split = min(35,n);
    if 2*split < n
        disp ("Split value too low. Not all values will display")
    end
    descs = cell(1,n);
    for i = 1:split

        tool = prepareText(items.Name{i});
        weight = prepareText(items.Weight{i});
        cost = prepareText(items.Cost(i));
        description = prepareText(items.Description{i});
        %line = strcat('\t  \\parbox[t]{\\q cm}{\\bf \\raggedright \\footnotesize',{' '}, tool, '}\t&\t  ', weight, '\t&\t', cost, ' gold \\\\ \n ');

        line = strcat("\\singleRow{{" + tool + "}{" + weight + "}{" + cost + "}}\n");
        
        if description~=""
            entry = strcat('\n \n \\generic{',tool,'}{',description,'}');
            descs{i} = entry;
        else
            descs{i} = "";
        end

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