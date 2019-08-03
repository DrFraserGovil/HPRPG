beasts = readtable('Beasts.xlsx');
beasts = sortrows(beasts);

fileName = '../Chapters/BeastsBeings.tex';
readFile = fileread(fileName);



insertPoint = strfind(readFile, '%%BeastBegin');

endPoint = strfind(readFile, '%%BeastEnd');

firstHalf = readFile(1:insertPoint+13);

secondHalf = readFile(endPoint:end);

n = size(beasts);
text = '\begin{longtable}{p{\q cm} p{\s cm}  p{\q cm}}';
tableEntries = {};
for i = 1:n
  
    beasts.Name{i}
    
    headerBlock = ['{{' beasts.Name{i} '}{' beasts.Summary{i} '}}'];
    textBlock = ['{' beasts.Description{i} '}'];
    physicalBlock = ['{{',beasts.Habitat{i},'}{',beasts.SizeParameter{i},'}{',beasts.Size{i},'}}'];
    
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
    statBlock = ['{ {',ath, '}{',beasts.FIN{i}, '}{',spr, '}{',chr, '}{',int, '}{',emp, '}{',pow, '}{',evl,'} }'];
    
    abilities = [];
    hp = beasts.HP{i};
    amr = beasts.AMR{i};
    atk = beasts.ATK{i};
    rng = beasts.RNG{i};
    
    attackBlock = ['{ {' atk '}{' rng '} }'];
    
    closeAttacks = strsplit(atk,'\\');
    rangedAttacks = strsplit(beasts.RNG{i},'\\');
    
    abilities = beasts.Abilities{i};
    weakness = beasts.Weaknesses{i};
    immun = beasts.Immunities{i};
    
    abilityBlock = ['{ {' abilities '}{' weakness '}{' immun '} }'];
    
    combatBlock = ['{ {',hp, '}{', amr, '} }'];
    
    mode = '{0}';
    
    beastEntry = ['\beast' headerBlock textBlock statBlock physicalBlock combatBlock attackBlock abilityBlock mode ];
    
    text = [text beastEntry];
    
    if mod(i,2)==1
        text = [text '\vspace{-2 cm}  & ~ & '];
    else
        text = [text ' \vspace{-2 cm} \\ ' ];
    end
end

fullText = [firstHalf, text, '\end{longtable}', secondHalf];

FID = fopen(fileName,'w');
fwrite(FID, fullText);
