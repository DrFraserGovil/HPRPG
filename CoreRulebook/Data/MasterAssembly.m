function MasterAssembly(quitMode)
    if nargin < 1
        quitMode = 0;
    end
    
    addpath('Disciplines/');
    addpath('Functions/');
    addpath('Items/');
    addpath('Statuses/');
	addpath('Artificing/')
    addpath('Archetype/')
    addpath('Feats/')
    
    disp('Assembling Archetypes');
    assembleArchetypes('../');
    
    disp('Assembling Spells');
    assembleSpells('../');
    
    disp('Assembling Skills');
    assembleFeats('../');
    
    disp('Assembling Statuses');
    assembleStatus('../');
    
    disp('Assembling Weapons');
    assembleWeapons('../');
	
    disp('Assembling Tools');
    assembleTools('../');

    
    path(pathdef)
    
    disp('Data Transfer complete. Beginning xelatex compilation now');
    if quitMode == 1
        quit;
    end
end