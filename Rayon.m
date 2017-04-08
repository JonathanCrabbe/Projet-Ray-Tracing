classdef Rayon
    %Cette classe contient les propri�t�s des faisceaux
    

    properties
        d %Distance parcoure par le rayon avant d'atteindre l'�metteur
        theta %Direction d'�mission relativement � l'antenne
        At = 1;%Att�nuation totale accumul�e par le rayon lors de ses interactions
        Pem = 0.1; %La puissance rayonn�e par l'�metteur est de 0,1W (20 dBm
    end
    
    methods
        %Constructeur:
        function obj = Rayon(d,theta)
            obj.d = d;
            obj.theta = theta;
        end
        
        %Calcul du champ arrivant au r�cepteur:
        function E = getE(obj,G)
            mu0 = 4*pi*10^-7;
            eps0 = 10^-9 / (36*pi);
            beta = 2*pi*(2.45*10^9)*sqrt(eps0*mu0);
            E = exp(-i*beta*obj.d)*obj.At*sqrt(60*G*obj.Pem)/obj.d;
        end
       
    end 
end


