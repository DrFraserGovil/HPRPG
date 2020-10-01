function assembleHogwarts(fileRoot)
   
    %if no target given, assume that called directly, else assume called by
    %master
   
    if nargin < 1
        disp('Insufficient inputs provided');
        addpath('../../../CoreRulebook/Data/Functions/');
        fileRoot = '../../';
 
    end
    fileNameRoot = fileRoot + "Chapters/MagicalWorld/";
    f = readtable("Locations.xlsx");
 
    buildings = Building.empty;
    for i = 1:height(f)
       buildings(i) = Building(f(i,:)); 
    end
    
    
    locations = readtable("Rooms.xlsx");
    
    for i = 1:height(locations)
       room = Location(locations(i,:)); 
       bidx = findBuildings(room.Building, buildings);
       
       if bidx ~= -1
          buildings(bidx) = buildings(bidx).addLocation(room); 
       end
    end
    
    
    
    
    text = "";
    
    for i = 1:length(buildings)
        
        
        text = text + buildings(i).print() + "\n\n";
        
    end
    
    
    targetName = fileNameRoot + "HogwartsPlaces.tex";
    
    
    

    fullText = text;

    FID = fopen(targetName,'w');
    fprintf(FID, fullText);
    fclose(FID);
end

function idx = findBuildings(name, buildings)
    idx = -1;
    for j = 1:length(buildings)

       if string(name) == string(buildings(j).Name)
           idx = j;
           return
       end
    end
end