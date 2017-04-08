classdef Antenne
    %Cette classe contient les propriétés des antennes qui sont
    %des dipôles lambda/2 par hypothèse

    properties
        x %Abscisse de l'origine de l'antenne
        y %Ordonnée de l'origine de l'antenne
        lambda %Longueur d'onde rayonnée ou reçue
        Ia = sqrt(2*0.1/73); %Courant parcouru par l'antenne si elle rayonne
        etha = 1; %Rendement de l'antenne
           
    end
    
    methods
        %Constructeur:
        function obj = Antenne(x,y,lambda)
            obj.x = x;
            obj.y = y;
            obj.lambda = lambda;
        end
        
        %Aficchage de l'antenne:
        function plot(obj)
            plot([obj.x ,obj.x],...
            [obj.y - (obj.lambda)/4,obj.y + (obj.lambda)/4], 'Color', 'g');
            hold on;
        end
        
        %Calcule le gain de l'antenne dans la direction theta (formule 5.44):
        function G = getGain(obj,theta)
            G = obj.etha*120*pi*(obj.Ia^2/8*pi^2)*(cos(pi*cos(theta)/2)/sin(theta))^2;
        end
        
    end 
end


