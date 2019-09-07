function color=getColor_ratio(r,g,b)
color="";
%fprintf('\nr:%f g:%f b:%f',r,g,b);
GR=round(g/r);BG=round(b/g);RB=round(r/b);
BR=round(b/r);GB=round(g/b);RG=round(r/g);
if(GR==0 && BR==0 && g-b<=40 && g<=35 && b<=50)
    color="R";
elseif(g>r && RG==0 && BG<=1 && r<=40 && b<=120)
    color="G";
elseif(RB==0 && GB==0 && r<=g && g<=106)
    color="B";
elseif(g/r<=0.6 && GB==0 && b>=150)
    color="P";
elseif(RB==0 && r<=50)
    color="C";
elseif(RG>=1 && (BR<=1||(b/r<=1.7&&b/r>=1.4)) && b>=140)
    color="W";
elseif(g<=80 || (g<=100 && abs(g-b)<=20) || RG>=2)
    color="O";
elseif(BR<=1 && GR<=1 && r<=180)
    color="Y";    
end
fprintf('\ncolor : %s',color);
end

