function [ debit ] = powerToDebit( power)
%Cette fonction calcule le debit binaire en Mbps associe a une puissance 
%donnee en W en utilisant l'interpolation lineaire suggere dans les consignes

Pdbm = 10*(log(power) + 3);
debit = 6 + (54-6)*(Pdbm+93)/20;
end

