classdef Corner
    %Cette classe contient les proprietes des coins de l'environement

    properties %Proprietes variables du mur
        x1 %Abscisse extremite 1
        y1 %Ordonnee extremite 1   
        perm %Permitivite relative
        cond %Conductivite
        eps2
    end
    
    properties (Constant = true) %Constantes utiles dans les calculs
        mu0 = 4*pi*10^-7;
        eps0 = 10^-9 / (36*pi);  
        beta = 2*pi*(2.45*10^9)*sqrt(4*pi*10^-7 *10^-9 / (36*pi)); %Norme du vecteur d'onde dans le vide
        Z1 = sqrt((10^-9 / (36*pi))/(4*pi*10^-7)); %Impedance vide
    end
    
    methods
        %Constructeur:
        function obj = Corner(x1,y1,perm,cond)
            obj.x1 = x1;
            obj.y1 = y1;
            obj.perm = perm;
            obj.cond = cond;
            obj.eps2 = obj.perm * obj.eps0;
        end
        
        %Renvoie le coefficient de diffraction au travers du mur
        function D = getDiffraction(obj,thetai)
            phip = thetai; % Angle d'incidence
            %phi = 0; % Angle de refraction
            %delta = pi - (phip-phi);
            %sp = 0; % Distance ?? la source
            %s = 0; % Dista,ce au recepteur
            %L = s*sp/(s+sp);
            %Calcul du coefficient de transmission par 8.79:
            %ft = obj.FT(2*obj.beta*L*(sin(delta/2))^2);
            %D = -(exp(-i*pi/4)/(2*sqrt(2*pi*obj.beta*L)))*(ft/sin(delta/2));
        end
        
         %Affichage de l'antenne:
        function plot(obj)
            plot(obj.x1 ,obj.y1,'*r');
            hold on;
        end
        
        function ft = FT(obj,x)
            fun = @(t) exp(-i*t^2);
            ft = 2*i*sqrt(x)*exp(j*x)*integral(fun,sqrt(x),Inf);
        end
    end 
end

