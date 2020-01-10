function nAttempts()
    N =10;
    grid = cell(150,N-1);
    ns = [];
    for l = [1:N-1]
        p =l/N;
        q = " p = " + num2str(p);
        low = 1;
        up = 0;
        n =1;
        doublecount = false;
        empty = false;
        s = "";
        while up < 100
            up = round((1- (1- p)^n)*100);
            r = "~";
            moveOn = false;

            if up > low
                r = num2str(low) + "-" +num2str(up);
                moveOn = true;
            end
            if up == low
                r = num2str(low);
                if strcmp(s,r)==false
                    moveOn = true;
                    s = r;
                end
            end

            if moveOn
                low = up + 1;
                if ~any(ns == n)
                    ns(end+1) = n;
                end
            end
            %disp(num2str(l) + ": " + r)
            grid{n,l} = r;
            n= n+1;
        end

    end
    
    grid;
    for n = ns

       r = "\\cellcolor{\\tablecolorhead} " + num2str(n);
      for l = [1:N-1]
        e = grid{n,l};
        r = r + "\t&\t";
        if ~isempty(e)
            r = r + e +  "\t";
        else
            r = r + "~ \t";
        end

            
      end
  
      q = sprintf(r+"\n\\\\\n");
      disp(q)
end