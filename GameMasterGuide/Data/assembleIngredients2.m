beasts = readtable('ingredients.csv');
beasts = sortrows(beasts);

fileName = '../Chapters/Potions.tex';
readFile = fileread(fileName);



insertPoint = strfind(readFile, '%%IngBegin');

endPoint = strfind(readFile, '%%IngEnd');

firstHalf = readFile(1:insertPoint+10);
secondHalf = readFile(endPoint:end);

n = size(beasts);
Ncols = 6;
text = '\begin{longtable}{';
for i = 1:Ncols
    text = text + "p{\q cm}"
    text = text + "p{\t cm}"
end

text = text + "}";
tableEntries = {};
for i = 1:n
    id = beasts.IngredientID(i);
    name = beasts.Name{i};
    disp(name)
    cat = beasts.Category(i);
    
    e1 = beasts.Effect1{i};
    s1 = beasts.Strength1(i);
    e2 = beasts.Effect2{i};
    s2 = beasts.Strength2(i);
    e3 = beasts.Effect3{i};
    s3 = beasts.Strength3(i);
    e4 = beasts.Effect4{i};
    s4 = beasts.Strength4(i);
    
    rarity = beasts.Cost(i);
    
    diff = beasts.MixingDifficulty(i);
    info = beasts.Description{i};
    introBlock = "\ingredient{" + num2str(id) + "}{" + name + "}{" + num2str(cat) + "}";
    es = {e1,e2,e3,e4};
    ss = [s1,s2,s3,s4];
    effBlock = "{";

    for j = 1:length(es)
        
       if ~isempty(es{j}) &&  ~isnan(ss(j))
           effBlock = effBlock + "{" + es{j} + "}";
           effBlock = effBlock + "{" + num2str(ss(j)) + "}";
       else
           effBlock = effBlock + "{}{0}";
       end
    end
    
    effBlock = effBlock + " }";
    
    diffBlock = "{ " + num2str(rarity) + "}";
    diffBlock = diffBlock  + "{" + num2str(diff) + "}";

    
    temp = introBlock + effBlock + diffBlock+"{"+info +"}";
    if mod(i,Ncols) ==0
        temp = temp + " \\ ";
    else
        temp = temp + "&~&";
    end
        
    text = text + temp;

end

fullText = firstHalf +  text +  '\end{longtable}' +secondHalf;
FID = fopen(fileName,'w');
fwrite(FID, fullText);
