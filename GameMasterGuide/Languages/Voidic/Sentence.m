classdef Sentence < handle
    
    
    properties
        Original
        Words
        Phonology
    end
    
    methods
        function obj = Sentence(text,phonology)
           obj.Original = text;
           obj.Phonology = phonology; 
           obj.Words = Word.empty;
           obj.generateWords();
          
            
        end
        
        function generateWords(obj)
            
            t = [obj.Original ' '];
            
            r = find(t == ' ');
            endl = 0;
            
            for i = 1:length(r)
               start = endl + 1;
               endl = r(i);
               
               word = t(start:endl-1);
               
               w = Word(word, obj.Phonology);
               obj.Words(end+1) = w;
            end
        end
        
        
    end
end

