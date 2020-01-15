classdef Ingredient < handle
	
	properties
		Name
		Description
		Cost
		CriticalPotions
		OptionalPotions
	end
	
	methods
		function obj = Ingredient(tableLine)
			
			if nargin < 1
				obj.Name = "Default";
				obj.Description = "";
				obj.Cost = 0;
				
			else
				if ~isempty(tableLine.Name{1})
					obj.Name = convertCharsToStrings(tableLine.Name{1});
					obj.Cost = tableLine.Cost(1);
					obj.Description = tableLine.Description{1};
				end
			end
			obj.CriticalPotions = string.empty;
			obj.OptionalPotions = string.empty;
		end
		
	
	end
end

