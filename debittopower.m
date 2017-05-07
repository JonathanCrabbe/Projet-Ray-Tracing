function [ power ] = debitToPower( debit )
%Cette fonction calcule la puissance en Watts associe a un debit binaire
%donnee en Mbpsen utilisant l'interpolation lineaire suggere dans les consignes


Pdbm = -93 + (20)*(debit-6)/(54-6);
power = 10^-3 * 10^(Pdbm/10);

end

