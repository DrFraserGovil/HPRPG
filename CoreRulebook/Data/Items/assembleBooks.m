books = readtable('Items/books.xlsx');
books = sortrows(books);

fileName = '../Chapters/Books.tex';
readFile = fileread(fileName);


insertPoint = strfind(readFile, '%%BooksBegin');

endPoint = strfind(readFile, '%%BooksEnd');

firstHalf = prepareText(readFile(1:insertPoint+13));

secondHalf = prepareText(readFile(endPoint:end));


preamble = ' \begin{center} \footnotesize \begin{rndtable}{|p{\w cm} l |}';
headers = '\hline \tablehead \normalsize \bf Name & \normalsize \bf Cost \\ \hline ';

text = [preamble headers];
spellText = prepareText(strcat('\subsection{Spell Books} \spellIntro',text));
normalText = prepareText(strcat('\subsection{Normal Books} \normalIntro',text));
n = size(books);
descriptionText = "";
for (i = 1:n)
    topic = prepareText(books.Name{i});
    b1 = prepareText(books.Book1{i});
	b2 = prepareText(books.Book2{i});
	b3 = prepareText(books.Book3{i});
	b4 = prepareText(books.Book4{i});
	b5 = prepareText(books.Book5{i});
	
	bs = {b1,b2,b3,b4,b5};
	
	c1 = prepareText(num2str(books.Cost1(i)));
	c2 = prepareText(num2str(books.Cost2(i)));
	c3 = prepareText(num2str(books.Cost3(i)));
	c4 = prepareText(num2str(books.Cost4(i)));
	c5 = prepareText(num2str(books.Cost5(i)));
	cs = {c1,c2,c3,c4,c5};
	
    description = prepareText(books.Description{i});
	
    line = strcat('\t\\bf ',{' '}, topic,'\t&\t'); 

    if b1==""
		line = strcat(line, c1,' \\\\ \n');
	else
		j = 1;
		line = strcat(line,'\\\\\n');
		for j = 1:5
			if bs{j}~=""
				line = strcat(line,'\t~~{\\it',{' '},bs{j}, '}\t&\t',cs{j},'\\\\\n');
				a = 1;
			end
			j = j+1;
		end
	end
	if contains(line,"Spellbook")
		spellText = strcat(spellText,line);
	else
		normalText = strcat(normalText,line);
	end
	entry = strcat('\n \n \\book{',topic,'}{',description,'}');
	descriptionText = descriptionText + entry;
end
ender = '\\hline\n\\end{rndtable}\n\\end{center} \\vfill \\normalsize \n';

fullText = strcat(firstHalf, normalText, ender, spellText, ender, secondHalf);



FID = fopen(fileName,'w');
fprintf(FID,fullText);
