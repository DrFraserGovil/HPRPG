f = readtable("ModellingHP.xlsx");
fTitles = string(transpose(f{:,1}));
N = 30000;
L = 20;
h = height(f);
MAX = 430;
HP = zeros(h,L,MAX);
FP = zeros(h,L,MAX);
base = [1:MAX];
for i = 1:h
   nHP = f.nHPLevel(i);
   xHP = f.xHPLevel(i);
   aHP = f.hpAdv(i);
   
   nFP = f.nFPLevel(i);
   xFP = f.xFPLevel(i);
   aFP = f.fpAdv(i);
   for j = 1:N
       hp = [f.HPStart(i)  generate(nHP,xHP,aHP,L-1)];
       fp = [f.FPStart(i)  generate(nFP, xHP,aFP,L-1)];
       
       for k = 1:L
           H = sum(hp(1:k)) + k -1;
           F = sum(fp(1:k)) + k - 1;
           
           HP(i,k,H) = HP(i,k,H) + 1;
           
           FP(i,k,F) = FP(i,k,F) + 1;
           
       end
       
   end
end

ell = 5;
colormap(flipud(gray))
%subplot(1,2,1);
cla;
produceImage(HP,ell,fTitles,N);
colorbar
% subplot(1,2,2);
% cla;
% caxis([10e-2,10e-1])
% produceImage(FP,ell,fTitles);

function produceImage(grid,level,titles,N)
   interest = squeeze(grid(:,level,:));
   [~,m] = size(interest);
   while any(interest(:,m)) == 0
       m = m - 1;
   end
   interest = interest(:,1:m)/N;
    im = image(interest);
    im.CDataMapping = 'scaled';
  set(gca,'ytick',[1:length(titles)],'yticklabels',titles);
   
end

function R = generate(n,x,adv,L)
    R = zeros(1,L);
    for i = 1:n
       R = R + randi(x,1,L); 
    end

    for q = 1:abs(adv)
        sgn = abs(adv)/adv;
        R2 = zeros(1,L);
        for i = 1:n
           R2 = R2 + randi(x,1,L); 
        end 
        q = (sgn+1)/2;
        diff = (R2 > R);
        
        P = (1-q) + diff*(1 + 2*(q - 1));
        R = R + P.*(R2 - R);
    end
end