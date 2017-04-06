function [ debit ] = powerToDebit( power)
%Cette fonction calcule le débit binaire en Mbps associé à une puissance 
%donnée en W en utilisant l'interpolation linéaire suggérée dans les consignes

Pdbm = 10*(log(power) + 3);
debit = 6 + (54-6)*(Pdbm+93)/20;
end

