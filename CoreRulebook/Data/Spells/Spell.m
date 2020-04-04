classdef Spell < handle

    properties
        Name

        School
        Discipline
        Incantation
        Type
        Symbol
        Level
		Range
        LevelName
        Effect
        Duration
        HigherLevel
        Resist

        Blockable
        Dodgeable
    end
    
    methods
                
        function obj = Spell()
           obj.Name = "Null";
           obj.School = "Null";
           obj.Discipline = "Null";
           obj.Incantation = "Null";
           obj.Type = "Nonetype";
           obj.Symbol = "";
		   obj.Range = "Self";
           obj.Level = 0;
           obj.LevelName = "None";
           obj.Effect = "None";
           obj.Duration = 0;
           obj.HigherLevel = "None";
           obj.Resist = "None";
           obj.Blockable = false;
           obj.Dodgeable = false;
        end
        
       
        function obj = ReadLine(obj,line)
            
            obj.Name = line.Name{1};
            obj.School = line.School{1};
            obj.Discipline = line.Discipline{1};
            obj.Incantation = line.Incantation{1};
            obj.Type = line.Type{1};
            n = line.Level;
			obj.Range = line.Range{1};
            levelNames = ["Trivial","Beginner", "Novice","Adept", "Expert", "Master", "Ascendant"];
            name = levelNames(n+1);
            obj.Level = n;
            obj.LevelName = name;
           
            obj.getSymbol();
           
            obj.Effect = line.Effect{1};
            obj.Duration = line.Duration{1};
            obj.HigherLevel = line.HigherLevel{1};
            
            obj.Resist = line.Resist{1};

            if strcmp(line.Blockable{1},"Y")
                obj.Blockable = true;
            end
            if strcmp(line.Dodgeable{1},"Y")
                obj.Dodgeable = true;
            end
        end
        
        function getSymbol(obj)
            spellTypes = ["Instant","Focus","Ritual","Ward","Music","Beast"];
            symbs = ["\\instSymb","\\concSymb","\\ritSymb","\\wardSymb","\\musicSymb","\\beastSymb"];
            for i = 1:length(spellTypes)
                if ~isempty(strfind(obj.Type,spellTypes(i)))
                    obj.Symbol = symbs(i);     
                end
            end
        end
        
        function t = output(sp)
            t = "\\spell{\n\t";
            t = t+ "name = " + prepareText(sp.Name)+", ";
            t = t + "school = " + sp.School+", ";
            t = t + "discipline = " + sp.Discipline+", ";
            t = t + "type = " + prepareText(sp.Type)+", ";           
            t = t + "level =" + sp.LevelName+", ";
			t = t + "range =" + sp.Range + ", ";
            %% conditionals  
            if isempty(sp.Incantation)
                t = t + "noIncant = 1, ";
            else
                t = t + "incant = " + prepareText(sp.Incantation)+", ";
            end
                  
            if isempty(sp.Duration)
                t = t + "noDur = 1, ";
            else
                t = t + "duration = " + prepareText(sp.Duration) + ",";
            end
           
            if isempty(sp.HigherLevel)
                t = t + "noHigh = 1, ";
            else
                t = t + "higher = " + prepareText(sp.HigherLevel) + ",";
            end
            
            
            if isempty(sp.Resist)
                t = t + "noResist =1, ";
            else
                t = t + "resist = " + prepareText(sp.Resist) + ", ";
            end
            
            if sp.Blockable == false && sp.Dodgeable == false
                t = t + "noBlock = 1, ";
            else
                t = t +"negation = ";
                if sp.Blockable == true
                    t = t + "Blockable";
                    if sp.Dodgeable == true
                        t = t + "  and Dodgeable";
                    end
                else
                    t = t + "Dodgeable";
                end
                t = t + ",";
            end
            
              
            %% end
            t = t + "effect =" + prepareText(sp.Effect) + "\n}";
        end
    end
end

