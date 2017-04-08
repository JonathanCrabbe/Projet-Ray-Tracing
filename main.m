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

%1) Calcul du rayon direct:

%Distance parcourue par le rayon direct:

%Point de d�part
 xd1  = stationBase.x; 
 yd1 = stationBase.y;
 
 %Point d'arriv�e
 xd2 = recepteur.x; 
 yd2 = recepteur.y;
 d = sqrt((xd1-xd2)^2 + (yd1-yd2)^2); %Distance parcourue
 theta = acos(abs(dot(vectRay,[0 1]))); %Angle relativement � l'antenne
 
 directRay = Rayon(d,theta); %Construction de l'objet rayon
 
 lineRay = [xd1 yd1; xd2 yd2]; %Segment associ� au rayon
 plot(lineRay(:,1),lineRay(:,2)); hold on;
 vectRay = [xd2-xd1 yd2-yd1]/sqrt((xd1-xd2)^2 + (yd1-yd2)^2);
%D�termination de l'att�nuation par les murs rencontr�s:

for i = 1:numel(wallList)
    walli = wallList(i);
    %Segment de droite associ� au mur:
    lineWall = [walli.x1 walli.y1; walli.x2 walli.y2]; 
    
    %Le rayon intersecte-t-il le mur?
 
    if (verifyIntersection(lineRay,lineWall)) %Si le mur est rencontr�, compatbiliser att�nuation:
       vectWall = walli.getNormVect(); %Vecteur normal au mur norm�
       thetai = acos(abs(dot(vectRay,vectWall))); %Angle d'incidence
       directRay.At = directRay.At * walli.getTransmission(thetai); %Att�nuation
    end 
        
end
G = stationBase.getGain(directRay.theta); %Gain dans la direction consid�r�e
E = directRay.getE(G) %Calcul du champ arrivant au r�cepteur;

%Affichage des antennes:

stationBase.plot();
recepteur.plot();





