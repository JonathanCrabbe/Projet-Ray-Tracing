function [ power ] = debitToPower( debit )
%Cette fonction calcule la puissance en Watts associ� � un d�bit binaire
%donn�e en Mbpsen utilisant l'interpolation lin�aire sugg�r�e dans les consignes


Pdbm = -93 + (20)*(debit-6)/(54-6);
power = 10^-3 * 10^(Pdbm/10);

end

