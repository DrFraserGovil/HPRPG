function newText = prepareText(text,commaMode,dashMode)
    if nargin < 2
        commaMode= 1;
    end
    if nargin < 3
        dashMode = 1;
    end
    newText = "";
    text = char(text);
    for j = 1:length(text)
        character = text(j);
        if strcmp(character, "\")==1
            character = "\\";
        end
        if dashMode
            if strcmp(character,"-")==1
                character = "\\minus{}";
            end
        end
        if commaMode
            if strcmp(character,",")==1
                character = "\\comma{}";
            end
        end
        if strcmp(character,"%")==1
            character = "%%";
        end
       newText = newText + character;
    end


end

