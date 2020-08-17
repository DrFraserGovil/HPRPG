function assembleArchetypes(fileRoot)

    %if no target given, assume that called directly, else assume called by
    %master

    if nargin < 1
        disp('Insufficient inputs provided');
        addpath('../Functions/');
        fileRoot = '../../';
    end
    fileNameRoot = strcat(fileRoot,'Chapters/Part1_Characters/');
    %% open file

    f = readtable("Archetypes.xlsx");
    headers = f.Properties.VariableNames;
    f = sortrows(f,1);
    t = "";
    for i = 1:height(f)
        t = t + "\\archetype\n{\n\tname = " +f{i,1}{1};
        for j = 2:length(headers)

            if j < length(headers)
                text = f{i,j}{1};
            else
                if ~isnan(f{i,j})
                    text = num2str(f{i,j});
                else
                    text = string.empty;
                end

            
            end
            if ~isempty(text)
                t = t + ",\n\t" + headers(j) + " = " + prepareText(text)+ "";
            end
        end
        t = t + ", feats = \\" + f{i,1}{1} + "Feats";
        t = t + "\n}\n\n";
    end



    %% output to file

    fileName = strcat(fileNameRoot, 'ArchetypesList.tex');


    readFile = fileread(fileName);
    insertPoint = strfind(readFile, '%%Begin');
    endPoint = strfind(readFile, '%%End');
    firstHalf = prepareText(readFile(1:insertPoint+7),0,0);

    secondHalf = prepareText(readFile(endPoint:end),0,0);

    fullText = firstHalf +t + "\n" + secondHalf;
    FID = fopen(fileName,'w');
    fprintf(FID, fullText);
    fclose(FID);

end