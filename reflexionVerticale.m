%Ceci est le script principal dans lequel est effectuee la simulation
%qui affiche la distribution de puissance

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
test = 0


%Construction des objets murs de l'environement(distances en m�tres)

wall1 = Wall(0,0,5000,0,epsMur, sigmaMur,0.2); 


%Creation d'une liste contenant les murs: 
wallList = [wall1];
%Affichage des murs:



%Creation d'une liste de coins
 


cornerList = [];

%Construction de la station de base

stationBase = Antenne(0,100,lambda);
powerDistribution = []; %Puissance recue en (X,Y)
speedDistribution = []; %Debit recu en (X,Y)

%Application de l'algorithme de Ray Tracing a differents recepteurs:

xi = 1; %Indice abscisce
yi = 1; %Indice ordonnee
for x = 4999.9:0.0001:5000
    for y = 99.9:0.0001:100 
        recepteur = Antenne(x,y,lambda);
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

         if(xd1 == xd2 && yd1 == yd2)
             vectRay = [0 0];
         else   
            vectRay = [xd2-xd1 yd2-yd1]/sqrt((xd1-xd2)^2 + (yd1-yd2)^2);
         end

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
        theta = acos(abs(dot(vectRay,[0 1])));
        G = stationBase.getGain(theta); %Gain dans la direction consideree
        E = directRay.getE(G); %Calcul du champ arrivant au recepteur
        thetam = acos(abs(dot(directRay.getLastVect,[0 1])));
        he = recepteur.getHauteur(thetam); %Hauteur l'equivalente de l'antenne
        %PRX = PRX + ((abs(he*E))^2)/(8*recepteur.Ra); %Puissance moyenne recue

        %2) Calcul des reflexions simples:

        for i = 1:(numel(wallList)) %Pour chaque mur:

           reflectedRayi = Rayon(3); %creation du rayon reflette mar le mur i
           reflectedRayi.x1 = xd1;
           reflectedRayi.y1 = yd1;
           reflectedRayi.x3 = xd2;
           reflectedRayi.y3 = yd2;
            test

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
         
          theta = acos(abs(dot(vectRay,[0 1])));
          G = stationBase.getGain(theta); %Gain dans la direction consideree
          E = E+reflectedRayi.getE(G); %Calcul du champ arrivant au recepteur
          thetam = acos(abs(dot(directRay.getLastVect,[0 1])));
          he = recepteur.getHauteur(thetam); %Hauteur equivalente de l'antenne
          PRX = ((abs(he*E))^2)/(8*recepteur.Ra); %Puissance moyenne re�ue
          
          else % Rayon pas valable car il n'intersecte pas le mur
               reflectedRayi.x2 = 1/0;
               reflectedRayi.y2 = 1/0;
               reflectedRayi.At = 0;
           end


           %Affichage rayon:
           
          %reflectedRayi.plot();
          
        end

        %3) Calcul des reflexions doubles

        
        
        %Ceci tombe � l'eau en champ proche:
        
        if(sqrt((x-stationBase.x)^2+(y-stationBase.y)^2)< 1.6*lambda)
            PRX = 0.1; %0,1 Watt au voisinage de l'antenne
        end
        
        powerDistribution(xi,yi) = 10*(log10(PRX)+3);
        speedDistribution(xi,yi) = powertodebit(PRX);
        yi = yi+1; %Incrementation indice ordonnee
        test = test+1;
    end
    xi = xi+1;
    yi = 1;
end



%stationBase.plot();
%recepteur.plot();

%Affichage de la distribution de puissance:

X = 4999.9:0.0001:5000;
Y = 99.9:0.0001:100;
surf(X,Y,powerDistribution', 'FaceAlpha', 1); 
c = colorbar;
c.Label.String = 'Debit binaire maximal (Mb/s)';
title('Distribution du debit recu en fonction de la position du recepteur');
xlabel('Abscisse (m)');
ylabel('Ordonnee (m)');
text(stationBase.x, stationBase.y, '\leftarrow EX');


