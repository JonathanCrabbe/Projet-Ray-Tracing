%Ceci est le script principal dans lequel est effectuee la simulation
%qui affiche la distribution de puissance

clear all; close all;

%Initialisation des constantes:

epsMur = 5; %Permitivite relative des murs (en beton)
sigmaMur = 0.014; %Conductivite des murs (en beton)
e2 = 0.5;
e1 = 0.3; %Epaisseur mur (m)
c = 299792458; %Vitesse de la lumiere dans le vide (m/s)
f = 2.45*10^9; %Frequence des communications (Hertz) 
lambda = c/f; %Longueur d'onde rayonnee (m)
Pem = 0.1; %La puissance rayonnee par l'emetteur est de 0,1W (20 dBm)



%Construction des objets murs de l'environement(distances en m�tres)

wall1 = Wall(0,0,0,12,epsMur, sigmaMur,e2); 
wall2 = Wall(0,0,63,0,epsMur, sigmaMur,e2); 
wall3 = Wall(0,12,24,12,epsMur, sigmaMur,e2); 
wall4 = Wall(24,9.9,24,42,epsMur, sigmaMur,e2); 
wall5 = Wall(24,42,32,42,epsMur, sigmaMur,e2);
wall6 = Wall(32,42,32,10,epsMur, sigmaMur,e2);
wall7 = Wall(26,18,63,18,epsMur, sigmaMur,e2);
wall8 = Wall(63,18,63,0,epsMur, sigmaMur,e2);

wall10 = Wall(24,0,24,9,epsMur, sigmaMur,e1);
wall12 = Wall(32,0,32,8,epsMur, sigmaMur,e1);
wall13 = Wall(40,0,40,8,epsMur, sigmaMur,e1);
wall14 = Wall(47,0,47,8,epsMur, sigmaMur,e1);
wall15 = Wall(55,0,55,8,epsMur, sigmaMur,e1);

wall16 = Wall(24,8,30,8,epsMur, sigmaMur,e1);
wall17 = Wall(30.9,8,33,8,epsMur, sigmaMur,e1);
wall18 = Wall(33.9,8,45,8,epsMur, sigmaMur,e1);
wall19 = Wall(45.9,8,53,8,epsMur, sigmaMur,e1);
wall20 = Wall(53.9,8,55.1,8,epsMur, sigmaMur,e1);
wall21 = Wall(56,8,63,8,epsMur, sigmaMur,e1);

wall22 = Wall(55,10,55,18,epsMur, sigmaMur,e1);
wall23 = Wall(47,10,47,18,epsMur, sigmaMur,e1);
wall24 = Wall(46,18,46,14,epsMur, sigmaMur,e1);
wall25 = Wall(46,10,46,13.1,epsMur, sigmaMur,e1);
wall26 = Wall(43,10,43,18,epsMur, sigmaMur,e1);
wall27 = Wall(40,10,40,18,epsMur, sigmaMur,e1);

wall29 = Wall(40,16,40.3,16,epsMur, sigmaMur,e1);
wall30 = Wall(41.2,16,41.8,16,epsMur, sigmaMur,e1);
wall31 = Wall(42.7,16,43,16,epsMur, sigmaMur,e1);
wall32 = Wall(41.5,16,41.5,18,epsMur, sigmaMur,e1);

wall33 = Wall(56.1,8,56.1,8.5,epsMur, sigmaMur,e1);
wall34 = Wall(56.1,9.4,56.1,10,epsMur, sigmaMur,e1);

wall35 = Wall(54,10,56.1,10,epsMur, sigmaMur,e1);
wall36 = Wall(53.1,10,45.5,10,epsMur, sigmaMur,e1);
wall37 = Wall(44.6,10,41.9,10,epsMur, sigmaMur,e1);
wall38 = Wall(41,10,40,10,epsMur, sigmaMur,e1);
wall39 = Wall(37,10,26,10,epsMur, sigmaMur,e1);


wall41 = Wall(26,26,32,26,epsMur, sigmaMur,e1);
wall42 = Wall(26,34,32,34,epsMur, sigmaMur,e1);

