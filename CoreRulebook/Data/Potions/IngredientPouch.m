classdef IngredientPouch < handle

	properties
		Ingredients;
	end
	
	methods
		function obj = IngredientPouch()
			obj.Ingredients = Ingredient.empty;
			
			obj.loadPouch();
		end
		
		function loadPouch(obj)
			ings =  readtable("ingredients.xlsx");
			N = height(ings);
			for i = 1:N
				ing = Ingredient(ings(i,:));
				if ~isempty(ing) && ~isempty(ing.Name)
					obj.Ingredients(end+1) = ing;
				end
			end
		end
		
		function ing = search(obj,name)
			l = [obj.Ingredients.Name];
			
			I = find(l == name);
			
			ing = Ingredient.empty;
			if I > 0
				ing = obj.Ingredients(I);
			end
		end
	end
end

