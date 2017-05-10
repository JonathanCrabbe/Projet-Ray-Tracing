%Ceci est le script principal dans lequel est effectuee la simulation
 
clear all; close all;
 
%Initialisation des constantes:
 
epsMur = 5; %Permitivite relative des murs (en beton)
sigmaMur = 0.014; %Conductivite des murs (en beton)
L = 50; %Longueur caracteristique du plan(m)
e = 0.3; %Epaisseur mur (m)
c = 299792458; %Vitesse de la lumiere dans le vide (m/s)
f = 2.45*10^9; %Frequence des communications (Hertz)
lambda = c/f; %Longueur d'onde rayonnee (m)
Pem = 0.1; %La puissance rayonnee par l'emetteur est de 0,1W (20 dBm)
 
 
 
%Construction des objets murs de l'environement
 
wall1 = Wall(0,0,0,10.93,epsMur, sigmaMur,0.2);
wall2 = Wall(0,0,7,0,epsMur, sigmaMur,0.29);
wall3 = Wall(7,0,7,10.93,epsMur, sigmaMur,0.2);
wall4 = Wall(0,10.93,7,10.93,epsMur, sigmaMur,0.5);
wall5 = Wall(0,8.36,2.5,8.36,epsMur, sigmaMur,0.1);
wall6 = Wall(2.5,8.76,2.5,7.29,epsMur, sigmaMur,0.18);
wall7 = Wall(0,6.16,3.32,6.16,epsMur, sigmaMur,0.1);
wall8 = Wall(0,3.56,1,3.56,epsMur, sigmaMur,0.33);
wall9 = Wall(3.32,3.56,3.32,4.36,epsMur, sigmaMur,0.3);
wall10 = Wall(3.32,5.06,3.32,6.16,epsMur, sigmaMur,0.3);
wall11 = Wall(6.72,6.75,6.72,7.75,epsMur, sigmaMur,0.28);
wall12 = Wall(6.55,3.56,7,3.56,epsMur, sigmaMur,0.33);
wall13 = Wall(3.32,3.56,3.82,3.56,epsMur, sigmaMur,0.34);
wall14 = Wall(1,1.2,1,3.56,epsMur, sigmaMur,0.18);
 
%Creation d'une liste contenant les murs:
wallList = [wall1, wall2, wall3, wall4, wall5, wall6, wall7, wall8, wall9, wall10, wall11, wall12, wall13, wall14];
 
%Affichage des murs:
 
for i = 1:numel(wallList)
    wallList(i).plot();
end
 
%Creation d'une liste de coins
 
corner1 = Corner(0,0,epsMur,sigmaMur,2);
corner2 = Corner(0,10.93,epsMur,sigmaMur,2);
corner3 = Corner(7,10.93,epsMur,sigmaMur,2);
corner4 = Corner(7,0,epsMur,sigmaMur,2);
corner5 = Corner(0,8.36,epsMur,sigmaMur,2);
corner6 = Corner(2.5,8.76,epsMur,sigmaMur,1);
corner7 = Corner(2.5,7.29,epsMur,sigmaMur,1);
corner8 = Corner(2.5,8.36,epsMur,sigmaMur,2);
corner9 = Corner(0,6.16,epsMur,sigmaMur,2);
corner10 = Corner(6.72,6.75,epsMur,sigmaMur,1);
corner11 = Corner(6.72,7.75,epsMur,sigmaMur,1);
corner12 = Corner(6.55,3.56,epsMur,sigmaMur,1);
corner13 = Corner(7,3.56,epsMur,sigmaMur,2);
corner14= Corner(3.32,5.06,epsMur,sigmaMur,1);
corner15 = Corner(3.32,3.56,epsMur,sigmaMur,2);
corner16 = Corner(3.32,4.36,epsMur,sigmaMur,1);
corner17 = Corner(3.32,6.16,epsMur,sigmaMur,2);
corner18 = Corner(1,1.2,epsMur,sigmaMur,1);
corner19 = Corner(1,3.56,epsMur,sigmaMur,2);
corner20 = Corner(0,3.56,epsMur,sigmaMur,2);
corner21 = Corner(3.82,3.56,epsMur,sigmaMur,1);
 
