classdef Character < handle

    properties
        Name
        Species
        Archetype
        Items
        Physical
        Background
        Personality
        isGM
    end
    
    methods
        function obj = Character(name,species,tableName,archetype,physical,background,personality)
            obj.Name = name;
            obj.Species = species;
            obj.Archetype = archetype;
            obj.Physical = physical;
            obj.Background = background;
            obj.Personality = personality;
            obj.Items = Item.empty;
            obj.isGM = false;

            if strcmp(obj.Name,"Game Master")
                obj.isGM = true;
            end
            
            obj.getInventory(tableName);
        end
        
        
        function t = print(obj)
           
            t = "\\character";
            t = t + "{" + prepareText(obj.Name) + "}";
            t = t + "{" + prepareText(obj.Species) + "}";
            t = t + "{" + prepareText(obj.Archetype) + "}";
            t = t + "{" + prepareText(obj.Physical) + "}";
            t = t + "{" + prepareText(obj.Background) + "}";
            t = t + "{" + prepareText(obj.Personality) + "}";
            t = t + "{";

           
            if ~isempty(obj.Items) > 0
                [~,I] = sort([obj.Items.Name]);
                obj.Items = obj.Items(I);
                [~,I] = sort([obj.Items.Class]);
                obj.Items = obj.Items(I);
                
                class = obj.Items(1).Class;
                t = t + "\n \\subsection{" + prepareText(class) + "}\n";
                for i = 1:length(obj.Items)
                    %%assuming items are prepped for printing
                    if ~strcmp((obj.Items(i).Class),class)
                        class = obj.Items(i).Class;
                        t = t + "\n \\subsection{" + prepareText(class) + "}\n";
                    end
                    
                    t = t + obj.Items(i).print() + "\n";
                end
            end
            t = t + "}";
        end
        
        function getInventory(obj,tableName)
           file = "ItemList.xlsx";
           
           f = readtable(file);
           h = height(f);
           if ~obj.isGM
               hasColumn = f.(tableName);
               for i = 1:h
                   if ~isnan(hasColumn(i))
                      
                      item = Item(f(i,:),hasColumn(i));
                      
                      obj.Items(end+1) = item;
                   end
               end
           end
        end
    end
end

