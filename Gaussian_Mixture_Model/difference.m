function value = difference(a,b,f)
% difference between two elements
if f==1
    if(a>b)
        value = a - b;
    else
        value = b - a;
    end
% difference between two matrices    
elseif f==2
   value=abs(a-b);
end

end