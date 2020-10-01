classdef Location
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Name
        Building
        Description
        Floor
    end
    
    methods
        function obj = Location(tableLine)
            obj.Name = string(tableLine.Room{1});
            obj.Building = string(tableLine.Location{1});
            obj.Description = string(tableLine.Description{1});
            obj.Floor = string(tableLine.Floor{1});
        end
        
        function s = print(obj)
            s = "\\location{";

            q = prepareText(obj.Name);
            s = s + q + "}";
            s = s + "{" + prepareText(obj.Description) + "}";
            s = s + "\n";
        end
    end
end

