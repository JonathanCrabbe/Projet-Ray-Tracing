function [ debit ] = powerToDebit( power)
%Cette fonction calcule le debit binaire en Mbps associe a une puissance 
%donnee en W en utilisant l'interpolation lineaire suggere dans les consignes

Pdbm = 10*(log10(power) + 3);
   
  debit = 6 + (54-6)*(Pdbm+93)/20;
  if(debit < 0)
      debit = 0; %Probleme survenant de la linearisation
  end

end

