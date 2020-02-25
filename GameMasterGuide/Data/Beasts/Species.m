classdef Species < handle

    properties
        Name
        Description
        Beasts
        HasImage
        Image
        Height
    end
    
    methods
        function obj = Species(name,description,image,height)
            obj.Name = string(name);
            obj.Description = string(description);
            
            obj.Image = string(image);
            obj.Height = num2str(height);
            obj.HasImage = false;
            if ~isempty(image)
                obj.HasImage = true;
                if isnan(obj.Height)
                    obj.Height = 0.5;
                end
            else
                obj.Image = "";
            end
            
            obj.Beasts=Beast.empty;
        end
        
        function text = print(obj)
                text = "";
        end
    end
end

