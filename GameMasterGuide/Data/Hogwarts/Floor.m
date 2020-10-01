classdef Floor
    %UNTITLED4 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Name
        Rooms
        IsGeneric
    end
    
    methods
        function obj = Floor(name)
            obj.Name = string(name);
            
            if string(obj.Name) == "Generic"
                obj.IsGeneric = 1;
            else
                obj.IsGeneric = 0;
            end
            obj.Rooms = Location.empty;
        end
        
        function s = print(obj)
            obj.Name = obj.parseName;
            s = "\\floor{";
            s = s + obj.Name +"}";
            if obj.IsGeneric == 1
                s = "";
            end
            s = s + "\n{";
            for i = 1:length(obj.Rooms)
               s = s + obj.Rooms(i).print(); 
            end
            s = s + "}";
        end
        
        function t = parseName(obj)
           r = ["0","1","2","3","4","5","6","7","8","9","10","11"];
           s = ["Ground", "First", "Second", "Third", "Fourth", "Fifth", "Sixth", "Seventh", "Eighth", "Ninth", "Tenth", "Eleventh"];
           t = obj.Name;
           for i = 1:length(r)
               if obj.Name == r(i)
                 t = s(i) + " Floor";
               end
           end
        end
    end
end

