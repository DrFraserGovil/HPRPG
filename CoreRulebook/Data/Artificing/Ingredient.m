classdef Ingredient < handle
	
	properties
		Name
		Description
		Rarity
        Properties
	end
	
	methods
		function obj = Ingredient(tableLine)
	
			if nargin < 1
				obj.Name = "Default";
				obj.Description = "";
                obj.Rarity = "Trivial";
                obj.Properties = string.empty;
				
			else
				if ~isempty(tableLine.Name{1})
					obj.Name = convertCharsToStrings(tableLine.Name{1});
					obj.Description = string(tableLine.Description{1});
                    obj.Rarity = string(tableLine.Rarity{1});
                    w = width(tableLine);
                    
                    i = 4;
                    obj.Properties = string.empty;
                    while i <= w && ~isempty(tableLine{1,i}{1})
                        obj.Properties(end+1) = tableLine{1,i}{1};
                        i = i +1;
                    end
                    obj.Properties = sort(obj.Properties);
				end
            end
        end
		
        function text = print(obj)
           text = "\\ingredient";
			text = text +  "{" + prepareText(obj.Name) + "}";
			text = text + "{" + prepareText(obj.Description) + "} ";
            text = text + "{";
            
            for i = 1:length(obj.Properties)
                text = text + "\\imp{" + prepareText(obj.Properties(i)) + "}";
                if length(obj.Properties) > 1
                   if i < length(obj.Properties) -1
                       text = text + ", ";
                   elseif i ==length(obj.Properties)-1
                       text = text + " and ";
                   end
                end
                
            end
            text = text + "}";
        end
       
	end
end

