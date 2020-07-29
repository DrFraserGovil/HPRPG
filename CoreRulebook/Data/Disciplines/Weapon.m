classdef Weapon

    properties
       Name;
       Category;
       Range;
       Proficiency;
       ProficiencyValue;
       Difficulty;
       DamageBase;
       Type;
       Notes;
    end
    
    methods
        function obj = Weapon(tableLine)
            obj.Name = string(tableLine.Name{1});
            obj.Category = string(tableLine.Category{1});
            obj.Range = string(tableLine.Range{1});
            obj.Proficiency = string(tableLine.Proficiency{1});
            obj.ProficiencyValue = num2str(tableLine.ProficiencyVal(1));
            obj.Difficulty = num2str(tableLine.Difficulty(1));
            obj.DamageBase = num2str(tableLine.DamageBase(1));
            obj.Type = string(tableLine.Type{1});
            obj.Notes = string(tableLine.Additional{1});
            
            
            if (obj.Proficiency == "Brawl")
                obj.Proficiency = "\brawl";
            elseif obj.Proficiency == "Skirmish"
                obj.Proficiency = "\skirmish";
            else
                obj.Proficiency = "\marksman";
            end
                
                
        end
        
        function text = print(obj)
            
            text = "\weapon";
           
            inputs = [obj.Name, obj.Range, obj.Proficiency, obj.ProficiencyValue, obj.Difficulty, obj.DamageBase,...,
                obj.Type, obj.Notes];
            
            for i = 1:length(inputs)
               text = text + "{" + inputs(i) + "}"; 
            end
            text = text;
            
        end
    end
end

