classdef Antenne
    %Cette classe contient les propriétés des antennes qui sont
    %des dipôles lambda/2 par hypothèse

    properties
        x %Abscisse de l'origine de l'antenne
        y %Ordonnée de l'origine de l'antenne
        lambda %Longueur d'onde rayonnée ou reçue
           
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
    end 
end


