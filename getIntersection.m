function [ intersection] = getIntersection( line1, line2 )
%Ce script calcule l'intersection entre les droites line1 et line2
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
intersection = [xintersect; yintersect];

if(line1(2,1) == line1(1,1)) %Droite 1 verticale
   intersection = [line1(1,1); m2*line1(1,1)+b2];
end

if(line2(2,1) == line2(1,1)) %Droite 2 verticale
    intersection = [line2(1,1); m1*line2(1,1)+b1];
end

if(m1 == m2 && b1 == b2)
    intersection = [line1(1,1); line1(1,2)];
end

end

