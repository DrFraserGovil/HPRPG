Ns = 1:14;
DVs = 3:1:12;
cats = 2:3;
successes = -1:7;

M = [];
i = 0;
t = "";

for DV = DVs
    t = t + "\\subsection{Difficulty = " + num2str(DV) + "}\n";
    for cat = cats
        t = t+  "\\subsubsection{Catastrophe Range = 1-" + num2str(cat) + "}\n";
        
    t = t + "\\probTable{\n";
for N = Ns
    i = i + 1;
    j = 0;
    t = t + "\\probRow";
    for ns = successes
        if ns > N
            t = t + "{-}";
        else
        j = j + 1;
        
        if j < length(successes)
            value = success(ns,N,DV,cat);
        else
            value = 0;
            for np = ns:N
                value = value + success(np,N,DV,cat);
            end
        end
        if value > 1e-4
        text = num2str( round(value*100,2,'Significant'));
        else
            text = "$<$0.1";
        end
        t = t + "{" + text + "}"; 
        end
    end
    t = t + "\n";
end
t = t + "} \n\n";
    end
end
fprintf(t)