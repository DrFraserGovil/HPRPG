
function assembleNPCs(fileRoot)
   
    %if no target given, assume that called directly, else assume called by
    %master
   
    if nargin < 1
        %disp('Insufficient inputs provided');
        addpath('../../CoreRulebook/Data/Functions/');
        addpath('../../CoreRulebook/Data/Feats/');
        fileRoot = '';    
    end
    
    opts = detectImportOptions("NPC.xlsx","NumHeaderLines",1,"ReadVariableNames",true);
 
    f = readtable("NPC.xlsx",opts);

    
    list = NPC.empty;
    for i = 1:height(f)
        n = f.Name{i};
        
        if ~isempty(n)
       
           N = NPC(f(i,:));
 %           list(end+1) = N;
            N.Render();
        end
        
    end
    
    
        
end

