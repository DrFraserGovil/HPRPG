Ns = 1:14;
DVs = 3:1:11;
cats = 2:3;

M = [];
i = 0;
t = "";

for DV = DVs
    t = t + "\\subsection{Difficulty = " + num2str(DV) + "}\n";
    cat = floor(DV/2);
   % for cat = cats
   %     t = t+  "\\subsubsection{Catastrophe Range = 1-" + num2str(cat) + "}\n";
        
        t = t + "\\probTable{\n";
        for N = Ns
            i = i + 1;
            j = 0;
            t = t + "\\probRow";
            vector = success(N,DV);
            
            pFail = vector(1) + vector(2);
           
            pSuccess = 1 - pFail;
            mean = sum([-1:N].*vector);
            q = -1;
            t = t + "{";
            for w = -1:7
                if w > N
                    t = t + "{-}";
                else
                    j = j + 1;
                    
                    if w < 7
                        value = vector(j);
                        
                    else
                        
                        value = 0;
                        for k = 9:length(vector)
                            value = value + vector(k);
                        end

                    end
                    
                   
                    q = q + 1;
                    if value > 1e-3
                        text = num2str( round(value*100,2,'Significant'));
                    else
                        text = "$<$0.1";
                    end
                    t = t + "{" + text + "}";
                end
            end
            t = t + "}";
            t = t + "{" + num2str( round(pFail*100,2,'Significant')) + "}";
            t = t + "{" + num2str( round(pSuccess*100,2,'Significant')) + "}";
            
            if mean > 0
                t = t + "{" + num2str( round(mean,2,'Significant')) + "}";
            else
                t = t + "{Catastrophe}";
            end
            t = t + "\n";
        end
        t = t + "} \n\n";
    %end
end
fprintf(t)