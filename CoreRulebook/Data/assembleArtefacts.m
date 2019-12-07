items = readtable('Items/artefacts.xlsx');
items = sortrows(items);

fileName = '../Chapters/Adventuring.tex';
readFile = fileread(fileName);


insertPoint = strfind(readFile, '%%ArtefactBegin');

endPoint = strfind(readFile, '%%ArtefactEnd');

firstHalf = prepareText(readFile(1:insertPoint+15));

secondHalf = prepareText(readFile(endPoint:end));


preamble = ' \begin{center}\begin{rndtable}{|p{\q cm} l l |}';
headers = '\hline \tablehead \bf Name & \bf Weight & \bf Cost \\ \hline ';

text = [preamble headers];
text = prepareText(text);
[n,~] = size(items);
descriptionText = "";
line = "";
split = min(35,n);
if 2*split < n
	disp ("Split value too low. Not all values will display")
end
descs = cell(1,n);
for (i = 1:split)
	
	tool = prepareText(items.Name{i});
	weight = prepareText(items.Weight{i});
	cost = prepareText(num2str(items.Cost(i)));
	description = prepareText(items.Description{i});
	line = strcat('\t  \\parbox[t]{\\q cm}{\\bf \\raggedright \\footnotesize',{' '}, tool, '}\t&\t  ', weight, '\t&\t', cost, ' gold \\\\ \n ');
	
	if description~=""
		entry = strcat('\n \n \\generic{',tool,'}{',description,'}');
		descs{i} = entry;
	else
		descs{j} = "";
	end
% 	j = split + i;
% 	if j <= n
% 		tool = prepareText(items.Name{j});
% 		weight = prepareText(items.Weight{j});
% 		cost = prepareText(num2str(items.Cost(j)));
% 		description = prepareText(items.Description{j});
% 		
% 		line = strcat(line,'\t&~&\t \\bf \\parbox[t]{\\q cm}{\\raggedright \\footnotesize',{' '}, tool, '}\t&\t  ', weight, '\t&\t', cost, ' gold \\\\ \n');
% 
% 		if description~=""
% 			entry = strcat('\n \n \\generic{',tool,'}{',description,'}');
% 			descs{j} = entry;
% 		else
% 			descs{j} = "";
% 		end
% 
% 	else
% 		line = strcat(line,'&~&~&~&~ \\\\ \n');
% 	end
	
	text = strcat(text,line);
	
end
for j = 1:n
	descriptionText = strcat(descriptionText,descs{j});
end



ender = '\\hline\n\\end{rndtable}\n\\end{center} \n';

fullText = strcat(firstHalf, text, ender, descriptionText, secondHalf);



FID = fopen(fileName,'w');
fprintf(FID,fullText);
