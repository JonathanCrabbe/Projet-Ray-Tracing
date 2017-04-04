classdef Wall
    %Cette classe contient les propriétés des murs de l'environement

    properties
        x1 %Abscisse extrémité 1
        y1 %Ordonnée extrémité 1
        x2 %Abscisse extrémité 2
        y2 %Ordonnée extremité 2    
        perm %Permitivité
        cond %Conductivité
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

