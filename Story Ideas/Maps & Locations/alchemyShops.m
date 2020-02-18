function alchemyShops()

    addpath("../../CoreRulebook/Data/Potions/");

    opts = detectImportOptions('potions.xlsx','NumHeaderLines',2);
    opts.VariableNamesRange = 'A1';
    f = readtable("potions.xlsx",opts,'ReadVariableNames',true);
	
	N = height(f);
	
	potions = Potion.empty;
	
	pouch = IngredientPouch();
	for i = 1:N
		p = Potion(f(i,:),pouch);
		
		if ~isempty(p.Name)
		
			potions(end+1) = p;
		end
	end
	
	for i = 1:length(pouch.Ingredients)
		ing = pouch.Ingredients(i);
		
        if isempty(ing.CriticalPotions) && isempty(ing.OptionalPotions)
           disp(ing.Name + " has no uses") 
        end
    end
	
    potionShops = ["alchemyList","badalchemyList"];
    ingredientShops = ["ingredientList","badingredientList"];
    
    for i = 1:length(potionShops)
        g = readtable(potionShops(i)+".xlsx");
        
        h = height(g);
        
        for j = 1:h
           name = g.Item{j};
           for k = 1:length(potions)
                if strcmp(name,potions(k).Name)
                    g.Description{j} = char(potions(k).Effect);
                    g.Cost{j} = char(potions(k).Cost);
                end
           end
        end
        
        writetable(g,potionShops(i)+".xlsx");
    end
    
    for i = 1:length(ingredientShops)
         g = readtable(ingredientShops(i)+".xlsx");
        
        h = height(g);
        
        for j = 1:h
           name = g.Item{j};
           
           ing = pouch.search(name);
           
           if ~isempty(ing)
                g.Description{j} = char(ing.Description);
                 gCost{j} = char(ing.Cost);
           end
           
        end
        
        writetable(g,ingredientShops(i)+".xlsx");
    end

end