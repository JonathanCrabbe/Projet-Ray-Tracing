classdef Rayon
    %Cette classe contient les propriétés des faisceaux
    

    properties
      
       
        At = 1;%Atténuation totale accumulée par le rayon lors de ses interactions
        Pem = 0.1; %La puissance rayonnée par l'émetteur est de 0,1W (20 dBm)
        numPoints = 0; %Nombre de points du du graphe du rayon
        
        %Coordonnées des points définissant le graphe du rayon (au maximum
        %4)
        x1 = 0;
        y1 = 0;
        x2 = 0;
        y2 = 0;
        x3 = 0;
        y3 = 0;
        x4 = 0;
        y4 = 0;
    end
    
    methods
        %Constructeur:
        function obj = Rayon(numPoints)
            obj.numPoints = numPoints;
        end
        
        %Renvoie la distance totale parcourue par le rayon
        function d = getD(obj)
            d = 0;
            path = [obj.x1 obj.y1; obj.x2 obj.y2;...
                obj.x3 obj.y3; obj.x4 obj.y4]; %Chemin suivi par le rayon
            for i =  1:(obj.numPoints-1)
                d = d+ sqrt((path(i,1)-path(i+1,1))^2+...
                    (path(i,2)-path(i+1,2))^2);
            end
        end
        
        %Calcul du champ arrivant au récepteur:
        function E = getE(obj,G)
            d = obj.getD();
            mu0 = 4*pi*10^-7;
            eps0 = 10^-9 / (36*pi);
            beta = 2*pi*(2.45*10^9)*sqrt(eps0*mu0);
            E = exp(-i*beta*d)*obj.At*sqrt(60*G*obj.Pem)/d;
        end
        
        
        %Affiche le rayon dans l'environement:
        function plot(obj)
            path = [obj.x1 obj.y1; obj.x2 obj.y2;...
                obj.x3 obj.y3; obj.x4 obj.y4]; %Chemin suivi par le rayon
            for i =  1:(obj.numPoints-1)
                plot([path(i,1),path(i+1,1)],...
                    [path(i,2),path(i+1,2)], 'Color', 'g');
                hold on;
            end
        end
       
    end 
end


