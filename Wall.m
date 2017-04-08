classdef Wall
    %Cette classe contient les propri�t�s des murs de l'environement

    properties
        x1 %Abscisse extr�mit� 1
        y1 %Ordonn�e extr�mit� 1
        x2 %Abscisse extr�mit� 2
        y2 %Ordonn�e extremit� 2    
        perm %Permitivit� relative
        cond %Conductivit�
        ep %Epaisseur
    end
    
    methods
        %Constructeur:
        function obj = Wall(x1,y1,x2,y2,perm,cond,ep)
            obj.x1 = x1;
            obj.y1 = y1;
            obj.x2 = x2;
            obj.y2 = y2;
            obj.perm = perm;
            obj.cond = cond;
            obj.ep = ep;
        end
        
        %Affiche le mur dans l'environement 
        function plot(obj)
            plot([obj.x1,obj.x2], [obj.y1,obj.y2], 'Color', 'b');
            hold on;
        end
        
        %Renvoie le coefficient de transmission au travers du mur
        function T = getTransmission(obj,thetai)
            mu0 = 4*pi*10^-7;
            eps0 = 10^-9 / (36*pi);
            eps2 = obj.perm * eps0; %Permitivit� mur
            betam = 2*pi*(2.45*10^9)*sqrt(eps2*mu0); %Norme du vecteur d'onde dans le mur
            beta = 2*pi*(2.45*10^9)*sqrt(eps0*mu0); %Norme du vecteur d'onde dans le vide
            thetat = asin(sqrt(1/obj.perm)*sin(thetai)); %Angle de transmission
            Z2 = sqrt(eps2/mu0); %Imp�dance mur
            Z1 = sqrt(eps0/mu0); %Imp�dance vide
            gammap = (Z2*cos(thetai) - Z1*cos(thetat))/(Z2*cos(thetai)+Z1*cos(thetat)); %Coefficient de r�flection normal
            s = obj.ep/cos(thetat); %Distance parcourue dans le mur
            T = abs((exp(-i*(betam*s))*(1 - gammap^2))/... 
                (1- (gammap^2 * exp(-2*i*betam*2*s + i*2*beta*s*sin(thetat)*sin(thetai)))));
        end
        
        %Renvoie un vecteur normal au mur:
        function vect = getNormVect(obj)
            vect = [obj.y2-obj.y1  -obj.x2+obj.x1]/ ...
                sqrt((obj.x1-obj.x2)^2 + (obj.y1-obj.y2)^2);
        end
    end 
end

