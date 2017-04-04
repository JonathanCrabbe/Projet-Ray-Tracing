classdef Antenne
    %Cette classe contient les propri�t�s des antennes qui sont
    %des dip�les lambda/2 par hypoth�se

    properties
        x %Abscisse de l'origine de l'antenne
        y %Ordonn�e de l'origine de l'antenne
        lambda %Longueur d'onde rayonn�e ou re�ue
           
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


