%Ceci est le script principal dans lequel est effectu�e la simulation

clear all; close all;

%Initialisation des constantes:

epsMur = 5; %Permitivit� relative des murs (en b�ton)
sigmaMur = 0.014; %Conductivit� des murs (en b�ton)
L = 50; %Longueur caract�ristique du plan(m)
e = 0.4; %Epaisseur mur (m)
c = 299792458; %Vitesse de la lumi�re dans le vide (m/s)
f = 2.45*10^9; %Fr�quence des communications (Hertz) 
lambda = c/f; %Longueur d'onde rayonn�e (m)
Pem = 0.1; %La puissance rayonn�e par l'�metteur est de 0,1W (20 dBm)



%Construction des objets murs de l'environement

wall1 = Wall(0,0,0,L,epsMur, sigmaMur,e); 
wall2 = Wall(0,0,L,0,epsMur, sigmaMur,e); 
wall3 = Wall(L,0,L,L,epsMur, sigmaMur,e); 
wall4 = Wall(0,L,L,L,epsMur, sigmaMur,e); 
wall5 = Wall(0,L/2,L,L/2,epsMur, sigmaMur,e);
wall6 = Wall(2*L/3,0,2*L/3,5*L/6,epsMur, sigmaMur,e);

%Cr�ation d'un liste contenant les murs: 
wallList = [wall1, wall2, wall3, wall4, wall5, wall6];

%Affichage des murs:

for i = 1:numel(wallList)
    wallList(i).plot();
end

%Création d'une liste de coins
 
corner1 = Corner(0,0,epsMur,sigmaMur);
corner2 = Corner(0,L/2,epsMur,sigmaMur);
corner3 = Corner(0,L,epsMur,sigmaMur);
corner4 = Corner(2*L/3,0,epsMur,sigmaMur);
corner5 = Corner(L,0,epsMur,sigmaMur);
corner6 = Corner(L,L/2,epsMur,sigmaMur);
corner7 = Corner(L,L,epsMur,sigmaMur);
corner8 = Corner(2*L/3,L/2,epsMur,sigmaMur);
corner9 = Corner(2*L/3,5*L/6,epsMur,sigmaMur);
 
cornerList = [corner1,corner2,corner3,corner4,corner5,corner6,corner7,corner8,corner9];

%Construction des objets antenne de l'environement

stationBase = Antenne(10,10,lambda);
recepteur = Antenne(20,20,lambda);
P = 0; %Puissance arrivant au r�cepteur
E = 0; %Champ arrivant au r�cepteur

%1) Calcul du rayon direct:

%Distance parcourue par le rayon direct:

%Point de d�part
 xd1  = stationBase.x; 
 yd1 = stationBase.y;
 
 
 %Point d'arriv�e
 xd2 = recepteur.x; 
 yd2 = recepteur.y;
 
 directRay = Rayon(2); %Construction de l'objet rayon (� 2 points)
 
 vectRay = [xd2-xd1 yd2-yd1]/sqrt((xd1-xd2)^2 + (yd1-yd2)^2);
 
 %Affichage du rayon:
 directRay.x1 = xd1;
 directRay.y1 = yd1;
 directRay.x2 =xd2;
 directRay.y2 = yd2;
 %directRay.plot();
 
 lineRay = [xd1 yd1; xd2 yd2]; %Segment associ� au rayon
 
%D�termination de l'att�nuation par les murs rencontr�s:

for i = 1:numel(wallList)
    walli = wallList(i);
    
    %Segment de droite associ� au mur:
    lineWall = walli.getLine(); 
    
    %Le rayon intersecte-t-il le mur?
 
    if (verifyIntersection(lineRay,lineWall)) %Si le mur est rencontr�, compatbiliser att�nuation:
        vectWall = walli.getNormVect(); %Vecteur normal au mur norm�
        thetai = acos(abs(dot(vectRay,vectWall))); %Angle d'incidence
        directRay.At = directRay.At * walli.getTransmission(thetai); %Att�nuation
    end 
        
end
theta = acos(abs(dot(vectRay,[0 1]))); %Angle relativement � l'antenne
G = stationBase.getGain(theta); %Gain dans la direction consid�r�e
E = E + directRay.getE(G); %Calcul du champ arrivant au r�cepteur;

%2) Calcul des r�flections simples:

