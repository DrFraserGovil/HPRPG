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
        end
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
    end
end

