function assembleFeats(fileRoot)

    %if no target given, assume that called directly, else assume called by
    %master

    if nargin < 1
        disp('Insufficient inputs provided');
        addpath('../Functions/');
        fileRoot = '../../';
    end
    fileNameRoot = strcat(fileRoot,'Chapters/Part1_Characters/');
    
    f = readtable("Feats.xlsx");
    f = sortrows(f,1);
    featList = Feat.empty;
    nFeat = [];
    ownerList = string.empty;
    for i = 1:height(f)
       feat = Feat();
       feat= feat.ReadIn(f(i,:));
       ownerFound = false;
       for j = 1:length(ownerList)
          if ownerList(j) == feat.Owner
              ownerFound = true;
              featList(j,nFeat(j)+1) = feat;
              nFeat(j) = nFeat(j) + 1;
          end
       end
       if (ownerFound == false)
          ownerList(end+1) = feat.Owner;
          featList(end+1,1) = feat;
          nFeat(end+1) = 1;
       end
    end
    
    r = "";
    for i = 1:length(ownerList)
       r = r + "\\def\\" + ownerList(i) + "Feats\n{\n";
       for j = 1:nFeat(i)
          r = r + "\t" + featList(i,j).print() + "\n"; 
       end
       r = r + "}\n\n";
    end
    
    targetName = fileNameRoot + "FeatList.tex";
    

    fullText = r;

    FID = fopen(targetName,'w');
    fprintf(FID, fullText);
    fclose(FID);
end