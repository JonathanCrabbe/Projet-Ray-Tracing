%Ceci est le script principal dans lequel est effectuee la simulation
%qui affiche la distribution de puissance

clear all; close all;

%Initialisation des constantes:

epsMur = 5; %Permitivite relative des murs (en beton)
sigmaMur = 0.014; %Conductivite des murs (en beton)
c = 299792458; %Vitesse de la lumiere dans le vide (m/s)
f = 2.45*10^9; %Frequence des communications (Hertz) 
lambda = c/f; %Longueur d'onde rayonnee (m)
Pem = 0.1; %La puissance rayonnee par l'emetteur est de 0,1W (20 dBm)


stationBase = Antenne(5,5,lambda);
powerDistribution = []; %Puissance recue en (X,Y)
speedDistribution = []; %Debit recu en (X,Y)

%Application de l'algorithme de Ray Tracing � differents recepteurs:

xi = 1; %Indice abscisce
yi = 1; %Indice ordonnee
for x = 0:1:200
    for y = 0:1:200
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

         directRay = Rayon(2); %Construction de l'objet rayon (a 2 points

         %Affichage du rayon:
         directRay.x1 = xd1;
         directRay.y1 = yd1;
         directRay.x2 =xd2;
         directRay.y2 = yd2;
         %directRay.plot();
       
        
        G = recepteur.getGain(pi/2); %Gain dans la direction consideree
        E = directRay.getE(G); %Calcul du champ arrivant au recepteur;
        
        he = recepteur.getGain(pi/2); %Hauteur �quivalente de l'antenne
        PRX = PRX + ((abs(he*E))^2)/(8*recepteur.Ra); %Puissance moyenne recue

       
    
        if(sqrt((x-stationBase.x)^2+(y-stationBase.y)^2)< 1.6*lambda)
            PRX = 0.1; %0,1 Watt au voisinage de l'antenne
        end
        powerDistribution(xi,yi) = 10*(log10(PRX)+3);
        
        speedDistribution(xi,yi) = powertodebit(PRX);
        
         if (10*(log10(PRX)+3)>-93)
            rectangle('Position',[x,y,1,1],'FaceColor','g'); hold on
        else
            rectangle('Position',[x,y,1,1],'FaceColor','r'); hold on
        end
        
        yi = yi+1; %Incrementation indice ordonnee
    end
    xi = xi+1;
    yi = 1;
end



stationBase.plot();
%recepteur.plot();

%Affichage de la distribution de puissance:

X = 0:0.5:10;
Y = 0:0.5:10;
%surf(X,Y,powerDistribution', 'FaceAlpha', 0.5);
colorbar;
title('Distribution du debit recu en fonction de la position du recepteur');
xlabel('Abscisse (m)');
ylabel('Ordonnee (m)');
text(stationBase.x, stationBase.y, '\leftarrow EX');