wall43 = Wall(24,40,24.55,40,epsMur, sigmaMur,e1);
wall44 = Wall(25.45,40,26,40,epsMur, sigmaMur,e1);

wall45 = Wall(26,42,26,39.5,epsMur, sigmaMur,e1);
wall46 = Wall(26,38.6,26,33,epsMur, sigmaMur,e1);
wall47 = Wall(26,32.1,26,19.9,epsMur, sigmaMur,e1);
wall48 = Wall(26,19,26,17,epsMur, sigmaMur,e1);
wall49 = Wall(26,16.1,26,10,epsMur, sigmaMur,e1);

%Creation d'une liste contenant les murs: 
wallList = [wall1,wall2,wall3,wall4,wall5,wall6,wall7,wall8,wall10,wall12,wall13,wall14,wall15,wall16,wall17,wall18,wall19,wall20,wall21,wall22,wall23,wall24,wall25,wall26,wall27,wall29,wall30,wall31,wall32,wall33,wall34,wall35,wall36,wall37,wall38,wall39,wall41,wall42,wall43,wall44,wall45,wall46,wall47,wall48,wall49];

%Affichage des murs:



%Creation d'une liste de coins
 
corner1 = Corner(0,0,epsMur,sigmaMur,2);
corner2 = Corner(0,12,epsMur,sigmaMur,2);
corner3 = Corner(24,12,epsMur,sigmaMur,2);
corner4 = Corner(24,42,epsMur,sigmaMur,2);
corner5 = Corner(32,42,epsMur,sigmaMur,2);
corner6 = Corner(32,18,epsMur,sigmaMur,2);
corner7 = Corner(63,18,epsMur,sigmaMur,2);
corner8 = Corner(63,0,epsMur,sigmaMur,2);

corner9 = Corner(24,0,epsMur,sigmaMur,2);
corner10 = Corner(32,0,epsMur,sigmaMur,2);
corner11 = Corner(40,0,epsMur,sigmaMur,2);
corner12 = Corner(47,0,epsMur,sigmaMur,2);
corner13 = Corner(55,0,epsMur,sigmaMur,2);

corner14= Corner(24,8,epsMur,sigmaMur,2);
corner15 = Corner(24,9,epsMur,sigmaMur,1);
corner16 = Corner(24,9.9,epsMur,sigmaMur,1);

corner17 = Corner(30,8,epsMur,sigmaMur,1);
corner18 = Corner(30.9,8,epsMur,sigmaMur,1);
corner19 = Corner(32,8,epsMur,sigmaMur,2);
corner20 = Corner(33,8,epsMur,sigmaMur,1);
corner21 = Corner(33.9,8,epsMur,sigmaMur,1);
corner22 = Corner(40,8,epsMur,sigmaMur,2);
corner23 = Corner(45,8,epsMur,sigmaMur,1);
corner24 = Corner(45.9,8,epsMur,sigmaMur,1);
corner25 = Corner(47,8,epsMur,sigmaMur,2);
corner26 = Corner(53,8,epsMur,sigmaMur,1);
corner27 = Corner(53.9,8,epsMur,sigmaMur,1);
corner28 = Corner(55,8,epsMur,sigmaMur,2);
corner29 = Corner(55.1,8,epsMur,sigmaMur,1);
corner30 = Corner(56,8,epsMur,sigmaMur,1);
corner31 = Corner(56.1,8,epsMur,sigmaMur,2);
corner32 = Corner(63,8,epsMur,sigmaMur,2);

corner33 = Corner(56.1,8.5,epsMur,sigmaMur,1);
corner34 = Corner(56.1,9.4,epsMur,sigmaMur,1);
corner35 = Corner(56.1,10,epsMur,sigmaMur,2);

corner36 = Corner(40,18,epsMur,sigmaMur,2);
corner37 = Corner(41.5,18,epsMur,sigmaMur,2);
corner38 = Corner(43,18,epsMur,sigmaMur,2);
corner39 = Corner(46,18,epsMur,sigmaMur,2);
corner40 = Corner(47,18,epsMur,sigmaMur,2);
corner41 = Corner(55,18,epsMur,sigmaMur,2);

