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
        
        ExpandedInventory;
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
            obj.ExpandedInventory = string.empty;
            if ~isempty(tableLine.InventoryLink{1})
                [temp,extend] = fetchInventory(tableLine.InventoryLink{1});
                
                if extend == false
                    obj.Inventory = obj.Inventory + temp;
                else
                    obj.Inventory = obj.Inventory + "A full inventory for this shop can be found at the end  of the document";
                    obj.ExpandedInventory = temp;
                end
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

function [text,extend] = fetchInventory(link)
    text = "";
    
    f = readtable(link + ".xlsx");
    h = height(f);
    extend = false;
    base = "\inventLine";
    if h > 5
        extend = true;
        base = "\invent";
    end

    for i = 1:h
        
        
        name = f.Item{i} + "~($\times$" + num2str(f.Quantity(i)) +")";
        
        text = text + sprintf(prepareText(base +"{" + name +"}{" + f.Description{i} + "}{" + f.Cost{i} + "}") + "\n");   
        
        
        
    end
    text = text;
end
