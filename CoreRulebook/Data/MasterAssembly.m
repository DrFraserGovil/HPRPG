function MasterAssembly(quitMode)
    if nargin < 1
        quitMode = 0;
    end
    
    addpath('Spells/');
    addpath('Functions/');
    addpath('Items/');
    addpath('Potions/');
	addpath('Enchanting/')
    addpath('Archetypes/')
    
    disp('Assembling Archetypes');
    archetypeAssembler('Archetypes/');
    
    disp('Assembling Spells');
    assembleSpells(6,'../Chapters/Part5_Lists/');
    
    disp('Assembling Books')
    assembleBooks('../Chapters/Part3_Items/');
    
    disp('Assembling Skills');
    assembleSkills();
    
    disp('Assembling Statuses');
    assembleStatus()
    
    disp('Assembling Weapons');
    assembleWeapons('../Chapters/Part3_Items/');
	
    disp('Assembling Tools');
    assembleTools('../Chapters/Part3_Items/');

    disp('Assembling Potions');
	assemblePotions("../Chapters/");
    
    disp('Assembling Runes');
    runeAssembler('../Chapters/Part3_Items/');
    
    path(pathdef)
    
    disp('Data Transfer complete. Beginning xelatex compilation now');
    if quitMode == 1
        quit;
    end
end