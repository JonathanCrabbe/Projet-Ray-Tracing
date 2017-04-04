classdef Wall
    %Cette classe contient les propri�t�s des murs de l'environement

    properties
        x1 %Abscisse extr�mit� 1
        y1 %Ordonn�e extr�mit� 1
        x2 %Abscisse extr�mit� 2
        y2 %Ordonn�e extremit� 2    
        perm %Permitivit�
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
        
        function plot(obj)
            plot([obj.x1,obj.x2], [obj.y1,obj.y2], 'Color', 'b');
            hold on;
        end
    end 
end

