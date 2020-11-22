classdef NPC < handle

    properties
        PrintName;
        Name;
        Family;
        Personality;
        Archetype;
        Aspects
        Abilities
        Affinities
        Defences
        Movement
    end
    
    methods
        function obj = NPC(statLine)
            obj.Name = "";
            obj.Family = "";
            obj.Personality = "";
            obj.Archetype = "";
            obj.Aspects = Rating.empty;
            obj.Abilities = Rating.empty;
            obj.Affinities = Rating.empty;
            obj.Defences = Rating.empty;
            if nargin == 1
                obj = obj.normalAsignment(statLine);
            end
        end
        
        function obj = normalAsignment(obj,statLine)

            charName = statLine.Name{1};
            obj.PrintName = charName(~isspace(charName));
            obj.Name = string(statLine.Name{1});
            obj.Family = string(statLine.Family{1});
            obj.Personality = string(statLine.Personality{1});
            obj.Archetype = string(statLine.Archetype{1});
            
           
            obj.Movement = statLine.Movement(1);
            obj.parseAspects(statLine);
            obj.parseAffinities(statLine);
            obj.parseAbilities(statLine);
            obj.parseDefences(statLine);
        end
        function parseAspects(obj,statLine)
            aspects = ["Fitness", "Precision","Vitality","Charm","Deception","Insight","Intelligence","Willpower","Perception"];
            for i = 1:length(aspects)
                v = statLine.(aspects(i));
                obj.Aspects(i) = Rating(aspects(i),v);
            end
        end
        
        function parseAffinities(obj,statLine)
           	affinities = ["Alteration","Bewitchment","Cerebral","Conjuration","Curses","Elemental","Hermetics","Hexes","Kinesis","Occultism","Psionics","Temporal","Warding","Necromancy"];
           
            for i = 1:length(affinities)
                v = statLine.(affinities(i));
                obj.Affinities(i) = Rating(affinities(i),v);
            end
            
        end
        
        function parseAbilities(obj,statLine)
           innate = ["Alertness","Bravery","Conviction","Eloquence","Intimidation","Kindness","Kinship","Logic","Speed","Strength"];
           practical = ["Acrobatics","Brawl","Covert","Craft","Imbue","Marksmanship","Performance","Pilot","Skirmish","Survival"];
           learned = ["Arcane","FirstAid","History","Investigation","Linguistics","Muggle","Nature","Science","Unnature","World"];
           
           
            n = 1;
            for i = 1:length(innate)
                
                v = statLine.(innate(i));

                if v > 0&& n < 6
                    obj.Abilities(1,n) = Rating(innate(i),v);
                    n = n + 1;
                end
            end
            inSpec =statLine.ArchInnate{1};
            r = Rating(inSpec,statLine.InnateAbility);
            obj.Abilities(1,n) = r;
            
            
            n = 1;
            for i = 1:length(practical)
                v = statLine.(practical(i));

                if v > 0 && n < 6
                    
                    obj.Abilities(2,n) = Rating(practical(i),v);
                    n = n + 1;
                end
            end
            inSpec =statLine.ArchPractical{1};
            r = Rating(inSpec,statLine.PracticalAbility);
            obj.Abilities(2,n) = r;
            
            
            n = 1;
            for i = 1:length(learned)
                v = statLine.(learned(i));

                if v > 0&& n < 6
                    obj.Abilities(3,n) = Rating(learned(i),v);
                    n = n+1;
                end
            end
            inSpec =statLine.ArchKnowledge{1};
            r = Rating(inSpec,statLine.KnowledgeAbility);
            obj.Abilities(3,n) = r;
        end
        
        function parseDefences(obj,statLine)
           names = ["BaseBlock","BonusBlock","BaseDodge","BonusDodge","BaseEndure","BonusEndure"];
           
           for i = 1:length(names)
              v = statLine.(names(i));

              obj.Defences(i) = Rating(names(i),v);
           end
        end
        
        function s = Print(obj)
           s = "";
           
           normalNames = ["Name","Family","Personality","Archetype","Movement"];
           normalValues = [obj.Name, obj.Family, obj.Personality, obj.Archetype,obj.Movement];
           
           for i = 1:length(normalNames)
              defer = "\\def\\char" + normalNames(i) + "{" + normalValues(i) + "}";
              s = s + defer + "\n";
           end
            
 
           ratingHolders = {obj.Aspects,obj.Affinities,obj.Defences};
           for i = 1:length(ratingHolders)
               T = ratingHolders{i};
               for j = 1:length(T)
                   if ~T(j).IsError
                      defer = "\\def\\char" + T(j).Name + "{" + T(j).Value +"}";
                      s = s + defer + "\n";
                   end
               end
               
           end
           
           s = s + obj.printAbilities();
        end
        
        function s = printAbilities(obj)
            s = "";
            names = ["Innate", "Practical","Knowledge"];
            [a,b] = size(obj.Abilities);
            for i = 1:a
                
                for j = 1:b
                    s = s + "\\def\\char" + names(i) + num2roman(j) + "{" +obj.Abilities(i,j).Name +"}\n";
                    s = s + "\\def\\char" + names(i) + num2roman(j) + "Val{" +obj.Abilities(i,j).Value +"}\n";
                end
            end
            
        end
        
        function Render(obj)
            command = "cd ../Latex; xelatex -jobname=" + obj.PrintName + " -output-directory=../CharacterSheets/  CharacterSheet.tex"; 
            
            targetName = "../Latex/datafile.tex";
            FID = fopen(targetName,'w');
            fprintf(FID, obj.Print());
            fclose(FID);
            
            
            system(command);
            
            endings = ["aux", "log", "out"];
            for i = 1:length(endings)
                system("rm ../CharacterSheets/*." + endings(i))
            end
        end
    end
end

