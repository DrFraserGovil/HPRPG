function assembleStatus(fileRoot)

    if nargin < 1
        disp('Insufficient inputs provided');
        addpath('../Functions/');
        fileRoot = '../../';
    end
    opts = detectImportOptions("Statuses.xlsx","ReadVariableNames",true,"NumHeaderLines",0);
    statuses= readtable('Statuses.xlsx',opts);
    statuses = sortrows(statuses);

    
    text = "";

    n = size(statuses);
    W= width(statuses);
    for (i = 1:n)
        
        r = statuses{i,3}{1};
        line = "\status{" + statuses.Name{i} + "}{";
        line = line + statuses{i,2}{1} + "}{";
        
        j =3;
         r = statuses{i,j}{1};
            while j <= W && ~isempty(r) 
               
                line = line + "\item " + r;
                j = j +1;
                
                r = "";
                if j <= W
                    r = statuses{i,j}{1};
                end
  
            end
  
        line = line + "}";
        text = text + prepareText(line) + "\n\n";
    end

    fileName = strcat(fileRoot,'Chapters/Part2_Actions/StatusList.tex');
   

    FID = fopen(fileName,'w');
    fprintf(FID, text);
end