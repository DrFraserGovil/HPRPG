classdef Rating
 
    properties
        Name
        Value
        IsError
    end
    
    methods
        function obj = Rating(name,val)
            obj.IsError = false;
            if nargin < 2 
                val = 0;
            end
            if nargin < 1
                name = "error";
                obj.IsError = true;
                val = -1;
            end
            
            
            obj.Name = string(name);
            obj.Value = val;
        end

    end
end

