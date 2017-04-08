classdef Rayon
    %Cette classe contient les propriétés des faisceaux
 

    properties
        d %Distance parcoure par le rayon avant d'atteindre l'émetteur
        theta %Direction d'émission relativement à l'antenne
        At = 1;%Atténuation totale accumulée par le rayon lors de ses interactions
  
    end
    
    methods
        %Constructeur:
        function obj = Rayon(d,At)
            obj.d = d;
        end
    end 
end


