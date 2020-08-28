function assemblePotions(fileNameRoot)
    
    if nargin < 1
        disp('Insufficient inputs provided');
        addpath('../Functions/');
        fileNameRoot = '../../';
    end
	
    %% load in ingredients
	f = readtable("ingredients.xlsx");
    f = sortrows(f);
    ings = Ingredient.empty;
    for i = 1:height(f)
       ings(end+1) = Ingredient(f(i,:));
 
    end
   
    %% load in effects
    g = readtable("effects.xlsx");
    g = sortrows(g);
    effects = Effect.empty;
    for i = 1:height(g)
        effects(end+1) = Effect(g(i,:),ings);
    end
    
    %% checks for missing effects
    z = [effects.Name];
    missingText = "Missing Effects:\n";
    q = 0;
    for i = 1:length(ings)
       for j = 1:length(ings(i).Properties)
           if ~any(ings(i).Properties(j) == z)
              missingText = missingText + "\t" + ings(i).Properties(j) + "  \t(" + ings(i).Name + ")\n";
              q = q + 1;
           end
       end
    end
    if q > 0
        missingText = missingText + "(Total %d missing)\n";
        fprintf(missingText,q);
    end
    
    rares = unique([ings.Rarity]);
    
    %% print out ingredients
    text = "";
    for i = 1:length(rares)
        text = text + "\\def\\" + rares(i) + "List{";
        for j = 1:length(ings)
            if ings(j).Rarity == rares(i)
                text = text + "\n\t" + ings(j).print();
            end
        end
        text = text + "\n}\n";
    end
    
    
    
    text = text + "\n\n\\def\\effectList{";
     for i = 1:length(effects)
         if length(effects(i).Ingredients) > 0
            text = text + "\n\t" + effects(i).print();
         end
     end
    text = text + "\n}";
    
    fileName = fileNameRoot + "Chapters/Part5_Artificing/IngredientList.tex";
    FID = fopen(fileName,'w');
    fprintf(FID, text);
end