corner42 = Corner(32,26,epsMur,sigmaMur,2);
corner43 = Corner(32,34,epsMur,sigmaMur,2);

corner44 = Corner(24,40,epsMur,sigmaMur,2);
corner45 = Corner(24.55,40,epsMur,sigmaMur,1);
corner46 = Corner(25.45,40,epsMur,sigmaMur,1);
corner47 = Corner(26,40,epsMur,sigmaMur,2);

corner48 = Corner(26,42,epsMur,sigmaMur,2);
corner49 = Corner(26,18,epsMur,sigmaMur,2);
corner50 = Corner(26,39.5,epsMur,sigmaMur,1);
corner51 = Corner(26,38.6,epsMur,sigmaMur,1);
corner52 = Corner(26,34,epsMur,sigmaMur,2);
corner53 = Corner(26,33,epsMur,sigmaMur,1);
corner54 = Corner(26,32.1,epsMur,sigmaMur,1);
corner55 = Corner(26,26,epsMur,sigmaMur,2);
corner56 = Corner(26,19.9,epsMur,sigmaMur,1);
corner57 = Corner(26,19,epsMur,sigmaMur,1);
corner58 = Corner(26,17,epsMur,sigmaMur,1);
corner59 = Corner(26,16.1,epsMur,sigmaMur,1);
corner60 = Corner(26,10,epsMur,sigmaMur,2);

corner61 = Corner(32,10,epsMur,sigmaMur,2);
corner62 = Corner(37,10,epsMur,sigmaMur,1);
corner63 = Corner(40,10,epsMur,sigmaMur,2);
corner64 = Corner(41,10,epsMur,sigmaMur,1);
corner65 = Corner(41.9,10,epsMur,sigmaMur,1);
corner66 = Corner(43,10,epsMur,sigmaMur,2);
corner67 = Corner(44.6,10,epsMur,sigmaMur,1);
corner68 = Corner(45.5,10,epsMur,sigmaMur,1);
corner69 = Corner(46,10,epsMur,sigmaMur,2);
corner70 = Corner(47,10,epsMur,sigmaMur,2);
corner71 = Corner(53.1,10,epsMur,sigmaMur,1);
corner72 = Corner(54,10,epsMur,sigmaMur,1);
corner73 = Corner(55,10,epsMur,sigmaMur,2);

corner74 = Corner(40,16,epsMur,sigmaMur,2);
corner75 = Corner(40.3,16,epsMur,sigmaMur,1);
corner76 = Corner(41.2,16,epsMur,sigmaMur,1);
corner77 = Corner(41.5,16,epsMur,sigmaMur,2);
corner78 = Corner(41.8,16,epsMur,sigmaMur,1);
corner79 = Corner(42.7,16,epsMur,sigmaMur,1);
corner80 = Corner(43,16,epsMur,sigmaMur,2);

corner81 = Corner(46,14,epsMur,sigmaMur,1);
corner82 = Corner(46,13.1,epsMur,sigmaMur,1);


cornerList = [corner1,corner2,corner3,corner4,corner5,corner6,corner7,corner8,corner9,corner10,corner11,corner12,corner13,corner14,corner15,corner16,corner17,corner18,corner19,corner20,corner21,corner22,corner23,corner24,corner25,corner26,corner27,corner28,corner29,corner30,corner31,corner32,corner33,corner34,corner35,corner36,corner37,corner38,corner39,corner40,corner41,corner42,corner43,corner44,corner45,corner46,corner47,corner48,corner49,corner50,corner51,corner52,corner53,corner54,corner55,corner56,corner57,corner58,corner59,corner60,corner61,corner62,corner63,corner64,corner65,corner66,corner67,corner68,corner69,corner70,corner71,corner72,corner73,corner74,corner75,corner76,corner77,corner78,corner79,corner80,corner81,corner82];

for i = 1:numel(cornerList)
    cornerList(i).plot();
end


for i = 1:numel(wallList)
    wallList(i).plot();
end