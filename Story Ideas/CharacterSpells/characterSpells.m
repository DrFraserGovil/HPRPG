addpath('../../CoreRulebook/Data/Functions/');
addpath('../../CoreRulebook/Data/Spells/');
[~,spells] = assembleSchools(6);


f = readtable("Spells.xlsx");
startID = 4;

names = string.empty;
for i = startID:width(f)
   name = string( f.Properties.VariableNames{i});
   charSpells = {Spell.empty, Spell.empty,Spell.empty,Spell.empty,Spell.empty,Spell.empty,Spell.empty};
   
   %detect and load the relevant spells
   colIDs = find(f{:,i} == 1);
   for j = 1:length(colIDs)
        id = colIDs(j);
        spellName = f{id,1};
        spellID = find(string({spells.Name})== spellName);
        
        if isempty(spellID)
            disp("Could not locate spell '" + spellName + "'");
        else
            spell = spells(spellID);
            n = spell.Level + 1;
            
            charSpells{n}(end+1) = spell;
        end
   end

   % sort each levels spells
   for i = 1:length(charSpells)
       [~,I] = sort({charSpells{i}.Name});
      charSpells{i} = charSpells{i}(I); 
   end

   summary = tableFormat(charSpells);
   list = listFormat(charSpells);
   text = "\\spellDoc{" + name + "\\apos{}s Spells}{\n" + summary + "\n\n" + list + "\n}";
   
   fullText = "\\input{spellDefinitions} \n\n" + text;
   
   fileName = name + "Spells.tex";
   
   FID = fopen(fileName,'w');
   fprintf(FID, fullText);
   fclose(FID);
   
    sysCommand = "xelatex " + fileName;
    system(sysCommand);
    rms = ["aux", "log", "out"];
    for i = 1:length(rms)
        system("rm *." + rms(i) );
    end
   
end


addpath(pathdef)

function t=  tableFormat(spellList)
    t = "{ \\footnotesize \n \\discTable{Memorised Spells}\n{\n";
    
    ns = [];
    for i = 1:length(spellList)
   
       ns(i) = length(spellList{i}); 
    end

    nMax = max(ns);
    
    for i = 1:nMax
        t = t + "\t\\spellRow";
        
        for q = 1:length(spellList)
            t = t + "{";
            if i <= length(spellList{q}) 
                t = t + prepareText( "\spellEntry{" + spellList{q}(i).Name) + "}{" + spellList{q}(i).Symbol + "}" ;
            else
                t = t + "\\emptySpell{}";
            end
            t = t + "}";
        end
        t = t + "\n\n";
    end
    
    t = t + "}}";
end
function t = listFormat(spellList)
    t = "\\begin{multicols}{3}\n";
    
    allSpells = Spell.empty;
    
    for j = 1:length(spellList)
       allSpells = [allSpells spellList{j} ]; 
    end
    [~,I] = sort({allSpells.Name});
    allSpells = allSpells(I); 
    
    for j = 1:length(allSpells)
       t = t + "\t " + allSpells(j).output() + "\n\n"; 
    end
    
    t = t + "\n\\end{multicols}";
end