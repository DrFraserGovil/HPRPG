function v = success(r,n,dv,cat,die)
        
    if nargin < 4
        cat = 1;
    end
    if nargin < 5
        die = 12;
    end

    if length(r) > 1
        for i = 1:length(r)
            v(i) = success(r(i),n,dv,cat,die);
        end
    else


        if r < 0
           % disp("Negative number detected: calculating catastrophe probability")
            v = 1;
            for j = 0:n
                v = v - success(j,n,dv,cat,die);
            end
        else


            X = die;
            p = (X + 1 - dv)/12;
            pCritFail = cat/(dv - 1);
            j = 0:n-r;


            successes = r + j;
            spareDice = n - r- j;
            requiredCrits = j;


            block1 = binopdf(successes,n,p);
            block2 = binopdf(requiredCrits,spareDice,pCritFail);

            v = sum(block1.*block2);
        end
    end
end