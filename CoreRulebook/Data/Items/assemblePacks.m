packs = readtable('Items/packs.xlsx');
packs = sortrows(packs);

fileName = '../Chapters/Adventuring.tex';
readFile = fileread(fileName);


insertPoint = strfind(readFile, '%%PackBegin');

endPoint = strfind(readFile, '%%PackEnd');

firstHalf = prepareText(readFile(1:insertPoint+12));

secondHalf = prepareText(readFile(endPoint:end));


preamble = '';
headers = '';

text = [preamble headers];
text = prepareText(text);
n = size(packs);
descriptionText = "";
for (i = 1:n)
    tool = prepareText(packs.Name{i})
    cost = prepareText(num2str(packs.Cost(i)));
    description = prepareText(packs.Components{i});
    line = strcat('\\pack{',tool,'}{',cost,'}{',description,'}'); 
    text = strcat(text,line,'\n\n');
	

end

fullText = strcat(firstHalf, text, secondHalf);



FID = fopen(fileName,'w');
fprintf(FID,fullText);
