function MasterAssembly(quitMode)
    if nargin < 1
        quitMode = 0;
    end
    
    addpath('Spells/');
    addpath('Functions/');
    addpath('Items/');
    addpath('Potions/');
	disp('Assembling Spells');
    allSpellAssembler(6,'../Chapters/');
    
    assembleBooks();
     disp('Assembling Skills');
     assembleSkills();
      disp('Assembling Statuses');
    assembleStatus()
     disp('Assembling Weapons');
    assembleWeapons();
	
     
     disp('Assembling Tools');
    assembleTools();


    disp('Assembling Potions');
	assemblePotions();
    

    path(pathdef)
    
    disp('Data Transfer complete. Beginning xelatex compilation now');
    if quitMode == 1
        quit;
    end
end