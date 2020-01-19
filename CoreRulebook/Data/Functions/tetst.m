xs = [6,10,6, 8,20];
ns = [1, 1,2,2, 1];

profs = [2,3,4,5,6];
stats=[1,2,3,4,5];

bons = profs+stats;

dvs = [5,10,15,20,25];
mat=zeros(5,5);
for i = 1:length(xs)
    n = ns(i);
    x = xs(i);
    r = num2str(n) + "d" + num2str(x) + ": \t";
   
    N = 1000000;
    
    array = ones(1,N)*bons(i);
    
    for j = 1:n
        array = array + randi([1,x],1,N);
    end
   

    for j = 1:i
        q= sum(array>=dvs(j));
    
        r = r + num2str(round(q/N,2)) + "\t\t";
        mat(i,j) = round(q/N,2);
    end
    
    
    
    
end
disp(mat)