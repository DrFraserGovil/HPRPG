function assembleShops(fileNameRoot)
   
    %if no target given, assume that called directly, else assume called by
    %master
   
    if nargin < 1
        disp('Insufficient inputs provided');
        addpath('../../CoreRulebook/Data/Functions/');
        fileNameRoot = '';
		originRoot = '';
	end
  
	texFiles = dir(originRoot + "*.tex");
    for i = 1:length(texFiles)
        targetName = texFiles(i).name;
        originName = targetName(1:end-4) + ".xlsx";

		f = readtable(originName);
		f = sortrows(f);
		h = height(f);

		text = "";
		for i = 1:h
			b = Shop(f(i,:));

		   text = text + b.print() + "\n\n";
		end




		readFile = fileread(targetName);
		insertPoint = strfind(readFile, '%%ShopBegin');
		endPoint = strfind(readFile, '%%ShopEnd');
		firstHalf = prepareText(readFile(1:insertPoint+11),0,0);

		secondHalf = prepareText(readFile(endPoint:end),0,0);

		fullText = firstHalf + text  + "\n"+ secondHalf;

		FID = fopen(targetName,'w');
		fprintf(FID, fullText);
		fclose(FID);
	end
end