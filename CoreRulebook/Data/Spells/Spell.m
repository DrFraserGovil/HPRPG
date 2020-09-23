classdef Spell < handle
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Name
        Discipline
        Description
        Incantation
        Book
        Level0
        Level1
        Level2
        Level3
        Level4
        Level5
        Level6
        Level7
    end
    
    methods
        function obj = Spell()
            obj.Name = "None";
            obj.Discipline = "None";
            obj.Description = "None";
            obj.Incantation = "None";
            obj.Book = "None";
            obj.Level0= "None";
            obj.Level1 = "None";
            obj.Level2 = "None";
            obj.Level3 = "None";
            obj.Level4 = "None";
            obj.Level5 = "None";
            obj.Level6 = "None";
            obj.Level7 = "None";
        end
        
        function obj = ReadLine(obj,tableLine)
            obj.Name = string(tableLine.Name{1});
            obj.Discipline = string(tableLine.Discipline{1});
            obj.Description = string(tableLine.Description{1});
            obj.Incantation = string(tableLine.Incantation{1});
            obj.Book = string(tableLine.Book{1});
            obj.Level0 = string(tableLine.Nihil{1});
            obj.Level1 = string(tableLine.Primus{1});
            obj.Level2 = string(tableLine.Dua{1});
            obj.Level3 = string(tableLine.Tria{1});
            obj.Level4 = string(tableLine.Qartum{1});
            obj.Level5 = string(tableLine.Qinta{1});
            obj.Level6 = string(tableLine.Sextus{1});
            obj.Level7 = string(tableLine.Sumnus{1});
        end
        
        function t = Print(obj)
            t = "\\spell{";
            
            triggers = ["name","incantation","book","description"];
            values = [obj.Name,obj.Incantation,obj.Book,obj.Description];
            
            for i = 1:length(triggers)
                t = t + triggers(i) + " = " + prepareText(values(i));
                if i < length(triggers)
                    t = t + ", ";
                end
            end
            
            hasAgg = false;
            hasT = ["zero","one","two","three","four","five","six","seven"];
            hasVals = [obj.Level0,obj.Level1,obj.Level2,obj.Level3,obj.Level4,obj.Level5,obj.Level6,obj.Level7];
            for i = 1:length(hasT)
               if hasVals(i) == "" || isempty(hasVals(i))
                    t = t + ", " + "has" + hasT(i) + "=0";
               else
                    t = t + ", " + "has" + hasT(i) + "=1";
                    t = t + ", " + hasT(i) + "=" + prepareText(hasVals(i));
                    hasAgg = true;
               end
            end
    
            t = t + ", hasExamples = " + num2str(hasAgg);
            t = t + "}";
            

        end
    end
end

