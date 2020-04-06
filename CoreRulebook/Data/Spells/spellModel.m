opts = detectImportOptions('AllSpells.xlsx','NumHeaderLines',2);
opts.VariableNamesRange = 'A1';
f = readtable("AllSpells.xlsx",opts,'ReadVariableNames',true);


damageDetected = (f.DoesDamage == 1);
f(~damageDetected,:) = [];
fTitles = string(transpose(f{:,1}));
dMax = 300;
N = 1000000;
h = height(f);
nLevels = 6;
damage = zeros(h,nLevels+1,dMax);

for i = 1:h

   ell = f.Level(i);
   for j = ell:nLevels
        eLevels = (j - ell);
        r = ones(1,N)*f.Base(i);
        for k = 1:f.nBase(i)
           r = r + randi(f.xBase(i),1,N); 
        end
        for k = 1:eLevels
            for m = 1:f.nPerLevel(i)
                r = r + randi(f.xPerLevel(i),1,N);
            end
        end
        for z = 1:N
           damage(i,j+1,r(z)+1) = damage(i,j+1,r(z)+1)+ 1; 
        end
   end
end

for i = 0:6
figure()
produceImage(damage,i,fTitles,N);
title(strcat("Level ", num2str(i)));
colorbar
end

function produceImage(grid,level,titles,N)
   interest = squeeze(grid(:,level+1,:));
   [p,m] = size(interest);
   while any(interest(:,m)) == 0
       m = m - 1;
   end
   keepers = [];
   erasers = [];
   for q = 1:p
       if ~any(interest(q,:) > 0)
          erasers(end+1) = q;
       else
           keepers(end+1) = q;
       end
   end
   interest = interest(keepers,1:m)/N;
   titles = titles(keepers);
    im = image([0:m-1],[1:length(titles)],interest);
    im.CDataMapping = 'scaled';
  set(gca,'ytick',[1:length(titles)],'yticklabels',titles);

end
