beasts = readtable('Sapients.xlsx');

beasts = sortrows(sortrows(beasts,2));
fileName = '../Chapters/BeastsBeings.tex';
readFile = fileread(fileName);


insertPoint = strfind(readFile, '%%SapientBegin');

endPoint = strfind(readFile, '%%SapientEnd');

firstHalf = readFile(1:insertPoint+15);

secondHalf = readFile(endPoint:end);

n = size(beasts);
text = '\begin{longtable}{p{\q cm} p{\s cm}  p{\q cm}}';
tableEntries = {};
for i = 1:n
  
    beasts.Subclass{i}
    initialEntry = ['\sapient{' beasts.Class{i} '}{',beasts.Subclass{i},'}'];
    
    temp = beasts.ATH{i};
    ath =  temp(find(~isspace(temp)));
    
    temp = beasts.FIN{i};
    fin =  temp(find(~isspace(temp)));
    
    temp = beasts.SPR{i};
    spr =  temp(find(~isspace(temp)));
    
    temp = beasts.CHR{i};
    chr =  temp(find(~isspace(temp)));
    
    temp = beasts.INT{i};
    int =  temp(find(~isspace(temp)));
    
    temp = beasts.EMP{i};
    emp =  temp(find(~isspace(temp)));
    
    temp = beasts.POW{i};
    pow =  temp(find(~isspace(temp)));
    
    temp = beasts.EVL{i};
    evl =  temp(find(~isspace(temp)));
    statEntry = ['{ {',ath, '}{',beasts.FIN{i}, '}{',spr, '}{',chr, '}{',int, '}{',emp, '}{',pow, '}{',evl,'} }'];
    abilities = [];
    hp = beasts.HP{i};
    fp = beasts.FP{i};

   
    
    
    abilities = beasts.Abilities{i};
    
    combatEntry = ['{ {',hp, '}{', fp,'}{', abilities,'}{',beasts.Skills{i},'}}'];
    
    
    itemsEntry = ['{', beasts.Items{i},'}{',beasts.Spells{i},'}'];
    
    mode = num2str(beasts.CombatType(i));
    
    text = [text initialEntry combatEntry itemsEntry statEntry '{'  beasts.Description{i} '}' mode];
    
    if mod(i,2)==1
        text = [text '\vspace{-2cm}  & ~ & '];
    else
        text = [text ' \vspace{-2cm} \\ ' ];
    end
end

fullText = [firstHalf, text, '\end{longtable}', secondHalf];

FID = fopen(fileName,'w');
fwrite(FID, fullText);
