classdef Word < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Original
        Letters
        Phonology
        Angles
    end
    
    methods
        function obj = Word(text,phonology)
            obj.Original = text;
            obj.Phonology = phonology;
            obj.parseLetters()
            obj.prepareCircoid();
        end
        
        function parseLetters(obj)
            t = obj.Original;
            i = 1;
            while i <= length(t)
               c = t(i);
               if c == '\'
                   i = i + 1;
                   c = [c t(i)];
               end
               
               id = obj.phonologySearch(c);
               
               if id > -1
                  obj.Letters(end+1) = id;
               else
                   disp("Error, could not translate '" + string(c) + "'");
               end
               
               i = i + 1;
               
               
               
            end
            obj.Original;
            obj.Letters;
        end
        
        function id = phonologySearch(obj,letter)
           h = height(obj.Phonology);
           letter = lower(letter);
           
           
           id = -1;
           
           for i = 1:h
               q = obj.Phonology.Letter{i};
               if ( string(letter) == string(q))
                   id = i;
               end
           end
        end
        
        function prepareCircoid(obj)
            Max = height(obj.Phonology);
            
            angle = 2 * pi / (Max);
            for i = 1:length(obj.Letters)
               obj.Angles(i) = (obj.Letters(i) - 1) * angle; 
            end
        end
        
        function plotCircoid(obj,cx,cy,r)
            obj

            angles = [0 obj.Angles 0];
            rs = [0 ones(1,length(obj.Angles)) 0]*r;

            for i = 2:length(angles)
                
                while angles(i) <= angles(i-1)
                    angles(i) = angles(i) + 2*pi;
                end
                    
            end
           
            
           
            polarplot(angles,rs)

        end
        
    end
end

