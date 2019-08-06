nLevels = 20;

%% Define keys
t = "";
for i = 3:nLevels
    textProf = strcat("\\define@key{archetype}{arcane", num2roman(i), "}{\\def\\arcane", num2roman(i), "{#1}}");
    textAlpha = strcat("\\define@key{archetype}{alphaFeature", num2roman(i), "}{\\def\\alpha", num2roman(i), "{#1}}");
     textBeta = strcat("\\define@key{archetype}{betaFeature", num2roman(i), "}{\\def\\beta", num2roman(i), "{#1}}");
    t = t + textProf + "\n";
    t = t + textAlpha + "\n";
    t = t+ textBeta + "\n";
end
disp("%Key definitions:")
fprintf(t)

%% Define Key defaults
t = "\\setkeys{archetype}{firstLevelFeature=None,secondLevelFeature=None";
for i = 1:nLevels
    arcane =  strcat(", arcane",num2roman(i),"=", num2str(floor(i/5)));
    t = t + arcane;
    if i > 2
        t = t + strcat(", alphaFeature",num2roman(i),"=None");
        t = t +  strcat(", betaFeature",num2roman(i),"=None");
    end
end
t = t + "}";
fprintf("\n\n Default keys:\n")
fprintf(t+"\n\n\n")


%% Define table
t = "\\bf Level 	&	\\bf Arcane Wisdom	&	\\bf #2 Features	&	\\bf #3 Features\n\\\\ \n";
for i = 1:nLevels
    t = t + num2str(i) + "  &  + \\arcane" + num2roman(i);
    
    if i > 2
        pBox = "\\parbox[t]{\\w cm}{\\raggedright";
        arg1 = pBox + "\\alpha" + num2roman(i) + "}";
        arg2 = pBox + "\\beta" + num2roman(i) + "}";
        t = t + " & "+ arg1 + "  &  " + arg2 +  "\n \\\\\n";
    else
        t = t + " & \\multicolumn{2}{c}{";
        if i == 1
            t = t + "\\firstLVLf";
        else
            t = t + "\\secondLVLf";
        end
        t = t + "} \n\\\\\n";
    end
    
end 
fprintf(t)