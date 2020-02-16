classdef Shop

    properties
        Name
        Location
        Proprietor
        ProprietorDescription
        Speciality
        Exterior
        Interior
        Inventory
    end
    
    methods
        function obj = Shop(tableLine)
            obj.Name = tableLine.Name{1};
            obj.Location = tableLine.Street{1};
            obj.Proprietor = tableLine.Proprietor{1};
            obj.ProprietorDescription = tableLine.ProprietorDescription{1};
            obj.Speciality = tableLine.Speciality{1};
            obj.Exterior = tableLine.Exterior{1};
            obj.Interior = tableLine.Interior{1};
            obj.Inventory = tableLine.Inventory{1};
            
            if ~isempty(tableLine.InventoryLink{1})
                obj.Inventory = obj.Inventory + "~\\ There is a link to this inventory at " + tableLine.InventoryLink{1};
            end
        end
        
        function text = print(obj)
            text = "\shop{";
            text = text + obj.Name + "}{";
            text = text + obj.Location + "}{";
            text = text + "\basicPerson{" + obj.Proprietor + "}{" + obj.ProprietorDescription + "} }{";
            text = text + obj.Speciality + "}{";
            text = text + obj.Exterior + "}{";
            text = text + obj.Interior + "}{";
            text = text + obj.Inventory + "}";
            
            text = prepareText(text);
        end
    end
end

