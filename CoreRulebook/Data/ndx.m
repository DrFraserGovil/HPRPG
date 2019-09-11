function  ndx(dieCompact,advFlag)

    die = [];
    for i = 1:length(dieCompact)
        dx = dieCompact{i}(1);
        nd = dieCompact{i}(2);
        for j = 1:nd
            die(end+1) = dx;
        end
    end

    n = length(die);
    
    Nsim = 100000;
    range = n:sum(die);
    bins = zeros(1,length(range));
    X = [];
    for i = 1:Nsim
       t = 0;
       k = 0;
       while k <= abs(advFlag)
            test = 0;
            
            for j = 1:n
                x = die(j);
                test = test + randi(x);
            end
            
            if t == 0
                t = test;
            else
                if sign(advFlag) > 0
                    if test > t
                        t = test;
                    end
                else
                    if test < t
                        t = test;
                    end
                end
            end
            k = k + 1;            
            
       end
  
      X(end+1) = t;
    end
    Mean = mean(X)
    Median = median(X)
    sigma = std(X)
    histogram(X,'Normalization','probability');
    
end

