% Calcul de la puissance au point P :
clear all; 
close all;
Ei = 1;
lambda = 0.12244898;

fun1 = @(x) sin((pi/2)*x.^2);
fun2 = @(y) cos((pi/2)*y.^2);

k = 1;
l = 1;


for d = 10:0.1:100;
    for h = 0:0.1:10;
    nu = h/sqrt(2/(lambda*d));
    C = integral(fun1,0,nu);
    S = integral(fun2,0,nu);
    P = 1/(120*pi)*(abs(exp(-1i*d*2*pi/lambda)*Ei*(1-(1+1i)/2*(C-1i*S))))^2
    M(k,l) = P;
    l = l+1;
    end
    l = 1;
    k = k+1;
end

X = 0:0.5:90;
Y = 0:0.5:10;
surf(M, 'FaceAlpha', 0.5);
colorbar;
title('Distribution du debit recu en fonction de la position du recepteur');
xlabel('Abscisse (m)');
ylabel('Ordonnee (m)');




