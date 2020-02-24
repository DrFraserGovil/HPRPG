classdef Species < handle

    properties
        Name
        Description
        Beasts
       
    end
    
    methods
        function obj = Species(name,description)
            obj.Name = string(name);
            obj.Description = string(description);
            
            
            
            
            obj.Beasts=Beast.empty;
        end
        
        function text = print(obj)
                text = "";
        end
    end
end

