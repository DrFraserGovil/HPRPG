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
        end
        
        function t = output(sp)
            t = "\\spell{";
            t = t+ "name = " + prepareText(sp.Name)+", ";
            t = t + "incant = " + prepareText(sp.Incantation)+", ";
            if isempty(sp.Incantation)
                t = t + "noIncant = 1, ";
            end
            t = t + "school = " + sp.School+", ";
            t = t + "type = " + prepareText(sp.Type)+", ";
            t = t + "level =" + sp.LevelName+", ";
            t = t + "fp = " + num2str(sp.FP)+", ";
            t = t + "attribute =" + sp.Check+", ";
            t = t + "proficiency = " + prepareText(sp.Proficiency)+", ";
            if isempty(sp.Proficiency)
                t = t + "noProf = 1, ";
            end
            t = t + "dv = " + num2str(sp.DV)+", ";
            t = t + "duration = " + prepareText(sp.Duration) + ",";
            if strcmp(sp.Duration,"0")==1
                t = t + "noDur = 1, ";
            end
            t = t + "higher = " + prepareText(sp.HigherLevel) + ",";
            if isempty(sp.HigherLevel)
                t = t + "noHigh = 1, ";
            end
            t = t + "effect =" + prepareText(sp.Effect) + "}";
        end
    end
end

