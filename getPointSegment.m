function [ intersection] = getPointSegment( xpoint,ypoint, xextreme1, yextreme1, xextreme2, yextreme2 )
      % Ce script vérifie qu'un point est sur un segment
     intersection = false;
     if (yextreme1 ~= yextreme2)
        if (((xextreme2-xextreme1)/(yextreme2-yextreme1) == (xpoint-xextreme1)/(ypoint-yextreme1)) || ((xextreme2-xextreme1)/(yextreme2-yextreme1) == -(xpoint-xextreme1)/(ypoint-yextreme1)))
            if ( xextreme1 < xextreme2)
                if( xpoint <= xextreme2 && xpoint >= xextreme1)
                    intersection = true;
                end
            elseif ( xextreme1 > xextreme2)
                if( xpoint >= xextreme2 && xpoint <= xextreme1)
                    intersection = true;
                end
            else
                if ( yextreme1 < yextreme2)
                    if( ypoint <= yextreme2 && ypoint >= yextreme1)
                        intersection = true;
                    end
                else
                    if( ypoint >= yextreme2 && ypoint <= yextreme1)
                        intersection = true;
                    end
                end
            end
        end
     else
        if (ypoint == yextreme1)
            if ( xextreme1 < xextreme2)
                if( xpoint <= xextreme2 && xpoint >= xextreme1)
                    intersection = true;
                end
            else
                if( xpoint >= xextreme2 && xpoint <= xextreme1)
                    intersection = true;
                end
            end
        end
     end