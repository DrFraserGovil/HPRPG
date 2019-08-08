nLevels = 20;
nLevelsShort = 5;

fileName = '../Chapters/Archetypes.tex';
readFile = char(fileread(fileName));
%% doubleup on backslashes
i = 1;
N = length(readFile);
while i <= N
    c = readFile(i);
    if c == "\"
        readFile = char(strcat(readFile(1:i), "\",readFile(i+1:end)));
        i = i + 1;
        N = length(readFile);
    end
    if c == "%"
        if readFile(i+1)=="%"
            p1 = readFile(1:i-1);
            p2 = readFile(i+2:end);
            join = strcat(p1,"%%%%",p2);
            i = i + 2;
        else
            p1 = readFile(1:i-1);
            p2 = readFile(i+1:end);
            join = strcat(p1,"%%",p2);
            i = i + 1;
        end
        readFile = char(join);
        N = length(readFile);
        
    end
    i = i + 1;
end

%% Chunk the file
keyBegin = strfind(readFile,"%%%%keyBegin");
keyEnd = strfind(readFile,"%%%%keyEnd");
tableBegin = strfind(readFile,"%%%%tableBegin");
tableEnd = strfind(readFile,"%%%%tableEnd");

stableBegin = strfind(readFile,"%%%%smallTableBegin");
stableEnd = strfind(readFile,"%%%%smallTableEnd");

defaultBegin = strfind(readFile,"%%%%defaultBegin");
defaultEnd = strfind(readFile,"%%%%defaultEnd");





chunk1 = readFile(1:keyBegin +14);
chunk2 = readFile(keyEnd:tableBegin+16);
chunk3 = readFile(tableEnd:stableBegin+22);
chunk4 = readFile(stableEnd:defaultBegin+18);
chunk5 = readFile(defaultEnd:end);
%% Define keys
t1 = "";
for i = 1:nLevels
    textProf = strcat("\\define@key{archetype}{arcane", num2roman(i), "}{\\def\\arcane", num2roman(i), "{#1}}");
    t1 = t1 + textProf + "\n";
    
    textAlpha = strcat("\\define@key{archetype}{alphaFeature", num2roman(i), "}{\\def\\alpha", num2roman(i), "{#1}}");
    textBeta = strcat("\\define@key{archetype}{betaFeature", num2roman(i), "}{\\def\\beta", num2roman(i), "{#1}}");
    t1 = t1 + textAlpha + "\n";
    t1 = t1+ textBeta + "\n";
    
    textFeature = strcat("\\define@key{archetype}{feature", num2roman(i), "}{\\def\\feature", num2roman(i), "{#1}}");
    t1 = t1 + textFeature + "\n";
    
    
    
end


%% Define Key defaults
t2 = "\\setkeys{archetype}{";
for i = 1:nLevels
    if i > 1
        t2 = t2 + ",";
    end
    arcane =  strcat(" arcane",num2roman(i),"=", num2str(floor(i/5)));
    t2 = t2 + arcane;
    
    t2 = t2 + strcat(", alphaFeature",num2roman(i),"= -- ");
    t2 = t2 +  strcat(", betaFeature",num2roman(i),"= --");
    
    t2 = t2 + strcat(", feature",num2roman(i),"= --");
    
end
t2 = t2 + "}";



%% Define table
t3 = "";
for i = 1:nLevels
    t3 = t3 + num2str(i) + "  &  + \\arcane" + num2roman(i);
    
    
    pBox = "\\parbox[t]{\\w cm}{\\raggedright";
    arg0 = pBox + "\\feature" + num2roman(i) + "}";
    arg1 = pBox + "\\alpha" + num2roman(i) + "}";
    arg2 = pBox + "\\beta" + num2roman(i) + "}";
    t3 = t3 + " & "+ arg0 + " & " + arg1 + "  &  " + arg2 +  "\n \\\\\n";
    
    if i <= nLevelsShort
        t4 = t3;
    end
end

fullText = chunk1 + t1 + "\n";
fullText = fullText + chunk2 + t3+ "\n";
fullText = fullText +chunk3 + t4+ "\n";
fullText = fullText + chunk4 + t2 + "\n"+  chunk5 + "\n";

fprintf(t1)
fprintf(t3)
fprintf(t4)
fprintf(t2 + "\n")
%fullText
%fprintf(fullText)
%FID = fopen(fileName,'w');
%fprintf(FID,fullText);

