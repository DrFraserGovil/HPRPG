words = ["name", "article", "description"];

abilities = ["innate","knowledge","practical"];
subabilities = ["Ability","Description","Nil","I","II","III","IV","V","VI","VII"];

for i = 1:length(abilities)
    for j = 1:length(subabilities)
        words(end+1) = abilities(i) + subabilities(j);
    end
end


t = "\\makeatletter\n";
r = "\\makeatother\n\n\\newcommand\\archetype[1]\n{\n\t\\begingroup\n\t\\setkeys{archetype}{";
for i = 1:length(words)
   t = t + "\\define@key{archetype}{" + words(i) + "}{\\def\\" + words(i) + "{#1}}\n";
   r = r + words(i) + "= None";
   if i < length(words)
       r = r + ",";
   end
end
r = r + "} \n";
fprintf(t + r)