cornerList = [corner1,corner2,corner3,corner4,corner5,corner6,corner7,corner8,corner9,corner10,corner11,corner12,corner13,corner14,corner15,corner16,corner17,corner18,corner19,corner20,corner21];
 
for i = 1:numel(cornerList)
    %cornerList(i).plot();
end
%Construction des objets antenne de l'environement
 
stationBase = Antenne(2,8.66,lambda);
recepteur = Antenne(5,2.5,lambda);
E = 0; %Champ arrivant au recepteur
        PRX = 0; %Puissance arrivant au recepteur
       
 
        %1) Calcul du rayon direct:
 
        %Distance parcourue par le rayon direct:
 
        %Point de depart
         xd1  = stationBase.x;
         yd1 = stationBase.y;
 
 
         %Point d'arrivee
         xd2 = recepteur.x;
         yd2 = recepteur.y;
 
         directRay = Rayon(2); %Construction de l'objet rayon (a 2 points)
 
         vectRay = [xd2-xd1 yd2-yd1]/sqrt((xd1-xd2)^2 + (yd1-yd2)^2);
 
         %Affichage du rayon:
         directRay.x1 = xd1;
         directRay.y1 = yd1;
         directRay.x2 =xd2;
         directRay.y2 = yd2;
         %directRay.plot();
 
         lineRay = [xd1 yd1; xd2 yd2]; %Segment associe au rayon
 
        %Determination de l'attenuation par les murs rencontres:
 
        for i = 1:numel(wallList)
            walli = wallList(i);
 
            %Segment de droite associe au mur:
            lineWall = walli.getLine();
 
            %Le rayon intersecte-t-il le mur?
 
            if (verifyIntersection(lineRay,lineWall)) %Si le mur est rencontre, compatbiliser attenuation:
                vectWall = walli.getNormVect(); %Vecteur normal au mur norme
                thetai = acos(abs(dot(vectRay,vectWall))); %Angle d'incidence
                directRay.At = directRay.At * walli.getTransmission(thetai); %Attenuation
            end
 
        end
        theta = acos(abs(dot(vectRay,[0 1]))); %Angle relativement a l'antenne ï¿½mï¿½trice
        G = stationBase.getGain(theta); %Gain dans la direction consideree
        E = directRay.getE(G); %Calcul du champ arrivant au recepteur;
        thetam = acos(abs(dot(directRay.getLastVect,[0 1]))); %Angle d'arrivï¿½e ï¿½ l'antenne
        he = recepteur.getHauteur(thetam); %Hauteur ï¿½quivalente de l'antenne
        PRX = PRX + ((abs(he*E))^2)/(8*recepteur.Ra);%Puissance moyenne reï¿½ue
 
        %2) Calcul des reflexions simples:
 
        for i = 1:(numel(wallList)) %Pour chaque mur:
 
           reflectedRayi = Rayon(3); %creation du rayon reflette mar le mur i
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
 
           %Coordonnees Antenne miroire:
           xam = 2*intersectioni(1)-xd1;
           yam = 2*intersectioni(2)-yd1;
           %plot( xam,yam, '*r'); hold on;
 
           %Point de reflexion theorique:
            lineRay = [xam yam; xd2 yd2 ];
            intersectioni = getIntersection(lineWall,lineRay);
 
            %Verification que le point de reflection est sur le mur et si oui, calcul de l'attenuation par reception et transmission:
            if(verifyIntersection(lineRay,lineWall))
               reflectedRayi.x2 = intersectioni(1);
               reflectedRayi.y2 = intersectioni(2);
 
               % Coefficient de reflexion
 
               vectRay1 = [reflectedRayi.x2-xd1 reflectedRayi.y2-yd1]/sqrt((xd1-reflectedRayi.x2)^2 + (yd1-reflectedRayi.y2)^2);
               thetai = acos(abs(dot(vectRay1,wallVecti))); %Angle d'incidence
               reflectedRayi.At = reflectedRayi.At * walli.getReflexion(thetai);
               for j = 1:numel(wallList)
                   wallj = wallList(j);
 
                   %Segment de droite associe au mur:
                   lineWall = wallj.getLine();
 
                   %Segment de droite associe aux deux morceaux du rayon
                   lineRay1 = [xd1 yd1; reflectedRayi.x2 reflectedRayi.y2];
                   lineRay2 = [reflectedRayi.x2 reflectedRayi.y2; xd2 yd2];
 
                   %Le rayon intersecte-t-il les murs?
                    if (verifyIntersection(lineRay1,lineWall)) %Si le mur est rencontre, compatbiliser attenuation:
                        intersection = getIntersection(lineRay1,lineWall);
                        if (intersection(1) == reflectedRayi.x2)
                            if (intersection(2) ~= reflectedRayi.y2)    
                                vectWall = wallj.getNormVect(); %Vecteur normal au mur norme
                                vectRay1 = [reflectedRayi.x2-xd1 reflectedRayi.y2-yd1]/sqrt((xd1-reflectedRayi.x2)^2 + (yd1-reflectedRayi.y2)^2);
                                thetai = acos(abs(dot(vectRay1,vectWall))); %Angle d'incidence
                                reflectedRayi.At = reflectedRayi.At * wallj.getTransmission(thetai); %Attenuation
                            end
                        else
                            vectWall = wallj.getNormVect(); %Vecteur normal au mur norme
                            vectRay1 = [reflectedRayi.x2-xd1 reflectedRayi.y2-yd1]/sqrt((xd1-reflectedRayi.x2)^2 + (yd1-reflectedRayi.y2)^2);
                            thetai = acos(abs(dot(vectRay1,vectWall))); %Angle d'incidence
                            reflectedRayi.At = reflectedRayi.At * wallj.getTransmission(thetai); %Attenuation
                        end
                    end
                    if (verifyIntersection(lineRay2,lineWall)) %Si le mur est rencontre, compatbiliser attenuation:
                        intersection = getIntersection(lineRay2,lineWall);
                        if (intersection(1) == reflectedRayi.x2)
                            if (intersection(2) ~= reflectedRayi.y2)
                                vectWall = wallj.getNormVect(); %Vecteur normal au mur norme
                                vectRay2 = [xd2-reflectedRayi.x2 yd2-reflectedRayi.y2]/sqrt((reflectedRayi.x2-xd2)^2 + (reflectedRayi.y2-yd2)^2);
                                thetai = acos(abs(dot(vectRay2,vectWall))); %Angle d'incidence
                                reflectedRayi.At = reflectedRayi.At * wallj.getTransmission(thetai); %Attenuation
                            end
                        else
                            vectWall = wallj.getNormVect(); %Vecteur normal au mur norme
                            vectRay2 = [xd2-reflectedRayi.x2 yd2-reflectedRayi.y2]/sqrt((reflectedRayi.x2-xd2)^2 + (reflectedRayi.y2-yd2)^2);
                            thetai = acos(abs(dot(vectRay2,vectWall))); %Angle d'incidence
                            reflectedRayi.At = reflectedRayi.At * wallj.getTransmission(thetai); %Attenuation
                        end
                    end
               end
          %Pour un rayon valable, on ajoute la puissance au recepteur:    
          vectRay1 = [reflectedRayi.x2-xd1 reflectedRayi.y2-yd1]/sqrt((xd1-reflectedRayi.x2)^2 + (yd1-reflectedRayi.y2)^2);
          theta = acos(abs(dot(vectRay1,[0 1]))); %Angle relativement a l'antenne
          G = stationBase.getGain(theta); %Gain dans la direction consideree
          E =  reflectedRayi.getE(G); %Calcul du champ arrivant au recepteur
          thetam = acos(abs(dot(reflectedRayi.getLastVect,[0 1]))); %Angle d'arrivï¿½e ï¿½ l'antenne
          he = recepteur.getHauteur(thetam); %Hauteur ï¿½quivalente de l'antenne
          PRX = PRX + ((abs(he*E))^2)/(8*recepteur.Ra); %Puissance moyenne reï¿½ue
         
          else % Rayon pas valable car il n'intersecte pas le mur
               reflectedRayi.x2 = 1/0;
               reflectedRayi.y2 = 1/0;
               reflectedRayi.At = 0;
           end
 
 
           %Affichage rayon:
          
          %reflectedRayi.plot();
         
        end
 
        %3) Calcul des reflexions doubles
 
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
 
                        %Coordonnees des antennes miroires:
                        xami = 2*intersectioni(1)-xd1;
                        yami = 2*intersectioni(2)-yd1;
 
                        xamj = 2*intersectionj(1)-xd2;
                        yamj = 2*intersectionj(2)-yd2;
 
                        %plot( xami,yami, '*c'); hold on;
                        %plot( xamj,yamj, '*c'); hold on;
 
                        %Points de reflexion theorique:
                        lineRay = [xami yami; xamj yamj ];
                        intersectioni = getIntersection(lineWalli,lineRay);
                        intersectionj = getIntersection(lineWallj,lineRay);
 
                        %Verification que ce point n'est pas associe a un coin
 
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
 
                        %Verification que les point de reflection sont sur le mur et ne correspondent pas a un coin:
                        if(verifyIntersection(lineRay,lineWalli) && verifyIntersection(lineRay,lineWallj) && noCorner)
                            reflectedRayij.x2 = intersectioni(1);
                            reflectedRayij.y2 = intersectioni(2);
                            reflectedRayij.x3 = intersectionj(1);
                            reflectedRayij.y3 = intersectionj(2);
 
                            % Calcul de l'attenuation due aux reflexions
 
                            vectRay1 = [reflectedRayij.x2-xd1 reflectedRayij.y2-yd1]/sqrt((xd1-reflectedRayij.x2)^2 + (yd1-reflectedRayij.y2)^2);
                            thetai1 = acos(abs(dot(vectRay1,wallVecti))); %Angle d'incidence
                            reflectedRayij.At = reflectedRayij.At * walli.getReflexion(thetai1);
 
                            vectRay2 = [reflectedRayij.x3-reflectedRayij.x2 reflectedRayij.y3-reflectedRayij.y2]/sqrt((reflectedRayij.x2-reflectedRayij.x3)^2 + (reflectedRayij.y2-reflectedRayij.y3)^2);
                            thetai2 = acos(abs(dot(vectRay2,wallVectj))); %Angle d'incidence
                            reflectedRayij.At = reflectedRayij.At * wallj.getReflexion(thetai2);
 
                            vectRay3 = [xd2-reflectedRayij.x3 yd2-reflectedRayij.y3]/sqrt((reflectedRayij.x3-xd2)^2 + (reflectedRayij.y3-yd2)^2);
 
                            % Calcul de l'attenuation due aux transmissions
                            for k = 1:numel(wallList)
                                wallk = wallList(k);
                                 %Segment de droite associe au mur:
                                 lineWall = wallk.getLine();
 
                                 %Segments de droite associes aux trois morceaux du rayon
                                 lineRay1 = [xd1 yd1; reflectedRayij.x2 reflectedRayij.y2];
                                 lineRay2 = [reflectedRayij.x2 reflectedRayij.y2; reflectedRayij.x3 reflectedRayij.y3];
                                 lineRay3 = [reflectedRayij.x3 reflectedRayij.y3; xd2 yd2];
                                    %Le rayon intersecte-t-il les murs?
 
                                 if (verifyIntersection(lineRay1,lineWall)) %Si le mur est rencontre, compatbiliser attenuation:
                                    intersection = getIntersection(lineRay1,lineWall);
                                    if (intersection(1) == reflectedRayij.x2)
                                        if (intersection(2) ~= reflectedRayij.y2)
                                            vectWall = wallk.getNormVect(); %Vecteur normal au mur norme
                                            thetai = acos(abs(dot(vectRay1,vectWall))); %Angle d'incidence
                                            reflectedRayij.At = reflectedRayij.At * wallk.getTransmission(thetai); %Attenuation
                                        end
                                    else
                                        vectWall = wallk.getNormVect(); %Vecteur normal au mur norme
                                        thetai = acos(abs(dot(vectRay1,vectWall))); %Angle d'incidence
                                        reflectedRayij.At = reflectedRayij.At * wallk.getTransmission(thetai); %Attenuation
                                    end
                                 end
                                if (verifyIntersection(lineRay2,lineWall)) %Si le mur est rencontre, compatbiliser attenuation:
                                    intersection = getIntersection(lineRay2,lineWall);
                                    if (intersection(1) ~= reflectedRayij.x2 || intersection(2) ~= reflectedRayij.y2)
                                        if (intersection(1) ~= reflectedRayij.x3 || intersection(2) ~= reflectedRayij.y3)
                                            vectWall = wallk.getNormVect(); %Vecteur normal au mur norme
                                            thetai = acos(abs(dot(vectRay2,vectWall))); %Angle d'incidence
                                            reflectedRayij.At = reflectedRayij.At * wallk.getTransmission(thetai); %Attenuation
                                        end
                                    end
                                end
                                if (verifyIntersection(lineRay3,lineWall))%Si le mur est rencontre, compatbiliser attenuation:
                                    intersection = getIntersection(lineRay3,lineWall);
                                    if (intersection(1) == reflectedRayij.x3)
                                        if (intersection(2) ~= reflectedRayij.y3)
                                            vectWall = wallk.getNormVect(); %Vecteur normal au mur norme
                                            thetai = acos(abs(dot(vectRay3,vectWall))); %Angle d'incidence
                                            reflectedRayij.At = reflectedRayij.At * wallk.getTransmission(thetai); %Attenuation
                                        end
                                    else
                                        vectWall = wallk.getNormVect(); %Vecteur normal au mur norme
                                        thetai = acos(abs(dot(vectRay3,vectWall))); %Angle d'incidence
                                        reflectedRayij.At = reflectedRayij.At * wallk.getTransmission(thetai); %Attenuation
                                    end
                                end
                            end
                           %Pour un rayon valable, on ajoute la
                           %contribution en puissance:
                           vectRay1 = [reflectedRayij.x2-xd1 ...
                               reflectedRayij.y2-yd1]/sqrt((xd1-reflectedRayij.x2)^2 + ...
                               (yd1-reflectedRayij.y2)^2);
                           theta = acos(abs(dot(vectRay1,[0 1]))); %Angle relativement a l'antenne
                           G = stationBase.getGain(theta); %Gain dans la direction consideree
                           E =  reflectedRayij.getE(G); %Calcul du champ arrivant au recepteur
                           thetam = acos(abs(dot(reflectedRayij.getLastVect,[0 1]))); %Angle d'arrivï¿½e ï¿½ l'antenne
                           he = recepteur.getHauteur(thetam); %Hauteur ï¿½quivalente de l'antenne
                           PRX = PRX + ((abs(he*E))^2)/(8*recepteur.Ra); %Puissance moyenne reï¿½ue
 
                        else
                            reflectedRayij.x2 = 1/0;
                            reflectedRayij.y2 = 1/0;
                            reflectedRayij.x3 = 1/0;
                            reflectedRayij.y3 = 1/0;
                            reflectedRayij.At = 0;
                        end
 
 
                           %Affichage rayon:
                          
                           %reflectedRayij.plot();
                          
                          
                  end
              end
        end
 
        %4) Calcul de la diffraction
 
        for i = 1:(numel(cornerList))
           corneri = cornerList(i);
           
           if (corneri.numWall == 1)
               for j = 1:numel(wallList)
                   wallj = wallList(j);
                   if (getPointSegment(corneri.x1, corneri.y1, wallj.x1, wallj.y1, wallj.x2, wallj.y2))
                       corneri.wall1 = wallj;
                       break;
                   end
               end
           end
          
           if (corneri.numWall == 2)
               numberWall = 0;
               for j = 1:numel(wallList)
                   wallj = wallList(j);
                   if (getPointSegment(corneri.x1, corneri.y1, wallj.x1, wallj.y1, wallj.x2, wallj.y2))
                       if (numberWall == 0)
                           corneri.wall1 = wallj;
                           numberWall = 1;
                       else
                           corneri.wall2 = wallj;
                           break;
                       end
                   end
               end
           end
           
           diffractedRayi = Rayon(3);
           diffractedRayi.x1 = xd1;
           diffractedRayi.y1 = yd1;
           diffractedRayi.x2 = corneri.x1;
           diffractedRayi.y2 = corneri.y1;
           diffractedRayi.x3 = xd2;
           diffractedRayi.y3 = yd2;
 
           for j = 1:numel(wallList)
                   wallj = wallList(j);
                   %Segment de droite associe au mur:
                   lineWall = wallj.getLine();
 
                   %Segment de droite associe aux deux morceaux du rayon
                   lineRay1 = [xd1 yd1; corneri.x1 corneri.y1];
                   lineRay2 = [corneri.x1 corneri.y1; xd2 yd2];
 
                   %Le rayon intersecte-t-il les murs? Si oui on doit
                   %calculer le coefficient de transmission
 
                   if (verifyIntersection(lineRay1,lineWall)) %Si le mur est rencontre, compatbiliser attenuation:
                        intersection = getIntersection(lineRay1,lineWall);
                        if (intersection(1) == diffractedRayi.x2)
                            if (intersection(2) ~= diffractedRayi.y2)    
                                vectWall = wallj.getNormVect(); %Vecteur normal au mur norme
                                vectRay1 = [diffractedRayi.x2-xd1 diffractedRayi.y2-yd1]/sqrt((xd1-diffractedRayi.x2)^2 + (yd1-diffractedRayi.y2)^2);
                                thetai = acos(abs(dot(vectRay1,vectWall))); %Angle d'incidence
                                diffractedRayi.At = diffractedRayi.At * wallj.getTransmission(thetai); %Attenuation
                            end
                        else
                            vectWall = wallj.getNormVect(); %Vecteur normal au mur norme
                            vectRay1 = [diffractedRayi.x2-xd1 diffractedRayi.y2-yd1]/sqrt((xd1-diffractedRayi.x2)^2 + (yd1-diffractedRayi.y2)^2);
                            thetai = acos(abs(dot(vectRay1,vectWall))); %Angle d'incidence
                            diffractedRayi.At = diffractedRayi.At * wallj.getTransmission(thetai); %Attenuation
                        end
                    end
                    if (verifyIntersection(lineRay2,lineWall)) %Si le mur est rencontre, compatbiliser attenuation:
                        intersection = getIntersection(lineRay2,lineWall);
                        if (intersection(1) == diffractedRayi.x2)
                            if (intersection(2) ~= diffractedRayi.y2)
                                vectWall = wallj.getNormVect(); %Vecteur normal au mur norme
                                vectRay2 = [xd2-diffractedRayi.x2 yd2-diffractedRayi.y2]/sqrt((diffractedRayi.x2-xd2)^2 + (diffractedRayi.y2-yd2)^2);
                                thetai = acos(abs(dot(vectRay2,vectWall))); %Angle d'incidence
                                diffractedRayi.At = diffractedRayi.At * wallj.getTransmission(thetai); %Attenuation
                            end
                        else
                            vectWall = wallj.getNormVect(); %Vecteur normal au mur norme
                            vectRay2 = [xd2-diffractedRayi.x2 yd2-diffractedRayi.y2]/sqrt((diffractedRayi.x2-xd2)^2 + (diffractedRayi.y2-yd2)^2);
                            thetai = acos(abs(dot(vectRay2,vectWall))); %Angle d'incidence
                            diffractedRayi.At = diffractedRayi.At * wallj.getTransmission(thetai); %Attenuation
                        end
                    end
           end
 
 
           %diffractedRayi.At = diffractedRayi.At * corneri.getDiffraction(xd1,yd1,xd2,yd2);
 
           vectRay1 = [diffractedRayi.x2-xd1 diffractedRayi.y2-yd1]/sqrt((xd1-diffractedRayi.x2)^2 + (yd1-diffractedRayi.y2)^2);
           theta = acos(abs(dot(vectRay1,[0 1]))); %Angle relativement a l'antenne
           G = stationBase.getGain(theta); %Gain dans la direction consideree
           E =  diffractedRayi.getE(G); %Calcul du champ arrivant au recepteur;
           thetam = acos(abs(dot(diffractedRayi.getLastVect,[0 1]))); %Angle d'arrivï¿½e ï¿½ l'antenne
           he = recepteur.getHauteur(thetam); %Hauteur ï¿½quivalente de l'antenne
           PRX = PRX + ((abs(he*E))^2)/(8*recepteur.Ra); %Puissance moyenne reï¿½ue
              
           diffractedRayi.plot();
 
        end
       
 
%Affichage des antennes:
 
stationBase.plot();
recepteur.plot();