for i = 1:(numel(wallList)) %Pour chaque mur:
    
   reflectedRayi = Rayon(3); %cr�ation du rayon reflett� mar le mur i
   reflectedRayi.x1 = xd1;
   reflectedRayi.y1 = yd1;
   reflectedRayi.x3 = xd2;
   reflectedRayi.y3 = yd2;
   
   
   %Calcul de l'intersection avec le mur par la normale au mur: 
   walli = wallList(i);
   wallVecti = walli.getNormVect();
   lineRay = [xd1 yd1; xd1+wallVecti(1) yd1+wallVecti(2)];
   lineWall = walli.getLine(); 
   intersectioni = getIntersection(lineRay, lineWall);
   
   %Coordonn�es Antenne miroire:
   xam = 2*intersectioni(1)-xd1;
   yam = 2*intersectioni(2)-yd1;
   plot( xam,yam, '*r'); hold on;
   
   %Point de r�flection th�orique:
    lineRay = [xam yam; xd2 yd2 ];
    intersectioni = getIntersection(lineWall,lineRay);
    
    %V�rification que le point de r�flection est sur le mur et si oui, calcul de l'attenuation par reception et transmission:
    if(verifyIntersection(lineRay,lineWall))
       reflectedRayi.x2 = intersectioni(1);
       reflectedRayi.y2 = intersectioni(2);
       
       % Coefficient de réflexion
       
       vectRay1 = [reflectedRayi.x2-xd1 reflectedRayi.y2-yd1]/sqrt((xd1-reflectedRayi.x2)^2 + (yd1-reflectedRayi.y2)^2);
       thetai = acos(abs(dot(vectRay1,wallVecti))); %Angle d'incidence
       reflectedRayi.At = reflectedRayi.At * walli.getReflexion(thetai);
       for j = 1:numel(wallList)
           wallj = wallList(j);
  
           %Segment de droite associï¿½ au mur:
           lineWall = wallj.getLine();
      
           %Segment de droite associé aux deux morceaux du rayon
           lineRay1 = [xd1 yd1; reflectedRayi.x2 reflectedRayi.y2];
           lineRay2 = [reflectedRayi.x2 reflectedRayi.y2; xd2 yd2];
      
           %Le rayon intersecte-t-il les murs?
 
           if (verifyIntersection(lineRay1,lineWall)) %Si le mur est rencontrï¿½, compatbiliser attï¿½nuation:
               vectWall = wallj.getNormVect(); %Vecteur normal au mur normï¿½
               vectRay1 = [reflectedRayi.x2-xd1 reflectedRayi.y2-yd1]/sqrt((xd1-reflectedRayi.x2)^2 + (yd1-reflectedRayi.y2)^2);
               thetai = acos(abs(dot(vectRay1,vectWall))); %Angle d'incidence
               reflectedRayi.At = reflectedRayi.At * wallj.getTransmission(thetai); %Attï¿½nuation
           end
           if (verifyIntersection(lineRay2,lineWall)) %Si le mur est rencontrï¿½, compatbiliser attï¿½nuation:
               vectWall = wallj.getNormVect(); %Vecteur normal au mur normï¿½
               vectRay2 = [xd2-reflectedRayi.x2 yd2-reflectedRayi.y2]/sqrt((reflectedRayi.x2-xd2)^2 + (reflectedRayi.y2-yd2)^2);
               thetai = acos(abs(dot(vectRay2,vectWall))); %Angle d'incidence
               reflectedRayi.At = reflectedRayi.At * wallj.getTransmission(thetai); %Attï¿½nuation
           end
       end
  
   else % Rayon pas valable car il n'intersecte pas le mur
       reflectedRayi.x2 = 1/0;
       reflectedRayi.y2 = 1/0;
       reflectedRayi.At = 0;
   end
  
  
   %Affichage rayon:
  %reflectedRayi.plot();
  vectRay1 = [reflectedRayi.x2-xd1 reflectedRayi.y2-yd1]/sqrt((xd1-reflectedRayi.x2)^2 + (yd1-reflectedRayi.y2)^2);
  theta = acos(abs(dot(vectRay1,[0 1]))); %Angle relativement Ã  l'antenne
  G = stationBase.getGain(theta); %Gain dans la direction considÃ©rÃ©e
  E = E + reflectedRayi.getE(G); %Calcul du champ arrivant au rÃ©cepteur
end

%3) Calcul des réflexions doubles
 
