function result=cubicKernel(X,X_n,h)
rows=size(X_n,1);
d=size(X_n,2);
%Cube kernel uses param h
X_new=repmat(X,rows,1);h_new=repmat(h,rows,1);
Z=((X_new-X_n)./h_new);
Ind=(sum(abs(Z)>0.5,2)~=0);
result=(sum(Ind==0)/h(1,1)^d)/rows;
end