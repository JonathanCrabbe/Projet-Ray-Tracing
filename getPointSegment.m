function [ doIntersect] = getPointSegment( xpoint,ypoint, line )
      % Ce script verifie qu'un point (xpoint,ypoint) est sur un segment
      % line
     doIntersect = false;
    
     m = (line(2,2) - line(1,2))/(line(2,1) - line(1,1)); %Pente de la droite
     p = line(2,2) - m * line(2,1); %Translation verticale de la droite relativement à l'origine
     yinter = m*xpoint+p; %Ordonnee theorique du point sur la droite
   
     %Vérifie si l'absisce est dans l'intervalle considere
     isXPointInside = @(xint,myline) ...
    (xint >= myline(1,1) && xint <= myline(2,1)) || ...
    (xint >= myline(2,1) && xint <= myline(1,1));

     %Vérifie si l'odonnée est dans l'intervalle considere
     isYPointInside = @(yint,myline) ...
    (yint >= myline(1,2) && yint <= myline(2,2)) || ...
    (yint >= myline(2,2) && yint <= myline(1,2));

    if(line(2,1) == line(1,1)) %Droite  verticale
         
         doIntersect = xpoint == line(1,1) && ... %Abscisce dans la droite 
         isYPointInside(ypoint,line) ; %Ordonnee dans la droite 

    elseif(line(2,2) == line(1,2)) %Droite horizontale
        
         doIntersect = isXPointInside(xpoint,line) && ... %Abscisce dans la droite 
          ypoint == line(1,2); %Ordonnee dans la droite 
   
    
    else
         doIntersect = isPointInside(xintersect,line) && ... %Le point est sur le segment
         yinter == ypoint; %Les ordonnes coinincident
    end

    
     end