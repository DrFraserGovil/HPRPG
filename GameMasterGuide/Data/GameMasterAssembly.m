function GameMasterAssembly(quitMode)
    if nargin < 1
        quitMode = 0;
    end
    
    addpath('Beasts/');
    addpath('../../CoreRulebook/Data/Functions/');
    addpath('Hogwarts/');
    
    
    disp('Assembling Beasts');
    assembleBeasts('../');
    
    disp('Assembling Hogwarts');
    assembleHogwarts('../');
    
   
    
    path(pathdef)
    
    
    if quitMode == 1
        disp('Data Transfer complete. Beginning xelatex compilation now');
        quit;
    end
end
