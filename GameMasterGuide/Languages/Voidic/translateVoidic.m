function Text = translateVoidic(targetFile)

    phonology = readtable("voidicPhonology.xlsx");
    file = char(fileread(targetFile));
    
    
    
    r  = find(file == '.');
    r = [r regexp(file, "[\n]")];
    r = sort(r);
    
    Text = Sentence.empty;
    if ~isempty(r)
       
        endl = 0;
        for i = 1:length(r)
            start = endl+1;
            endl = r(i);
            
            chunk = file(start:endl-1);
            if count(chunk,' ') < length(chunk)
                s = Sentence(chunk,phonology);
                Text(end+1) = s;
            end
        end
       
    else
        Text = Sentence(file,phonology);
    end
   
   
end