for i = 1:(numel(wallList)) %Pour chaque couple de mur:
      for j = 1:(numel(wallList)) 
         
          if(j ~= i)
                reflectedRayij = Rayon(4);
 
                reflectedRayij.x1 = xd1;
                reflectedRayij.y1 = yd1;
                reflectedRayij.x4 = xd2;
                reflectedRayij.y4 = yd2;
 
                walli = wallList(i);
                wallj = wallList(j);
                wallVecti = walli.getNormVect();
                wallVectj = wallj.getNormVect();
 
                lineRayi = [xd1 yd1; xd1+wallVecti(1) yd1+wallVecti(2)];
                lineRayj = [xd2 yd2; xd2+wallVectj(1) yd2+wallVectj(2)];
 
                lineWalli = walli.getLine();
                lineWallj = wallj.getLine();
 
                intersectioni = getIntersection(lineRayi, lineWalli);
                intersectionj = getIntersection(lineRayj, lineWallj);
 
                %Coordonnï¿½es des antennes miroires:
                xami = 2*intersectioni(1)-xd1;
                yami = 2*intersectioni(2)-yd1;
 
                xamj = 2*intersectionj(1)-xd2;
                yamj = 2*intersectionj(2)-yd2;
 
                plot( xami,yami, '*c'); hold on;
                plot( xamj,yamj, '*c'); hold on;
 
                %Points de rï¿½flection thï¿½orique:
                lineRay = [xami yami; xamj yamj ];
                intersectioni = getIntersection(lineWalli,lineRay);
                intersectionj = getIntersection(lineWallj,lineRay);
                
                %V�rification que ce point n'est pas associ� � un coin
                
                if (intersectioni(1) == intersectionj(1))
                    if (intersectioni(2) == intersectionj(2))
                        %Cas pathologique du coin:
                        noCorner = false;
                    else
                        noCorner = true;
                    end
                else
                    noCorner = true;
                end
 
                %Verification que les point de reflection sont sur le mur et ne correspondent pas � un coin:
                if(verifyIntersection(lineRay,lineWalli) && verifyIntersection(lineRay,lineWallj) && noCorner)
                    reflectedRayij.x2 = intersectioni(1);
                    reflectedRayij.y2 = intersectioni(2);
                    reflectedRayij.x3 = intersectionj(1);
                    reflectedRayij.y3 = intersectionj(2);
                   
                    % Calcul de l'atténuation due aux reflexions
                   
                    vectRay1 = [reflectedRayij.x2-xd1 reflectedRayij.y2-yd1]/sqrt((xd1-reflectedRayij.x2)^2 + (yd1-reflectedRayij.y2)^2);
                    thetai1 = acos(abs(dot(vectRay1,wallVecti))); %Angle d'incidence
                    reflectedRayij.At = reflectedRayij.At * walli.getReflexion(thetai1);
                   
                    vectRay2 = [reflectedRayij.x3-reflectedRayij.x2 reflectedRayij.y3-reflectedRayij.y2]/sqrt((reflectedRayij.x2-reflectedRayij.x3)^2 + (reflectedRayij.y2-reflectedRayij.y3)^2);
                    thetai2 = acos(abs(dot(vectRay2,wallVectj))); %Angle d'incidence
                    reflectedRayij.At = reflectedRayij.At * wallj.getReflexion(thetai2);
                   
                    vectRay3 = [xd2-reflectedRayij.x3 yd2-reflectedRayij.y3]/sqrt((reflectedRayij.x3-xd2)^2 + (reflectedRayij.y3-yd2)^2);
                    
                    % Calcul de l'atténuation due aux transmissions
                    for k = 1:numel(wallList)
                        wallk = wallList(k);
                         %Segment de droite associÃ¯Â¿Â½ au mur:
                         lineWall = wallk.getLine();
     
                         %Segments de droite associÃ© aux trois morceaux du rayon
                         lineRay1 = [xd1 yd1; reflectedRayij.x2 reflectedRayij.y2];
                         lineRay2 = [reflectedRayij.x2 reflectedRayij.y2; reflectedRayij.x3 reflectedRayij.y3];
                         lineRay3 = [reflectedRayij.x3 reflectedRayij.y3; xd2 yd2];
                            %Le rayon intersecte-t-il les murs?
 
                         if (verifyIntersection(lineRay1,lineWall)) %Si le mur est rencontrÃ¯Â¿Â½, compatbiliser attÃ¯Â¿Â½nuation:
                            vectWall = wallk.getNormVect(); %Vecteur normal au mur normÃ¯Â¿
                            thetai = acos(abs(dot(vectRay1,vectWall))); %Angle d'incidence
                            reflectedRayij.At = reflectedRayij.At * wallk.getTransmission(thetai); %AttÃ¯Â¿Â½nuation
                         end
                         if (verifyIntersection(lineRay2,lineWall)) %Si le mur est rencontrÃ¯Â¿Â½, compatbiliser attÃ¯Â¿Â½nuation:
                            vectWall = wallk.getNormVect(); %Vecteur normal au mur normÃ¯Â¿Â
                            thetai = acos(abs(dot(vectRay2,vectWall))); %Angle d'incidence
                            reflectedRayij.At = reflectedRayij.At * wallk.getTransmission(thetai); %AttÃ¯Â¿Â½nuation
                         end
                         if (verifyIntersection(lineRay3,lineWall)) %Si le mur est rencontrÃ¯Â¿Â½, compatbiliser attÃ¯Â¿Â½nuation:
                            vectWall = wallk.getNormVect(); %Vecteur normal au mur normÃ¯Â¿Â
                            thetai = acos(abs(dot(vectRay3,vectWall))); %Angle d'incidence
                            reflectedRayij.At = reflectedRayij.At * wallk.getTransmission(thetai); %AttÃ¯Â¿Â½nuation
                         end
                    end
                   
                   
                else
                    reflectedRayij.x2 = 1/0;
                    reflectedRayij.y2 = 1/0;
                    reflectedRayij.x3 = 1/0;
                    reflectedRayij.y3 = 1/0;
                    reflectedRayij.At = 0;
                end
 
 
                   %Affichage rayon:
                   reflectedRayij.plot();
                   vectRay1 = [reflectedRayij.x2-xd1 reflectedRayij.y2-yd1]/sqrt((xd1-reflectedRayij.x2)^2 + (yd1-reflectedRayij.y2)^2);
                   theta = acos(abs(dot(vectRay1,[0 1]))); %Angle relativement Ãƒ  l'antenne
                   G = stationBase.getGain(theta); %Gain dans la direction considÃƒÂ©rÃƒÂ©e
                   E = E + reflectedRayij.getE(G); %Calcul du champ arrivant au rÃƒÂ©cepteur
          end
      end
