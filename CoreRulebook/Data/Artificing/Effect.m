classdef Effect

    properties
        Name
        Description
        Ingredients
    end
    
    methods
        function obj = Effect(tableLine,ingredients)
            obj.Name = string(tableLine.Name{1});
            obj.Description = tableLine.Description{1};
            obj.Ingredients = string.empty;
            for j = 1:length(ingredients)
                if any(ingredients(j).Properties==obj.Name)
                    obj.Ingredients(end+1) = ingredients(j).Name; 
                end
            end
        end
        
        function text = print(obj)
             text = "\\effect";
			text = text +  "{" + prepareText(obj.Name) + "}";
			text = text + "{" + prepareText(obj.Description) + "} ";
            text = text + "{";
            
            N = length(obj.Ingredients);
            crit = 3;
            if N > crit
               obj.Ingredients = (obj.Ingredients(randperm(N)));
               N = crit;
            
            end
            for i = 1:N
                text = text + "\\imp{" + prepareText(obj.Ingredients(i)) + "}";
                if N > 1
                   if i < N -1
                       text = text + ", ";
                   elseif i ==N-1
                       text = text + " and ";
                   end
                end
                
            end
            text = text + "}";
        end
    end
end

