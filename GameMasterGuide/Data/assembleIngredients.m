beasts = readtable('ingredients.csv');
beasts = sortrows(beasts);

fileName = '../Chapters/Potions.tex';
readFile = fileread(fileName);



insertPoint = strfind(readFile, '%%IngBegin');

endPoint = strfind(readFile, '%%IngEnd');

firstHalf = readFile(1:insertPoint+10);
secondHalf = readFile(endPoint:end);

n = size(beasts);
text = '\begin{longtable}{|p{\u cm}| p{\q cm}| p{\s cm}|  p{\q cm}| p{\q cm}| p{\q cm}| p{\q cm}| p{\r cm} |p{\r cm} |p{\r cm}|}';
text = text + "\hline \bf ID & \bf Name & \bf Type & \bf Effect 1 & \bf Effect 2 & \bf Effect 3& \bf Effect 4 & \bf Rare & \bf \$ & \bf MD \\ \hline \hline";
tableEntries = {};
for i = 1:n
    id = beasts.IngredientID(i);
    name = beasts.Name{i};
    disp(name)
    cat = beasts.Category{i};
    
    e1 = beasts.Effect1{i};
    s1 = beasts.Strength1(i);
    e2 = beasts.Effect2{i};
    s2 = beasts.Strength2(i);
    e3 = beasts.Effect3{i};
    s3 = beasts.Strength3(i);
    e4 = beasts.Effect4{i};
    s4 = beasts.Strength4(i);
    
    rarity = beasts.Rarity(i);
    cost = beasts.Cost(i);
    diff = beasts.MixingDifficulty(i);
    temp = "";
    temp = temp + " " + id;
    temp = temp + "& \bf \parbox[t]{\q cm}{\raggedright " + name + "}\vspace{\t cm}";
    temp = temp + "& " + cat;
    if ~isnan(s1)
        temp = temp + "& " + e1 + " (" + num2str(s1) + ")";
    else
        temp = temp + "& ";
    end
    if ~isnan(s2)
        temp = temp + "& " + e2 + " (" + num2str(s2) + ")";
     else
        temp = temp + "& ";
    end
    if ~isnan(s3)
        temp = temp + "& " + e3 + " (" + num2str(s3) + ")";
    else
        temp = temp + "& ";
    end
    if ~isnan(s4)
        temp = temp + "& " + e4+ " (" + num2str(s4) + ")";
    else
        temp = temp + "& ";
    end
    temp = temp + "&" + num2str(rarity);
    temp = temp + "&" + num2str(cost);
    temp = temp + "&" + num2str(diff);
    temp = temp + "\\ \hline";
    text = text + temp;
end

fullText = firstHalf +  text +  '\end{longtable}' +secondHalf;
FID = fopen(fileName,'w');
fwrite(FID, fullText);
