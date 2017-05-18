classdef Wall
    %Cette classe contient les proprietes des murs de l'environement

    properties %Proprietes variables du mur
        x1 %Abscisse extremite 1
        y1 %Ordonnee extremite 1
        x2 %Abscisse extremite 2
        y2 %Ordonnee extremite 2    
        perm %Permitivite relative
        cond %Conductivite
        ep %Epaisseur
        eps2; %Permitivite mur
        Z2 ; %Impedance mur
        betam ; %Norme du vecteur d'onde dans le mur
        alpha;
        betagamma;
    end
    
    properties (Constant = true) %Constantes utiles dans les calculs
        mu0 = 4*pi*10^-7;
        eps0 = 10^-9 / (36*pi);  
        beta = 2*pi*(2.45*10^9)*sqrt(4*pi*10^-7 *10^-9 / (36*pi)); %Norme du vecteur d'onde dans le vide
        Z1 = sqrt((10^-9 / (36*pi))/(4*pi*10^-7)); %Impedance vide
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
            obj.alpha = 2*pi*(2.45*10^9)*sqrt(obj.eps2*obj.mu0/2)*sqrt(sqrt(1+(cond/(obj.eps2*2*pi*2.45*10^9)^2))-1);
            obj.betagamma = 2*pi*(2.45*10^9)*sqrt(obj.eps2*obj.mu0/2)*sqrt(sqrt(1+(cond/(obj.eps2*2*pi*2.45*10^9)^2))+1);
        end
        
        %Affiche le mur dans l'environement 
        function plot(obj)
            plot([obj.x1,obj.x2], [obj.y1,obj.y2], 'Color', 'r', 'LineWidth', 1);
            hold on;
        end
        
        %Renvoie le coefficient de transmission au travers du mur
        function T = getTransmission(obj,thetai)
            thetat = asin(sqrt(1/obj.perm)*sin(thetai)); %Angle de transmission 
            gammap = (obj.Z2*cos(thetai) - obj.Z1*cos(thetat))/...
                (obj.Z2*cos(thetai)+obj.Z1*cos(thetat)); %Coefficient de reflexion normal
            s = obj.ep/cos(thetat); %Distance parcourue dans le mur
            %Calcul du coefficient de transmission par 8.44:
            T = (exp(-((obj.alpha+i*obj.betagamma)*s))*(1 - gammap^2))/... 
                (1- (gammap^2 * exp(-2*(obj.alpha+i*obj.betagamma)*s + i*2*obj.beta*s*sin(thetat)*sin(thetai))));
        end
        
        %Renvoie le coefficient de reflexion sur le mur
        function Gamma = getReflexion(obj,thetai)
            thetat = asin(sqrt(1/obj.perm)*sin(thetai)); %Angle de transmission 
            gammap = (obj.Z2*cos(thetai) - obj.Z1*cos(thetat))/...
                (obj.Z2*cos(thetai)+obj.Z1*cos(thetat)); %Coefficient de réflection normal
            s = obj.ep/cos(thetat); %Distance parcourue dans le mur
            %Calcul du coefficient de reflexion par 8.43:
            Gamma = gammap + (1-gammap^2)*((gammap * exp(-2*(obj.alpha+i*obj.betagamma)*s + i*2*obj.beta*s*sin(thetat)*sin(thetai)))/...
                (1- (gammap^2 * exp(-2*(obj.alpha+i*obj.betagamma)*s + i*2*obj.beta*s*sin(thetat)*sin(thetai)))));
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

