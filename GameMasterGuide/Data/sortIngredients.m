ings= readtable('ingredients.csv');
ings = sortrows(ings);

n = size(ings);

for i = 1:n
    id = ings.IngredientID(i);
    name = ings.Name{i}
    disp(name)
    cat = ings.Category(i);
    
    e1 = ings.Effect1{i};
    s1 = ings.Strength1(i);
    e2 = ings.Effect2{i};
    s2 = ings.Strength2(i);
    e3 = ings.Effect3{i};
    s3 = ings.Strength3(i);
    e4 = ings.Effect4{i};
    s4 = ings.Strength4(i);
    es = {e1, e2, e3, e4};
    ss = [s1 s2 s3 s4];
    
    trueEs = cell(1,sum(~isnan(ss)));
    trueSs = zeros(1,sum(~isnan(ss)));
    c = 1;
    for j = 1:length(es)
       if length(es{j}) > 1 && ~isnan(ss(j))
           trueEs{c} = es{j};
           trueSs(c) = ss(j);
           c = c+1;
       end
    end
    [sortedTrueEs,I] = sort(trueEs);
    sortedTrueSs = trueSs(I);
    
    N = length(trueEs);
    start = 4;
    fin = start + 2*N - 1;
    finfin = 10;
    q = 1;
    for j = start:2:fin
        ings.(j){i} = sortedTrueEs{q};
        ings.(j+1)(i) = sortedTrueSs(q);
        q = q + 1;
    end
    for k = j+2:2:finfin
         ings.(k){i} = '';
        ings.(k+1)(i) = NaN;
    end
end



writetable(ings,"ingredients.csv");