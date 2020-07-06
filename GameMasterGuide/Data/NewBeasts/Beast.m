classdef Beast

    properties
        Order
        Name
        Species
        Rating
        Mind
        Category
        
        Fitness
        Precision
        Vitality
        Charm
        Deception
        Insight
        Intelligence
        Willpower
        Perception
        
        Unharmed
        Bruised
        Hurt
        Injured
        Wounded
        Mangled
        
        Fortitude
        HasFortitude
        
        Block
        Dodge
        Defy
        
        SKills
        HasSkills
        
        Immune
        Resistant
        Susceptible
        
        Languages
        Armaments
        Skills
        Abilities
        
        Image
        hasImage
        ImagePos
        ImageHeight
        
        NeedsPage
        
        IsHuge
    end
    
    methods
        function obj = Beast(tableLine)
            obj.Order = tableLine.SpeciesOrder(1);
            obj.Name = tableLine.Name{1};
            obj.Species = tableLine.Species{1};
            obj.Mind = tableLine.Mind{1};
            obj.Category = tableLine.Category{1};
            obj.Rating = tableLine.Rating(1);
            
            obj.Unharmed = tableLine.Unharmed(1);
            obj.Bruised = tableLine.Bruised(1);
            obj.Hurt = tableLine.Hurt(1);
            obj.Injured = tableLine.Injured(1);
            obj.Wounded = tableLine.Wounded(1);
            obj.Mangled = tableLine.Mangled(1);
            
            obj.Fortitude = tableLine.Fortitude(1);
            obj.HasFortitude = true;
            if isnan(obj.Fortitude)
                obj.HasFortitude = false;
            end
            
            obj.Fitness = tableLine.Fitness(1);
            obj.Precision = tableLine.Precision(1);
            obj.Vitality = tableLine.Vitality(1);
            obj.Charm = tableLine.Charm(1);
            obj.Deception = tableLine.Deception(1);
            obj.Insight = tableLine.Insight(1);
            obj.Intelligence = tableLine.Intelligence(1);
            obj.Willpower = tableLine.Willpower(1);
            obj.Perception = tableLine.Perception(1);
            
            obj.Block = tableLine.Block(1);
            obj.Defy = tableLine.Defy(1);
            obj.Dodge = tableLine.Dodge(1);
            
            obj.Resistant = tableLine.Resistant{1};
            obj.Immune = tableLine.Immune{1};
            obj.Susceptible = tableLine.Susceptible{1};
            obj.Languages = tableLine.Languages{1};
            obj.Skills = tableLine.Skills{1};
            obj.HasSkills = true;
            if (obj.Skills == "")
                obj.HasSkills = false;
            end
            obj.Armaments = tableLine.Armaments{1};
            obj.Abilities = tableLine.Abilities{1};
        end
        
        function text = print(obj)
            
            text = "\\beast{";
           
            
            titles = ["name", "species","mind","category","rating"];
            array = [string(obj.Name), string(obj.Species), string(obj.Mind), string(obj.Category),string(obj.Rating)];
            
            for i = 1:length(array)
                text = text + prepareText(titles(i)) + " = " + prepareText(array(i)) + ", ";
            end
            
            text = text + obj.statBlock();
            
            numTitles = ["nUnharmed","nBruised","nHurt","nInjured","nWounded","nMangled","block","dodge","fortitude"];
            numArray = [obj.Unharmed, obj.Bruised, obj.Hurt, obj.Injured, obj.Wounded, obj.Mangled, obj.Block, obj.Dodge,obj.Fortitude];
            for i = 1:length(numArray)
                val = numArray(i);
                if isnan(val)
                    val = 0;
                end
                text = text + numTitles(i) + "="+num2str(val) + ", ";
            end
            
            hasTitles = ["hasSkills"];
            hasTriggers = [obj.HasSkills];
            includeTitles = ["skills"];
            includeVals = [string(obj.Skills)];
            
            for i = 1:length(hasTitles)
               if hasTriggers(i) 
                  text = text +  hasTitles(i) + " = 1, " + prepareText(includeTitles(i)) + " = " + prepareText(includeVals(i)) + ", ";
               end
            
            end
           
           text = text + "}";
        end
        
        function s = statBlock(obj)
            names = ["fit", "prs","vit","cha","dec","ins","int","wil","pcp"];
            vals = [obj.Fitness, obj.Precision, obj.Vitality, obj.Charm, obj.Deception, obj.Insight, obj.Intelligence, obj.Willpower, obj.Perception];
            
            s = "";
            for i = 1:length(names)
                
                v = vals(i);
                if isnan(v)
                    v = 0;
                end
               
            end
                
        end
    end
end

