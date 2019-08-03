beasts = readtable('../GameMasterGuide/Data/ingredients.csv');
beasts = sortrows(beasts);

fileName = 'CharacterSheet.tex';
readFile = fileread(fileName);



insertPoint = strfind(readFile, '%%IngBegin');

endPoint = strfind(readFile, '%%IngEnd');

firstHalf = readFile(1:insertPoint+10);
secondHalf = readFile(endPoint:end);

n = size(beasts);
text = '\begin{longtable}{|p{\p cm} | p{\q cm} | p{\r cm}| p{\s cm}|}';
text = text + "\hline \bf ID & \bf Name & \bf Effects & \bf No. \\ \hline \hline";
tableEntries = {};
for i = 1:n
    id = beasts.IngredientID(i);
    name = beasts.Name{i};
    disp(name)

    

    diff = beasts.MixingDifficulty(i);
    temp = "";
    temp = temp + " " + id;
    temp = temp + "& \bf \parbox[t]{\q cm}{\raggedright " + name + "}\vspace{\t cm}";
    temp = temp+"&~&~";
    temp = temp + "\\ \hline";
    text = text + temp;
end

fullText = firstHalf +  text +  '\end{longtable}' +secondHalf;
FID = fopen(fileName,'w');
fwrite(FID, fullText);
