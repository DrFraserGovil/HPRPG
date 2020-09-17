function assembleTools(fileRoot)
    if nargin < 1
        disp('Insufficient inputs provided');
        addpath('../Functions/');
        fileRoot = '../../';
    end
    fileNameRoot = fileRoot + "Chapters/Part3_Items/";
    tools = readtable('tools.xlsx');
    tools = sortrows(tools);

    fileName = fileNameRoot + "toolList.tex";
    

    text = "";
    n = size(tools);

    for i = 1:n
        if ~isempty(tools.Name{i})
            tool = prepareText(tools.Name{i});
            attribute =  prepareText(tools.Attribute{i});
            components =  prepareText(tools.Components{i});
            description = prepareText(tools.Purpose{i});
            
            
            
            
            line = "\\tool{"+tool + "}{" + attribute + "}{" + components + "}{" + description +"}\n";
            text = text + line;
        end
    end
   



    FID = fopen(fileName,'w');
    fprintf(FID,text);
end