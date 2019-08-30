% Fuction for calculating likelihood of given data, mean ,sigma %
function Z=lkhood(X,M,S)
for k=1:size(X,1)
    a=2*pi;
    b=(det(S))^(1/2);
    c=exp((-0.5)*(X(k,1:2)-M)*inv(S)*(X(k,1:2)-M)');
    Z(k)=c/(a*b);
end
Z=Z';
end