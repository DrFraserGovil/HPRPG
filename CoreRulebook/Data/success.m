function v = success(nDice,dv)
    catastrophe = max(1,floor(dv/3));
    NTries = 800000;
    rolls = randi([1,12],[NTries,nDice]);
    
    fails = sum(rolls <= catastrophe,2);
    successes = sum(rolls >= dv,2);
    miracles = sum(rolls == 12,2);

 
    modifiedFails = max(0,fails - miracles);
    
   
   
    net = successes - fails;
    

    catFails = (net < 0 & miracles == 0);
    net(~catFails & net < 0) = 0;
    
    
    distVector = zeros(1,nDice + 2);
    distVector(1) = sum(catFails);
    for i = 0:nDice
        distVector(i+2) = sum(net == i);
    end
    v = distVector/NTries;
end