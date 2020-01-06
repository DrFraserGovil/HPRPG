function assembleSkills()
    skills= readtable('skills.xlsx');
   
    [n,~] = size(skills);
skills = sortrows(skills);

skills.SortName = skills.Name;
for i = 1:n
   if contains(skills.Name{i},"Species")
      skills.SortName{i} = strcat('zzz_', skills.SortName{i}); 
   end
   if contains(skills.Name{i},"Magic:")
      skills.SortName{i} = strcat('A_',skills.SortName{i}); 
   end
end

[~,I] = sort(skills.SortName);
skills = skills(I,:);


    %statuses = sortrows(statuses,5);

    %preamble = '\begin{center} \tablealternate \begin{longtable}{|m{\w cm}  m{\y cm} m{\x cm} m{\z cm}|}';
    %headers = '\hline \tablehead \normalsize \bf Name  & \normalsize \bf Effect & \bf \normalsize Levels & \normalsize \bf Prerequisite \\ \hline \hline ';

    text = '';



    for (i = 1:n)
%         line = ['\bf \begin{flushleft} ' skills.Name{i}, '\end{flushleft}',...
%             '  &   \parbox[t]{\y cm}{\begin{flushleft}', skills.Effect{i}, '\end{flushleft}}',...
%             '  &   \parbox[t]{\x cm}{\begin{center}', num2str(skills.SkillLevels(i)), '\end{center}}',...
%             '  &   \parbox[t]{\z cm}{\begin{center} \it ', skills.Prerequisite{i}, '\end{center}}  \\  '];
%        
            
        line = strcat('\\skill{name = ', prepareText(skills.Name{i}), ',prerequisite=', prepareText(skills.Prerequisite{i}), ',  description = ', prepareText(skills.Effect{i}));
        if (isempty(skills.Prerequisite{i}))
            line = strcat(line,', noPre = 1');
        end
        line =strcat(line, ', n = ',num2str(skills.SkillLevels(i)));
        
        text = strcat(text,  line,'}\n\n');
      
    end



    fileName = '../Chapters/Skill_List.tex';
    readFile = fileread(fileName);


    insertPoint = strfind(readFile, '%%SkillBegin');

    endPoint = strfind(readFile, '%%SkillEnd');

    firstHalf = readFile(1:insertPoint+12);

    secondHalf = readFile(endPoint:end);

    fullText = strcat(prepareText(firstHalf,0), text, prepareText(secondHalf));

    FID = fopen(fileName,'w');
    fprintf(FID, fullText);
end