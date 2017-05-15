%Ce script calcule analytiquement la distribution du champt autour de
%l'antenne libre

c = 299792458;
f = 2.45*10^9; %Frequence des communications (Hertz) 
lambda = c/f; %Longueur d'onde rayonnee (m)

antenne = Antenne(0,0, lambda);


theta = @(x,y) (atan(x./y)); %Angle à l'éméteur
d = @(x,y) (sqrt(x.^2 + y.^2)); %Dinstance à l'émtteur
Ra = 83; %Resistance d'antenne

G = @(x,y) (antenne.getGain(theta(x,y))); %Gain de l'émétteur
h = @(x,y) (antenne.getHauteur(pi- theta(x,y))); %Hauteur équivalente du récepteur

P = @(x,y) ( 60*(abs(G(x,y)*h(x,y)))^2 /(8*Ra*d(x,y)));

X = -5:0.5:5;
Y = -5:0.5:5;
Z = zeros(21,21);

for i = 1:21
    for j = 1:21
        Z(i,j) = powertodebit(P(X(i),Y(j))); 
       if(d(X(i),Y(j)) == 0)
           Z(i,j) = powertodebit(0.1);
       end
    end 
end

surf(X,Y,Z');
colorbar;
q = colorbar;
q.Label.String = 'Debit binaire maximal (Mb/s)';
title('Distribution théorique du debit recu (antenne libre)');
xlabel('Abscisse (m)');
ylabel('Ordonnee (m)');

