function assembleEncounters(beastRoot)
   
    %if no target given, assume that called directly, else assume called by
    %master
   
    if nargin < 1
        disp('Insufficient inputs provided');
        addpath('../../../CoreRulebook/Data/Functions/');
        beastRoot = '../../Data/Beasts/';
 
    end
    
    addpath(beastRoot);
    
    opts = detectImportOptions("beasts.xlsx","NumHeaderLines",2);
    f = readtable("beasts.xlsx",opts);
    
    g = {'SpeciesOrder','Name','Species','Description','Rating','Mind','Category','Unharmed','Bruised','Hurt','Injured','Wounded','Mangled','Fortitude','Fitness','Precision','Vitality','Charm','Deception','Insight','Intelligence','Willpower','Perception','Block','Dodge','Defy','Immune','Resistant','Susceptible','Languages','Walk','Tunnel','Fly','Climb','Swim','Armaments','Skills','Abilities','Image','Stack'};
    f.Properties.VariableNames = g;
    f = sortrows(f);
    h = height(f);
    
    beasts = Beast.empty;
    for i = 1:h
        beasts(end+1) = Beast(f(i,:));
    end
   
    
    e= readtable("../Encounters.xlsx");
    E = Encounter.empty;
    for i = 1:height(e)
       E(end+1) = Encounter(e(i,:), beasts);
    end
    
    
    for i = 1:length(E)
       t = "\\input{EncounterDefinitions}\n\n\\begin{document}\n";
       t = t + E(i).print();
       t = t + "\n\n\\end{document}";
       
       targetName = E(i).ShortName + ".tex";
       FID = fopen(targetName,'w');
        fprintf(FID, t);
        fclose(FID);
        
        command = "xelatex -output-directory=../EncounterSheets/ " + E(i).ShortName + ".tex";
        system(command);
    end
    
    endings = ["aux", "log", "out"];
    for i = 1:length(endings)
        com = "rm ../EncounterSheets/*." + endings(i);
        system(com);
    end

end