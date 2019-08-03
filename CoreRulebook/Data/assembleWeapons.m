professions = readtable('weapons.xlsx');
professions = sortrows(professions);
professions = sortrows(professions,2);
professions = sortrows(professions,3);

fileName = '../Chapters/Items.tex';
readFile = fileread(fileName);


insertPoint = strfind(readFile, '%%WeaponsBegin');

endPoint = strfind(readFile, '%%WeaponsEnd');

firstHalf = readFile(1:insertPoint+14);

secondHalf = readFile(endPoint:end);


preamble = ' \begin{tabular}{|c|c|c|c|c|m {\l cm}|}';
headers = '\hline \normalsize \bf Weapon & \normalsize \bf Type & \normalsize \bf Brawler & \normalsize \bf Damage Check & \normalsize \bf Damage Type & \bf Notes\\ \hline \hline ';

text = [preamble headers];

n = size(professions);

for (i = 1:n)
    weapon = professions.Weapon{i};
    type = professions.Type{i};
    lvl = num2str(professions.BrawlerLevel(i));
    type = professions.Damage{i};
    notes = ['\parbox[t]{\l cm}{', professions.Notes{i}, '}'];
    check = [professions.Dice{i},' ', professions.Check{i}, ' (', professions.Proficiency{i}, ') '];
    
    if isnan(professions.BrawlerLevel(i))
        lvl = ' ';
    end
    line = ['\bf ', weapon, ' &  ', professions.Type{i}, ' & ', lvl,...
        ' & ', check, ' & ', type, '& ', notes, '\\ \hline '];
     
    text = [text line];
end
ender = '\end{tabular} ';

fullText = [firstHalf, text, ender, secondHalf];

FID = fopen(fileName,'w');
fwrite(FID, fullText);
