texFiles = dir('Archetypes/*.tex');
sList = {};
lList = {};
for i = 1:length(texFiles)
    fileObj = texFiles(i);
    tableFile = "Archetypes/" + fileObj.name(1:end-4) + ".xlsx";
    file = char(tableFile);
    
    f = readtable(file);
    [n,~] = size(f);
    name = f.Properties.VariableNames{3};
    branch1 = f.Properties.VariableNames{4};
    branch2 = f.Properties.VariableNames{5};
    des = f.Properties.VariableDescriptions;
    if ~isempty(des)
        if ~isempty(des{3})
            name = des{3}(27:end-1);
        end
        if ~isempty(des{4})
            branch1 = des{4}(27:end-1);
        end
        if ~isempty(des{5})
            branch2 = des{5}(27:end-1);
        end
    end
    
    mode = 0;
    if n==5
        mode = 1;
        sList{end+1} = fileObj.name(1:end-4);
    else
        lList{end+1} = fileObj.name(1:end-4);
    end
    
    vars = "";
    for i = 1:n
        com = ", ";
        
        if vars == ""
            com = "";
        end
        if ~isempty(f.(3){i})
            t = "feature"+num2roman(i)+"=" + f.(3){i};
            vars = vars + com + t;
            com = ", ";
            
        end
        
        if ~isempty(f.(4){i})
            t = "alphaFeature"+num2roman(i)+"=" + f.(4){i};
            vars = vars + com +  t;
            com = ", ";
            
        end
        if ~isempty(f.(5){i})
            t = "betaFeature"+num2roman(i)+"=" + f.(5){i};
            vars = vars + com + t;
            com = ", ";
            
        end
        if f.(2)(i) ~= floor(i/5)
            t = "arcane"+num2roman(i)+"=" +num2str( f.(2)(i));
            vars = vars+ com + t;
            com = ", ";
        end
    end
    vars
    
    
    fullText = "\archetype{"+name+"}{"+branch1+"}{"+branch2+"}{"+num2str(mode)+"}{" + vars +"}";
    
    fileName = "Archetypes/" + fileObj.name;
    readFile = fileread(fileName);
    sTrigger = "%%archBegin";
    eTrigger = "%%archEnd";
    insertPoint = strfind(readFile,sTrigger)+length(char(sTrigger));
    endPoint = strfind(readFile,eTrigger);
    
    
    t = readFile(1:insertPoint) + fullText + readFile(endPoint:end);
    
    
    FID = fopen(fileName,'w');
    fwrite(FID, t);
    t;
end

short = sort(sList);
long = sort(lList);

t = "";
for i = 1:length(short)
    s = short{i};
    t = t + "\n\\clearpage\n\\subfile{Data/Archetypes/"+s+"}";
end
for i = 1:length(long)
    s = long{i};
    t = t + "\n\\clearpage\n\\subfile{Data/Archetypes/"+s+"}";
end
t = t + "\n";
fprintf(t)