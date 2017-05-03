classdef Corner
    %Cette classe contient les propri�t�s des coins de l'environement

    properties %Propri�t�s variables du mur
        x1 %Abscisse extr�mit� 1
        y1 %Ordonn�e extr�mit� 1   
        perm %Permitivit� relative
        cond %Conductivit�
    end
    
    properties (Constant = true) %Constantes utiles dans les calculs
        mu0 = 4*pi*10^-7;
        eps0 = 10^-9 / (36*pi);  
        beta = 2*pi*(2.45*10^9)*sqrt(4*pi*10^-7 *10^-9 / (36*pi)); %Norme du vecteur d'onde dans le vide
        Z1 = sqrt((10^-9 / (36*pi))/(4*pi*10^-7)); %Imp�dance vide
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
            phip = ; % Angle d'incidence
            phi = ; % Angle de refraction
            delta = pi - (phip-phi);
            sp = ; % Distance à la source
            s = ; % Dista,ce au recepteur
            L = s*sp/(s+sp);
            %Calcul du coefficient de transmission par 8.79:
            D = ;
        end
        
    end 
end

