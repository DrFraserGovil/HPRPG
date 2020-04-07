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
            if obj.isGM
                t = obj.gmPrint();
            else
                t = obj.characterPrint();
            end
        end
        
        function t = characterPrint(obj)
            
            t = "\\character";
            t = t + "{" + prepareText(obj.Name) + "}";
            t = t + "{" + prepareText(obj.Species) + "}";
            t = t + "{" + prepareText(obj.Archetype) + "}";
            t = t + "{" + prepareText(obj.Physical) + "}";
            t = t + "{" + prepareText(obj.Background) + "}";
            t = t + "{" + prepareText(obj.Personality) + "}";
            t = t + "{" + obj.printFullInventory() + "}";
            
            
            t = t + "{" + obj.printInventorySummary() + "}";
        end
        
        function t = gmPrint(obj)
            t = "\\GM{";
            
            
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
                    
                    t = t + obj.Items(i).print(1) + "\n";
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
            else
                
                for i = 1:h
                    
                    item = Item(f(i,:),0);
                    obj.Items(end+1) = item;
                    
                    cNames = ["Nikc", "Helena", "Cerise", "Luke"];
                    obj.Items(i).isOwned = false;
                    obj.Items(i).Owners = "";
                    for j = 1:length(cNames)
                        col = f.(cNames(j));
                        c = col(i);
                        if ~isnan(c)
                            obj.Items(i).isOwned = true;
                            obj.Items(i).Owners = obj.Items(i).Owners + cNames(j) + ": " + num2str(c) + "\\";
                        end
                    end
                end
                
                
            end
        end
        
        function t = printFullInventory(obj)
            t = "";
            
            if ~isempty(obj.Items) > 0
                [~,I] = sort([obj.Items.SortName]);
                obj.Items = obj.Items(I);
                [~,I] = sort([obj.Items.SortClass]);
                obj.Items = obj.Items(I);
                
                class = obj.Items(1).Class;
                t = t + "\n \\subsection{" + prepareText(class) + "}\n";
                for i = 1:length(obj.Items)
                    %%assuming items are prepped for printing
                    if ~strcmp((obj.Items(i).Class),class)
                        class = obj.Items(i).Class;
                        t = t + "\n \\subsection{" + prepareText(class) + "}\n";
                    end
                    
                    t = t + obj.Items(i).print(0) + "\n";
                end
            end
        end
        
        function t = printInventorySummary(obj)
           t = "";
           t = "";
            
            if ~isempty(obj.Items) > 0
                [~,I] = sort([obj.Items.SortName]);
                obj.Items = obj.Items(I);
                [~,I] = sort([obj.Items.SortClass]);
                obj.Items = obj.Items(I);
                
                class = obj.Items(1).Class;
                t = t + "\n \\summaryHeader{" + prepareText(class) + "}\n";
                for i = 1:length(obj.Items)
                    %%assuming items are prepped for printing
                    if ~strcmp((obj.Items(i).Class),class)
                        class = obj.Items(i).Class;
                        t = t + "\n \\summaryHeader{" + prepareText(class) + "}\n";
                    end
                    
                    t = t + "\n" + "\\summaryEntry{" + prepareText(obj.Items(i).Name) + "}{" + num2str(obj.Items(i).Amount)  + "}\n";
                end
            end
           
        end
    end
end

