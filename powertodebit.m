function [ debit ] = powerToDebit( power)
%Cette fonction calcule le d�bit binaire en Mbps associ� � une puissance 
%donn�e en W en utilisant l'interpolation lin�aire sugg�r�e dans les consignes

Pdbm = 10*(log(power) + 3);
debit = 6 + (54-6)*(Pdbm+93)/20;
end

