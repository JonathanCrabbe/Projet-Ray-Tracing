classdef Wall
    %Cette classe contient les propriétés des murs de l'environement

    properties %Propriétés variables du mur
        x1 %Abscisse extrémité 1
        y1 %Ordonnée extrémité 1
        x2 %Abscisse extrémité 2
        y2 %Ordonnée extremité 2    
        perm %Permitivité relative
        cond %Conductivité
        ep %Epaisseur
        eps2; %Permitivité mur
        Z2 ; %Impédance mur
        betam ; %Norme du vecteur d'onde dans le mur
    end
    
    properties (Constant = true) %Constantes utiles dans les calculs
        mu0 = 4*pi*10^-7;
        eps0 = 10^-9 / (36*pi);  
        beta = 2*pi*(2.45*10^9)*sqrt(4*pi*10^-7 *10^-9 / (36*pi)); %Norme du vecteur d'onde dans le vide
        Z1 = sqrt((10^-9 / (36*pi))/(4*pi*10^-7)); %Impédance vide
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
            obj.eps2 = obj.perm * obj.eps0;
            obj.Z2 = sqrt((obj.eps2)/(obj.mu0));
            obj.betam = 2*pi*(2.45*10^9)*sqrt(obj.eps2*obj.mu0);
            
        end
        
        %Affiche le mur dans l'environement 
        function plot(obj)
            plot([obj.x1,obj.x2], [obj.y1,obj.y2], 'Color', 'b');
            hold on;
        end
        
        %Renvoie le coefficient de transmission au travers du mur
        function T = getTransmission(obj,thetai)
            thetat = asin(sqrt(1/obj.perm)*sin(thetai)); %Angle de transmission 
            gammap = (obj.Z2*cos(thetai) - obj.Z1*cos(thetat))/...
                (obj.Z2*cos(thetai)+obj.Z1*cos(thetat)); %Coefficient de réflection normal
            s = obj.ep/cos(thetat); %Distance parcourue dans le mur
            %Calcul du coefficient de transmission par 8.44:
            T = (exp(-i*(obj.betam*s))*(1 - gammap^2))/... 
                (1- (gammap^2 * exp(-2*i*obj.betam*2*s + i*2*obj.beta*s*sin(thetat)*sin(thetai))));
        end
        
        %Renvoie un vecteur normal au mur:
        function vect = getNormVect(obj)
            vect = [obj.y2-obj.y1  -obj.x2+obj.x1]/ ...
                sqrt((obj.x1-obj.x2)^2 + (obj.y1-obj.y2)^2);
        end
        
        %Renvoie le vecteur permettant de dessiner le mur:
        function line = getLine(obj)
            line = [obj.x1 obj.y1; obj.x2 obj.y2];
        end
    end 
end

