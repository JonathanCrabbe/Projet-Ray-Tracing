%Ceci est le script principal dans lequel est effectuée la simulation

%Initialisation des constantes:

epsMur = 5; %Permitivité relative des murs (en béton)
sigmaMur = 0.014; %Conductivité des murs (en béton)
L = 50; %Longueur caractéristique du plan(m)
e = 0.4; %Epaisseur mur (m)
c = 299792458; %Vitesse de la lumière dans le vide (m/s)
f = 2.45*10^9; %Fréquence des communications (Hertz) 
lambda = c/f; %Longueur d'onde rayonnée (m)
%Construction des objets murs de l'environement

wall1 = Wall(0,0,0,L,epsMur, sigmaMur,e); 
wall2 = Wall(0,0,L,0,epsMur, sigmaMur,e); 
wall3 = Wall(L,0,L,L,epsMur, sigmaMur,e); 
wall4 = Wall(0,L,L,L,epsMur, sigmaMur,e); 

%Création d'un liste contenant les murs: 
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



