%Ceci est le script principal dans lequel est effectu�e la simulation

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

%Construction des objets antenne de l'environement

stationBase = Antenne(10,10,lambda);
recepteur = Antenne(40,40,lambda);
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
 directRay.plot();
 
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
    
    %V�rification que le point de r�flection est sur le mur:
    if(verifyIntersection(lineRay,lineWall))
        reflectedRayi.x2 = intersectioni(1);
        reflectedRayi.y2 = intersectioni(2);
    else
        reflectedRayi.x2 = 1/0;
        reflectedRayi.y2 = 1/0;
    end
   %Affichage rayon:
   reflectedRayi.plot();
end




%Affichage des antennes:

stationBase.plot();
recepteur.plot();





