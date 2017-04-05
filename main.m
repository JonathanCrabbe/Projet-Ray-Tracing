%Ceci est le script principal dans lequel est effectu�e la simulation

%Initialisation des constantes:

epsMur = 5; %Permitivit� relative des murs (en b�ton)
sigmaMur = 0.014; %Conductivit� des murs (en b�ton)
L = 50; %Longueur caract�ristique du plan(m)
e = 0.4; %Epaisseur mur (m)
c = 299792458; %Vitesse de la lumi�re dans le vide (m/s)
f = 2.45*10^9; %Fr�quence des communications (Hertz) 
lambda = c/f; %Longueur d'onde rayonn�e (m)
%Construction des objets murs de l'environement

wall1 = Wall(0,0,0,L,epsMur, sigmaMur,e); 
wall2 = Wall(0,0,L,0,epsMur, sigmaMur,e); 
wall3 = Wall(L,0,L,L,epsMur, sigmaMur,e); 
wall4 = Wall(0,L,L,L,epsMur, sigmaMur,e); 

%Cr�ation d'un liste contenant les murs: 
wallList = [wall1, wall2, wall3, wall4];

%Affichage des murs:

for i = 1:numel(wallList)
    wallList(i).plot();
end

%Construction des objets antenne de l'environement

stationBase = Antenne(10,10,lambda);
recepteur = Antenne(40,40,lambda);

%Affichage des antennes:

stationBase.plot();
recepteur.plot();



