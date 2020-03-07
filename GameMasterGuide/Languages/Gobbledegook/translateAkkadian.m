function translateAkkadian(inputFile)
	
	f = readtable("akkadian.xlsx");
	nFamilies = [];
	families = string.empty;
	members = string.empty;
	
	
	h = height(f);
	for i = 1:h
		r = f.Family{i};
		if ~any(families == r)
			families(end+1) = r;
			nFamilies(end+1) = 0;
		end
		
		id = find(families == r);
		
		nFamilies(id) = nFamilies(id) + 1;
		members(id,nFamilies(id) ) = f.Latex{i};
		
	end
	
	
	g =  fileread(inputFile);
	
	replace = "";
	L = length(g);
	for i = 1:L
		
		t = g(i);
		
		if any(families == t)
			
			r = find(families == t);
			
			q = randi(nFamilies(r));
			
			t = "\\" + members(r,q) + "{}";
		end
		t
		replace = replace + t;
	end
	
	sprintf(replace)
end