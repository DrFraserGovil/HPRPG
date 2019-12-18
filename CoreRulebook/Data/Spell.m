classdef Spell < handle

    properties
        Name

        School
        Discipline
        Incantation
        Type
        Symbol
        Level
        LevelName
        Effect
        Duration
        HigherLevel
        Travel
        Resist
        ResistDV
    end
    
    methods
                
        function obj = Spell()
           obj.Name = "Null";
           obj.School = "Null";
           obj.Discipline = "Null";
           obj.Incantation = "Null";
           obj.Type = "Nonetype";
           obj.Symbol = "";
           obj.Level = 0;
           obj.LevelName = "None";
           obj.Effect = "None";
           obj.Duration = 0;
           obj.HigherLevel = "None";
           obj.Travel = "None";
           obj.Resist = "None";
           obj.ResistDV = "None";
        end
        
       
        function obj = ReadLine(obj,line)
            
            obj.Name = line.Name{1};
            obj.School = line.School{1};
            obj.Discipline = line.Discipline{1};
            obj.Incantation = line.Incantation{1};
            obj.Type = line.Type{1};
            n = line.Level;
            levelNames = ["Beginner", "Novice", "Adept", "Expert", "Master"];
            name = levelNames(n);
            obj.Level = n;
            obj.LevelName = name;
           
            obj.getSymbol();
           
            obj.Effect = line.Effect{1};
            obj.Duration = line.Duration{1};
            obj.HigherLevel = line.HigherLevel{1};
            obj.Travel = line.TravelType{1};
            
            obj.Resist = line.Resist{1};
            obj.ResistDV = line.ResistDV{1};
        end
        
        function getSymbol(obj)
            spellTypes = ["Instant","Concentration","Ritual","Ward","Music","Beast"];
            symbs = ["\\instSymb","\\concSymb","\\ritSymb","\\wardSymb","\\musicSymb","\\beastSymb"];
            for i = 1:length(spellTypes)
                if ~isempty(strfind(obj.Type,spellTypes(i)))
                    obj.Symbol = symbs(i);     
                end
            end
        end
        
        function t = output(sp)
            t = "\\spell{";
            t = t+ "name = " + prepareText(sp.Name)+", ";
            t = t + "school = " + sp.School+", ";
            t = t + "discipline = " + sp.Discipline+", ";
            t = t + "type = " + prepareText(sp.Type)+", ";           
            t = t + "level =" + sp.LevelName+", ";

            %% conditionals  
            if isempty(sp.Incantation)
                t = t + "noIncant = 1, ";
            else
                t = t + "incant = " + prepareText(sp.Incantation)+", ";
            end
                  
            if isempty(sp.Proficiency)
                t = t + "noProf = 1, ";
            else
                 t = t + "proficiency = " + prepareText(sp.Proficiency)+", ";
            end
           
            if strcmp(sp.Duration,"0")==1
                t = t + "noDur = 1, ";
            else
                t = t + "duration = " + prepareText(sp.Duration) + ",";
            end
           
            if isempty(sp.HigherLevel)
                t = t + "noHigh = 1, ";
            else
                t = t + "higher = " + prepareText(sp.HigherLevel) + ",";
            end
            
            if isempty(sp.Travel)
                t = t + "noTravel = 1, ";
            else
                t = t + "travel = " + prepareText(sp.Travel) +",";
            end
            
            if isempty(sp.Resist)
                t = t + "noResist =1, ";
            else
                t = t + "resist = " + prepareText(sp.Resist) + ", resistDV = " + prepareText(sp.ResistDV) + ", ";
            end
            %% end
            t = t + "effect =" + prepareText(sp.Effect) + "}";
        end
    end
end

