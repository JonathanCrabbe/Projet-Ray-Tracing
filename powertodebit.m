function [ debit ] = powerToDebit( power)
%Cette fonction calcule le debit binaire en Mbps associe a une puissance 
%donnee en W en utilisant l'interpolation lineaire suggere dans les consignes

Pdbm = 10*(log10(power) + 3);
   
  debit = 2.4*Pdbm + 229.2;
  if(debit > 54)
      debit = 54;
  end
  if(debit < 6)
      debit = 0; %Probleme survenant de la linearisation
  end

end

