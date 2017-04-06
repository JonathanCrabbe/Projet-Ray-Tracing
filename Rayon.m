classdef Rayon
    %Cette classe contient les propriétés des faisceaux
 

    properties
        d %Distance parcoure par le rayon avant d'atteindre l'émetteur
        At %Atténuation totale accumulée par le rayon lors de ses interactions
  
    end
    
    methods
        %Constructeur:
        function obj = Rayon(d,At)
            obj.d = d;
            obj.At = At;
        end
    end 
end


