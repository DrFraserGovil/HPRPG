function [galleon,sickle,totalKnut] = currency(gpb,judiciousRounding)

    if nargin < 2
        judiciousRounding = false;
    end

    totalKnut = ceil(gpb*493/50);
    
    galleon = floor(totalKnut/493);
    totalKnut = totalKnut - 493*galleon;
    
    sickle = floor(totalKnut/29);
    totalKnut = totalKnut - 29*sickle;

    
    if judiciousRounding == true
        if galleon > 0
            totalKnut = 0;
            sickle = round(sickle/5)*5;
        end
        if sickle > 0
            totalKnut = round(totalKnut/5)*5;
        end
    end
    disp({'G','S','K'});;
    disp([galleon,sickle,totalKnut])
end

