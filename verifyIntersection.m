function [ doIntersect ] = verifyIntersection( line1, line2 )
%Ce script v�rifie que les segments droites donn�es ont bien une
%intersection. Il renvoie true dans l'affirmative
%Algorithme issus de:
% http://blogs.mathworks.com/loren/2011/08/29/intersecting-lines/

slope = @(line) (line(2,2) - line(1,2))/(line(2,1) - line(1,1));
m1 = slope(line1);
m2 = slope(line2);
intercept = @(line,m) line(1,2) - m*line(1,1);
b1 = intercept(line1,m1);
b2 = intercept(line2,m2);
xintersect = (b2-b1)/(m1-m2);
yintersect = m1*xintersect + b1;
isPointInside = @(xint,myline) ...
    (xint >= myline(1,1) && xint <= myline(2,1)) || ...
    (xint >= myline(2,1) && xint <= myline(1,1));

if( m1 == m2) %Droites paralleles
    doIntersect = (b1 == b2);


elseif(line1(2,1) == line1(1,1)) %Droite 1 verticale
    doIntersect = isPointInside(line1(1,1), line2);


elseif(line2(2,1) == line2(1,1)) %Droite 1 verticale
    doIntersect = isPointInside(line2(1,1), line1);

    
else
    doIntersect = isPointInside(xintersect,line1) && ...
     isPointInside(xintersect,line2);
 end

end
