classdef Rayon
    %Cette classe contient les propri�t�s des faisceaux
 

    properties
        d %Distance parcoure par le rayon avant d'atteindre l'�metteur
        At %Att�nuation totale accumul�e par le rayon lors de ses interactions
  
    end
    
    methods
        %Constructeur:
        function obj = Rayon(d,At)
            obj.d = d;
            obj.At = At;
        end
    end 
end


