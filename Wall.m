classdef Wall
    %Cette classe permets de contrstruire des murs de l'environements
    
    properties
        x1 %Abscisse extr�mit� 1
        y1 %Ordonn�e extr�mit� 1
        x2 %Abscisse extr�mit� 2
        y2 %Ordonn�e extremit� 2    
        perm %Permitivit�
        ep %Epaisseur
    end
    
    methods
        %Constructeur:
        function obj = Wall(x1,y1,x2,y2,perm,ep)
            obj.x1 = x1;
            obj.y1 = y1;
            obj.x2 = x2;
            obj.y2 = y2;
            obj.perm = perm;
            obj.ep = ep;
        end
        
        function plot(obj)
            plot([obj.x1,obj.y1], [obj.x2,obj.y2]);
            hold on;
        end
    end 
end

