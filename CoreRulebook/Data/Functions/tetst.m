xs = [6,8,10,12,20];
ns = [1, 1,1,1, 1];

advs = [0,0,0,0,0];

profs = 0*[1,3,4,5,6];
stats=0*[1,2,3,4,5];

bons = profs+stats;

dvs = [5,8,12,15,20];
mat=zeros(5,5);
for i = 1:length(xs)
    n = ns(i);
    x = xs(i);
    r = num2str(n) + "d" + num2str(x) + ": \t";
   
    N = 1000000;
    
    array = ones(1,N)*bons(i);
    
    for j = 1:n
        R = randi([1,x],1,N);
		
		for k = 1:advs(i)
			R2 = randi([1,x],1,N);
			
			bigger = (R2 > R);
			R = R + bigger.*(R2 - R);
		end
		array = array + R;
    end
   

    for j = 1:i
        q= sum(array>=dvs(j));
    
        r = r + num2str(round(q/N,2)) + "\t\t";
        mat(i,j) = round(q/N,2);
    end
    
    
    
    
end
disp(mat)