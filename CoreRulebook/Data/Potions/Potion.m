classdef Potion < handle
	%UNTITLED2 Summary of this class goes here
	%   Detailed explanation goes here
	
	properties
		Name
        Summary
		Description
		Effect
		Dose
		SideEffect
		Cost;
		Difficulty;
		BrewTime;
		EssentialIngredients
		OptionalIngredients
		OptionalBonus
		OptionalCost
		SimpleInclude
	end
	
	methods
		function obj = Potion(inputLine,pouch)
					obj.EssentialIngredients = Ingredient.empty;
			obj.OptionalIngredients = Ingredient.empty;
			obj.OptionalBonus = [];
			obj.OptionalCost = [];
			if nargin < 1
				obj.Name = "Default";
                obj.Summary = "None";
				obj.Description = "None";
				obj.Effect = "None";
				obj.SideEffect = "None";
				obj.Dose = 0;
				obj.Cost = 0;
				obj.BrewTime = 0;
				obj.Difficulty = 0;
				
				
			else
				obj.Name = inputLine.PotionName{1};
				obj.Description = inputLine.Description{1};
                obj.Summary = inputLine.Summary{1};
				obj.processCost(inputLine.Cost(1));
				obj.Effect = strcat(inputLine.Effect{1}, " ",num2str(inputLine.Magnitude(1))," ",inputLine.Unit{1});
				obj.Difficulty = inputLine.Difficulty(1);
				obj.processTime(inputLine.BrewingHours(1));
				obj.SideEffect = inputLine.SideEffect{1};
				obj.Dose = inputLine.Doses(1);
				
				obj.SimpleInclude = inputLine.SimpleInclude(1);
				
				obj.processIngredients(inputLine,pouch)
			end
	
		end
		
		function text= print(obj)
			
			text = "\\potion{";
			text = text +  "name =" + prepareText(obj.Name) + ", ";
			text = text + "description =" + prepareText(obj.Description) + ", ";
			text = text + "cost =" +obj.Cost + ", ";
			text = text + "effect =" + prepareText(obj.Effect) + ", ";
			text = text + "difficulty =" + num2str(obj.Difficulty) + ", ";
			text = text + "time =" + obj.BrewTime + ", ";
			text = text + "doses =" + num2str(obj.Dose) + "~dose";
			if obj.Dose > 1
				text = text + "s";
			end
			text = text + ", ";
			
			text = text + "essential =";
			n = length(obj.EssentialIngredients);
            [~,I] = sort([obj.EssentialIngredients.Name]);
            obj.EssentialIngredients = obj.EssentialIngredients(I);
			for j = 1:n
				text = text + prepareText(obj.EssentialIngredients(j).Name);
				if j < n
					text = text + "\\comma{} ";
				end
			end
			text = text + ", ";
			
            
            optionalText = "optional = ";
            n = length(obj.OptionalIngredients);
            [~,I] = sort([obj.OptionalIngredients.Name]);
            
            
            
            obj.OptionalIngredients = obj.OptionalIngredients(I);
            obj.OptionalBonus = obj.OptionalBonus(I);
            obj.OptionalCost = obj.OptionalCost(I);
            for j = 1:n
                t = prepareText(obj.OptionalIngredients(j).Name);
                b = "+" + num2str(obj.OptionalBonus(j)) + "\\%%";
                c = num2str(obj.OptionalCost(j));
                optionalText = optionalText + t + " & " + b + " & " + c;
                optionalText = optionalText + "\\\\ ";
            end
            text = text + optionalText +  ",";
            
            text = text + "othereffect  =" + prepareText(obj.SideEffect) + "}";
		end
		
		function processTime(obj,time)
			if time < 24
				obj.BrewTime = num2str(time) + " hour";
				if time > 1
					obj.BrewTime = obj.BrewTime +"s";
				end
			else
				days = round(time/24);
				if days < 7
					obj.BrewTime = num2str(days) + " day";
					if days > 1
						obj.BrewTime = obj.BrewTime +"s";
					end
				else
					weeks = round(days/7);
					if weeks < 52
						obj.BrewTime = num2str(weeks) + " week";
						if weeks > 1
							obj.BrewTime = obj.BrewTime +"s";
						end
					else
						years = round(days/365);
						obj.BrewTime = num2str(years) + " year";
						if years > 1
							obj.BrewTime = obj.BrewTime +"s";
						end
					end
				end
			end
		end
		
		function processCost(obj,cost)
			sickleToGalleon = 17;
			galleons = floor(cost/sickleToGalleon);
			sickles = round( (cost - sickleToGalleon * galleons)/5)*5;
			
			obj.Cost = "";
			if galleons > 1
				obj.Cost = obj.Cost + num2str(galleons) + "\\galleon ";
            else
				obj.Cost = obj.Cost + num2str(sickles) + "\\sickle";
			end
		end
		
		
		function processIngredients(obj,inputLine,pouch)
			ingredientID = 12;

			for i = [0:3]+ingredientID
				name = inputLine{1,i}{1};
				
				if ~isempty(name)
					
					ing = pouch.search(name);
					if isempty(ing)
						disp(strcat("Ingredient List has no record of ", name));
						ing = Ingredient();
						ing.Name = name;
					else
						ing.CriticalPotions(end+1) = obj.Name;
					end
					obj.EssentialIngredients(end+1) = ing;
				end
			end
			
			optionID = 16;
			for i = [0:3:10]+optionID
				name = inputLine{1,i}{1};
				if ~isempty(name)
					
					ing = pouch.search(name);
					if isempty(ing)
						disp(strcat("Ingredient List has no record of ", name));
						ing = Ingredient();
						ing.Name = name;
					else
						ing.OptionalPotions(end+1) = obj.Name;
					end
					obj.OptionalIngredients(end+1) = ing;
					obj.OptionalCost(end+1) = inputLine{1,i+2};
					obj.OptionalBonus(end+1) = inputLine{1,i+1};
				end
			end
		end
	end
end

