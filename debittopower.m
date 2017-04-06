function [ power ] = debitToPower( debit )
%Cette fonction calcule la puissance en Watts associé à un débit binaire
%donnée en Mbpsen utilisant l'interpolation linéaire suggérée dans les consignes


Pdbm = -93 + (20)*(debit-6)/(54-6);
power = 10^-3 * 10^(Pdbm/10);

end

