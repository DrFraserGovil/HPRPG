function newText = prepareText(text)
    newText = "";
    text = char(text);
    for j = 1:length(text)
        character = text(j);
        if strcmp(character, "\")==1
            character = "\\";
        end
        if strcmp(character,"-")==1
            character = "\\minus{}";
        end
        if strcmp(character,",")==1
            character = "\\comma{}";
        end
        if strcmp(character,"%")==1
            character = "%%";
        end
       newText = newText + character;
    end


end

