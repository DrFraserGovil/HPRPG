classdef Item

    properties
        Name
        Amount
        Class
        Description
        Acquired
        hasAcquired
        TrueDescription
        hasTrueDescription
        PurchaseCost
        hasPurchaseCost
        SellValue
    end
    
    methods
        function obj = Item(tableLine,amount)
            obj.Name = string(tableLine.Name{1});
            obj.Class = string(tableLine.Class{1});
            obj.Description = tableLine.Description{1};
            obj.Acquired = tableLine.Acquired{1};
            obj.hasAcquired = true;
            if isempty(obj.Acquired)
                obj.hasAcquired = false;
            end
            obj.Amount = amount;
            obj.TrueDescription = tableLine.TrueDescription{1};
            obj.hasTrueDescription= true;
            if isempty(obj.TrueDescription)
                obj.hasTrueDescription = false;
            end
            obj.SellValue = tableLine.Value{1};
            if isempty(obj.SellValue)
               obj.SellValue = "Worthless"; 
            end
            obj.PurchaseCost = tableLine.PurchaseCost{1};
            obj.hasPurchaseCost= true;
            if isempty(obj.PurchaseCost)
                obj.hasPurchaseCost = false;
            end
        end
        
        function t = print(obj)
            t = "\n\\inventory{";
            t = t + "\n\tname = " + prepareText(obj.Name) + ", ";
            t = t + "\n\tamount = " + num2str(obj.Amount) +", ";
            t = t + "\n\tclass = " + prepareText(obj.Class) + ", ";
            if obj.hasAcquired == true
                t = t + "\n\thasAcquired = " + num2str(obj.hasAcquired) + ", ";
                t = t + "\n\tacquired = " + prepareText(obj.Acquired) + ", ";
            end
            t = t + "\n\tdescription = " + prepareText(obj.Description) + ", ";
            if obj.hasTrueDescription == true
                t = t + "\n\thasTrueDescription = " + num2str(obj.hasTrueDescription) + ", ";
                t = t + "\n\ttrueDescription = " + prepareText(obj.TrueDescription) + ", ";
            end
            if obj.hasPurchaseCost == true
                t = t + "\n\thasCost = " + num2str(obj.hasPurchaseCost) + ", ";
                t = t + "\n\tpurchaseCost = " + prepareText(obj.PurchaseCost) + ", ";
            end
            t = t + "\n\tsellValue = " + prepareText(obj.SellValue);
            t = t + "\n}";
        end
    end
end