end

%4) Calcul de la diffraction
 
for i = 1:(numel(cornerList))
   corneri = cornerList(i);
  
   diffractedRayi = Rayon(3);
   diffractedRayi.x1 = xd1;
   diffractedRayi.y1 = yd1;
   diffractedRayi.x3 = xd2;
   diffractedRayi.y3 = yd2;
  
   nodiffraction = false;
   for j = 1:numel(wallList)
           wallj = wallList(j);
           %Segment de droite associÃ¯Â¿Â½ au mur:
           lineWall = wallj.getLine();
     
           %Segment de droite associÃ© aux deux morceaux du rayon
           lineRay1 = [xd1 yd1; corneri.x1 corneri.y1];
           lineRay2 = [corneri.x1 corneri.y1; xd2 yd2];
     
           %Le rayon intersecte-t-il les murs? Si oui on ne doit pas en
           %tenir compte car la diffraction est trop forte
          
           intersectioni = getIntersection(lineRay1,lineWall);
           intersectionj = getIntersection(lineRay2,lineWall);
          
           if (verifyIntersection(lineRay1,lineWall)) %Si le mur est rencontrÃ¯Â¿Â½, compatbiliser attÃ¯Â¿Â½nuation:
               if ( intersectioni(1) == corneri.x1)
                   if ( intersectioni(2) == corneri.y1)
                        nodiffraction = false;
                   else
                       nodiffraction = true;
                       break;
                   end
               else
                    nodiffraction = true;
                    break;
               end
           end
           if (verifyIntersection(lineRay2,lineWall)) %Si le mur est rencontrÃ¯Â¿Â½, compatbiliser attÃ¯Â¿Â½nuation:
               if ( intersectionj(1) == corneri.x1)
                   if ( intersectionj(2) == corneri.y1)
                        nodiffraction = false;
                   else
                       nodiffraction = true;
                       break;
                   end
               else
                    nodiffraction = true;
                    break;
               end
           end
   end
  
   if (nodiffraction)
       diffractedRayi.x2 = 1/0;
       diffractedRayi.y2 = 1/0;
       diffractedRayi.At = 0;
   else
       diffractedRayi.x2 = corneri.x1;
       diffractedRayi.y2 = corneri.y1;
      
       %thetai = 0;
       %diffractedRayi.At = diffractedRayi.At * corneri.getDiffraction(thetai);
      
       vectRay1 = [diffractedRayi.x2-xd1 diffractedRayi.y2-yd1]/sqrt((xd1-diffractedRayi.x2)^2 + (yd1-diffractedRayi.y2)^2);
       theta = acos(abs(dot(vectRay1,[0 1]))); %Angle relativement ï¿½ l'antenne
       G = stationBase.getGain(theta); %Gain dans la direction considï¿½rï¿½e
       E = E + diffractedRayi.getE(G); %Calcul du champ arrivant au rï¿½cepteur;
       %diffractedRayi.plot();
   end   
     
end

%Affichage des antennes:

stationBase.plot();
recepteur.plot();





