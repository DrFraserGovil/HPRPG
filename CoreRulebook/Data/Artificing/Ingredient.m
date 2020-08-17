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
					
                    obj.Cost = strcat(tableLine.Rarity{1},", ",tableLine.Category{1}); 
                    
					obj.Description = tableLine.Description{1};
				end
			end
			obj.CriticalPotions = string.empty;
			obj.OptionalPotions = string.empty;
        end
		
        function text = print(obj)
           text = "\\ingredient{";
			text = text +  "name =" + prepareText(obj.Name) + ", ";
			text = text + "description =" + prepareText(obj.Description) + ", ";
            text = text + "cost =" +prepareText(obj.Cost )+ ", ";
           
            
            nC = length(obj.CriticalPotions);
            
            if nC > 0
                 text = text + "essential =";
                for i = 1:nC
                    text = text + prepareText(obj.CriticalPotions(i));
                    if i <nC
                        if i == nC - 1
                            text = text + " and ";
                        else
                            text = text  + "\\comma{} ";
                        end
                    end
                end
                text = text + ",";
            else
                text = text + " noEssential = 1";
            end
            
            nO = length(obj.OptionalPotions);
            
            if nO > 0
                text = text + "optional =";
                for i = 1:nO
                    text = text + prepareText(obj.OptionalPotions(i));
                    if i <nO
                        if i == nO - 1
                            text = text + " and ";
                        else
                            text = text  + "\\comma{} ";
                        end
                    end
                end
                
            else
                text = text + "noOptional = 1";
            end
            
            text = text + "}";
        end
        
     
        function processCost(obj,cost)
            cost = cost*17/50;

            sickles = floor(cost);
           knuts = (cost - sickles)*29;
           knuts = round(knuts/5)*5;
           
           galleons = floor(sickles/17);
           sickles = sickles - 17*galleons;
           
           c = "";
           if galleons > 0
               c = c + "\galleon{" + num2str(galleons) + "} ";
               sickles = round(sickles/5)*5;
               knuts =0;
           end
           if sickles > 0 
              c = c + "\sickle{"+ num2str(sickles) + "} ";
           end
           if knuts > 0
               c = c+"\knut{ " + num2str(knuts) + "} ";
           end
           obj.Cost = c;

        end
	end
end

