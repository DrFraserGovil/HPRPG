classdef Encounter
    
    properties
        Name
        ShortName
        Description
        Beasts
        Names
    end
    
    methods
        function obj = Encounter(tableLine, beasts)
            obj.Name = tableLine.Name{1};
            obj.Description = tableLine.Description{1};
            obj.Beasts = Beast.empty;
            obj.ShortName = tableLine.ShortName{1};
%             obj.Beasts(1) = beasts(1);
%             obj.Beasts(2) = beasts(2);
            obj.Names = {};
            w = width(tableLine);
            for j = 4:2:w-1
                
                               
               species = tableLine{1,j}{1};
               
               if (species == "") | (isempty(species)) | (ismissing(species))
                   break
               else
                   
                   collected = [obj.Beasts.Name];
                   
                   if ~isempty(obj.Beasts) && any(collected == species)
                       n = string(tableLine{1,j+1});
                       id = find(collected == species);
                       if n == "" || isempty(n) || ismissing(n)

                           n = obj.Beasts(id).Name +" " + num2str(1+ length(obj.Names{id}));
                       end
                       obj.Names{id}{end+1} = n;


                   else
                       all = [beasts.Name];

                       obj.Beasts(end+1) = beasts(all == species);
                       n = string(tableLine{1,j+1});
                       if n == "" || isempty(n) || ismissing(n)
                           n = obj.Beasts(end).Name + " 1";
                       end
                       obj.Names{end+1} ={ n};
                   end       
                end
            end
        end

        function t = print(obj)
           t  = "\\encounter{";
           t = t + prepareText(obj.Name) + "}\n";
           t = t +"{" + prepareText(obj.Description) + "}";
           
           t = t + "{";
          
           n = length(obj.Beasts);
           for i = 1:n
               t = t + obj.Beasts(i).print(2,obj.Names{i});
           end
           t = t + "}";
        end
    end
end

