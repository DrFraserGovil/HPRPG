function assembleWeapons(fileRoot)
   
    %if no target given, assume that called directly, else assume called by
    %master
   
    if nargin < 1
        disp('Insufficient inputs provided');
        addpath('../../../CoreRulebook/Data/Functions/');
        fileRoot = '../../';
 
    end
    fileNameRoot = fileRoot + "Chapters/Part3_Items/";
    f = readtable("Weapons.xlsx");
    f = sortrows(f,1);
    f = sortrows(f,6);
    f = sortrows(f,5);
    
    melee = Weapon.empty;
    ranged = Weapon.empty;
    
    
    for i = 1:height(f)
        w = Weapon(f(i,:));
        if w.Category == "Ranged"
            ranged(end+1) = w;
        else
            melee(end+1) = w;
        end
    end
    
    t1 = "\\def\\meleeWeapon\n{"; 
    for i = 1:length(melee)
       t1 = t1 + "\n\t" + prepareText(melee(i).print()); 
    end
    t1 = t1 + "\n}\n";
    
    t2 = "\\def\\rangedWeapon\n{"; 
    for i = 1:length(ranged)
       t2 = t2 + "\n\t" + prepareText(ranged(i).print()); 
    end
    t2 = t2 + "\n}\n";
    
    text = t1 + t2;
    
     targetName = fileNameRoot + "WeaponList.tex";
    

    fullText = text;

    FID = fopen(targetName,'w');
    fprintf(FID, fullText);
    fclose(FID);
end