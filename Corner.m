classdef Corner
    %Cette classe contient les proprietes des coins de l'environement
 
    properties %Proprietes variables du mur
        x1 %Abscisse extremite 1
        y1 %Ordonnee extremite 1  
        perm %Permitivite relative
        cond %Conductivite
        eps2
        numWall %Nombre de murs passant par le coin
        wall1 %Premier mur auquel le coin appartient
        wall2 %Second mur auquel le coin appartient
    end
   
    properties (Constant = true) %Constantes utiles dans les calculs
        mu0 = 4*pi*10^-7;
        eps0 = 10^-9 / (36*pi); 
        beta = 2*pi*(2.45*10^9)*sqrt(4*pi*10^-7 *10^-9 / (36*pi)); %Norme du vecteur d'onde dans le vide
        Z1 = sqrt((10^-9 / (36*pi))/(4*pi*10^-7)); %Impedance vide
    end
   
    methods
        %Constructeur:
        function obj = Corner(x1,y1,perm,cond,numWall)
            obj.x1 = x1;
            obj.y1 = y1;
            obj.perm = perm;
            obj.cond = cond;
            obj.eps2 = obj.perm * obj.eps0;
            obj.numWall = numWall;
        end
       
        %Renvoie le coefficient de diffraction au travers du mur
        function D = getDiffraction(obj,xd1,yd1,xd2,yd2)
            if (sqrt((xd1-obj.x1)^2 + (yd1-obj.y1)^2) == 0)
                vectRay1 = [0 0];
            else
                vectRay1 = [obj.x1-xd1 obj.y1-yd1]/sqrt((xd1-obj.x1)^2 + (yd1-obj.y1)^2);
            end
            if(sqrt((obj.x1-xd2)^2 + (obj.y1-yd2)^2) == 0)
                vectRay2 = [0 0];
            else
                vectRay2 = [xd2-obj.x1 yd2-obj.y1]/sqrt((obj.x1-xd2)^2 + (obj.y1-yd2)^2);
            end
            if (obj.numWall == 1)
                vectWall = obj.wall1.getNormVect();
                phip = acos(abs(dot(vectRay1,vectWall))); % Angle d'incidence
                phi = acos(abs(dot(vectRay2,vectWall))); % Angle de refraction
            else
                vectWall1 = obj.wall1.getNormVect();
                vectWall2 = obj.wall2.getNormVect();
                psy = acos(abs(dot(vectWall2,vectWall1)));
                phip = acos(abs(dot(vectRay1,vectWall1))) - (psy/2); % Angle d'incidence
                phi = acos(abs(dot(vectRay2,vectWall1)))- (psy/2); % Angle de refraction
            end
          
            delta = pi - (phip-phi);
            sp = sqrt((xd1-obj.x1)^2+(yd1-obj.y1)^2); % Distance a la source
            s = sqrt((xd2-obj.x1)^2+(yd2-obj.y1)^2); % Dista,ce au recepteur
            L = s*sp/(s+sp);            %Calcul du coefficient de transmission par 8.79:
            ft = obj.FT(2*obj.beta*L*(sin(delta/2))^2);
            D = -(exp(-i*pi/4)/(2*sqrt(2*pi*obj.beta*L)))*(ft/sin(delta/2));
            if (sqrt((xd1-obj.x1)^2 + (yd1-obj.y1)^2) == 0 || sqrt((obj.x1-xd2)^2 + (obj.y1-yd2)^2) == 0)
                 D = 1;
            end
        end
       
         %Affichage de l'antenne:
        function plot(obj)
            plot(obj.x1 ,obj.y1,'*r');
            hold on;
        end
       
        function ft = FT(obj,x)
            fun = @(t) exp(-i*t.^2);
            ft = 2*i*sqrt(x)*exp(j*x)*integral(fun,sqrt(x),sqrt(11*pi));
        end
    end
end
