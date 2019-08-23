classdef Spell

    properties
        Name
        School
        Incantation
        Type
        Level
        LevelName
        FP
        Check
        Proficiency
        DV
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
           obj.Incantation = "Null";
           obj.Type = "Nonetype";
           obj.Level = 0;
           obj.LevelName = "None";
           obj.FP = 0;
           obj.Check = "None";
           obj.Proficiency = "None";
           obj.DV = 0;
           obj.Effect = "None";
           obj.Duration = 0;
           obj.HigherLevel = "None";
           obj.Travel = "None";
           obj.Resist = "None";
           obj.ResistDV = "None";
        end
        
        function obj = ReadLine(obj,line,school)
            obj.Name = line.Name{1};
            obj.School = school;
            obj.Incantation = line.Incantation{1};
            obj.Type = line.Type{1};
            
            n = line.Level;
            levelNames = ["Beginner", "Novice", "Adept", "Expert", "Master"];
            name = levelNames(n);
            obj.Level = n;
            obj.LevelName = name;
            
            obj.FP = line.Fortitude;
            obj.Check = line.Attribute{1};
            obj.Proficiency = line.Proficiency{1};
            obj.DV = line.Difficulty;
            obj.Effect = line.Effect{1};
            obj.Duration = line.Duration{1};
            obj.HigherLevel = line.HigherLevel{1};
            obj.Travel = line.TravelType{1};
            
            obj.Resist = line.Resist{1};
            obj.ResistDV = line.ResistDV{1};
        end
        
        function t = output(sp)
            t = "\\spell{";
            t = t+ "name = " + prepareText(sp.Name)+", ";
            t = t + "school = " + sp.School+", ";
            t = t + "type = " + prepareText(sp.Type)+", ";           
            t = t + "level =" + sp.LevelName+", ";
            t = t + "fp = " + num2str(sp.FP)+", ";
            t = t + "attribute =" + sp.Check+", ";
            t = t + "dv = " + num2str(sp.DV)+", ";
            
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

