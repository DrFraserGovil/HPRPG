classdef Feat

    properties
        Name
        Owner
        Prerequisite
        HasPrerequisite
        Description
    end
    
    methods
        function obj = Feat()
           Name = "None";
           Owner = "None";
           Prerequisite = "";
           HasPrerequisite = "0";
           Description = "None";
        end
        function obj = ReadIn(obj,tableLine)
  
            obj.Name = string(tableLine.Name{1});
            obj.Owner = string(tableLine.People{1});
            obj.Prerequisite = string(tableLine.Prerequisite{1});
            obj.HasPrerequisite = "1";
            if (obj.Prerequisite == "")
                obj.HasPrerequisite = "0";
            end
            obj.Description = string(tableLine.Description{1});
            
        end
        
        function s = print(obj)
            s = "\feat{";
            s = s + obj.Name +" }{";
            s = s + obj.Description + "}{";
            s = s + obj.HasPrerequisite + "}{";
            s = s + obj.Prerequisite + "}";
            
            s = prepareText(s);
        end
    end
end

