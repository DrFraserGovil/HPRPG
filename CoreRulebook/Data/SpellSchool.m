classdef SpellSchool < handle

    properties
        Name
        SortName;
        Discipline
    end
    
    methods
        function obj = SpellSchool(name)
            obj.Name = name;
            obj.SortName = name;
            if strcmp(obj.Name, "Dark Arts") == 1
                obj.SortName = "zz"+ name;
            end
            obj.Discipline = SpellDiscipline.empty;
        end
        
        function val = hasDiscipline(obj,name)
            val = 0;
            for i = 1:length(obj.Discipline)
                if strcmp(obj.Discipline(i).Name,name) == 1
                    val = i;
                end
            end
        end
    end
end

