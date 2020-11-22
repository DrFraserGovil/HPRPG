heads = ["Innate", "Practical", "Knowledge"];


for i = 1:length(heads)
   
    for j = 1:6
        head = "\\def\\char" + heads(i) + num2roman(j)+ "{a" + num2str(j) + "}";
        val = "\\def\\char" + heads(i) + num2roman(j)+"Val{" + num2str(j) + "}";
       fprintf(head + "\n"); 
        fprintf(val + "\n"); 
    end
    
end

fprintf("\n\n");

J = " ";
for i = 1:length(heads)
   s = "{ ";
   
   for j = 1:6
        head = "\\char" + heads(i) + num2roman(j);
        val = "\\char" + heads(i) + num2roman(j) +"Val";
      s =  s + "{" + head +"}/{" + val + "}, ";
   end
   s = s + "}/{" + heads(i) + "},   "; 

   J = J + s;

end
fprintf(J)