classdef Building

    properties
        Name
        Description
        HasFloors
        Floors
    end
    
    methods
        function obj = Building(tableLine)
            obj.Name = string(tableLine.Name{1});
            obj.Description = string(tableLine.Description{1});
            obj.HasFloors = tableLine.HasFloors(1);
            if obj.HasFloors
                obj.Floors = Floor.empty;
            else
                obj.Floors = Floor("Generic");
            end
        end
        
        function obj = addLocation(obj,location)
            if obj.HasFloors
                idx = -1;
                for j = 1:length(obj.Floors)
                   if string(obj.Floors(j).Name) == string(location.Floor)
                       idx = j;
                   end
                end
                
                if idx == -1
                    obj.Floors(end+1) = Floor(location.Floor);
                    obj.Floors(end).Rooms = location;
                else
                    obj.Floors(idx).Rooms(end+1) = location;
                end
                
                
            else
               obj.Floors.Rooms(end+1) = location; 
            end
        end
        
        function s = print(obj)
           s = "\\building{";
           s = s + prepareText(obj.Name) + "}";
           s = s + "{" + prepareText(obj.Description )+ "}";
           s = s + "{\n";
           
           for j = 1:length(obj.Floors)
              s = s + obj.Floors(j).print() + "\n";
           end
           s = s + "}";
        end
    end
end

