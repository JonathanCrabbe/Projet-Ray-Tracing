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



%Construction des objets murs de l'environement(distances en m�tres)

wall1 = Wall(0,0,0,10,epsMur, sigmaMur,0.2); 


%Creation d'une liste contenant les murs: 
wallList = [wall1];

%Affichage des murs:



%Creation d'une liste de coins
 
corner1 = Corner(0,10,epsMur,sigmaMur,1);


cornerList = [corner1];

for i = 1:numel(cornerList)
    %cornerList(i).plot();
end
%Construction de la station de base


powerDistribution = []; %Puissance recue en (X,Y)
speedDistribution = []; %Debit recu en (X,Y)

%Application de l'algorithme de Ray Tracing � differents recepteurs:

xi = 1; %Indice abscisce
yi = 1; %Indice ordonnee
for x = 0:0.1:90
    for y = 0:0.1:10
        stationBase = Antenne(-10,y,lambda);
        recepteur = Antenne(x,y,lambda);
        %Point de depart
         xd1  = stationBase.x; 
         yd1 = stationBase.y;


         %Point d'arrivee
         xd2 = recepteur.x; 
         yd2 = recepteur.y;
        E = 0; %Champ arrivant au recepteur
        PRX = 0; %Puissance arrivant au recepteur
        

        
        %4) Calcul de la diffraction

        for i = 1:(numel(cornerList))
           corneri = cornerList(i);
           
           if (corneri.numWall == 1)
               for j = 1:numel(wallList)
                   wallj = wallList(j);
                   if (getPointSegment(corneri.x1, corneri.y1, wallj.getLine()))
                       corneri.wall1 = wallj;
                       break;
                   end
               end
           end
          
           if (corneri.numWall == 2)
               numberWall = 0;
               for j = 1:numel(wallList)
                   wallj = wallList(j);
                   if (getPointSegment(corneri.x1, corneri.y1, wallj.getLine()))
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
                                diffractedRayi.At = diffractedRayi.At * wallj.getTransmission(thetai) %Attenuation
                            end
                        else
                            vectWall = wallj.getNormVect(); %Vecteur normal au mur norme
                            vectRay1 = [diffractedRayi.x2-xd1 diffractedRayi.y2-yd1]/sqrt((xd1-diffractedRayi.x2)^2 + (yd1-diffractedRayi.y2)^2);
                            thetai = acos(abs(dot(vectRay1,vectWall))); %Angle d'incidence
                            diffractedRayi.At = diffractedRayi.At * wallj.getTransmission(thetai) %Attenuation
                        end
                    end
                    if (verifyIntersection(lineRay2,lineWall)) %Si le mur est rencontre, compatbiliser attenuation:
                        intersection = getIntersection(lineRay2,lineWall);
                        if (intersection(1) == diffractedRayi.x2)
                            if (intersection(2) ~= diffractedRayi.y2)
                                vectWall = wallj.getNormVect(); %Vecteur normal au mur norme
                                vectRay2 = [xd2-diffractedRayi.x2 yd2-diffractedRayi.y2]/sqrt((diffractedRayi.x2-xd2)^2 + (diffractedRayi.y2-yd2)^2);
                                thetai = acos(abs(dot(vectRay2,vectWall))); %Angle d'incidence
                                diffractedRayi.At = diffractedRayi.At * wallj.getTransmission(thetai) %Attenuation
                            end
                        else
                            vectWall = wallj.getNormVect(); %Vecteur normal au mur norme
                            vectRay2 = [xd2-diffractedRayi.x2 yd2-diffractedRayi.y2]/sqrt((diffractedRayi.x2-xd2)^2 + (diffractedRayi.y2-yd2)^2);
                            thetai = acos(abs(dot(vectRay2,vectWall))); %Angle d'incidence
                            diffractedRayi.At = diffractedRayi.At * wallj.getTransmission(thetai) %Attenuation
                        end
                    end
           end
 
 
           diffractedRayi.At = diffractedRayi.At * corneri.getDiffraction(xd1,yd1,xd2,yd2);
 
           vectRay1 = diffractedRayi.getFirstVect();
           theta = acos(abs(dot(vectRay1,[0 1]))); %Angle relativement a l'antenne
           G = stationBase.getGain(theta); %Gain dans la direction consideree
           E =  diffractedRayi.getE(G); %Calcul du champ arrivant au recepteur;
           thetam = acos(abs(dot(diffractedRayi.getLastVect,[0 1]))); %Angle d'arrivï¿½e ï¿½ l'antenne
           he = recepteur.getHauteur(thetam); %Hauteur ï¿½quivalente de l'antenne
           PRX = PRX + ((abs(he*E))^2)/(8*recepteur.Ra); %Puissance moyenne reï¿½ue
  
           %diffractedRayi.plot();
 
        end 
        
        %Ceci tombe � l'eau au voisinage d'une antenne
        if(sqrt((x-stationBase.x)^2+(y-stationBase.y)^2)< 1.6*lambda)
            PRX = 0.1; %0,1 Watt au voisinage de l'antenne
        end
        
        powerDistribution(xi,yi) = PRX;
        speedDistribution(xi,yi) = powertodebit(PRX);
        yi = yi+1; %Incrementation indice ordonnee
        
        stationBase.plot();
    end
    xi = xi+1;
    yi = 1;
end



stationBase.plot();
%recepteur.plot();

%Affichage de la distribution de puissance:

X = 0:0.1:90;
Y = 0:0.1:10;
surf(X,Y,speedDistribution', 'FaceAlpha', 0.5);
colorbar;
title('Distribution du debit recu en fonction de la position du recepteur');
xlabel('Abscisse (m)');
ylabel('Ordonnee (m)');
text(stationBase.x, stationBase.y, '\leftarrow EX');


for i = 1:numel(wallList)
    wallList(i).plot();
end