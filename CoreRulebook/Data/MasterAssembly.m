function MasterAssembly(quitMode)
    if nargin < 1
        quitMode = 0;
    end
    
    addpath('Spells/');
    addpath('Functions/');
    
    disp('Assembling Spells');
    allSpellAssembler(5,'../Chapters/');
    
     disp('Assembling Skills');
     assembleSkills();
% run assembleStatus.m
% run assembleWeapons.m
% run assembleArchetypes.m
% run assembleTools.m
%quit;
    path(pathdef)
    
    disp('Data Transfer complete. Beginning xelatex compilation now');
    if quitMode == 1
        quit;
    end
end